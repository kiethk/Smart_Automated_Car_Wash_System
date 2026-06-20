package controller;

import dao.CustomerDAO;
import dao.TiersDAO;
import dao.WalletDAO;
import dao.BookingDAO;
import dao.PromotionDAO;
import dto.Customer;
import dto.Wallet;
import dto.Tiers;
import dto.Promotion;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "Dashboard", urlPatterns = {"/dashboard"})
public class Dashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. BẢO MẬT: Kiểm tra đăng nhập
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }

        try {
            Customer customerSession = (Customer) session.getAttribute("CUSTOMER");

            if (customerSession != null) {
                CustomerDAO customerDAO = new CustomerDAO();
                TiersDAO tiersDAO = new TiersDAO();
                WalletDAO walletDAO = new WalletDAO();
                BookingDAO bookingDAO = new BookingDAO();
                PromotionDAO promotionDAO = new PromotionDAO();

                // ĐỒNG BỘ: Cập nhật Customer thực tế mới nhất từ Database
                Customer customer = customerDAO.getCustomerById(customerSession.getCustomerId());
                session.setAttribute("CUSTOMER", customer);

                // VÍ TIỀN: Lấy số dư ví mới nhất
                Wallet wallet = walletDAO.getWalletByCustomerId(customer.getCustomerId());
                session.setAttribute("WALLET", wallet);

                // TIẾN TRÌNH THĂNG HẠNG: Tính toán thông số hạng thành viên
                Tiers currentTier = tiersDAO.getTierById(customer.getTierId());
                request.setAttribute("CURRENT_TIER_NAME", currentTier.getTierName());

                Tiers nextTier = tiersDAO.getTierById(customer.getTierId() + 1);
                if (nextTier != null) {
                    int washesLeft = nextTier.getMinWashes() - customer.getTotalWashes();
                    if (washesLeft < 0) {
                        washesLeft = 0;
                    }

                    int currentRange = customer.getTotalWashes() - currentTier.getMinWashes();
                    int totalRange = nextTier.getMinWashes() - currentTier.getMinWashes();
                    int progressPercent = (totalRange > 0) ? (currentRange * 100 / totalRange) : 100;

                    if (progressPercent > 100) {
                        progressPercent = 100;
                    }
                    if (progressPercent < 0) {
                        progressPercent = 0;
                    }

                    request.setAttribute("NEXT_TIER_NAME", nextTier.getTierName());
                    request.setAttribute("WASHES_LEFT", washesLeft);
                    request.setAttribute("PROGRESS_PERCENT", progressPercent);
                } else {
                    request.setAttribute("PROGRESS_PERCENT", 100);
                    request.setAttribute("IS_MAX_TIER", true);
                }

                // SỬA LẠI: Lấy quảng cáo được lọc riêng theo đúng Hạng thành viên của khách hàng đó trong DB
                List<Promotion> activePromos = promotionDAO.getAvailablePromotionsForCustomer(customer.getCustomerId(), customer.getTierId());

                if (activePromos != null && !activePromos.isEmpty()) {
                    request.setAttribute("BANNER", activePromos.get(0)); // Lấy mã phù hợp nhất sắp hết hạn hiển thị lên trước
                    request.setAttribute("HAS_BANNER", true);
                } else {
                    request.setAttribute("HAS_BANNER", false);
                }

                // LỊCH HẸN SẮP TỚI ĐỘNG
                Map<String, Object> upcomingAppointment = bookingDAO.getUpcomingAppointmentByCustomerId(customer.getCustomerId());
                if (upcomingAppointment != null) {
                    request.setAttribute("APPOINTMENT", upcomingAppointment);
                    request.setAttribute("HAS_APPOINTMENT", true);
                } else {
                    request.setAttribute("HAS_APPOINTMENT", false);
                }
            }

            // Điều phối hiển thị (Forward)
            request.getRequestDispatcher("views/auth/customer/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

