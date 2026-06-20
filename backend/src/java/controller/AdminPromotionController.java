package controller;

import dao.PromotionDAO;
import dao.TiersDAO;
import dto.Promotion;
import dto.Tiers;
import dto.User;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import utils.CloudinaryConfig;

@WebServlet("/admin/promotions")
public class AdminPromotionController extends HttpServlet {

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return false;
        }

        User user = (User) session.getAttribute("USER");

        if (user.getRoleId() != 1) {
            request.setAttribute("ERROR_MSG", "You do not have permission to access this page.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return false;
        }

        return true;
    }

    private boolean isValidDiscountType(String discountType) {
        return "percent".equalsIgnoreCase(discountType)
                || "fixed".equalsIgnoreCase(discountType);
    }

    private Promotion buildPromotionFromRequest(HttpServletRequest request, boolean isUpdate) {
        Promotion p = new Promotion();

        if (isUpdate) {
            p.setPromotionId(Integer.parseInt(request.getParameter("promotionId")));
        }

        String code = request.getParameter("code");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");
        String discountType = request.getParameter("discountType");
        String targetTierIdRaw = request.getParameter("targetTierId");

        long discountValue = Long.parseLong(request.getParameter("discountValue"));
        long minOrderAmount = Long.parseLong(request.getParameter("minOrderAmount"));
        int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
        int isActive = Integer.parseInt(request.getParameter("isActive"));

        Date startDate = Date.valueOf(request.getParameter("startDate"));
        Date endDate = Date.valueOf(request.getParameter("endDate"));

        p.setCode(code != null ? code.trim().toUpperCase() : "");
        p.setTitle(title != null ? title.trim() : "");
        p.setDescription(description);
        p.setImageUrl(imageUrl);
        p.setDiscountType(discountType != null ? discountType.toLowerCase() : "");
        p.setDiscountValue(discountValue);
        p.setMinOrderAmount(minOrderAmount);
        p.setUsageLimit(usageLimit);
        p.setStartDate(startDate);
        p.setEndDate(endDate);
        p.setIsActive(isActive);

        if (targetTierIdRaw == null || targetTierIdRaw.trim().isEmpty() || "0".equals(targetTierIdRaw)) {
            p.setTargetTierId(null);
        } else {
            p.setTargetTierId(Integer.parseInt(targetTierIdRaw));
        }

        return p;
    }

    private boolean isValidPromotion(Promotion p) {
        if (p.getCode() == null || p.getCode().trim().isEmpty()) {
            return false;
        }

        if (p.getTitle() == null || p.getTitle().trim().isEmpty()) {
            return false;
        }

        if (!isValidDiscountType(p.getDiscountType())) {
            return false;
        }

        if (p.getDiscountValue() <= 0) {
            return false;
        }

        if ("percent".equalsIgnoreCase(p.getDiscountType()) && p.getDiscountValue() > 100) {
            return false;
        }

        if (p.getMinOrderAmount() < 0) {
            return false;
        }

        if (p.getUsageLimit() < 0) {
            return false;
        }

        if (p.getStartDate() == null || p.getEndDate() == null) {
            return false;
        }

        return !p.getEndDate().before(p.getStartDate());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        PromotionDAO promotionDAO = new PromotionDAO();
        TiersDAO tiersDAO = new TiersDAO();

        String editIdRaw = request.getParameter("editId");
        if (editIdRaw != null && !editIdRaw.trim().isEmpty()) {
            try {
                int editId = Integer.parseInt(editIdRaw);
                Promotion editPromotion = promotionDAO.getPromotionById(editId);
                request.setAttribute("EDIT_PROMOTION", editPromotion);
            } catch (NumberFormatException e) {
                request.setAttribute("ERROR_MSG", "Invalid promotion ID.");
            }
        }

        List<Promotion> promotions = promotionDAO.getAllPromotionsForAdmin();
        List<Tiers> tiers = tiersDAO.getAllTiers();

        Map<Integer, Integer> usageMap = new HashMap<>();
        for (Promotion p : promotions) {
            usageMap.put(p.getPromotionId(), promotionDAO.getPromotionUsageCount(p.getPromotionId()));
        }

        request.setAttribute("PROMOTIONS", promotions);
        request.setAttribute("TIERS", tiers);
        request.setAttribute("USAGE_MAP", usageMap);

        request.getRequestDispatcher("/views/admin/promotion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        PromotionDAO promotionDAO = new PromotionDAO();

        try {
            if ("create".equals(action)) {
                Promotion promotion = buildPromotionFromRequest(request, false);

                if (!isValidPromotion(promotion)) {
                    response.sendRedirect(request.getContextPath() + "/admin/promotions?error=invalid_input");
                    return;
                }

                boolean success = promotionDAO.createPromotion(promotion);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/promotions?msg=created");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/promotions?error=create_failed");
                }

                return;
            }

            if ("update".equals(action)) {
                Promotion promotion = buildPromotionFromRequest(request, true);

                if (!isValidPromotion(promotion)) {
                    response.sendRedirect(request.getContextPath() + "/admin/promotions?editId=" + promotion.getPromotionId() + "&error=invalid_input");
                    return;
                }

                boolean success = promotionDAO.updatePromotion(promotion);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/promotions?msg=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/promotions?error=update_failed");
                }

                return;
            }

            if ("toggle".equals(action)) {
                int promotionId = Integer.parseInt(request.getParameter("promotionId"));
                int isActive = Integer.parseInt(request.getParameter("isActive"));

                boolean success = promotionDAO.togglePromotionStatus(promotionId, isActive);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/promotions?msg=status_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/promotions?error=status_failed");
                }

                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/promotions");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/promotions?error=invalid_input");
        }
    }

}
