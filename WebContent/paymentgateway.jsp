<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>Payment Gateway</title></head>
<body>

<h2>Enter Mobile Number for OTP</h2>

<form action="SendOtpServlet" method="post">
    Mobile: <input type="text" name="mobile"><br>
    <button type="submit">Send OTP</button>
</form>

</body>
</html>