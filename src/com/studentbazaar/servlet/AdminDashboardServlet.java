package com.studentbazaar.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/studentbazaar", "root", ""
        );
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //  Only admin can see dashboard
        HttpSession session = request.getSession(false);
        if (session == null ||
                !"admin".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))) {
            response.sendRedirect(request.getContextPath() + "/home.jsp?error=unauthorized");
            return;
        }

        //  TOP PILL NUMBERS
        int totalUsers = 0;
        int activeListings = 0;
        int totalOrders = 0;
        double totalRevenue = 0.0;

        // CHART DATA 
        int buyersCount = 0;   
        int sellersCount = 0;  
        int adminsCount = 0;   

        List<String> monthLabels = new ArrayList<>();
        List<Integer> monthCounts = new ArrayList<>();

        List<String> orderStatusLabels = new ArrayList<>();
        List<Integer> orderStatusCounts = new ArrayList<>();

        // TABLES
        List<Map<String, Object>> dashboardProducts = new ArrayList<>();
        List<Map<String, Object>> dashboardUsers = new ArrayList<>();
        List<Map<String, Object>> recentOrders = new ArrayList<>();

        try (Connection con = getConnection()) {

           

            // Total users
            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM users");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalUsers = rs.getInt(1);
            }

            // Active listings = approved products
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM products WHERE status = 'approved'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) activeListings = rs.getInt(1);
            }

            // Total orders
            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM orders");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalOrders = rs.getInt(1);
            }

            // Total revenue (sum of product price for each order)
            String revenueSql =
                    "SELECT COALESCE(SUM(p.price),0) AS total " +
                    "FROM orders o " +
                    "LEFT JOIN products p ON o.product_id = p.id";
            try (PreparedStatement ps = con.prepareStatement(revenueSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalRevenue = rs.getDouble("total");
            }

            // ===== User roles chart =====
            // Buyers = distinct user_email in orders
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(DISTINCT user_email) FROM orders");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) buyersCount = rs.getInt(1);
            }

            // Sellers = distinct uploader in products
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(DISTINCT uploader) FROM products");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) sellersCount = rs.getInt(1);
            }

            // Admins = users with role='admin'
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM users WHERE role = 'admin'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) adminsCount = rs.getInt(1);
            }

            // ===== Products per month chart =====
            
            String productsPerMonthSql =
                    "SELECT DATE_FORMAT(posted_on,'%b %Y') AS label, " +
                    "       COUNT(*) AS cnt " +
                    "FROM products " +
                    "GROUP BY YEAR(posted_on), MONTH(posted_on) " +
                    "ORDER BY YEAR(posted_on), MONTH(posted_on) " +
                    "LIMIT 6";
            try (PreparedStatement ps = con.prepareStatement(productsPerMonthSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    monthLabels.add(rs.getString("label"));
                    monthCounts.add(rs.getInt("cnt"));
                }
            }

            // ===== Orders by status chart =====
            
            String ordersStatusSql =
            	    "SELECT 'Completed' AS status, COUNT(*) AS cnt FROM orders " +
            	    "UNION ALL " +
            	    "SELECT 'Pending' AS status, COUNT(*) AS cnt FROM cart";
            try (PreparedStatement ps = con.prepareStatement(ordersStatusSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orderStatusLabels.add(rs.getString("status"));
                    orderStatusCounts.add(rs.getInt("cnt"));
                }
            }

            //  Product Moderation table
            String productsSql =
                    "SELECT id, title, category, price, uploader, city, status, " +
                    "       posted_on AS posted_at " + // alias so JSP can still use 'postedAt'
                    "FROM products " +
                    "ORDER BY CASE WHEN status='pending' THEN 0 " +
                    "              WHEN status='approved' THEN 1 " +
                    "              ELSE 2 END, " +
                    "         posted_on DESC " ;
            try (PreparedStatement ps = con.prepareStatement(productsSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> p = new HashMap<>();
                    p.put("id", rs.getInt("id"));
                    p.put("title", rs.getString("title"));
                    p.put("category", rs.getString("category"));
                    p.put("price", rs.getInt("price"));
                    p.put("uploader", rs.getString("uploader"));
                    p.put("city", rs.getString("city"));
                    p.put("status", rs.getString("status"));
                    p.put("postedAt", rs.getTimestamp("posted_at"));
                    dashboardProducts.add(p);
                }
            }

            // ===== User Management table (all users, using student_status) =====
            String usersSql =
                    "SELECT id, name, email, phone, college, city, role, " +
                    "       student_status AS status, created_at " +
                    "FROM users ORDER BY id ASC LIMIT 20";
            try (PreparedStatement ps = con.prepareStatement(usersSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> u = new HashMap<>();
                    u.put("id", rs.getInt("id"));
                    u.put("name", rs.getString("name"));
                    u.put("email", rs.getString("email"));
                    u.put("phone", rs.getString("phone"));
                    u.put("college", rs.getString("college"));
                    u.put("city", rs.getString("city"));
                    u.put("role", rs.getString("role"));
                    u.put("status", rs.getString("status"));   // actually student_status
                    u.put("joinedAt", rs.getTimestamp("created_at"));
                    dashboardUsers.add(u);
                }
            }

            //  Orders & Purchases table 
            
            String ordersSql =
                    "SELECT o.id AS order_id, o.user_email AS buyer_email, o.product_id, " +
                    "       o.purchase_time, " +
                    "       p.title AS product_title, p.uploader AS seller_email, p.price AS amount " +
                    "FROM orders o " +
                    "LEFT JOIN products p ON o.product_id = p.id " +
                    "ORDER BY o.id DESC LIMIT 10";
            try (PreparedStatement ps = con.prepareStatement(ordersSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> r = new HashMap<>();
                    r.put("orderId", rs.getInt("order_id"));
                    r.put("productTitle", rs.getString("product_title"));
                    r.put("buyerEmail", rs.getString("buyer_email"));
                    r.put("sellerEmail", rs.getString("seller_email"));
                    r.put("amount", rs.getInt("amount"));
                    // status is null -> JSP will show 'success' by default
                    r.put("status", null);
                    r.put("purchasedAt", rs.getTimestamp("purchase_time"));
                    recentOrders.add(r);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Failed to load admin dashboard: " + e.getMessage());
        }

        // Put into request scope for JSP
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activeListings", activeListings);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);

        request.setAttribute("buyersCount", buyersCount);
        request.setAttribute("sellersCount", sellersCount);
        request.setAttribute("adminsCount", adminsCount);

        request.setAttribute("monthLabels", monthLabels);
        request.setAttribute("monthCounts", monthCounts);

        request.setAttribute("orderStatusLabels", orderStatusLabels);
        request.setAttribute("orderStatusCounts", orderStatusCounts);

        request.setAttribute("pendingProducts", dashboardProducts);
        request.setAttribute("dashboardUsers", dashboardUsers);
        request.setAttribute("recentOrders", recentOrders);

        RequestDispatcher rd = request.getRequestDispatcher("adminDashboard.jsp");
        rd.forward(request, response);
    }
}