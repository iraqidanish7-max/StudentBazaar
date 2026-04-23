package com.studentbazaar.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ManageOrderActionServlet")
public class ManageOrderActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // check if given column exists in orders table
    private boolean columnExists(Connection con, String columnName) throws SQLException {
        DatabaseMetaData md = con.getMetaData();
        try (ResultSet rs = md.getColumns(null, null, "orders", columnName)) {
            return rs.next();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/home.jsp?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("orderId");
        if (action == null || idStr == null) {
            response.sendRedirect("ManageOrdersServlet?msg=invalid");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(idStr);
        } catch (NumberFormatException ex) {
            response.sendRedirect("ManageOrdersServlet?msg=badid");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("ManageOrdersServlet?msg=error");
            return;
        }

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/studentbazaar", "root", "")) {

            if ("update_status".equalsIgnoreCase(action)) {
                String newStatus = request.getParameter("newStatus");
                if (newStatus == null) {
                    response.sendRedirect("ManageOrdersServlet?msg=nostatus");
                    return;
                }
                // check if 'status' column exists
                if (!columnExists(con, "status")) {
                    response.sendRedirect("ManageOrdersServlet?msg=nostatuscol");
                    return;
                }
                try (PreparedStatement ps = con.prepareStatement("UPDATE orders SET status = ? WHERE id = ?")) {
                    ps.setString(1, newStatus);
                    ps.setInt(2, orderId);
                    ps.executeUpdate();
                }
            } else if ("delete".equalsIgnoreCase(action)) {
                try (PreparedStatement ps = con.prepareStatement("DELETE FROM orders WHERE id = ?")) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }
            }

            response.sendRedirect("ManageOrdersServlet?msg=ok");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("ManageOrdersServlet?msg=error");
        }
    }
}