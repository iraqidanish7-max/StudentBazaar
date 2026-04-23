package com.studentbazaar.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ManageOrdersServlet")
public class ManageOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // admin guard
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/home.jsp?error=unauthorized");
            return;
        }

        List<String> columns = new ArrayList<>();
        List<Map<String,Object>> rows = new ArrayList<>();

        String sql = "SELECT * FROM orders ORDER BY id DESC"; // works with any column set

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/studentbazaar", "root", "");
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                ResultSetMetaData md = rs.getMetaData();
                int colCount = md.getColumnCount();
                for (int i = 1; i <= colCount; i++) {
                    columns.add(md.getColumnLabel(i));
                }

                while (rs.next()) {
                    Map<String,Object> row = new LinkedHashMap<>();
                    for (String col : columns) {
                        Object val = rs.getObject(col);
                        row.put(col, val);
                    }
                    rows.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Failed to load orders: " + e.getMessage());
        }

        request.setAttribute("ordersColumns", columns);
        request.setAttribute("ordersRows", rows);
        RequestDispatcher rd = request.getRequestDispatcher("manageOrders.jsp");
        rd.forward(request, response);
    }
}