<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("home.jsp?error=unauthorized");
        return;
    }

    Map<String,Object> totals = (Map<String,Object>) request.getAttribute("totals");
    List<Map<String,Object>> topProducts = (List<Map<String,Object>>) request.getAttribute("topProducts");
    List<Map<String,Object>> ordersPerDay = (List<Map<String,Object>>) request.getAttribute("ordersPerDay");
    String errorMsg = (String) request.getAttribute("errorMsg");

    if (totals == null) totals = new HashMap<>();
    if (topProducts == null) topProducts = new ArrayList<>();
    if (ordersPerDay == null) ordersPerDay = new ArrayList<>();

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Admin Reports - StudentBazaar</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body{font-family: 'Segoe UI', Tahoma, sans-serif; background:#071022; color:#fff; margin:20px;}
        .wrap{max-width:1200px;margin:0 auto;}
        .top { display:flex; justify-content:space-between; align-items:center; gap:12px; }
        .card-row { display:flex; gap:14px; margin-top:14px; flex-wrap:wrap; }
        .card { flex:1 1 220px; background:rgba(255,255,255,0.05); padding:18px; border-radius:12px; box-shadow:0 8px 30px rgba(0,0,0,0.4); }
        .card h3 { margin:0 0 8px 0; font-size:18px; color:#fff; }
        .card p { margin:0; color:#d9dde0; font-size:20px; font-weight:700; }
        .section { margin-top:22px; background:rgba(255,255,255,0.02); padding:14px; border-radius:12px; }
        table { width:100%; border-collapse:collapse; margin-top:12px; }
        th, td { padding:10px; border-bottom:1px solid rgba(255,255,255,0.03); text-align:left; }
        th { color:#cfe6ff; }
        .muted { color:#bfc7cb; }
        .btn { display:inline-block; padding:8px 12px; border-radius:8px; background:linear-gradient(90deg,#6a11cb,#2575fc); color:#fff; text-decoration:none; font-weight:700; }
        .small { font-size:13px; padding:6px 8px; border-radius:6px; }
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <div>
            <a href="adminDashboard.jsp" style="color:#fff; text-decoration:none;">← Back to Admin</a>
            <h2 style="display:inline-block; margin-left:12px;">Reports</h2>
        </div>

        <div style="display:flex; gap:10px;">
            <a class="btn" href="ReportsServlet?download=orders">Download Orders CSV</a>
            <a class="btn" href="ReportsServlet?download=products">Download Sales by Product CSV</a>
        </div>
    </div>

    <% if (errorMsg != null) { %>
        <div class="section" style="background:#2b1010;color:#ffd2d2;">Error while generating report: <%= errorMsg %></div>
    <% } %>

    <div class="card-row">
        <div class="card">
            <h3>Total Orders</h3>
            <p> <%= totals.getOrDefault("totalOrders", 0) %> </p>
            <div class="muted small">Orders recorded in DB</div>
        </div>
        <div class="card">
            <h3>Total Revenue</h3>
            <p> ₹ <%= String.format("%.2f", ((Number)totals.getOrDefault("totalRevenue", 0.0)).doubleValue()) %> </p>
            <div class="muted small">Sum of price column (best-effort)</div>
        </div>
        <div class="card">
            <h3>Users</h3>
            <p> <%= totals.getOrDefault("totalUsers", 0) %> </p>
            <div class="muted small">Registered users</div>
        </div>
        <div class="card">
            <h3>Products</h3>
            <p> <%= totals.getOrDefault("totalProducts", 0) %> </p>
            <div class="muted small">Products in catalog</div>
        </div>
    </div>

    <div class="section">
        <h3>Top Products (by number of orders)</h3>
        <% if (topProducts.isEmpty()) { %>
            <div class="muted">No product aggregation available (orders table may not have a product column).</div>
        <% } else { %>
            <table>
                <thead>
                    <tr><th>#</th><th>Product</th><th>Orders</th><th>Revenue</th></tr>
                </thead>
                <tbody>
                <% int idx=1;
                   for (Map<String,Object> p : topProducts) { %>
                    <tr>
                        <td><%= idx++ %></td>
                        <td><%= p.get("product") %></td>
                        <td><%= p.get("count") %></td>
                        <td><%= p.get("revenue") == null ? "-" : String.format("₹%.2f", ((Number)p.get("revenue")).doubleValue()) %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>

    <div class="section">
        <h3>Orders per Day (recent)</h3>
        <% if (ordersPerDay.isEmpty()) { %>
            <div class="muted">No date data available (orders table may not have a date column or date values are not parsable).</div>
        <% } else { %>
            <table>
                <thead><tr><th>Date</th><th>Orders</th></tr></thead>
                <tbody>
                <% for (Map<String,Object> r : ordersPerDay) {
                       Object d = r.get("day");
                       Object c = r.get("count");
                   %>
                    <tr>
                        <td><%= d == null ? "-" : (d instanceof java.sql.Date ? new SimpleDateFormat("yyyy-MM-dd").format((java.util.Date)d) : d.toString()) %></td>
                        <td><%= c %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>

</div>
</body>
</html>