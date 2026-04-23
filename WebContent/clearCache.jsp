<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("home.jsp?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Clear Cache / Temp - Admin</title>
    <style>
        body{font-family:Segoe UI, Tahoma, sans-serif;background:#0b0e16;color:#fff;margin:20px}
        .wrap{max-width:1100px;margin:0 auto;}
    </style>
</head>
<body>
<div class="wrap">
    <a class="back" href="adminDashboard.jsp">← Back to Admin</a>
    <h2>Clear Cache / Temp (Placeholder)</h2>
    
</div>
</body>
</html>