<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession otpSession = request.getSession(false);
    String otpSuccess = (otpSession != null) ? (String) otpSession.getAttribute("otpSuccess") : null;

    // Only show this page if OTP was successfully sent
    if ("true".equals(otpSuccess) || request.getParameter("error")!=null){
        otpSession.removeAttribute("otpSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Verify OTP - StudentBazaar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Main theme CSS -->
    <link rel="stylesheet" href="css/studentbazaar.css">

    <!-- Font Awesome (if needed later) -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="page-bg">

    <%@ include file="header.jsp" %>

    <main class="otp-page-main">

        <section class="otp-card-shell rainbow-frame">
            <div class="rainbow-inner otp-card">

                <h2>Enter OTP</h2>
                <p class="otp-subtext">
                    We’ve sent a one-time password to your registered email.
                    Enter it below to confirm your purchase.
                </p>

                <form class="otp-form" action="OtpVerificationServlet" method="post">
                    <label for="otp">OTP Code</label>
                    <input type="text"
                           id="otp"
                           name="otp"
                           class="otp-input"
                           placeholder="6-digit OTP"
                           maxlength="6"
                           required>

                    <button type="submit"
                            class="primary-gradient-btn otp-submit-btn">
                        Verify &amp; Complete Payment
                    </button>

                    <p class="otp-hint">
                        Didn’t receive it? Please check your spam folder or try again after a minute.
                    </p>
                </form>

            </div>
        </section>

    </main>

    <%@ include file="footer.jsp" %>

    <!-- OTP sent alert (shown only once because of session flag) -->
    <script>
        Swal.fire({
            title: 'OTP Sent!',
            text: 'Check your email for the OTP code.',
            icon: 'success',
            confirmButtonColor: '#2575fc',
            confirmButtonText: 'OK'
        });
    </script>
<%
    String error = request.getParameter("error");
    if ("invalidOtp".equals(error)) {
%>
<script>
Swal.fire({
    icon: 'error',
    title: 'Invalid OTP',
    text: 'Your Otp attempt failed. Please restart the purchase process',
    confirmButtonColor: '#d33'
});
</script>
<%
    }
%>
</body>
</html>
<%
    } // end if otpSuccess == "true"
%>