package com.studentbazaar.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.studentbazaar.dao.OrderDAO;

@WebServlet("/DownloadOrdersCSV")
public class DownloadOrdersCSVServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");

        List<Map<String, Object>> orders;
        try {
            orders = OrderDAO.getUserOrders(userEmail);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to fetch orders for CSV.");
            return;
        }

        // CSV headers
        response.setContentType("text/csv; charset=UTF-8");
        String filename = "studentbazaar_orders.csv";
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + filename + "\"");

        try (PrintWriter out = response.getWriter()) {
            //  UTF-8 BOM for Excel (Hindi/Unicode friendly)
            out.write('\uFEFF');

            // Header row
            out.println("Title,Category,Price,Purchase Time,Image Path");

            if (orders != null) {
                for (Map<String, Object> order : orders) {
                    String title = String.valueOf(order.get("title"));
                    String category = String.valueOf(order.get("category"));
                    String price = String.valueOf(order.get("price"));
                    String purchaseTime = String.valueOf(order.get("purchaseTime"));
                    String imagePath = String.valueOf(order.get("imagePath"));

                    // Simple CSV escaping: wrap in quotes and replace any quotes inside
                    title = "\"" + title.replace("\"", "\"\"") + "\"";
                    category = "\"" + category.replace("\"", "\"\"") + "\"";
                    purchaseTime = "\"" + purchaseTime.replace("\"", "\"\"") + "\"";
                    imagePath = "\"" + imagePath.replace("\"", "\"\"") + "\"";

                    out.println(title + "," + category + "," + price + "," + purchaseTime + "," + imagePath);
                }
            }
        }
    }
}