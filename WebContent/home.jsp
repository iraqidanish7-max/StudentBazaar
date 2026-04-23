<%@ page language="java" 
         contentType="text/html;charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.*, javax.servlet.*, javax.servlet.http.*, java.sql.*, com.studentbazaar.dao.CartDAO, com.studentbazaar.model.Product" %>
<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) currentSession.getAttribute("username");
    String userEmail = (String) currentSession.getAttribute("userEmail");

    // ⭐ studentStatus from session (set in LoginServlet)
    String studentStatus = (String) currentSession.getAttribute("studentStatus");
    if (studentStatus == null || studentStatus.trim().isEmpty()) {
        studentStatus = "Pending"; // safe default
    }

    // Avatar initial
    char firstLetter = 'S';
    if (username != null && !username.trim().isEmpty()) {
        firstLetter = Character.toUpperCase(username.trim().charAt(0));
    }

    // Cart count
    int cartCount = 0;
    if (userEmail != null) {
        try {
            List<Product> cartList = CartDAO.getCartItems(userEmail);
            cartCount = (cartList != null) ? cartList.size() : 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //  Profile photo: load from session or DB
    String profilePhoto = (String) currentSession.getAttribute("profilePhoto");
    if (profilePhoto == null && userEmail != null) {
        Connection conPhoto = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conPhoto = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentbazaar", "root", "");

            String sqlPhoto = "SELECT profile_photo FROM users WHERE email = ?";
            try (PreparedStatement ps = conPhoto.prepareStatement(sqlPhoto)) {
                ps.setString(1, userEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        profilePhoto = rs.getString("profile_photo");
                    }
                }
            }

            currentSession.setAttribute("profilePhoto", profilePhoto);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conPhoto != null) {
                try { conPhoto.close(); } catch (Exception ex) {}
            }
        }
    }

    //  Analytics stats (counts)
    int itemsBought = 0;
    int itemsSold = 0;
    int campusListings = 0;

    //  Money analytics
    double totalSpent = 0.0;
    double totalEarned = 0.0;
    double totalSavings = 0.0;

    if (userEmail != null) {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/studentbazaar", "root", "");

            // 1️⃣ Items Bought (orders table)
            String sqlBought = "SELECT COUNT(*) FROM orders WHERE user_email = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlBought)) {
                ps.setString(1, userEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        itemsBought = rs.getInt(1);
                    }
                }
            }

            // Items Sold / Listed (products table, uploader = this user)
            String sqlSold = "SELECT COUNT(*) FROM products WHERE uploader = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlSold)) {
                ps.setString(1, userEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        itemsSold = rs.getInt(1);
                    }
                }
            }

            //  Total campus listings (all products)
            String sqlListings = "SELECT COUNT(*) FROM products";
            try (PreparedStatement ps = con.prepareStatement(sqlListings);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    campusListings = rs.getInt(1);
                }
            }

            //  Total spent & savings (as buyer) - join orders + products
            String sqlSpend = "SELECT p.price, p.discount FROM orders o "
                            + "JOIN products p ON o.product_id = p.id "
                            + "WHERE o.user_email = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlSpend)) {
                ps.setString(1, userEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        double price = rs.getDouble("price");
                        double discount = rs.getDouble("discount");
                        totalSpent += price;
                        totalSavings += discount;
                    }
                }
            }

            //  Total earned (as seller) - products uploaded by this user that have an order
            String sqlEarn = "SELECT p.price FROM orders o "
                           + "JOIN products p ON o.product_id = p.id "
                           + "WHERE p.uploader = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlEarn)) {
                ps.setString(1, userEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        double price = rs.getDouble("price");
                        totalEarned += price;
                    }
                }
            }

            System.out.println("📊 Dashboard Analytics -> email=" + userEmail
                    + ", itemsBought=" + itemsBought
                    + ", itemsSold=" + itemsSold
                    + ", campusListings=" + campusListings
                    + ", totalSpent=" + totalSpent
                    + ", totalEarned=" + totalEarned
                    + ", totalSavings=" + totalSavings);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (con != null) {
                try { con.close(); } catch (Exception ex) {}
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>StudentBazaar - Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/studentbazaar.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="page-bg">

    <%@ include file="header.jsp" %>

    <main class="dashboard-layout">

        <!--  Left vertical panel -->
        <aside class="dashboard-sidebar card-gradient-border">
            <div class="dashboard-sidebar-top">

                <!-- Avatar (circle + image or initial) -->
                <div class="dashboard-avatar" id="dashboardAvatar">
                    <% if (profilePhoto != null && !profilePhoto.trim().isEmpty()) { %>
                        <img src="<%= profilePhoto %>" alt="Profile photo" class="avatar-image">
                    <% } else { %>
                        <span><%= firstLetter %></span>
                    <% } %>
                </div>

                <!-- Upload form (hidden file input + button + filename) -->
                <form id="avatarUploadForm"
                      class="avatar-upload-form"
                      action="UploadProfilePhotoServlet"
                      method="post"
                      enctype="multipart/form-data">
                    <input type="file"
                           name="profilePhoto"
                           id="profilePhotoInput"
                           accept="image/*"
                           class="avatar-file-input">
                    <label for="profilePhotoInput" class="btn-avatar">
                        Change photo
                    </label>
                    <span id="avatarFileName" class="avatar-file-name"></span>
                </form>

                <div class="dashboard-identity">
                    <h2><%= username %></h2>
                    <p class="dashboard-role">StudentBazaar Member</p>
                    <span class="badge-student">
                        <%= "Verified".equalsIgnoreCase(studentStatus)
                                ? "Verified Student ✅"
                                : "Student Account" %>
                    </span>
                </div>
            </div>

            <div class="sidebar-stats">
                <div class="sidebar-stat">
                    <span class="sidebar-stat-label">Cart Items</span>
                    <span class="sidebar-stat-value"><%= cartCount %></span>
                </div>
                <div class="sidebar-stat">
                    <span class="sidebar-stat-label">My Listings</span>
                    <span class="sidebar-stat-value"><%= itemsSold %></span>
                </div>
                <div class="sidebar-stat">
                    <span class="sidebar-stat-label">Status</span>
                    <span class="sidebar-stat-value 
                        <%= "Verified".equalsIgnoreCase(studentStatus) ? "status-verified" : "status-pending" %>">
                        <%= studentStatus %>
                    </span>
                </div>
            </div>

            <nav class="dashboard-nav">
                <a href="home.jsp" class="dashboard-nav-link active">
                    <i class="fas fa-house"></i>
                    <span>Dashboard</span>
                </a>
                <a href="buyproduct.jsp" class="dashboard-nav-link">
                    <i class="fas fa-store"></i>
                    <span>Buy Products</span>
                </a>
                <a href="sellproduct.jsp" class="dashboard-nav-link">
                    <i class="fas fa-upload"></i>
                    <span>Sell an Item</span>
                </a>
                <a href="ViewMyProductServlet" class="dashboard-nav-link">
                    <i class="fas fa-box-open"></i>
                    <span>My Posts</span>
                </a>
                <a href="cart.jsp" class="dashboard-nav-link">
                    <i class="fas fa-shopping-cart"></i>
                    <span>My Cart (<%= cartCount %>)</span>
                </a>
                <a href="logout.jsp" class="dashboard-nav-link logout-link">
                    <i class="fas fa-power-off"></i>
                    <span>Logout</span>
                </a>
            </nav>
        </aside>

        <!--  Right side content -->
        <section class="dashboard-main">

            <!-- Hero greeting on top -->
            <section class="dashboard-hero-card card-gradient-border">
                <p class="dashboard-greeting">Hello, <span><%= username %></span> 👋</p>
                <h1 class="dashboard-title">Welcome back to your campus marketplace</h1>
                <p class="dashboard-subtitle">
                    Manage your purchases, listings and discover deals from other students –
                    all in one simple dashboard.
                </p>

                <div class="dashboard-quick-actions">
                    <a href="vieworders.jsp" class="btn btn-gradient">
                        <i class="fas fa-receipt"></i> My Purchases
                    </a>
                    <a href="sellproduct.jsp" class="btn btn-outline">
                        <i class="fas fa-plus-circle"></i> Post an Item
                    </a>
                    <a href="buyproduct.jsp" class="btn btn-soft">
                        <i class="fas fa-compass"></i> Explore Products
                    </a>
                </div>

                <div class="dashboard-stats-row">
                    <div class="dashboard-stat-card">
                        <span class="stat-label">Cart Items</span>
                        <span class="stat-value"><%= cartCount %></span>
                        <span class="stat-hint">Items waiting to checkout</span>
                    </div>
                    <div class="dashboard-stat-card">
                        <span class="stat-label">Total Listings</span>
                        <span class="stat-value"><%= itemsSold %></span>
                        <span class="stat-hint">Your active posts</span>
                    </div>
                    <div class="dashboard-stat-card">
                        <span class="stat-label">Student Status</span>
                        <span class="stat-value 
                            <%= "Verified".equalsIgnoreCase(studentStatus) ? "status-verified" : "status-pending" %>">
                            <%= studentStatus %>
                        </span>
                        <span class="stat-hint">
                            <%= "Verified".equalsIgnoreCase(studentStatus)
                                    ? "Your ID is verified. Enjoy full access."
                                    : "Will update after ID verification." %>
                        </span>
                    </div>
                </div>
            </section>

            <!--  Analytics section -->
            <section class="dashboard-section">
                <h2 class="dashboard-heading">Your StudentBazaar Analytics</h2>

                <div class="dashboard-card-grid">
                    <div class="dashboard-card card-gradient-border">
                        <h3>🛒 Items Bought</h3>
                        <p class="analytics-number"><%= itemsBought %></p>
                        <p>Products you’ve purchased using your StudentBazaar account.</p>
                    </div>
                    <div class="dashboard-card card-gradient-border">
                        <h3>📦 Items Sold / Listed</h3>
                        <p class="analytics-number"><%= itemsSold %></p>
                        <p>Items you’ve posted for sale as a seller/uploader.</p>
                    </div>
                    <div class="dashboard-card card-gradient-border">
                        <h3>🏬 Total Campus Listings</h3>
                        <p class="analytics-number"><%= campusListings %></p>
                        <p>Live listings currently visible to all students on the platform.</p>
                    </div>
                </div>
            </section>
            <!--  Single Big Pie Chart Section -->
<section class="dashboard-section">
    <h2 class="dashboard-heading">Your Activity Overview</h2>
    <p class="dashboard-subtitle">
        A quick look at how much you’ve spent, earned, and saved on StudentBazaar.
    </p>

    <div class="big-pie-card">
        <!-- LEFT: text, legend, numbers -->
        <div class="big-pie-left">
            <h3 class="big-pie-title">Money Flow (₹)</h3>
            <p class="big-pie-caption">
                Summary of your StudentBazaar transactions till now.
            </p>

            <!-- HTML Legend (sharp text, not inside canvas) -->
            <div class="big-pie-legend">
                <div class="legend-item">
                    <span class="legend-color legend-spent"></span>
                    Amount Spent
                </div>
                <div class="legend-item">
                    <span class="legend-color legend-earned"></span>
                    Amount Earned
                </div>
                <div class="legend-item">
                    <span class="legend-color legend-saved"></span>
                    Savings
                </div>
            </div>

            <!-- Numeric summary -->
            <div class="big-pie-metrics">
                <div class="metric-item">
                    <span class="metric-label">Amount Spent</span>
                    <span class="metric-value">₹<%= (long) totalSpent %></span>
                </div>
                <div class="metric-item">
                    <span class="metric-label">Amount Earned</span>
                    <span class="metric-value">₹<%= (long) totalEarned %></span>
                </div>
                <div class="metric-item">
                    <span class="metric-label">Savings</span>
                    <span class="metric-value">₹<%= (long) totalSavings %></span>
                </div>
            </div>

            <!-- Listings summary (from second chart idea) -->
            <div class="big-pie-extra">
                <div class="metric-item">
                    <span class="metric-label">My Listings</span>
                    <span class="metric-value"><%= itemsSold %></span>
                </div>
                <div class="metric-item">
                    <span class="metric-label">Campus Listings</span>
                    <span class="metric-value"><%= campusListings %></span>
                </div>
            </div>
        </div>

        <!-- RIGHT: big pie chart -->
        <div class="big-pie-right">
            <div class="big-pie-canvas-wrapper">
                <canvas id="bigActivityPie"></canvas>
                <div id="bigPieEmpty" class="chart-empty-message">
                    No transactions yet.<br>
                    Once you start buying or selling, your money flow will appear here.
                </div>
            </div>
        </div>
    </div>
</section>

               </main>

    <!-- Big avatar modal (only if photo exists) -->
    <% if (profilePhoto != null && !profilePhoto.trim().isEmpty()) { %>
    <div id="avatarModal" class="avatar-modal">
        <div class="avatar-modal-backdrop"></div>
        <div class="avatar-modal-content">
            <img src="<%= profilePhoto %>" alt="Profile photo">
        </div>
    </div>
    <% } %>
    <script>
document.addEventListener("DOMContentLoaded", function () {
    /* ===== Avatar upload: auto-submit + filename ===== */
    const avatarForm = document.getElementById('avatarUploadForm');
    const fileInput = document.getElementById('profilePhotoInput');
    const fileNameSpan = document.getElementById('avatarFileName');

    if (avatarForm && fileInput) {
        fileInput.addEventListener('change', function () {
            if (fileInput.files && fileInput.files.length > 0) {
                const name = fileInput.files[0].name;
                if (fileNameSpan) {
                    fileNameSpan.textContent = name;
                }
                avatarForm.submit();
            }
        });
    }

    /* ===== Avatar modal open/close ===== */
    const avatar = document.getElementById('dashboardAvatar');
    const avatarModal = document.getElementById('avatarModal');

    if (avatar && avatarModal) {
        const backdrop = avatarModal.querySelector('.avatar-modal-backdrop');

        const closeAvatarModal = () => {
            avatarModal.classList.remove('show');
        };

        avatar.addEventListener('click', function () {
            avatarModal.classList.add('show');
        });

        if (backdrop) {
            backdrop.addEventListener('click', closeAvatarModal);
        }

        avatarModal.addEventListener('click', function (e) {
            if (e.target === avatarModal) {
                closeAvatarModal();
            }
        });

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                closeAvatarModal();
            }
        });
    }

    /* ===== Single Big Pie Chart ===== */
    const itemsBought    = <%= itemsBought %>;
    const itemsSold      = <%= itemsSold %>;
    const campusListings = <%= campusListings %>;

    const totalSpent     = <%= totalSpent %>;
    const totalEarned    = <%= totalEarned %>;
    const totalSavings   = <%= totalSavings %>;

    const pieCanvas = document.getElementById('bigActivityPie');
    const pieEmpty  = document.getElementById('bigPieEmpty');

    const hasMoneyData =
        (totalSpent > 0) || (totalEarned > 0) || (totalSavings > 0);

    if (pieCanvas && pieEmpty) {
        if (!hasMoneyData) {
            pieCanvas.style.display = 'none';
            pieEmpty.style.display  = 'block';
        } else {
            pieEmpty.style.display  = 'none';
            pieCanvas.style.display = 'block';

            const COLOR_SPENT  = '#6a11cb';  // matches .legend-spent
            const COLOR_EARNED = '#00c78c';  // matches .legend-earned
            const COLOR_SAVED  = '#ff9800';  // matches .legend-saved

            new Chart(pieCanvas, {
                type: 'pie',
                data: {
                    labels: ['Amount Spent', 'Amount Earned', 'Savings'],
                    datasets: [{
                        data: [totalSpent, totalEarned, totalSavings],
                        backgroundColor: [
                            COLOR_SPENT,
                            COLOR_EARNED,
                            COLOR_SAVED
                        ],
                        borderColor: '#ffffff',
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }, // we use HTML legend
                        tooltip: {
                            backgroundColor: '#ffffff',
                            titleColor: '#111827',
                            bodyColor: '#111827',
                            borderColor: '#e5e7eb',
                            borderWidth: 1,
                            callbacks: {
                                label: function (ctx) {
                                    const v = ctx.parsed || 0;
                                    try {
                                        return ctx.label + ': ₹' + v.toLocaleString('en-IN');
                                    } catch (e) {
                                        return ctx.label + ': ₹' + v;
                                    }
                                }
                            }
                        }
                    }
                }
            });
        }
    }
});
</script>
    <%@ include file="footer.jsp" %>

</body>
</html>