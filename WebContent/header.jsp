<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="java.util.*,javax.servlet.http.*,com.studentbazaar.dao.CartDAO,com.studentbazaar.model.Product" %>

<%
    // ===== Session & login info =====
    HttpSession hdrSession = request.getSession(false);
    String hdrUsername = null;
    String hdrUserEmail = null;
    boolean isLoggedIn = false;
    boolean isAdmin = false;

    if (hdrSession != null) {
        hdrUsername = (String) hdrSession.getAttribute("username");
        hdrUserEmail = (String) hdrSession.getAttribute("userEmail");
        Object roleObj = hdrSession.getAttribute("role");

        isLoggedIn = (hdrUsername != null);
        if (roleObj != null && "admin".equalsIgnoreCase(roleObj.toString())) {
            isAdmin = true;
        }
    }

    // ===== Cart count for navbar =====
    int headerCartCount = 0;
    if (isLoggedIn && hdrUserEmail != null) {
        try {
            List<Product> hdrCartList = CartDAO.getCartItems(hdrUserEmail);
            headerCartCount = (hdrCartList != null) ? hdrCartList.size() : 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== Active page detection for highlight =====
    String uri = request.getRequestURI();
    boolean atIndex     = uri.endsWith("index.jsp");
    boolean atLogin     = uri.endsWith("login.jsp");
    boolean atRegister  = uri.endsWith("register.jsp");
    boolean atDashboard = uri.endsWith("home.jsp");
    boolean atAdmin     = (uri.contains("adminDashboard.jsp") || uri.contains("AdminDashboardServlet"));
%>

<div class="site-header">
    <div class="nav-container">
        <div class="brand">
            <img src="<%=request.getContextPath()%>/img/logo.jpeg"
                 alt="StudentBazaar Logo"
                 class="brand-logo">
            <div class="brand-text">
                <h1>StudentBazaar</h1>
                <p>Buy & Sell Inside Your Campus</p>
            </div>
        </div>

        <div class="nav-links">
            <% if (!isLoggedIn) { %>
                <!--  Public navbar: Home / Login / Register -->
                <a href="index.jsp"
                   class="nav-link <%= atIndex ? "nav-link-active" : "" %>">
                    Home
                </a>

                <a href="login.jsp"
                   class="nav-link <%= atLogin ? "nav-link-active" : "" %>">
                    Login
                </a>

                <a href="register.jsp"
                   class="nav-link primary <%= atRegister ? "nav-link-active" : "" %>">
                    Register
                </a>

            <% } else { %>
                <!--  Logged-in navbar: Dashboard / (Admin) / Logout / Cart -->
                <a href="home.jsp"
                   class="nav-link <%= atDashboard ? "nav-link-active" : "" %>">
                    Dashboard
                </a>

                <% if (isAdmin) { %>
                    <a href="AdminDashboardServlet"
                       class="nav-link <%= atAdmin ? "nav-link-active" : "" %>">
                        Admin
                    </a>
                <% } %>

                <a href="logout.jsp" class="nav-link nav-link-logout">
                    Logout <i class="fas fa-power-off"></i>
                </a>

                <a href="cart.jsp" class="nav-link-icon" title="View Cart">
                    <i class="fas fa-shopping-cart"></i>
                    <span class="cart-badge"><%= headerCartCount %></span>
                </a>
            <% } %>
        </div>
    </div>
</div>