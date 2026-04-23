package com.studentbazaar.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/OtpServlet")
public class OtpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession();
        String correctOtp = (String) session.getAttribute("generatedOtp");

        if (correctOtp == null) {
            correctOtp = "1234"; 
        }

        if (enteredOtp.equals(correctOtp)) {
            // Success - show confirmation
            session.removeAttribute("generatedOtp"); 
            response.sendRedirect("paymentSuccess.jsp");
        } else {
            // Wrong OTP - redirect with error
            response.sendRedirect("otp.jsp?error=1");
        }
    }
}