package com.studentbazaar.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt; // for password verification

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentbazaar", "root", "")) {

                // Fetch user by email
                String query = "SELECT * FROM users WHERE email = ?";
                try (PreparedStatement ps = con.prepareStatement(query)) {
                    ps.setString(1, email);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            String storedHash = rs.getString("password");
                            String roleFromDb = rs.getString("role"); 

                            //student_status (may be null for admin / old records)
                            String studentStatus = rs.getString("student_status");
                            if (studentStatus == null || studentStatus.trim().isEmpty()) {
                                studentStatus = "Pending"; // safe default
                            }

                            if (storedHash != null && BCrypt.checkpw(password, storedHash)) {
                                HttpSession session = request.getSession();

                                session.setAttribute("username", rs.getString("name"));
                                session.setAttribute("userContact", rs.getString("phone"));
                                session.setAttribute("userEmail", rs.getString("email"));

                                // normalize role
                                String effectiveRole = (roleFromDb != null && !roleFromDb.trim().isEmpty())
                                        ? roleFromDb
                                        : "user";
                                session.setAttribute("role", effectiveRole);

                                //  store status in session for dashboard badges
                                session.setAttribute("studentStatus", studentStatus);

                                // session timeout: 30 minutes
                                session.setMaxInactiveInterval(30 * 60);

                                // Redirect admin via servlet, others to home.jsp
                                if ("admin".equalsIgnoreCase(effectiveRole)) {
                                    // goes to servlet that prepares stats & forwards to admin-dashboard.jsp
                                    response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
                                } else {
                                    response.sendRedirect(request.getContextPath() + "/home.jsp");
                                }
                                return;

                            } else {
                                // wrong password
                                response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
                                return;
                            }
                        } else {
                            // no such email
                            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
                            return;
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=exception");
        }
    }
}