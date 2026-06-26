package controller;

import dao.BayDAO;
import dao.BookingDAO;
import dao.CustomerDAO;
import dao.PromotionDAO;
import dao.ServiceDAO;
import dao.SlotDAO;
import dao.VehicleDAO;
import dao.WalletDAO;
import dto.Booking;
import dto.Customer;
import dto.Promotion;
import dto.Service;
import dto.Slot;
import dto.User;
import dto.Vehicle;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/booking")
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        User loginedUser = (User) session.getAttribute("USER");

        CustomerDAO cd = new CustomerDAO();
        WalletDAO walletDAO = new WalletDAO();

        VehicleDAO vd = new VehicleDAO();
        ServiceDAO sd = new ServiceDAO();
        SlotDAO sld = new SlotDAO();
        PromotionDAO pd = new PromotionDAO();

        try {
            Customer loginedCustomer = cd.getCustomerByUserId(loginedUser.getUserId());

            if (loginedCustomer == null) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=login");
                return;
            }

            dto.Wallet wallet = walletDAO.getWalletByCustomerId(loginedCustomer.getCustomerId());

            // Refresh lại session để các trang khác cũng dùng dữ liệu mới
            session.setAttribute("CUSTOMER", loginedCustomer);
            session.setAttribute("WALLET", wallet);

            LocalDate minBookingDate = LocalDate.now().plusDays(1);

            String selectedDate = request.getParameter("date");

            if (selectedDate == null || selectedDate.trim().isEmpty()) {
                selectedDate = minBookingDate.toString();
            } else {
                try {
                    LocalDate selectedLocalDate = LocalDate.parse(selectedDate);

                    if (selectedLocalDate.isBefore(minBookingDate)) {
                        selectedDate = minBookingDate.toString();
                    }
                } catch (Exception e) {
                    selectedDate = minBookingDate.toString();
                }
            }

            String selectedServiceId = request.getParameter("serviceId");
            request.setAttribute("SELECTED_SERVICE_ID", selectedServiceId);

            List<Vehicle> vehicleList = vd.getVehiclesByCustomerId(loginedCustomer.getCustomerId());
            List<Service> serviceList = sd.getActiveServices();
            List<Slot> slotList = sld.getSlotsByDate(selectedDate);
            List<Slot> allSlotList = sld.getAllSlots();
            List<Promotion> promoList = pd.getAvailablePromotionsForCustomer(
                    loginedCustomer.getCustomerId(),
                    loginedCustomer.getTierId()
            );

            request.setAttribute("CUSTOMER", loginedCustomer);
            request.setAttribute("WALLET", wallet);
            request.setAttribute("VEHICLES", vehicleList);
            request.setAttribute("SERVICES", serviceList);
            request.setAttribute("SLOTS", slotList);
            request.setAttribute("ALLSLOTLIST", allSlotList);
            request.setAttribute("PROMOTIONS", promoList);
            request.setAttribute("SELECTED_DATE", selectedDate);

            request.getRequestDispatcher("/views/auth/customer/booking.jsp").forward(request, response);
            return;

        } catch (Exception e) {
            log("Error at BookingController (doGet): " + e.getMessage());
            e.printStackTrace();

            if (!response.isCommitted()) {
                request.setAttribute("ERROR_MSG", "System error while loading booking form: " + e.getMessage());
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return; // Thoát hàm ngay lập tức sau khi redirect
        }

        request.setCharacterEncoding("UTF-8");
        User loginedUser = (User) session.getAttribute("USER");

        CustomerDAO cd = new CustomerDAO();
        BookingDAO bd = new BookingDAO();
        BayDAO bayDAO = new BayDAO();

        try {
            Customer loginedCustomer = cd.getCustomerByUserId(loginedUser.getUserId());
            if (loginedCustomer == null) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=home");
                return; // Thoát hàm ngay lập tức sau khi redirect
            }

            // 1. Đọc các tham số cơ bản từ Form gửi lên
            String bookingDate = request.getParameter("bookingDate");

            if (bookingDate == null || bookingDate.trim().isEmpty()) {
                request.setAttribute("ERROR_MSG", "Please select a booking date.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            LocalDate minBookingDate = LocalDate.now().plusDays(1);
            LocalDate selectedBookingDate;

            try {
                selectedBookingDate = LocalDate.parse(bookingDate);
            } catch (Exception e) {
                request.setAttribute("ERROR_MSG", "Invalid booking date format.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            if (selectedBookingDate.isBefore(minBookingDate)) {
                request.setAttribute("ERROR_MSG", "Same-day booking is not allowed. Please book from tomorrow onward.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            int slotId = Integer.parseInt(request.getParameter("slotId"));
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String notes = request.getParameter("notes");

            // 2. Đọc các tham số tính toán tài chính & phương thức thanh toán
            String paymentMethod = request.getParameter("paymentMethod");

            long totalAmount = 100000;
            String totalAmountStr = request.getParameter("totalAmountInput");
            if (totalAmountStr != null && !totalAmountStr.trim().isEmpty()) {
                totalAmount = Long.parseLong(totalAmountStr);
            }

            long discountAmount = 0;
            String discountStr = request.getParameter("discountAmountInput");
            if (discountStr != null && !discountStr.trim().isEmpty()) {
                discountAmount = Long.parseLong(discountStr);
            }

            int redeemPoints = 0;
            String redeemPointsStr = request.getParameter("redeemPoints");
            if (redeemPointsStr != null && !redeemPointsStr.trim().isEmpty()) {
                redeemPoints = Integer.parseInt(redeemPointsStr);
            }

            Integer promotionId = null;
            String promoIdStr = request.getParameter("promotionIdInput");
            if (promoIdStr != null && !promoIdStr.trim().isEmpty() && !"0".equals(promoIdStr.trim())) {
                try {
                    promotionId = Integer.parseInt(promoIdStr.trim());
                } catch (NumberFormatException e) {
                    log("Warning: promotionIdInput is not a valid number: " + promoIdStr);
                    promotionId = null;
                }
            }

            // 3. Tự động tìm khoang rửa trống (Bay) tương thích
            Integer assignedBayId = bayDAO.getAvailableBayId(bookingDate, slotId);

            if (assignedBayId == null) {
                request.setAttribute("ERROR_MSG", "This slot is fully booked. Please choose another slot.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return; // Thoát hàm ngay lập tức sau khi forward lỗi hết chỗ
            }

            // 4. Khởi tạo đối tượng DTO Đơn hàng
            Booking newBooking = new Booking();
            newBooking.setBookingDate(bookingDate);
            newBooking.setSlotId(slotId);
            newBooking.setDiscountAmount(discountAmount);
            newBooking.setTotalAmount(totalAmount);
            newBooking.setPointsEarned(0);
            newBooking.setStatus("pending");
            newBooking.setNotes(notes);
            newBooking.setCustomerId(loginedCustomer.getCustomerId());
            newBooking.setVehicleId(vehicleId);
            newBooking.setPromotionId(promotionId);
            newBooking.setBayId(assignedBayId);

            if ("wallet".equalsIgnoreCase(paymentMethod)) {
                dao.WalletDAO walletDAO = new dao.WalletDAO();
                dto.Wallet wallet = walletDAO.getWalletByCustomerId(loginedCustomer.getCustomerId());

                long currentBalance = (wallet != null) ? wallet.getBalance() : 0;

                if (wallet == null || currentBalance < totalAmount) {
                    request.setAttribute("ERROR_MSG", "Tài khoản ví của bạn không đủ số dư để thực hiện giao dịch này. Vui lòng nạp thêm tiền!");

                    VehicleDAO vd = new VehicleDAO();
                    ServiceDAO sd = new ServiceDAO();
                    SlotDAO sld = new SlotDAO();
                    PromotionDAO pd = new PromotionDAO();

                    request.setAttribute("CUSTOMER", loginedCustomer);
                    request.setAttribute("VEHICLES", vd.getVehiclesByCustomerId(loginedCustomer.getCustomerId()));
                    request.setAttribute("SERVICES", sd.getActiveServices());
                    request.setAttribute("SLOTS", sld.getSlotsByDate(bookingDate));
                    request.setAttribute("ALLSLOTLIST", sld.getAllSlots());
                    request.setAttribute("PROMOTIONS", pd.getAvailablePromotionsForCustomer(
                            loginedCustomer.getCustomerId(),
                            loginedCustomer.getTierId()
                    ));
                    request.setAttribute("SELECTED_DATE", bookingDate);

                    request.getRequestDispatcher("/views/auth/customer/booking.jsp").forward(request, response);
                    return;
                }
            }

            // 5. Gọi hàm xử lý Transaction nạp DB
            boolean isSuccess = bd.insertBookingWithPayment(newBooking, paymentMethod, redeemPoints, serviceId);

            if (isSuccess) {
                Customer refreshedCustomer = cd.getCustomerByUserId(loginedUser.getUserId());

                dao.WalletDAO walletDAO = new dao.WalletDAO();
                dto.Wallet refreshedWallet = walletDAO.getWalletByCustomerId(refreshedCustomer.getCustomerId());

                session.setAttribute("CUSTOMER", refreshedCustomer);
                session.setAttribute("WALLET", refreshedWallet);

                response.sendRedirect(request.getContextPath() + "/MainController?action=bookingHistory&msg=Booking success!");
                return; 
            } else {
                request.setAttribute("ERROR_MSG", "Failed to create your booking request. Database processing error.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return; // ĐÃ SỬA: Thêm return để bảo vệ luồng phản hồi
            }

        } catch (NumberFormatException nfe) {
            log("Error parsing numbers at BookingController (doPost): " + nfe.getMessage());
            request.setAttribute("ERROR_MSG", "Invalid payment input format data: " + nfe.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return; // ĐÃ SỬA: Thêm return để kết thúc hàm trong catch
        } catch (Exception e) {
            log("Error at BookingController (doPost): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("ERROR_MSG", "System error while processing your booking: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return; // ĐÃ SỬA: Thêm return để kết thúc hàm trong catch
        }
    }
}
