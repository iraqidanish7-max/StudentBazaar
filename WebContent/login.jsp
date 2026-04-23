<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>StudentBazaar - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/studentbazaar.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="page-bg">
<div class="page-wrapper">

    <%@ include file="header.jsp" %>

    <section class="auth-section">
        <div class="auth-card auth-card--narrow reveal-card">
            <h2 class="auth-title">Login to StudentBazaar</h2>
            <p class="auth-subtitle">
                Access your campus marketplace dashboard and manage your listings in one place.
            </p>

            <form action="LoginServlet" method="post" autocomplete="off">
                <label for="email" class="auth-label">Email</label>
                <input type="text" name="email" id="email" class="auth-input"
                       placeholder="Email" autocomplete="off" required>

                <div class="password-wrapper">
                    <label for="password" class="auth-label">Password</label>
                    <input type="password" name="password" id="password" class="auth-input"
                           placeholder="Password" autocomplete="off" required>
                    <span class="toggle-password" onclick="togglePassword()">👁</span>
                </div>

                <div class="auth-actions">
                    <button type="submit" class="btn-primary auth-btn">Login</button>
                </div>
            </form>

            <div class="auth-footer-text">
                Don’t have an account?
                <a href="register.jsp">Register here</a>
            </div>
        </div>
    </section>

    <%@ include file="footer.jsp" %>

</div>

<!-- JS: password toggle + SweetAlert login status -->
<script>
    function togglePassword() {
        const input = document.getElementById("password");
        if (!input) return;
        input.type = input.type === "password" ? "text" : "password";
    }

    function subscribeAlert(event) {
        event.preventDefault();
        Swal.fire("Subscribed!", "Thank you for subscribing to StudentBazaar!", "success");
    }

    <% if ("invalid".equals(request.getParameter("error"))) { %>
    window.onload = function () {
        Swal.fire("Login Failed", "Incorrect email or password!", "error");
    }
    <% } %>

    <% if ("loggedout".equals(request.getParameter("status"))) { %>
    window.onload = function () {
        Swal.fire({
            icon: 'success',
            title: 'Logged Out',
            text: 'You have been successfully logged out!',
            showConfirmButton: false,
            timer: 2000
        });
    }
    <% } %>
</script>

</body>
</html>