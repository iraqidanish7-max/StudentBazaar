package com.studentbazaar.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ManageUserActionServlet")
public class ManageUserActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/home.jsp?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        String userId = request.getParameter("userId");

        if (action == null || userId == null) {
            response.sendRedirect("ManageUsersServlet?msg=invalid");
            return;
        }

        try {
            int id = Integer.parseInt(userId);
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/studentbazaar", "root", "")) {

                PreparedStatement ps = null;
                switch (action.toLowerCase()) {
                    case "promote":
                        ps = con.prepareStatement("UPDATE users SET role = 'admin' WHERE id = ?");
                        ps.setInt(1, id);
                        ps.executeUpdate();
                        break;
                    case "demote":
                        ps = con.prepareStatement("UPDATE users SET role = 'user' WHERE id = ?");
                        ps.setInt(1, id);
                        ps.executeUpdate();
                        break;
                    case "suspend":
                        ps = con.prepareStatement("UPDATE users SET status = 'suspended' WHERE id = ?");
                        ps.setInt(1, id);
                        ps.executeUpdate();
                        break;
                    case "activate":
                        ps = con.prepareStatement("UPDATE users SET status = 'active' WHERE id = ?");
                        ps.setInt(1, id);
                        ps.executeUpdate();
                        break;
                    case "delete":
                        ps = con.prepareStatement("DELETE FROM users WHERE id = ?");
                        ps.setInt(1, id);
                        ps.executeUpdate();
                        break;
                }
            }
            response.sendRedirect("ManageUsersServlet?msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageUsersServlet?msg=error");
        }
    }
}