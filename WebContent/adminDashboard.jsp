<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("home.jsp?error=unauthorized");
        return;
    }
    String username = (String) session.getAttribute("username");
    if (username == null || username.trim().isEmpty()) {
        username = "Admin";
    }

    // Stats from servlet
    Integer totalUsers      = (Integer) request.getAttribute("totalUsers");
    Integer activeListings  = (Integer) request.getAttribute("activeListings");
    Integer totalOrders     = (Integer) request.getAttribute("totalOrders");
    Double  totalRevenue    = (Double)  request.getAttribute("totalRevenue");

    if (totalUsers == null)     totalUsers = 0;
    if (activeListings == null) activeListings = 0;
    if (totalOrders == null)    totalOrders = 0;
    if (totalRevenue == null)   totalRevenue = 0.0;

    //  User roles counts
    Integer buyersCount  = (Integer) request.getAttribute("buyersCount");
    Integer sellersCount = (Integer) request.getAttribute("sellersCount");
    Integer adminsCount  = (Integer) request.getAttribute("adminsCount");
    if (buyersCount == null)  buyersCount = 0;
    if (sellersCount == null) sellersCount = 0;
    if (adminsCount == null)  adminsCount = 0;

    //  Products per month
    List<String> monthLabels = (List<String>) request.getAttribute("monthLabels");
    List<Integer> monthCounts = (List<Integer>) request.getAttribute("monthCounts");
    if (monthLabels == null) monthLabels = new ArrayList<>();
    if (monthCounts == null) monthCounts = new ArrayList<>();

    //  Orders by status
    List<String> orderStatusLabels = (List<String>) request.getAttribute("orderStatusLabels");
    List<Integer> orderStatusCounts = (List<Integer>) request.getAttribute("orderStatusCounts");
    if (orderStatusLabels == null) orderStatusLabels = new ArrayList<>();
    if (orderStatusCounts == null) orderStatusCounts = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>StudentBazaar – Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- central CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/studentbazaar.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="page-bg">

<%@ include file="header.jsp" %>

<main class="admin-main">

    <!-- ================== HERO / SYSTEM OVERVIEW ================== -->
    <section class="dashboard-hero-card card-gradient-border admin-hero-card">
        <div class="admin-hero-text">
            <p class="admin-hero-kicker">Admin Panel</p>
            <h1 class="admin-hero-title">System Overview</h1>
            <p class="admin-hero-subtitle">
                Monitor users, product listings, and orders from a single, scrolling dashboard.
            </p>
        </div>
        <div class="admin-hero-meta">
            <span class="admin-hero-meta-label">Logged in as</span>
            <span class="admin-hero-meta-value"><i class="fas fa-user-shield"></i> <%= username %></span>
        </div>

        <div class="admin-stat-pills">
            <div class="admin-stat-pill">
                <span class="pill-label">Users</span>
                <span class="pill-value"><%= totalUsers %></span>
            </div>
            <div class="admin-stat-pill">
                <span class="pill-label">Active Listings</span>
                <span class="pill-value"><%= activeListings %></span>
            </div>
            <div class="admin-stat-pill">
                <span class="pill-label">Orders</span>
                <span class="pill-value"><%= totalOrders %></span>
            </div>
            <div class="admin-stat-pill">
                <span class="pill-label">Revenue (₹)</span>
                <span class="pill-value">₹<%= String.format("%,.0f", totalRevenue) %></span>
            </div>
        </div>
    </section>

    <!-- ================== PLATFORM ANALYTICS (CHART AREA) ================== -->
    <section class="admin-section-card admin-analytics-card" id="analytics">
        <div class="admin-section-header">
            <h2 class="admin-section-title">Platform Analytics</h2>
            <p class="admin-section-subtitle">
                Visual overview of users, product activity, and order health.
            </p>
        </div>

        <div class="admin-charts-grid">
            <div class="admin-chart-box">
                <h3 class="chart-title">User Roles</h3>
                <p class="chart-caption">Buyers vs Sellers vs Admins.</p>
                <div class="chart-canvas-wrapper">
                    <canvas id="adminUsersChart"></canvas>
                </div>
            </div>
            <div class="admin-chart-box">
                <h3 class="chart-title">Products per Month</h3>
                <p class="chart-caption">New listings posted by students each month.</p>
                <div class="chart-canvas-wrapper">
                    <canvas id="adminProductsChart"></canvas>
                </div>
            </div>
            <div class="admin-chart-box">
                <h3 class="chart-title">Orders by Status</h3>
                <p class="chart-caption">Breakdown of successful, pending and failed orders.</p>
                <div class="chart-canvas-wrapper">
                    <canvas id="adminOrdersChart"></canvas>
                </div>
            </div>
        </div>
    </section>

    <!-- ================== PRODUCT MODERATION ================== -->
    <section class="admin-section-card" id="products">
        <div class="admin-section-header">
            <h2 class="admin-section-title">Product Moderation</h2>
            <p class="admin-section-subtitle">
                Review new product listings posted by students. Approve or reject directly from here.
            </p>
        </div>

        <div class="admin-table-wrapper">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>#ID</th>
                    <th>Product</th>
                    <th>Seller</th>
                    <th>Category</th>
                    <th>Price (₹)</th>
                    <th>Status</th>
                    <th>Posted At</th>
                    <th>Admin Action</th>
                </tr>
                </thead>
                <tbody>
<%
    List<Map<String,Object>> pendingProducts =
        (List<Map<String,Object>>) request.getAttribute("pendingProducts");
    if (pendingProducts == null) pendingProducts = new ArrayList<>();
    int pIdx = 1;
    java.text.SimpleDateFormat dateOnly = new java.text.SimpleDateFormat("yyyy-MM-dd");
    for (Map<String,Object> p : pendingProducts) {
        int pid = (Integer) p.get("id");
        String title = String.valueOf(p.get("title"));
        String uploader = String.valueOf(p.get("uploader"));
        String category = String.valueOf(p.get("category"));
        Object priceObj = p.get("price");
        String priceStr = priceObj == null ? "-" : priceObj.toString();
        String statusVal = String.valueOf(p.get("status"));
        java.sql.Timestamp postedTs = (java.sql.Timestamp) p.get("postedAt");
        String postedStr = postedTs == null ? "—" : dateOnly.format(postedTs);
%>
    <tr>
        <td><%= pIdx++ %></td>
        <td><%= title %></td>
        <td><%= uploader %></td>
        <td><%= category %></td>
        <td>₹<%= priceStr %></td>
        <td>
            <span class="admin-status-badge status-<%= statusVal == null ? "pending" : statusVal.toLowerCase() %>">
                <%= statusVal == null ? "Pending" : statusVal %>
            </span>
        </td>
        <td><%= postedStr %></td>
        <td>
            <form method="post" action="ManageProductActionServlet" style="display:inline-block;">
                <input type="hidden" name="productId" value="<%= pid %>">
                <input type="hidden" name="action" value="approve">
                <button class="btn btn-xs btn-approve">Approve</button>
            </form>
            <form method="post" action="ManageProductActionServlet" style="display:inline-block;">
                <input type="hidden" name="productId" value="<%= pid %>">
                <input type="hidden" name="action" value="reject">
                <button class="btn btn-xs btn-reject">Reject</button>
            </form>
        </td>
    </tr>
<% } %>
<% if (pendingProducts.isEmpty()) { %>
    <tr><td colspan="8" style="text-align:center; padding:12px;">No products found yet.</td></tr>
<% } %>
                </tbody>
            </table>
        </div>
    </section>

    <!-- ================== USER MANAGEMENT ================== -->
    <section class="admin-section-card" id="users">
        <div class="admin-section-header">
            <h2 class="admin-section-title">User Management</h2>
            <p class="admin-section-subtitle">
                View all registered users, promote to admin, and enable/disable accounts when needed.
            </p>
        </div>

        <div class="admin-table-wrapper">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>#User</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Joined</th>
                    
                </tr>
                </thead>
                <tbody>
<%
    List<Map<String,Object>> dashUsers =
        (List<Map<String,Object>>) request.getAttribute("dashboardUsers");
    if (dashUsers == null) dashUsers = new ArrayList<>();

    for (Map<String,Object> u : dashUsers) {
        int uid = (Integer) u.get("id");
        String name = String.valueOf(u.get("name"));
        String email = String.valueOf(u.get("email"));
        String userRole = String.valueOf(u.get("role"));
        String userStatus = String.valueOf(u.get("status"));

        String joined = "—";
        Object joinedObj = u.get("joinedAt");
        if (joinedObj instanceof java.sql.Timestamp) {
            joined = new java.text.SimpleDateFormat("yyyy-MM-dd")
                        .format((java.util.Date) joinedObj);
        }
%>
    <tr>
        <td><%= uid %></td>
        <td><%= name %></td>
        <td><%= email %></td>
        <td>
            <span class="admin-status-badge status-role-<%= userRole.toLowerCase() %>">
                <%= userRole %>
            </span>
        </td>
        <td>
            <span class="admin-status-badge status-<%= userStatus.toLowerCase() %>">
                <%= userStatus %>
            </span>
        </td>
        <td><%= joined %></td>
        <td>
            <!-- Promote / Demote -->
            

                   </td>
    </tr>
<% } %>
<% if (dashUsers.isEmpty()) { %>
    <tr><td colspan="7" style="text-align:center; padding:12px;">No users found.</td></tr>
<% } %>
                </tbody>
            </table>
        </div>
    </section>

    <!-- ================== ORDERS OVERVIEW ================== -->
    <section class="admin-section-card" id="orders">
        <div class="admin-section-header">
            <h2 class="admin-section-title">Orders &amp; Purchases</h2>
            <p class="admin-section-subtitle">
                Recent transactions on the platform.
            </p>
        </div>

        <div class="admin-table-wrapper">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>#Order</th>
                    <th>Product</th>
                    <th>Buyer</th>
                    <th>Seller</th>
                    <th>Amount (₹)</th>
                    <th>Status</th>
                    <th>Purchased At</th>
                </tr>
                </thead>
                <tbody>
<%
    List<Map<String,Object>> recentOrders =
        (List<Map<String,Object>>) request.getAttribute("recentOrders");
    if (recentOrders == null) recentOrders = new ArrayList<>();
    for (Map<String,Object> r : recentOrders) {
        int oid = (Integer) r.get("orderId");
        String productTitle = String.valueOf(r.get("productTitle"));
        String buyerEmail = String.valueOf(r.get("buyerEmail"));
        String sellerEmail = String.valueOf(r.get("sellerEmail"));
        Object amtObj = r.get("amount");
        String amount = amtObj == null ? "-" : amtObj.toString();
        Object statusObj = r.get("status");
        String statusOrder = (statusObj == null) ? null : statusObj.toString();

        String purchasedAt = "—";
        Object tsObj = r.get("purchasedAt");
        if (tsObj instanceof java.sql.Timestamp) {
            purchasedAt = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm")
                              .format((java.util.Date) tsObj);
        }

        // decide final label + css key
        String statusCss  = (statusOrder == null || "null".equalsIgnoreCase(statusOrder))
                ? "success"
                : statusOrder.toLowerCase();

        String statusLabel = (statusOrder == null || "null".equalsIgnoreCase(statusOrder))
                ? "Completed"
                : statusOrder;
%>
    <tr>
        <td><%= oid %></td>
        <td><%= productTitle %></td>
        <td><%= buyerEmail %></td>
        <td><%= sellerEmail %></td>
        <td>₹<%= amount %></td>
        <td>
    <span class="admin-status-badge status-<%= statusCss %>">
        <%= statusLabel %>
    </span>
</td>
        <td><%= purchasedAt %></td>
    </tr>
<% } %>
<% if (recentOrders.isEmpty()) { %>
    <tr><td colspan="7" style="text-align:center; padding:12px;">No orders found.</td></tr>
<% } %>
                </tbody>
            </table>
        </div>
    </section>

    <!-- ================== MAINTENANCE SECTION ================== -->
    <section class="admin-section-card" id="maintenance">
        <div class="admin-section-header">
            <h2 class="admin-section-title">Maintenance &amp; Tools</h2>
            <p class="admin-section-subtitle">
                Clear cached data and perform platform-level actions.
            </p>
        </div>

        <button id="clearCacheBtn" class="btn btn-danger">
            <i class="fas fa-trash-alt"></i> Clear Cache / Temp Files
        </button>
    </section>

</main>

<%@ include file="footer.jsp" %>

<!-- Clear Cache JS  -->
<script>
document.getElementById('clearCacheBtn').addEventListener('click', function () {
    if (!confirm('Are you sure you want to permanently delete all temp files?')) return;

    var btn = this;
    var originalText = btn.innerText;
    btn.disabled = true;
    btn.innerText = 'Clearing...';

    fetch('ClearCacheServlet', { method: 'POST', headers: { 'Accept': 'application/json' } })
        .then(function (resp) {
            return resp.text().then(function (text) {
                btn.disabled = false;
                btn.innerText = originalText;

                try {
                    var j = JSON.parse(text);
                    var files = j.deletedFiles || 0;
                    var bytes = j.deletedBytes || 0;
                    var errors = j.errors || j.message || '';
                    alert('✅ Cache cleared!\nDeleted files: ' + files +
                          '\nFreed: ' + bytes + ' bytes' +
                          (errors ? '\nErrors: ' + errors : ''));
                } catch (err) {
                    var short = text.length > 800 ? text.substring(0, 800) + '\n\n(Truncated...)' : text;
                    var w = window.open('', '_blank');
                    w.document.write('<pre style="white-space:pre-wrap; font-family:monospace;">' +
                                     short.replace(/</g,'&lt;').replace(/>/g,'&gt;') + '</pre>');
                    w.document.title = 'ClearCache response (raw)';
                    alert('⚠️ Server returned non-JSON response. Response opened in new tab.');
                }
            });
        })
        .catch(function (err) {
            btn.disabled = false;
            btn.innerText = originalText;
            alert('❌ Error clearing cache: ' + err.message);
        });
});
</script>

<!-- ================== CHART INITIALIZATION ================== -->
<script>
    // User Roles chart
    (function() {
        var ctx = document.getElementById('adminUsersChart');
        if (!ctx) return;

        var data = {
            labels: ['Buyers', 'Sellers', 'Admins'],
            datasets: [{
                data: [<%= buyersCount %>, <%= sellersCount %>, <%= adminsCount %>],
                backgroundColor: ['#6a11cb', '#2575fc', '#00ffe7']
            }]
        };

        new Chart(ctx, {
            type: 'pie',
            data: data,
            options: {
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    })();

    // Products per Month chart
    (function() {
        var ctx = document.getElementById('adminProductsChart');
        if (!ctx) return;

        var labels = [<%
            for (int i = 0; i < monthLabels.size(); i++) {
                if (i > 0) out.print(",");
                out.print("\"" + monthLabels.get(i) + "\"");
            }
        %>];

        var counts = [<%
            for (int i = 0; i < monthCounts.size(); i++) {
                if (i > 0) out.print(",");
                out.print(monthCounts.get(i));
            }
        %>];

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Listings',
                    data: counts,
                    backgroundColor: '#6a11cb'
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                        precision: 0
                    }
                },
                plugins: {
                    legend: { display: false }
                }
            }
        });
    })();

    // Orders by Status chart
    (function() {
        var ctx = document.getElementById('adminOrdersChart');
        if (!ctx) return;

        var labels = [<%
            for (int i = 0; i < orderStatusLabels.size(); i++) {
                if (i > 0) out.print(",");
                out.print("\"" + orderStatusLabels.get(i) + "\"");
            }
        %>];

        var counts = [<%
            for (int i = 0; i < orderStatusCounts.size(); i++) {
                if (i > 0) out.print(",");
                out.print(orderStatusCounts.get(i));
            }
        %>];

        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: counts,
                    backgroundColor: ['#00c853', '#ffb300', '#d32f2f', '#42a5f5']
                }]
            },
            options: {
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    })();
</script>

</body>
</html>