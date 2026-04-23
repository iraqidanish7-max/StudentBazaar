package com.studentbazaar.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException { }

    public void destroy() { }

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String context = request.getContextPath(); 
        String uri = request.getRequestURI();      
        String path = uri.substring(context.length());

        // Public resources (allowed without authentication)
        boolean isPublic =
                path.equals("/") ||
                path.equals("/index.jsp") ||
                path.equals("/login.jsp") ||
                path.equals("/register.jsp") ||
                path.equals("/logout.jsp") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/img/") ||
                path.startsWith("/images/") ||
                path.startsWith("/videos/") ||
                path.startsWith("/fonts/") ||
                path.startsWith("/LoginServlet") ||
                path.startsWith("/RegisterServlet") ||
                path.startsWith("/OtpServlet") ||
                path.startsWith("/SendOtpServlet");

        // Admin-only paths
        boolean isAdminPath =
                path.startsWith("/admin") ||
                path.endsWith("/adminDashboard.jsp") ||
                path.contains("/ManageProductsServlet") ||
                path.contains("/manageProducts.jsp") ||
                path.contains("/manageUsers.jsp");

        // If public, continue
        if (isPublic) {
            chain.doFilter(req, res);
            return;
        }

        // For protected resources, check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            // not logged in
            response.sendRedirect(context + "/login.jsp");
            return;
        }

        // If admin page requested, ensure role is admin
        if (isAdminPath) {
            Object r = session.getAttribute("role");
            String role = (r != null) ? r.toString() : null;
            if (role == null || !"admin".equalsIgnoreCase(role)) {
                // unauthorized
                response.sendRedirect(context + "/home.jsp?error=unauthorized");
                return;
            }
        }

        // Allow request
        chain.doFilter(req, res);
    }
}