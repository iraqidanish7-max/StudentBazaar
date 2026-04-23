package com.studentbazaar.servlet;

import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;

@WebServlet("/OtpVerificationServlet")
public class OtpVerificationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession();
        String sessionOtp = (String) session.getAttribute("otp");

        // Dual key fallback
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            userEmail = (String) session.getAttribute("email");
        }

        System.out.println("DEBUG >> Session OTP: " + sessionOtp);
        System.out.println("DEBUG >> Entered OTP: " + enteredOtp);
        System.out.println("DEBUG >> userEmail from session: " + userEmail);

        if (enteredOtp != null && enteredOtp.equals(sessionOtp)) {

            // ------------------ BEGIN: transactional save-to-orders + cart-delete ------------------
            Connection conn = null;
            try {
                conn = DBConnection.getConnection();
                conn.setAutoCommit(false); // start transaction

                // Fetch cart items for this user (product_id + quantity)
                String fetchSql = "SELECT product_id, quantity FROM cart WHERE user_email = ?";
                try (PreparedStatement fetchPs = conn.prepareStatement(fetchSql)) {
                    fetchPs.setString(1, userEmail);
                    try (ResultSet rs = fetchPs.executeQuery()) {
                        // prepare insert if there are rows
                        boolean hasRows = false;

                        //  batch inserts into orders table
                        String insertSql = "INSERT INTO orders (user_email, product_id) VALUES (?, ?)";
                        try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                            while (rs.next()) {
                                hasRows = true;
                                int productId = rs.getInt("product_id");
                                insertPs.setString(1, userEmail);
                                insertPs.setInt(2, productId);
                                insertPs.addBatch();
                            }

                            if (hasRows) {
                                insertPs.executeBatch();
                            }
                        }
                    }
                }

                // Delete cart rows for the user
                String deleteSql = "DELETE FROM cart WHERE user_email = ?";
                int rowsDeleted = 0;
                try (PreparedStatement delPs = conn.prepareStatement(deleteSql)) {
                    delPs.setString(1, userEmail);
                    rowsDeleted = delPs.executeUpdate();
                }

                conn.commit(); 
                System.out.println("✅ Transaction committed. Cart delete rows = " + rowsDeleted);

            } catch (Exception e) {
                e.printStackTrace();
                // rollback on error
                if (conn != null) {
                    try {
                        conn.rollback();
                        System.out.println("❗ Transaction rolled back due to error.");
                    } catch (Exception rollbackEx) {
                        rollbackEx.printStackTrace();
                    }
                }
            } finally {
                if (conn != null) {
                    try {
                        conn.setAutoCommit(true);
                        conn.close();
                    } catch (Exception closeEx) {
                        closeEx.printStackTrace();
                    }
                }
            }
            // ------------------ END transactional block ------------------

            // Clear session cart objects (unchanged)
            session.removeAttribute("cartItems");
            session.setAttribute("cartCount", 0);

            // Send thank-you email (kept exactly as in your original code)
            final String senderEmail = "studentbazaar.otp@gmail.com";
            final String senderPassword = "vmxkucqvshvbpyll";

            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            // note: javax.mail.Session is used for mail; using a local variable name avoids confusion
            Session mailSession = Session.getInstance(props, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderEmail, senderPassword);
                }
            });

            try {
                if (userEmail != null && !userEmail.isEmpty()) {
                    Message confirmationMsg = new MimeMessage(mailSession);
                    confirmationMsg.setFrom(new InternetAddress(senderEmail));
                    confirmationMsg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
                    confirmationMsg.setSubject("StudentBazaar - Order Confirmation");
                    confirmationMsg.setText("Hello,\n\nThank you for shopping with StudentBazaar!\nYour order has been placed.\n\nTeam StudentBazaar");
                    Transport.send(confirmationMsg);
                }
            } catch (MessagingException e) {
                // keep existing behavior: print stack and continue
                e.printStackTrace();
            }

            // keep existing redirect to paymentsuccess.jsp
            response.sendRedirect("paymentsuccess.jsp");

        } else {
            // keep existing invalid OTP behavior unchanged
        	response.sendRedirect("otp.jsp?error=invalidOtp");
        	return;
        }
    }
}