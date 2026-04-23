package com.studentbazaar.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Secure session check: do not create new session if it doesn't exist
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get userEmail from session
        String userEmail = (String) session.getAttribute("userEmail");

        //  Get productId safely
        String productIdStr = request.getParameter("productId");
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect("buyproduct.jsp");
            return;
        }

        int productId = Integer.parseInt(productIdStr);

        try {
            Connection con = DBConnection.getConnection();

            //  Check if already in cart
            String checkQuery = "SELECT * FROM cart WHERE user_email = ? AND product_id = ?";
            PreparedStatement checkStmt = con.prepareStatement(checkQuery);
            checkStmt.setString(1, userEmail);
            checkStmt.setInt(2, productId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // increment quantity
                String updateQuery = "UPDATE cart SET quantity = quantity + 1 WHERE user_email = ? AND product_id = ?";
                PreparedStatement updateStmt = con.prepareStatement(updateQuery);
                updateStmt.setString(1, userEmail);
                updateStmt.setInt(2, productId);
                updateStmt.executeUpdate();
            } else {
                //  insert new
                String insertQuery = "INSERT INTO cart (user_email, product_id, quantity) VALUES (?, ?, 1)";
                PreparedStatement insertStmt = con.prepareStatement(insertQuery);
                insertStmt.setString(1, userEmail);
                insertStmt.setInt(2, productId);
                insertStmt.executeUpdate();
            }

            //  Set SweetAlert success message
            session.setAttribute("cartMessage", "Product added to cart!");
         //  Count total cart items for this user
            String countQuery = "SELECT SUM(quantity) AS total FROM cart WHERE user_email = ?";
            PreparedStatement countStmt = con.prepareStatement(countQuery);
            countStmt.setString(1, userEmail);
            ResultSet countRs = countStmt.executeQuery();
            int totalItems = 0;
            if (countRs.next()) {
                totalItems = countRs.getInt("total");
            }

            // Store in session
            session.setAttribute("cartCount", totalItems);

            // redirect back to category page (pass category back from JSP form)
            String category = request.getParameter("category");
            if (category != null && !category.trim().isEmpty()) {
                response.sendRedirect("CategoryServlet?category=" + category);
            } else {
                response.sendRedirect("buyproduct.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}