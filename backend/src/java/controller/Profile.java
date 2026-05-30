package controller;

import dao.CustomerDAO;
import dao.TiersDAO;
import dao.UserDAO;
import dao.VehicleDAO;
import dao.WalletDAO;
import dto.Customer;
import dto.Tiers;
import dto.User;
import dto.Vehicle;
import dto.Wallet;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/profile")
public class Profile extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // 1. Kiểm tra đăng nhập bảo mật
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Giả lập hoặc lấy dữ liệu thật từ Session đã lưu lúc Login thành công
        User loginedUser = (User) session.getAttribute("USER");
        
        CustomerDAO cd = new CustomerDAO();
        TiersDAO td = new TiersDAO();
        WalletDAO wd = new WalletDAO();
        VehicleDAO vd = new VehicleDAO();

        Customer loginedCustomer = cd.getCustomerByUserId(loginedUser.getUserId());
        if (loginedCustomer == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        Tiers loginedTiers = td.getTierById(loginedCustomer.getTierId());
        Wallet loginedWallet = wd.getWalletByCustomerId(loginedCustomer.getCustomerId());
        List<Vehicle> vehicleList = vd.getVehiclesByCustomerId(loginedCustomer.getCustomerId());

        // ================= LOGIC TÍNH TOÁN TIẾN TRÌNH LÊN HẠNG KẾ TIẾP =================
        int nextTierId = loginedTiers.getTierId() + 1;
        Tiers nextTierData = td.getTierById(nextTierId);

        int targetWashes = loginedTiers.getMinWashes();
        long targetSpent = loginedTiers.getMinSpent();
        int washesPercent = 100;
        int spentPercent = 100;
        boolean hasNextTier = (nextTierData != null);

        if (hasNextTier) {
            targetWashes = nextTierData.getMinWashes();
            targetSpent = nextTierData.getMinSpent();

            if (targetWashes > 0) {
                washesPercent = (int) ((double) loginedCustomer.getTotalWashes() / targetWashes * 100);
                if (washesPercent > 100) washesPercent = 100;
            } else {
                washesPercent = 0;
            }

            if (targetSpent > 0) {
                spentPercent = (int) ((double) loginedCustomer.getTotalSpent() / targetSpent * 100);
                if (spentPercent > 100) spentPercent = 100;
            } else {
                spentPercent = 0;
            }
        }

        // 2. Gói tất cả các dữ liệu tính toán được vào Request Attribute để gửi sang JSP
        request.setAttribute("customerData", loginedCustomer);
        request.setAttribute("tierData", loginedTiers);
        request.setAttribute("walletData", loginedWallet);
        request.setAttribute("vehicles", vehicleList);
        request.setAttribute("hasNextTier", hasNextTier);
        request.setAttribute("targetWashes", targetWashes);
        request.setAttribute("targetSpent", targetSpent);
        request.setAttribute("washesPercent", washesPercent);
        request.setAttribute("spentPercent", spentPercent);

        // 3. Forward sang trang JSP ẩn danh để hiển thị giao diện sạch
        request.getRequestDispatcher("/views/auth/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}