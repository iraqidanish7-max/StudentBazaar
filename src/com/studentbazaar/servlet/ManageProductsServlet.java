package com.studentbazaar.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ManageProductsServlet")
public class ManageProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // admin guard (defensive)
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equalsIgnoreCase((String)session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/home.jsp?error=unauthorized");
            return;
        }

        List<Map<String, Object>> products = new ArrayList<>();

        String sql = "SELECT * FROM products "
                   + "ORDER BY CASE WHEN status='pending' THEN 0 WHEN status='approved' THEN 1 ELSE 2 END, id DESC";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/studentbazaar", "root", "");
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, Object> p = new HashMap<>();
                    p.put("id", rs.getInt("id"));
                    p.put("title", rs.getString("title"));
                    p.put("description", rs.getString("description"));
                    p.put("category", rs.getString("category"));
                    p.put("price", rs.getInt("price"));
                    p.put("product_condition", rs.getString("product_condition"));
                    p.put("contact", rs.getString("contact"));
                    p.put("image_path", rs.getString("image_path"));
                    p.put("back_image_path", rs.getString("back_image_path"));
                    p.put("uploader", rs.getString("uploader"));
                    p.put("city", rs.getString("city"));
                    p.put("discount", rs.getInt("discount"));
                    p.put("rating", rs.getFloat("rating"));
                    p.put("status", rs.getString("status"));
                    products.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Failed to load products: " + e.getMessage());
        }

        request.setAttribute("products", products);
        RequestDispatcher rd = request.getRequestDispatcher("manageProducts.jsp");
        rd.forward(request, response);
    }
}