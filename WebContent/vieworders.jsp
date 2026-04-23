<%@ page import="java.util.*, com.studentbazaar.dao.OrderDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> orders = new ArrayList<>();
    try {
        orders = OrderDAO.getUserOrders(userEmail);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>StudentBazaar - My Purchases</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/studentbazaar.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body class="page-bg">

    <%@ include file="header.jsp" %>

    <main class="orders-page-main">

        <!-- 🔹 Hero / Title card -->
        <section class="dashboard-hero-card card-gradient-border orders-hero">
            <p class="dashboard-greeting">
                Your <span>Purchase History</span> 🧾
            </p>
            <h1 class="dashboard-title">All the deals you’ve closed on StudentBazaar</h1>
            <p class="dashboard-subtitle">
                Track what you’ve bought, when you bought it, and download a CSV invoice anytime.
            </p>

            <div class="dashboard-quick-actions">
                <a href="home.jsp" class="btn btn-soft">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
                <a href="buyproduct.jsp" class="btn btn-outline">
                    <i class="fas fa-store"></i> Explore More Products
                </a>
                <a href="DownloadOrdersCSV" class="btn btn-gradient">
                    <i class="fas fa-file-download"></i> Download CSV Invoice
                </a>
            </div>
        </section>

        <!-- 🔹 Orders list -->
        <section class="dashboard-section">
            <h2 class="dashboard-heading">Your Orders</h2>

            <% if (orders != null && !orders.isEmpty()) { %>

                <div class="orders-grid">
                    <% for (Map<String, Object> order : orders) { %>
                        <div class="order-card card-gradient-border">
                            <div class="order-image-wrap">
                                <img src="<%= order.get("imagePath") %>" alt="Product image">
                            </div>
                            <div class="order-info">
                                <h3 class="order-title">
                                    <%= order.get("title") %>
                                </h3>
                                <p class="order-meta">
                                    <span class="order-chip">
                                        <i class="fas fa-tags"></i>
                                        <%= order.get("category") %>
                                    </span>
                                    <span class="order-chip">
                                        <i class="fas fa-indian-rupee-sign"></i>
                                        <%= order.get("price") %>
                                    </span>
                                </p>
                                <p class="order-date">
                                    Purchased on:
                                    <span><%= order.get("purchaseTime") %></span>
                                </p>
                            </div>
                        </div>
                    <% } %>
                </div>

            <% } else { %>

                <div class="orders-empty card-gradient-border">
                    <h3>No purchases yet</h3>
                    <p>
                        You haven’t bought anything on StudentBazaar so far.<br>
                        Start exploring products and your orders will appear here.
                    </p>
                    <a href="buyproduct.jsp" class="btn btn-gradient">
                        <i class="fas fa-compass"></i> Start Shopping
                    </a>
                </div>

            <% } %>
        </section>

    </main>

    <%@ include file="footer.jsp" %>

</body>
</html>