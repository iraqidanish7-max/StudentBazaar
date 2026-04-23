package com.studentbazaar.servlet;

import com.studentbazaar.dao.ProductDAO;
import com.studentbazaar.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/StartPaymentServlet")
public class StartPaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Get productId from request
        String productIdStr = request.getParameter("productId");

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            // Handle missing productId
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID missing in request");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);

            // Fetch product from DAO
            Product product = ProductDAO.getProductById(productId);
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }

            // Store in session or request to pass to next page
            session.setAttribute("selectedProduct", product);

            // Redirect to OTP or Payment Page
            response.sendRedirect("payment.jsp"); // Or payment.jsp or verifyOTP.jsp

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Something went wrong");
        }
    }
}