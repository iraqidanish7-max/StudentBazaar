package com.studentbazaar.servlet;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
	public static void placeOrder(HttpSession session) {
        try {
            Connection con = DBConnection.getConnection();
            String userEmail = (String) session.getAttribute("email");

            PreparedStatement ps = con.prepareStatement("DELETE FROM cart WHERE email = ?");
            ps.setString(1, userEmail);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        try {
            Connection conCheck = DBConnection.getConnection();
            PreparedStatement psCheck = conCheck.prepareStatement(
                "SELECT student_status FROM users WHERE email = ?"
            );
            psCheck.setString(1, userEmail);

            ResultSet rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {
                String status = rsCheck.getString("student_status");

                if (status == null || !status.equalsIgnoreCase("Verified")) {
                    response.sendRedirect("home.jsp?error=notverified");
                    return;
                }
            }

            rsCheck.close();
            psCheck.close();
            conCheck.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement psCart = null;
        PreparedStatement psProduct = null;
        PreparedStatement psInsert = null;
        PreparedStatement psDeleteCart = null;
        ResultSet rsCart = null;
        ResultSet rsProduct = null;

        try {
            con = DBConnection.getConnection();

            //  Get all cart items
            String sqlCart = "SELECT product_id, quantity FROM cart WHERE user_email = ?";
            psCart = con.prepareStatement(sqlCart);
            psCart.setString(1, userEmail);
            rsCart = psCart.executeQuery();

            while (rsCart.next()) {
                int productId = rsCart.getInt("product_id");
                int quantity = rsCart.getInt("quantity");

                //  Get product details
                String sqlProduct = "SELECT title, price, image_path FROM products WHERE id = ?";
                psProduct = con.prepareStatement(sqlProduct);
                psProduct.setInt(1, productId);
                rsProduct = psProduct.executeQuery();

                if (rsProduct.next()) {
                    String productName = rsProduct.getString("title");
                    int price = rsProduct.getInt("price");
                    String imagePath = rsProduct.getString("image_path");

                    //  Insert into orders
                    String sqlInsert = "INSERT INTO orders (buyer_email, product_name, price, status, order_date, product_image) VALUES (?, ?, ?, 'Placed', NOW(), ?)";
                    psInsert = con.prepareStatement(sqlInsert);
                    psInsert.setString(1, userEmail);
                    psInsert.setString(2, productName);
                    psInsert.setInt(3, price);
                    psInsert.setString(4, imagePath);
                    psInsert.executeUpdate();
                }
            }

            //  Clear cart
            String sqlDelete = "DELETE FROM cart WHERE user_email = ?";
            psDeleteCart = con.prepareStatement(sqlDelete);
            psDeleteCart.setString(1, userEmail);
            psDeleteCart.executeUpdate();

            response.sendRedirect("viewmypurchases.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred: " + e.getMessage());
        } finally {
            try { if (rsCart != null) rsCart.close(); } catch (Exception e) {}
            try { if (rsProduct != null) rsProduct.close(); } catch (Exception e) {}
            try { if (psCart != null) psCart.close(); } catch (Exception e) {}
            try { if (psProduct != null) psProduct.close(); } catch (Exception e) {}
            try { if (psInsert != null) psInsert.close(); } catch (Exception e) {}
            try { if (psDeleteCart != null) psDeleteCart.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}