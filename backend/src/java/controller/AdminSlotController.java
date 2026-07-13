package controller;

import dao.SlotDAO;
import dto.Slot;
import dto.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/slots")
public class AdminSlotController extends HttpServlet {

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

    private String buildTimeValue(String startTime, String endTime) {
        return startTime + " - " + endTime;
    }

    private boolean isValidTimeRange(String startTime, String endTime) {
        return startTime != null
                && endTime != null
                && !startTime.trim().isEmpty()
                && !endTime.trim().isEmpty()
                && startTime.compareTo(endTime) < 0;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        SlotDAO slotDAO = new SlotDAO();

        String editIdRaw = request.getParameter("editId");
        if (editIdRaw != null && !editIdRaw.trim().isEmpty()) {
            try {
                int editId = Integer.parseInt(editIdRaw);
                Slot editSlot = slotDAO.getSlotById(editId);
                request.setAttribute("EDIT_SLOT", editSlot);
            } catch (NumberFormatException e) {
                request.setAttribute("ERROR_MSG", "Invalid slot ID.");
            }
        }

        List<Slot> slots = slotDAO.getAllSlotsForAdmin();
        request.setAttribute("SLOTS", slots);

        request.getRequestDispatcher("/views/admin/slot.jsp").forward(request, response);
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
        SlotDAO slotDAO = new SlotDAO();

        try {
            if ("create".equals(action)) {
                String startTime = request.getParameter("startTime");
                String endTime = request.getParameter("endTime");
                int isActive = Integer.parseInt(request.getParameter("isActive"));

                if (!isValidTimeRange(startTime, endTime)) {
                    response.sendRedirect(request.getContextPath() + "/admin/slots?error=invalid_time");
                    return;
                }

                Slot slot = new Slot();
                slot.setStartTime(startTime);
                slot.setEndTime(endTime);
                slot.setTimeValue(buildTimeValue(startTime, endTime));
                slot.setIsActive(isActive);

                boolean success = slotDAO.createSlot(slot);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/slots?msg=created");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/slots?error=create_failed");
                }

                return;
            }

            if ("update".equals(action)) {
                int slotId = Integer.parseInt(request.getParameter("slotId"));
                String startTime = request.getParameter("startTime");
                String endTime = request.getParameter("endTime");
                int isActive = Integer.parseInt(request.getParameter("isActive"));

                if (!isValidTimeRange(startTime, endTime)) {
                    response.sendRedirect(request.getContextPath() + "/admin/slots?editId=" + slotId + "&error=invalid_time");
                    return;
                }

                Slot slot = new Slot();
                slot.setSlotId(slotId);
                slot.setStartTime(startTime);
                slot.setEndTime(endTime);
                slot.setTimeValue(buildTimeValue(startTime, endTime));
                slot.setIsActive(isActive);

                boolean success = slotDAO.updateSlot(slot);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/slots?msg=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/slots?error=update_failed");
                }

                return;
            }

            if ("toggle".equals(action)) {
                int slotId = Integer.parseInt(request.getParameter("slotId"));
                int isActive = Integer.parseInt(request.getParameter("isActive"));

                boolean success = slotDAO.toggleSlotStatus(slotId, isActive);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/slots?msg=status_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/slots?error=status_failed");
                }

                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/slots");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/slots?error=invalid_input");
        }
    }
}