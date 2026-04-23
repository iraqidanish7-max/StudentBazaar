package com.studentbazaar.servlet;

import com.studentbazaar.dao.ProductDAO;
import com.studentbazaar.model.Product;
import com.studentbazaar.servlet.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String buyerEmail = (String) session.getAttribute("userEmail");

        try {
            String productIdParam = request.getParameter("productId");
            Connection con = DBConnection.getConnection();
            int rows = 0;

            if (productIdParam != null && !productIdParam.isEmpty()) {
                // BUY NOW for single product
                int productId = Integer.parseInt(productIdParam);
                Product product = ProductDAO.getProductById(productId);

                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO orders (buyer_email, product_name, price, status, order_date) VALUES (?, ?, ?, ?, ?)"
                );
                ps.setString(1, buyerEmail);
                ps.setString(2, product.getName());
                ps.setInt(3, product.getPrice());
                ps.setString(4, "Success");
                ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

                rows = ps.executeUpdate();

            } else {
                // BUY FULL CART
                List<Product> cartList = (List<Product>) session.getAttribute("cartList");

                if (cartList != null && !cartList.isEmpty()) {
                    for (Product p : cartList) {
                        PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO orders (buyer_email, product_name, price, status, order_date) VALUES (?, ?, ?, ?, ?)"
                        );
                        ps.setString(1, buyerEmail);
                        ps.setString(2, p.getName());
                        ps.setInt(3, p.getPrice());
                        ps.setString(4, "Success");
                        ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                        rows += ps.executeUpdate();
                    }

                    // Clear the cart after successful order
                    session.removeAttribute("cartList");
                    session.setAttribute("cartcount",0);
                }
            }

            con.close();

            if (rows > 0) {
                session.setAttribute("message", "Payment Successful!");
                response.sendRedirect("viewmypurchases.jsp");
            } else {
                session.setAttribute("message", "Payment Failed!");
                response.sendRedirect("payment.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("payment.jsp");
        }
    }
}