package com.studentbazaar.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); 

        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");
        String productIdStr = request.getParameter("productId");

        try {
            int productId = Integer.parseInt(productIdStr);

            Connection con = DBConnection.getConnection();
            String sql = "DELETE FROM cart WHERE user_email = ? AND product_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, userEmail);
            ps.setInt(2, productId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                session.setAttribute("cartMessage", "Item removed from cart.");
            } else {
                session.setAttribute("cartMessage", "Item not found in cart.");
            }

            response.sendRedirect("cart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("cartMessage", "Something went wrong.");
            response.sendRedirect("cart.jsp");
        }
    }
}