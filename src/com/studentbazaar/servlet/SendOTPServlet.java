

package com.studentbazaar.servlet;

import java.io.PrintWriter;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;

import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.*;

@WebServlet("/SendOTPServlet")
public class SendOTPServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String FROM_EMAIL = "studentbazaar.otp@gmail.com";
    private static final String FROM_PASSWORD = "vmxkucqvshvbpyll"; // Gmail App Password

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();

        // Get user email from request or session
        String userEmail = request.getParameter("userEmail");
        if (userEmail == null || userEmail.trim().isEmpty()) {
            userEmail = (String) session.getAttribute("userEmail");
        }

        if (userEmail == null || userEmail.trim().isEmpty()) {
            out.println("<script>alert('Email not found. Please login first.'); window.location='login.jsp';</script>");
            return;
        }

        //  Generate OTP as String
        String otp = String.valueOf(new Random().nextInt(900000) + 100000);

        //  Store OTP and email in session
        session.setAttribute("otp", otp);
        session.setAttribute("otpEmail", userEmail);

        //  Optionally clear cart
        session.removeAttribute("cart");
        session.removeAttribute("cartCount");

        //  Prepare email
        final String subject = "Your StudentBazaar OTP Code";
        final String body = "Dear user,\n\nYour OTP code is: " + otp + "\n\nRegards,\nStudentBazaar Team";

        //  Email configuration
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);

            session.setAttribute("otpSuccess", "true");
            response.sendRedirect("otp.jsp");
        } catch (MessagingException e) {
            e.printStackTrace();
            out.println("<script>alert('Error sending OTP: " + e.getMessage() + "'); window.location='cart.jsp';</script>");
        }
    }
}