package com.studentbazaar.servlet;

import com.studentbazaar.model.Product;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditProductServlet")
public class EditProductServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentbazaar",
                    "root",
                    ""
            );

            String sql = "SELECT * FROM products WHERE id = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, productId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                product = new Product();
                product.setId(rs.getInt("id"));
                product.setTitle(rs.getString("title"));

                //  Description now fetched
                product.setDescription(rs.getString("description"));

                product.setCategory(rs.getString("category"));
                product.setCondition(rs.getString("product_condition"));
                product.setPrice(rs.getInt("price"));
                product.setContact(rs.getString("contact"));
                product.setCity(rs.getString("city"));
                product.setImagePath(rs.getString("image_path"));
                product.setBackImagePath(rs.getString("back_image_path"));
            }

            rs.close();
            pst.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (product != null) {
            request.setAttribute("product", product);
            RequestDispatcher dispatcher = request.getRequestDispatcher("editproduct.jsp");
            dispatcher.forward(request, response);
        } else {
            response.setContentType("text/html");
            response.getWriter().println("<h2 style='color:white;text-align:center;'>Product not found</h2>");
        }
    }
}