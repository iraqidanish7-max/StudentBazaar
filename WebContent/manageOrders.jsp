<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("home.jsp?error=unauthorized");
        return;
    }

    List<String> columns = (List<String>) request.getAttribute("ordersColumns");
    List<Map<String,Object>> rows = (List<Map<String,Object>>) request.getAttribute("ordersRows");
    if (columns == null) columns = new ArrayList<>();
    if (rows == null) rows = new ArrayList<>();

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Manage Orders - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body{font-family:'Segoe UI', Tahoma, sans-serif;background:#0b0e16;color:#fff;margin:20px;}
        .wrap{max-width:1200px;margin:0 auto;}
        table{width:100%;border-collapse:collapse;margin-top:12px;background:rgba(255,255,255,0.03);border-radius:6px;overflow:hidden;}
        th,td{padding:10px 12px;text-align:left;border-bottom:1px solid rgba(255,255,255,0.04);}
        th{background:rgba(255,255,255,0.02);}
        .badge{display:inline-block;padding:6px 10px;border-radius:12px;font-weight:700;}
        .status-pending{background:#ffb347;color:#000;}
        .status-shipped{background:#4db6ac;color:#000;}
        .status-delivered{background:#7efc6b;color:#000;}
        .status-cancelled{background:#ff6b6b;color:#000;}
        .actions form { display:inline-block; margin-right:6px; }
        .btn { padding:6px 10px;border-radius:8px;border:none;cursor:pointer;font-weight:700; }
        .btn.update{ background:#0984e3;color:#fff; }
        .btn.delete{ background:#636e72;color:#fff; }
        .back { color:#fff; text-decoration:none; }
        img.thumb { height:60px; width:80px; object-fit:cover; border-radius:6px; border:1px solid rgba(255,255,255,0.04); }
    </style>
</head>
<body>
<div class="wrap">
    <a href="adminDashboard.jsp" class="back">← Back to Admin</a>
    <h2 style="display:inline-block;margin-left:12px;">Manage Orders</h2>

    <div style="margin-top:8px;">
        <% if ("ok".equals(msg)) { %>
            <div style="color:#b6f7c1">Action completed.</div>
        <% } else if ("error".equals(msg)) { %>
            <div style="color:#ffb3b3">Action failed. Check logs.</div>
        <% } else if ("nostatuscol".equals(msg)) { %>
            <div style="color:#ffd27a">Table has no 'status' column - status update disabled.</div>
        <% } %>
    </div>

    <table>
        <thead>
            <tr>
                <th>#</th>
                <%-- print all column names as headers --%>
                <% for (String col : columns) { %>
                    <th><%= col %></th>
                <% } %>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <% int idx=1;
           for (Map<String,Object> r : rows) {
               Object idVal = r.get("id") != null ? r.get("id") : r.get("ID"); // try both common upper/lower
               String idStr = idVal != null ? idVal.toString() : String.valueOf(idx);
               // Prepare status if exists (case-insensitive)
               String statusVal = null;
               for (String possible : new String[] {"status","Status","order_status","OrderStatus"}) {
                   if (r.containsKey(possible) && r.get(possible) != null) {
                       statusVal = String.valueOf(r.get(possible));
                       break;
                   }
               }
        %>
            <tr>
                <td><%= idx++ %></td>
                <% for (String col : columns) {
                       Object v = r.get(col);
                       // If column seems image-like, render <img>
                       String lower = col.toLowerCase();
                       if (v != null && (lower.contains("img") || lower.contains("image") || lower.contains("photo"))) {
                %>
                    <td><img class="thumb" src="<%= String.valueOf(v) %>" alt="img"></td>
                <%   } else { %>
                    <td><%= v != null ? v : "-" %></td>
                <%   } 
                   } %>

                <td class="actions">
                    <%-- update status form only if status column exists --%>
                    <% if (statusVal != null) { %>
                        <form method="post" action="ManageOrderActionServlet" style="display:inline;">
                            <input type="hidden" name="orderId" value="<%= idStr %>">
                            <input type="hidden" name="action" value="update_status">
                            <select name="newStatus" style="padding:6px;border-radius:6px;margin-right:6px;">
                                <option value="pending" <%= "pending".equalsIgnoreCase(statusVal) ? "selected" : "" %>>Pending</option>
                                <option value="shipped" <%= "shipped".equalsIgnoreCase(statusVal) ? "selected" : "" %>>Shipped</option>
                                <option value="delivered" <%= "delivered".equalsIgnoreCase(statusVal) ? "selected" : "" %>>Delivered</option>
                                <option value="cancelled" <%= "cancelled".equalsIgnoreCase(statusVal) ? "selected" : "" %>>Cancelled</option>
                            </select>
                            <button class="btn update">Update</button>
                        </form>
                    <% } else { %>
                        <span style="color:#ccc;font-size:13px;">No status column</span>
                    <% } %>

                    <form method="post" action="ManageOrderActionServlet" onsubmit="return confirm('Delete this order permanently?');" style="display:inline;">
                        <input type="hidden" name="orderId" value="<%= idStr %>">
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