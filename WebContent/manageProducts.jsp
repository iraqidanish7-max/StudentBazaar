<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("home.jsp?error=unauthorized");
        return;
    }

    List<Map<String,Object>> products = (List<Map<String,Object>>) request.getAttribute("products");
    if (products == null) products = new ArrayList<>();
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Products - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; margin:20px; background:#0b0e16; color:#fff; }
        .wrap { max-width:1200px; margin: 0 auto; }
        h2 { margin-bottom:12px; }
        table { width:100%; border-collapse:collapse; margin-top:12px; background: rgba(255,255,255,0.03); border-radius:8px; overflow:hidden; }
        th, td { padding:10px 12px; text-align:left; border-bottom:1px solid rgba(255,255,255,0.04); }
        th { background: rgba(255,255,255,0.02); font-weight:700; }
        tr:hover td { background: rgba(255,255,255,0.01); }
        .status-pending { color: #ffb347; font-weight:700; }
        .status-approved { color: #7efc6b; font-weight:700; }
        .status-rejected { color: #ff6b6b; font-weight:700; }
        .actions form { display:inline-block; margin-right:6px; }
        .btn { padding:8px 10px; border-radius:8px; border:none; cursor:pointer; font-weight:700; }
        .btn.approve { background: #28a745; color:#fff; }
        .btn.reject { background: #ff6b6b; color:#fff; }
        .btn.delete { background: #6c757d; color:#fff; }
        .thumb { width:120px; height:80px; object-fit:cover; border-radius:6px; border:1px solid rgba(255,255,255,0.04); }
        .top-actions { display:flex; justify-content:space-between; align-items:center; gap:12px; }
        .filter { padding:8px 10px; background: rgba(255,255,255,0.03); color:#fff; border-radius:8px; border:1px solid rgba(255,255,255,0.02); }
        .msg { margin-top:10px; color:#cfcfcf; }
    </style>
</head>
<body>
<div class="wrap">
    <div class="top-actions">
        <h2>Manage Products (Admin)</h2>
        <div>
            <a href="adminDashboard.jsp" style="color:#fff; text-decoration:none; margin-right:12px;">← Back to Admin</a>
            <a href="home.jsp" style="color:#fff; text-decoration:none;">User View</a>
        </div>
    </div>

    <div class="msg">
        <% if ("ok".equals(msg)) { %>
            <div style="color:#b6f7c1">Action completed successfully.</div>
        <% } else if ("error".equals(msg)) { %>
            <div style="color:#ffb3b3">Action failed. Check server logs.</div>
        <% } else if ("invalid".equals(msg) || "invalid-id".equals(msg)) { %>
            <div style="color:#ffb3b3">Invalid request.</div>
        <% } %>
    </div>

    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Thumb</th>
                <th>Title</th>
                <th>Category</th>
                <th>Price</th>
                <th>Uploader</th>
                <th>City</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <% int idx=1;
           for (Map<String,Object> p : products) {
               Integer id = (Integer) p.get("id");
               String title = (String) p.get("title");
               String img = (String) p.get("image_path");
               String cat = (String) p.get("category");
               Object priceObj = p.get("price");
               String price = (priceObj != null) ? priceObj.toString() : "0";
               String uploader = (String) p.get("uploader");
               String city = (String) p.get("city");
               String status = (String) p.get("status");
               if (img == null || img.trim().isEmpty()) img = request.getContextPath() + "/img/default.jpg";
        %>
            <tr>
                <td><%= idx++ %></td>
                <td><img src="<%= img %>" class="thumb" alt="img"></td>
                <td><%= title %></td>
                <td><%= cat %></td>
                <td>₹<%= price %></td>
                <td><%= uploader %></td>
                <td><%= city %></td>
                <td>
                    <span class="status-<%= status != null ? status.toLowerCase() : "unknown" %>">
                        <%= status != null ? status : "N/A" %>
                    </span>
                </td>
                <td class="actions">
                    <!-- Approve -->
                    <form action="ManageProductActionServlet" method="post" onsubmit="return confirm('Approve this product?');" style="display:inline;">
                        <input type="hidden" name="productId" value="<%= id %>">
                        <input type="hidden" name="action" value="approve">
                        <button class="btn approve" title="Approve">Approve</button>
                    </form>

                    <!-- Reject -->
                    <form action="ManageProductActionServlet" method="post" onsubmit="return confirm('Reject this product?');" style="display:inline;">
                        <input type="hidden" name="productId" value="<%= id %>">
                        <input type="hidden" name="action" value="reject">
                        <button class="btn reject" title="Reject">Reject</button>
                    </form>

                    <!-- Delete -->
                    <form action="ManageProductActionServlet" method="post" onsubmit="return confirm('Delete this product permanently?');" style="display:inline;">
                        <input type="hidden" name="productId" value="<%= id %>">
                        <input type="hidden" name="action" value="delete">
                        <button class="btn delete" title="Delete">Delete</button>
                    </form>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>