package controller;

import dao.BayDAO;
import dao.BookingDAO;
import dao.CustomerDAO;
import dao.PromotionDAO;
import dao.ServiceDAO;
import dao.SlotDAO;
import dao.VehicleDAO;
import dto.Booking;
import dto.Customer;
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
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }

        Customer loginedCustomer = (Customer) session.getAttribute("CUSTOMER");

        VehicleDAO vd = new VehicleDAO();
        ServiceDAO sd = new ServiceDAO();
        SlotDAO sld = new SlotDAO();
        PromotionDAO pd = new PromotionDAO();

        try {
            if (loginedCustomer == null) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=login");
                return;
            }

            String selectedDate = request.getParameter("date");

            if (selectedDate == null || selectedDate.trim().isEmpty()) {
                selectedDate = LocalDate.now().toString();
            }

            List<Vehicle> vehicleList = vd.getVehiclesByCustomerId(loginedCustomer.getCustomerId());
            List<Service> serviceList = sd.getActiveServices();
            List<Slot> slotList = sld.getSlotsByDate(selectedDate);
            List<Slot> allSlotList = sld.getAllSlots();
            List<dto.Promotion> promoList = pd.getAllActivePromotions(); // <-- Lấy danh sách Voucher từ DB

            request.setAttribute("CUSTOMER", loginedCustomer);
            request.setAttribute("VEHICLES", vehicleList);
            request.setAttribute("SERVICES", serviceList);
            request.setAttribute("SLOTS", slotList);
            request.setAttribute("ALLSLOTLIST", allSlotList);
            request.setAttribute("PROMOTIONS", promoList); // <-- Đẩy sang JSP với key chuẩn "PROMOTIONS"
            request.setAttribute("SELECTED_DATE", selectedDate);

            // Điều hướng thẳng tới trang giao diện đặt lịch
            request.getRequestDispatcher("/views/auth/customer/booking.jsp").forward(request, response);

        } catch (Exception e) {
            log("Error at BookingController (doGet): " + e.getMessage());
            e.printStackTrace(); // In ra console để bạn dễ theo dõi nếu có lỗi SQL ngầm
            request.setAttribute("ERROR_MSG", "System error while loading booking form: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
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
                return;
            }

            String bookingDate = request.getParameter("bookingDate");
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            Integer assignedBayId = bayDAO.getAvailableBayId(bookingDate, slotId);
            String notes = request.getParameter("notes");

            if (assignedBayId == null) {
                request.setAttribute("ERROR_MSG", "This slot is fully booked. Please choose another slot.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            long totalAmount = 100000;
            int pointsEarned = 2;

            Booking newBooking = new Booking();
            newBooking.setBookingDate(bookingDate);
            newBooking.setSlotId(slotId);
            newBooking.setDiscountAmount(0);
            newBooking.setTotalAmount(totalAmount);
            newBooking.setPointsEarned(pointsEarned);
            newBooking.setStatus("pending");
            newBooking.setNotes(notes);
            newBooking.setCustomerId(loginedCustomer.getCustomerId());
            newBooking.setVehicleId(vehicleId);
            newBooking.setPromotionId(null);
            newBooking.setBayId(assignedBayId);

            boolean isSuccess = bd.insertBooking(newBooking);

            if (isSuccess) {
                response.sendRedirect(request.getContextPath() + "/profile?msg=Booking success!");
            } else {
                request.setAttribute("ERROR_MSG", "Failed to create your booking request. Please try again.");
                // ĐÃ SỬA: Thêm dấu / ở đầu đường dẫn forward sang JSP
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            }

        } catch (Exception e) {
            log("Error at BookingController (doPost): " + e.getMessage());
            request.setAttribute("ERROR_MSG", "System error while processing your booking: " + e.getMessage());
            // ĐÃ SỬA: Thêm dấu / ở đầu đường dẫn forward sang JSP
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
