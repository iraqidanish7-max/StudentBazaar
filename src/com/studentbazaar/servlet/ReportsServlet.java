package com.studentbazaar.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
@WebServlet("/ReportsServlet")
public class ReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // heuristics to pick the right column name
    
    private String pickColumn(List<String> cols, String... tokens) {
        for (String t : tokens) {
            for (String c : cols) {
                if (c.toLowerCase().contains(t.toLowerCase())) return c;
            }
        }
        // fallback to first column if nothing matches
        return cols.isEmpty() ? null : cols.get(0);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/home.jsp?error=unauthorized");
            return;
        }

        String contextPath = request.getContextPath();
        List<String> ordersCols = new ArrayList<>();
        Map<String, Object> totals = new HashMap<>();
        List<Map<String, Object>> topProducts = new ArrayList<>();
        List<Map<String, Object>> ordersPerDay = new ArrayList<>();
        String errorMsg = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/studentbazaar", "root", "")) {

                // 1) read column names from orders table
                try (ResultSet rs = con.getMetaData().getColumns(null, null, "orders", null)) {
                    while (rs.next()) {
                        String col = rs.getString("COLUMN_NAME");
                        ordersCols.add(col);
                    }
                }
                if (ordersCols.isEmpty()) {
                    // fallback: try SELECT * and grab metadata (in case of different case or privileges)
                    try (PreparedStatement ps = con.prepareStatement("SELECT * FROM orders LIMIT 1");
                         ResultSet rs = ps.executeQuery()) {
                        ResultSetMetaData md = rs.getMetaData();
                        for (int i = 1; i <= md.getColumnCount(); i++) {
                            ordersCols.add(md.getColumnLabel(i));
                        }
                    } catch (SQLException ignored) { /* ignore */ }
                }

                // pick best columns
                String idCol = pickColumn(ordersCols, "id", "ID");
                String buyerCol = pickColumn(ordersCols, "buyer", "user", "email");
                String productCol = pickColumn(ordersCols, "product", "title", "name");
                String priceCol = pickColumn(ordersCols, "price", "total", "amount");
                String statusCol = pickColumn(ordersCols, "status", "order_status");
                String dateCol = pickColumn(ordersCols, "date", "created", "order");

                
                // total orders
                int totalOrders = 0;
                try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM orders");
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalOrders = rs.getInt(1);
                } catch (SQLException ex) { /* leave 0 */ }

                // total revenue (if priceCol is numeric)
                double totalRevenue = 0.0;
                if (priceCol != null) {
                    String sqlSum = "SELECT SUM(CAST(" + priceCol + " AS DECIMAL(15,2))) FROM orders";
                    try (PreparedStatement ps = con.prepareStatement(sqlSum);
                         ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) totalRevenue = rs.getDouble(1);
                    } catch (SQLException ex) {
                        // maybe price column is named differently or non-numeric; ignore
                    }
                }

                // total users & products (safe queries)
                int totalUsers = 0;
                int totalProducts = 0;
                try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM users");
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalUsers = rs.getInt(1);
                } catch (SQLException ex) { /* ignore */ }
                try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM products");
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalProducts = rs.getInt(1);
                } catch (SQLException ex) { /* ignore */ }

                totals.put("totalOrders", totalOrders);
                totals.put("totalRevenue", totalRevenue);
                totals.put("totalUsers", totalUsers);
                totals.put("totalProducts", totalProducts);

                //  top products by count + revenue (if productCol exists)
                if (productCol != null) {
                    String prodSql;
                    if (priceCol != null) {
                        prodSql = "SELECT " + productCol + " AS product_name, COUNT(*) AS cnt, SUM(CAST(" + priceCol + " AS DECIMAL(15,2))) AS revenue " +
                                  "FROM orders GROUP BY " + productCol + " ORDER BY cnt DESC LIMIT 10";
                    } else {
                        prodSql = "SELECT " + productCol + " AS product_name, COUNT(*) AS cnt " +
                                  "FROM orders GROUP BY " + productCol + " ORDER BY cnt DESC LIMIT 10";
                    }
                    try (PreparedStatement ps = con.prepareStatement(prodSql);
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> row = new HashMap<>();
                            row.put("product", rs.getString("product_name"));
                            row.put("count", rs.getInt("cnt"));
                            try { row.put("revenue", rs.getDouble("revenue")); } catch (Exception ignore) {}
                            topProducts.add(row);
                        }
                    } catch (SQLException ex) {
                    }
                }

                //  orders per day (last 30 days) if dateCol parsable
                if (dateCol != null) {
                    // try to treat dateCol as datetime/timestamp or string parsable by DATE()
                    String perDaySql = "SELECT DATE(" + dateCol + ") AS order_day, COUNT(*) AS cnt " +
                            "FROM orders WHERE " + dateCol + " IS NOT NULL " +
                            "GROUP BY DATE(" + dateCol + ") ORDER BY order_day DESC LIMIT 30";
                    try (PreparedStatement ps = con.prepareStatement(perDaySql);
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> r = new HashMap<>();
                            r.put("day", rs.getDate("order_day"));
                            r.put("count", rs.getInt("cnt"));
                            ordersPerDay.add(r);
                        }
                    } catch (SQLException ex) {
                        // if DATE(column) fails (e.g., column not datetime), skip
                    }
                }

                // If request asked for CSV download, handle it
                String download = request.getParameter("download"); // "orders" or "products"
                if (download != null) {
                    if ("orders".equalsIgnoreCase(download)) {
                        // stream full orders CSV
                        response.setContentType("text/csv");
                        response.setHeader("Content-Disposition", "attachment; filename=\"orders_export.csv\"");
                        try (PrintWriter out = response.getWriter();
                             PreparedStatement ps = con.prepareStatement("SELECT * FROM orders");
                             ResultSet rs = ps.executeQuery()) {

                            ResultSetMetaData md = rs.getMetaData();
                            int colCount = md.getColumnCount();
                            // header
                            for (int i = 1; i <= colCount; i++) {
                                out.print(md.getColumnLabel(i));
                                if (i < colCount) out.print(",");
                            }
                            out.println();

                            while (rs.next()) {
                                for (int i = 1; i <= colCount; i++) {
                                    Object v = rs.getObject(i);
                                    String s = (v == null) ? "" : v.toString().replaceAll("\"", "\"\"");
                                    out.print("\"" + s + "\"");
                                    if (i < colCount) out.print(",");
                                }
                                out.println();
                            }
                        }
                        return;
                    } else if ("products".equalsIgnoreCase(download) && productCol != null) {
                        response.setContentType("text/csv");
                        response.setHeader("Content-Disposition", "attachment; filename=\"sales_by_product.csv\"");
                        try (PrintWriter out = response.getWriter()) {
                            // header
                            if (priceCol != null) {
                                out.println("\"product\",\"count\",\"revenue\"");
                                // reuse topProducts but run a query to include all rows
                                String q = "SELECT " + productCol + " AS product_name, COUNT(*) AS cnt, SUM(CAST(" + priceCol + " AS DECIMAL(15,2))) AS revenue " +
                                           "FROM orders GROUP BY " + productCol + " ORDER BY cnt DESC";
                                try (PreparedStatement ps = con.prepareStatement(q);
                                     ResultSet rs = ps.executeQuery()) {
                                    while (rs.next()) {
                                        String p = rs.getString("product_name");
                                        int cnt = rs.getInt("cnt");
                                        double rev = rs.getDouble("revenue");
                                        out.printf("\"%s\",%d,%.2f%n", p == null ? "" : p.replaceAll("\"","\"\""), cnt, rev);
                                    }
                                }
                                return;
                            } else {
                                out.println("\"product\",\"count\"");
                                String q = "SELECT " + productCol + " AS product_name, COUNT(*) AS cnt " +
                                           "FROM orders GROUP BY " + productCol + " ORDER BY cnt DESC";
                                try (PreparedStatement ps = con.prepareStatement(q);
                                     ResultSet rs = ps.executeQuery()) {
                                    while (rs.next()) {
                                        String p = rs.getString("product_name");
                                        int cnt = rs.getInt("cnt");
                                        out.printf("\"%s\",%d%n", p == null ? "" : p.replaceAll("\"","\"\""), cnt);
                                    }
                                }
                                return;
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = e.getMessage();
        }

        // pass everything to JSP
        request.setAttribute("ordersCols", ordersCols);
        request.setAttribute("totals", totals);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("ordersPerDay", ordersPerDay);
        request.setAttribute("errorMsg", errorMsg);

        RequestDispatcher rd = request.getRequestDispatcher("reports.jsp");
        rd.forward(request, response);
    }
}