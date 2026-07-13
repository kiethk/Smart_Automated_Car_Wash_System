package controller;

import dao.SlotDAO;
import dto.Slot;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/slots")
public class SlotApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");

        String date = request.getParameter("date");
        PrintWriter out = response.getWriter();

        if (date == null || date.trim().isEmpty()) {
            out.write("[]");
            return;
        }

        SlotDAO slotDAO = new SlotDAO();
        List<Slot> slots = slotDAO.getSlotsByDate(date);

        // Tự build JSON thủ công, không cần Gson
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < slots.size(); i++) {
            Slot s = slots.get(i);
            json.append("{")
                .append("\"slotId\":").append(s.getSlotId()).append(",")
                .append("\"timeValue\":\"").append(s.getTimeValue()).append("\",")
                .append("\"startTime\":\"").append(s.getStartTime()).append("\",")
                .append("\"endTime\":\"").append(s.getEndTime()).append("\",")
                .append("\"isActive\":").append(s.getIsActive()).append(",")
                .append("\"isFull\":").append(s.isFull())
                .append("}");
            if (i < slots.size() - 1) json.append(",");
        }
        json.append("]");

        out.write(json.toString());
    }
}