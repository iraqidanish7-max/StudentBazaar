package com.studentbazaar.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ManageUsersServlet")
public class ManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/home.jsp?error=unauthorized");
            return;
        }

        List<Map<String, Object>> users = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/studentbazaar", "root", "");
                 PreparedStatement ps = con.prepareStatement("SELECT id, name, email, phone, college, city, course, year, role, status FROM users ORDER BY id ASC");
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, Object> u = new HashMap<>();
                    u.put("id", rs.getInt("id"));
                    u.put("name", rs.getString("name"));
                    u.put("email", rs.getString("email"));
                    u.put("phone", rs.getString("phone"));
                    u.put("college", rs.getString("college"));
                    u.put("city", rs.getString("city"));
                    u.put("course", rs.getString("course"));
                    u.put("year", rs.getString("year"));
                    u.put("role", rs.getString("role"));
                    u.put("status", rs.getString("status"));
                    users.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("users", users);
        RequestDispatcher rd = request.getRequestDispatcher("manageUsers.jsp");
        rd.forward(request, response);
    }
}