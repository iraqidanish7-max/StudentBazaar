<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.studentbazaar.model.Product, com.studentbazaar.dao.CartDAO" %>
<%
    String cartMessage = (String) session.getAttribute("cartMessage");
    if (cartMessage != null) {
        session.removeAttribute("cartMessage");
    }

    String userEmail = (String) session.getAttribute("userEmail");
    List<Product> cart = null;
    int totalAmount = 0;

    if (userEmail != null) {
        try {
            cart = CartDAO.getCartItems(userEmail);
            session.setAttribute("cartList", cart);  // keep existing logic

            if (cart != null) {
                for (Product p : cart) {
                    totalAmount += p.getPrice();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>StudentBazaar - My Cart</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Global theme CSS -->
    <link rel="stylesheet" href="css/studentbazaar.css">

    <!-- Icons + SweetAlert -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="page-bg">

    <%@ include file="header.jsp" %>

    <main class="cart-page-main">

        <!-- 🔹 Hero card -->
        <section class="cart-hero-shell">
            <div class="cart-hero">
                <div class="cart-hero-left">
                    <h1>My Cart</h1>
                    <p>Review your selected items before securing them with OTP-protected checkout.</p>
                </div>
                <div class="cart-hero-right">
                    <span>Tips for safe purchases:</span>
                    <span>• Double-check product title & price</span>
                    <span>• Verify campus location</span>
                    <span>• OTP will be required to confirm the order</span>
                </div>
            </div>
        </section>

        <%
            if (cart != null && !cart.isEmpty()) {
        %>

        <!-- 🔹 Cart cards grid -->
        <section class="cart-grid">
            <%
                for (Product p : cart) {
            %>
            <article class="cart-card rainbow-frame">
                <div class="rainbow-inner cart-card-inner">

                    <!-- Discount badge + slider -->
                    <div style="position: relative;">
                        <span class="discount-badge"><%= p.getDiscount() %>% OFF</span>

                        <div class="cart-slider-wrapper">
                            <img class="slider-img active"
                                 src="<%= request.getContextPath() + "/" + p.getImagePath() %>"
                                 alt="Front View">

                            <% if (p.getBackImagePath() != null && !p.getBackImagePath().isEmpty()) { %>
                                <img class="slider-img"
                                     src="<%= request.getContextPath() + "/" + p.getBackImagePath() %>"
                                     alt="Back View">
                            <% } %>

                            <button type="button"
                                    class="slider-arrow slider-prev">&#10094;</button>
                            <button type="button"
                                    class="slider-arrow slider-next">&#10095;</button>
                        </div>
                    </div>

                    <!-- Title + verified -->
                    <div class="cart-title">
                        <span><%= p.getTitle() %></span>
                        <span class="verified-icon" title="Verified seller">
                            <i class="fa fa-check-circle"></i>
                        </span>
                    </div>

                    <!-- Location + category chips -->
                    <div class="cart-meta-row">
                        <span class="location-chip">📍 <%= p.getCity() %></span>
                        <span class="category-chip"><%= p.getCategory() %></span>
                    </div>

                    <!-- Info -->
                    <div class="cart-info">
                        <p><strong>Condition:</strong> <%= p.getCondition() %></p>
                        <p><strong>Price:</strong> ₹<%= p.getPrice() %></p>
                        <p><strong>Contact:</strong> <%= p.getContact() %></p>
                    </div>

                    <!-- Rating -->
                    <div class="cart-rating">
                        <%
                            double rating = p.getRating();
                            int fullStars = (int) rating;
                            boolean halfStar = (rating % 1 != 0);
                            int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

                            for (int i = 0; i < fullStars; i++) {
                        %>
                            <i class="fas fa-star"></i>
                        <%
                            }
                            if (halfStar) {
                        %>
                            <i class="fas fa-star-half-alt"></i>
                        <%
                            }
                            for (int i = 0; i < emptyStars; i++) {
                        %>
                            <i class="far fa-star"></i>
                        <%
                            }
                        %>
                        <span style="font-size: 11px; color: #6b7280;">(<%= rating %>)</span>
                    </div>

                    <div class="cart-posted">
                        Posted on: 14 July 2025
                    </div>

                    <!-- Remove button -->
                    <div class="cart-actions">
                        <form action="RemoveFromCartServlet" method="get">
                            <input type="hidden" name="productId" value="<%= p.getId() %>">
                            <button type="submit"
                                    class="danger-btn cart-remove-btn">
                                Remove
                            </button>
                        </form>
                    </div>

                </div>
            </article>
            <%
                } // end for
            %>
        </section>

        <%
            } else {
        %>
        <p class="cart-empty-message">
            Your cart is empty.
        </p>
        <%
            }
        %>

        <!-- 🔹 Total / summary -->
        <%
            if (cart != null && !cart.isEmpty()) {
                int gst = (int) (totalAmount * 0.18);
                int platformFee = 50;
                int convenienceFee = 20;
                int grandTotal = totalAmount + gst + platformFee + convenienceFee;
        %>

        <section class="cart-summary-box">
            <table>
                <tr>
                    <td>Subtotal:</td>
                    <td>₹<%= totalAmount %></td>
                </tr>
                <tr>
                    <td>GST (18%):</td>
                    <td>₹<%= gst %></td>
                </tr>
                <tr>
                    <td>Platform Fee:</td>
                    <td>₹<%= platformFee %></td>
                </tr>
                <tr>
                    <td>Convenience Fee:</td>
                    <td>₹<%= convenienceFee %></td>
                </tr>
                <tr class="grand-total">
                    <td>Grand Total:</td>
                    <td>₹<%= grandTotal %></td>
                </tr>
            </table>
        </section>

        <div class="cart-buy-wrapper">
            <form action="payment.jsp" method="post">
                <button type="submit"
                        class="primary-gradient-btn">
                    Buy Now
                </button>
            </form>
        </div>

        <%
            } // end if cart not empty
        %>

    </main>

    <%@ include file="footer.jsp" %>

    <!-- Slider Script (keeps your old logic, just new selectors) -->
    <script>
    document.querySelectorAll('.cart-slider-wrapper').forEach(function (wrapper) {
        const images = wrapper.querySelectorAll('.slider-img');
        const prev = wrapper.querySelector('.slider-prev');
        const next = wrapper.querySelector('.slider-next');
        let current = 0;

        if (!images.length) return;

        function updateSlider(index) {
            images.forEach((img, i) => {
                img.classList.toggle('active', i === index);
            });
        }

        if (images.length <= 1) {
            if (prev) prev.style.display = 'none';
            if (next) next.style.display = 'none';
            updateSlider(0);
            return;
        }

        prev.addEventListener('click', function () {
            current = (current - 1 + images.length) % images.length;
            updateSlider(current);
        });

        next.addEventListener('click', function () {
            current = (current + 1) % images.length;
            updateSlider(current);
        });

        updateSlider(current);
    });
    </script>

    <!--  SweetAlert for remove message (logic same as before, just cleaner) -->
    <%
        if (cartMessage != null) {
            String safeMessage = cartMessage.replace("\"", "\\\""); // escape quotes
    %>
    <script>
        Swal.fire({
            icon: 'success',
            title: "<%= safeMessage %>",
            showConfirmButton: false,
            timer: 1500
        });
    </script>
    <%
        }
    %>

</body>
</html>