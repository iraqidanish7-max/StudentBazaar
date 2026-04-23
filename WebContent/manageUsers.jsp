<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("home.jsp?error=unauthorized");
        return;
    }

    List<Map<String,Object>> users = (List<Map<String,Object>>) request.getAttribute("users");
    if (users == null) users = new ArrayList<>();
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { font-family:'Segoe UI',Tahoma,sans-serif;background:#0b0e16;color:#fff;margin:20px; }
        .wrap { max-width:1200px; margin:auto; }
        h2 { margin-bottom:10px; }
        table { width:100%; border-collapse:collapse; margin-top:15px; background:rgba(255,255,255,0.03); border-radius:10px; overflow:hidden; }
        th, td { padding:10px 12px; border-bottom:1px solid rgba(255,255,255,0.05); text-align:left; }
        th { background:rgba(255,255,255,0.05); }
        tr:hover td { background:rgba(255,255,255,0.03); }
        .status-active { color:#7efc6b; font-weight:700; }
        .status-suspended { color:#ff6b6b; font-weight:700; }
        .role-admin { color:#00ffe7; font-weight:700; }
        .role-user { color:#ccc; }
        .actions form { display:inline-block; margin-right:4px; }
        .btn { padding:6px 10px; border:none; border-radius:8px; cursor:pointer; font-weight:600; }
        .btn.promote { background:#00b894; color:#fff; }
        .btn.demote { background:#0984e3; color:#fff; }
        .btn.suspend { background:#ff7675; color:#fff; }
        .btn.activate { background:#6c5ce7; color:#fff; }
        .btn.delete { background:#636e72; color:#fff; }
        .back { color:#fff; text-decoration:none; margin-bottom:10px; display:inline-block; }
    </style>
</head>
<body>
<div class="wrap">
    <a href="adminDashboard.jsp" class="back">← Back to Admin</a>
    <h2>Manage Users</h2>

    <% if ("success".equals(msg)) { %>
        <div style="color:#9fffa3;">✔ Action completed successfully.</div>
    <% } else if ("error".equals(msg)) { %>
        <div style="color:#ffaaaa;">❌ Something went wrong.</div>
    <% } %>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>College</th>
            <th>City</th>
            <th>Role</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% for (Map<String,Object> u : users) { %>
            <tr>
                <td><%= u.get("id") %></td>
                <td><%= u.get("name") %></td>
                <td><%= u.get("email") %></td>
                <td><%= u.get("phone") %></td>
                <td><%= u.get("college") %></td>
                <td><%= u.get("city") %></td>
                <td class="role-<%= u.get("role") %>"><%= u.get("role") %></td>
                <td class="status-<%= u.get("status") %>"><%= u.get("status") %></td>
                <td class="actions">
                    <form method="post" action="ManageUserActionServlet">
                        <input type="hidden" name="userId" value="<%= u.get("id") %>">
                        <% if ("user".equalsIgnoreCase((String)u.get("role"))) { %>
                            <input type="hidden" name="action" value="promote">
                            <button class="btn promote">Promote</button>
                        <% } else { %>
                            <input type="hidden" name="action" value="demote">
                            <button class="btn demote">Demote</button>
                        <% } %>
                    </form>
                    <form method="post" action="ManageUserActionServlet">
                        <input type="hidden" name="userId" value="<%= u.get("id") %>">
                        <% if ("active".equalsIgnoreCase((String)u.get("status"))) { %>
                            <input type="hidden" name="action" value="suspend">
                            <button class="btn suspend">Suspend</button>
                        <% } else { %>
                            <input type="hidden" name="action" value="activate">
                            <button class="btn activate">Activate</button>
                        <% } %>
                    </form>
                    <form method="post" action="ManageUserActionServlet" onsubmit="return confirm('Delete user permanently?');">
                        <input type="hidden" name="userId" value="<%= u.get("id") %>">
                        <input type="hidden" name="action" value="delete">
                        <button class="btn delete">Delete</button>
                    </form>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>