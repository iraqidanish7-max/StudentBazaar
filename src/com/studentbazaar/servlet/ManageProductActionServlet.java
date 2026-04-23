package com.studentbazaar.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ManageProductActionServlet")
public class ManageProductActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // expects POST with: action = approve|reject|delete, productId = id
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/home.jsp?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        String pidStr = request.getParameter("productId");

        if (action == null || pidStr == null) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet?msg=invalid");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(pidStr);
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet?msg=invalid-id");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentbazaar", "root", "")) {

                if ("approve".equalsIgnoreCase(action)) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE products SET status = 'approved' WHERE id = ?")) {
                        ps.setInt(1, productId);
                        ps.executeUpdate();
                    }
                } else if ("reject".equalsIgnoreCase(action)) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE products SET status = 'rejected' WHERE id = ?")) {
                        ps.setInt(1, productId);
                        ps.executeUpdate();
                    }
                } else if ("delete".equalsIgnoreCase(action)) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "DELETE FROM products WHERE id = ?")) {
                        ps.setInt(1, productId);
                        ps.executeUpdate();
                    }
                }
            }

            // come back to the new admin dashboard, not the old black page
            response.sendRedirect(request.getContextPath()
                    + "/AdminDashboardServlet?msg=products-ok");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/AdminDashboardServlet?msg=products-error");
        }
    }
}