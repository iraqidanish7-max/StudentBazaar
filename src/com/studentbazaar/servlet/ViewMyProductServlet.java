package com.studentbazaar.servlet;

import com.studentbazaar.model.Product;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ViewMyProductServlet")
public class ViewMyProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Email of currently logged-in user (set in LoginServlet)
        String uploaderEmail = (String) request.getSession().getAttribute("userEmail");

        List<Product> productList = new ArrayList<>();
        List<Integer> soldProductIds = new ArrayList<>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentbazaar", "root", "");

            // 1️⃣ Fetch all products uploaded by this user
            String sql = "SELECT * FROM products WHERE uploader = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, uploaderEmail);
            rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setDescription(rs.getString("description"));
                p.setCategory(rs.getString("category"));
                p.setPrice(rs.getInt("price"));
                p.setCondition(rs.getString("product_condition"));
                p.setContact(rs.getString("contact"));
                p.setImagePath(rs.getString("image_path"));
                p.setBackImagePath(rs.getString("back_image_path"));

                // fixed values from table
                p.setCity(rs.getString("city"));
                p.setRating(rs.getInt("rating"));
                p.setDiscount(rs.getInt("discount"));

                productList.add(p);
            }

            // Close first statement/resultset before reusing
            rs.close();
            ps.close();

            String soldSql =
                    "SELECT DISTINCT o.product_id " +
                    "FROM orders o " +
                    "JOIN products p ON o.product_id = p.id " +
                    "WHERE p.uploader = ?";

            ps = con.prepareStatement(soldSql);
            ps.setString(1, uploaderEmail);
            rs = ps.executeQuery();

            while (rs.next()) {
                soldProductIds.add(rs.getInt("product_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Safe close
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        //  Pass both lists to JSP
        request.setAttribute("productList", productList);
        request.setAttribute("soldProductIds", soldProductIds);

        RequestDispatcher dispatcher = request.getRequestDispatcher("viewmyproduct.jsp");
        dispatcher.forward(request, response);
    }
}