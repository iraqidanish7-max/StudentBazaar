<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.studentbazaar.model.Product" %>
<%
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    String email = (String) session.getAttribute("email");

    // List of product IDs that are already sold (set by ViewMyProductServlet)
    List<Integer> soldProductIds = (List<Integer>) request.getAttribute("soldProductIds");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>StudentBazaar - My Products</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Main theme CSS -->
    <link rel="stylesheet" href="css/studentbazaar.css">

    <!-- Icons -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body class="page-bg">

    <%@ include file="header.jsp" %>

    <main class="myproducts-page-main">

        <!-- 🔹 Hero card -->
        <section class="myproducts-hero-shell">
            <div class="myproducts-hero">
                <div class="myproducts-hero-left">
                    <h1>My Uploaded Products</h1>
                    <p>Review, edit or manage your active listings in one place.</p>
                </div>
                <div class="myproducts-hero-right">
                    <span>Tip for better sales:</span>
                    <span>• Use clear product titles</span>
                    <span>• Add front &amp; back images</span>
                    <span>• Keep your price student-friendly</span>
                </div>
            </div>
        </section>

        <%
            if (productList != null && !productList.isEmpty()) {
        %>

        <!-- 🔹 Grid of product cards -->
        <section class="myproducts-grid">
            <% for (Product p : productList) {
                   boolean isSold = (soldProductIds != null && soldProductIds.contains(p.getId()));
            %>
            <article class="myproduct-card rainbow-frame <%= isSold ? "myproduct-card-sold" : "" %>">
                <div class="rainbow-inner myproduct-card-inner">

                    <!-- Discount badge + slider -->
                    <div style="position: relative;">
                        <span class="discount-badge"><%= p.getDiscount() %>% OFF</span>

                        <div class="image-slider">
                            <img class="slider-img active"
                                 src="<%= request.getContextPath() + "/" + p.getImagePath() %>"
                                 alt="Front Image">

                            <% if (p.getBackImagePath() != null && !p.getBackImagePath().isEmpty()) { %>
                                <img class="slider-img"
                                     src="<%= request.getContextPath() + "/" + p.getBackImagePath() %>"
                                     alt="Back Image">
                            <% } %>

                            <div class="arrow left-arrow">&#10094;</div>
                            <div class="arrow right-arrow">&#10095;</div>
                        </div>
                    </div>

                    <!-- Title + verified + SOLD tag -->
                    <div class="myproduct-title-row">
                        <h3>
                            <%= p.getTitle() %>
                            <span class="myproduct-verified" title="Verified seller">
                                <i class="fa fa-check-circle"></i>
                            </span>
                            <% if (isSold) { %>
                                <span class="sold-pill">SOLD</span>
                            <% } %>
                        </h3>
                    </div>

                    <!-- Location + category chips -->
                    <div class="myproduct-meta-row">
                        <span class="location-chip">📍 <%= p.getCity() %></span>
                        <span class="category-chip"><%= p.getCategory() %></span>
                    </div>

                    <!-- Map -->
                    <div class="map-container">
                        <iframe src="https://www.google.com/maps?q=<%= p.getCity() %>&output=embed"></iframe>
                    </div>

                    <!-- Basic details -->
                    <div class="myproduct-info">
                        <p><strong>Condition:</strong> <%= p.getCondition() %></p>
                        <p><strong>Price:</strong> ₹<%= p.getPrice() %></p>
                        <p><strong>Contact:</strong> <%= p.getContact() %></p>
                    </div>

                    <!-- Rating -->
                    <div class="myproduct-rating">
                        <%
                            float rating = p.getRating();
                            for (int i = 1; i <= 5; i++) {
                                if (i <= rating) {
                        %>
                        <i class="fas fa-star"></i>
                        <%
                                } else {
                        %>
                        <i class="far fa-star"></i>
                        <%
                                }
                            }
                        %>
                    </div>

                    
                    <!-- Buttons (or sold message) -->
                    <div class="myproduct-actions">
                        <% if (!isSold) { %>
                            <a class="primary-gradient-btn"
                               href="<%= request.getContextPath() %>/EditProductServlet?id=<%= p.getId() %>">
                                ✏️ Edit
                            </a>

                            <a href="javascript:void(0);"
                               class="danger-btn"
                               onclick="confirmDelete(<%= p.getId() %>)">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        <% } else { %>
                            <button type="button" class="btn-disabled" disabled>
                                This product is sold – further changes are disabled.
                            </button>
                        <% } %>
                    </div>

                </div>
            </article>
            <% } %>
        </section>

        <%
            } else {
        %>
        <p class="myproducts-empty">
            You haven't uploaded any products yet.
        </p>
        <%
            }
        %>

    </main>

    <!-- Scroll-to-top button -->
    <button id="scrollTopBtn" title="Go to top">↑</button>

    <%@ include file="footer.jsp" %>

    <!-- SweetAlert2 for delete confirm -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- Image slider script -->
    <script>
    document.querySelectorAll('.image-slider').forEach(function (slider) {
        const images = slider.querySelectorAll('.slider-img');
        const leftArrow = slider.querySelector('.left-arrow');
        const rightArrow = slider.querySelector('.right-arrow');

        if (!images.length) return;
        let current = 0;

        function showImage(index) {
            images.forEach(img => img.classList.remove('active'));
            images[index].classList.add('active');
        }

        if (images.length > 1) {
            rightArrow.addEventListener('click', function () {
                current = (current + 1) % images.length;
                showImage(current);
            });

            leftArrow.addEventListener('click', function () {
                current = (current - 1 + images.length) % images.length;
                showImage(current);
            });
        } else {
            // If only one image, hide arrows
            leftArrow.style.display = 'none';
            rightArrow.style.display = 'none';
        }
    });
    </script>

    <!-- Delete confirmation -->
    <script>
    function confirmDelete(productId) {
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to undo this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#2575fc',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '<%= request.getContextPath() %>/DeleteProductServlet?id=' + productId;
            }
        });
    }
    </script>

    <!-- Scroll-to-top behaviour -->
    <script>
    const scrollBtn = document.getElementById("scrollTopBtn");

    window.addEventListener("scroll", function () {
        if (!scrollBtn) return;
        const scrolled = document.body.scrollTop || document.documentElement.scrollTop;
        scrollBtn.style.display = scrolled > 300 ? "block" : "none";
    });

    if (scrollBtn) {
        scrollBtn.addEventListener("click", function () {
            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    }
    </script>

</body>
</html>