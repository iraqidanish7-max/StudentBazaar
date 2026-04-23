<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.studentbazaar.model.Product" %>
<%
    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        out.println("<h2 style='color:#111827;text-align:center;margin-top:120px;font-family:Segoe UI;'>No product found to edit.</h2>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Product - StudentBazaar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Main theme CSS (same as login / sell / viewmyproduct) -->
    <link rel="stylesheet" href="css/studentbazaar.css">

    <!-- Font Awesome (icons) -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body class="page-bg">

    <%@ include file="header.jsp" %>

    <main class="sell-page-main"><%-- reuse same layout as sellproduct.jsp --%>

        <!--  Hero card (blue) -->
        <section class="sell-hero-shell">
            <div class="sell-hero">
                <div class="sell-hero-text">
                    <h1>Edit Your Product</h1>
                    <p>Update your listing details to keep information clear and accurate for other students.</p>
                    <p class="sell-hero-subtext">
                        Tip: Better photos & clear description = faster sale.
                    </p>
                </div>
                <div class="sell-hero-meta">
                    <div><i class="fa-solid fa-pen-to-square"></i> Editing: <strong><%= product.getTitle() %></strong></div>
                    <span>Category: <%= product.getCategory() %></span>
                    <span>City: <%= product.getCity() %></span>
                </div>
            </div>
        </section>

        <!--  Form card (rainbow frame + white inner) -->
        <section class="sell-form-shell rainbow-frame">
            <div class="rainbow-inner sell-form-card">
                <div class="sell-form-header">
                    <h2>Update Listing Details</h2>
                    <p>All fields are editable. If you don’t upload a new image, the existing one will remain.</p>
                </div>

                <!--  LOGIC: same UpdateProductServlet + same field names -->
                <form action="<%= request.getContextPath() %>/UpdateProductServlet"
                      method="post"
                      enctype="multipart/form-data"
                      onsubmit="return validateEditForm()">

                    <!-- hidden product id -->
                    <input type="hidden" name="id" value="<%= product.getId() %>"/>

                    <div class="sell-form-grid">

                        <!-- Title -->
                        <div class="sell-form-field full-width">
                            <label for="title">Product Title</label>
                            <input type="text"
                                   id="title"
                                   name="title"
                                   value="<%= product.getTitle() %>"
                                   placeholder="e.g., Lenovo Laptop"
                                   required>
                        </div>

                        <!-- Description (if your Product has it) -->
                        <div class="sell-form-field full-width">
                            <label for="description">Product Description</label>
                            <textarea id="description"
          name="description"
          rows="4">
<%= (product.getDescription() != null ? product.getDescription() : "") %></textarea>
                        </div>

                        <!-- Category -->
                        <div class="sell-form-field">
                            <label for="category">Category</label>
                            <select name="category" id="category" required>
                                <option value="">-- Select Category --</option>
                                <%
                                    String[] categories = {
                                        "Mobiles", "Books", "Shoes", "Bags", "Watches", "Stationery", "Speakers",
                                        "Clothes", "Gaming", "Headphones", "Laptops", "Furniture", "Bicycles",
                                        "Bikes", "Power Banks", "Sports", "Earbuds", "Wall Clocks", "Lamps",
                                        "Water Bottles", "Accessories", "Musical Instruments", "Project Kits",
                                        "Study Table", "Decor Items", "Perfumes", "Printers", "Table Fans",
                                        "Bedsheets", "Mugs", "Calculators", "Keyboards and Mice",
                                        "Extension Boards", "Beauty Products", "Cleaning Essentials",
                                        "Fitness Equipments", "Indoor Games", "Kitchen Appliances",
                                        "Pet Supplies", "Self-Care Products"
                                    };
                                    String currentCat = product.getCategory();
                                    if (currentCat == null) currentCat = "";
                                    for (String cat : categories) {
                                %>
                                <option value="<%= cat %>"
                                    <%= cat.equalsIgnoreCase(currentCat) ? "selected" : "" %>>
                                    <%= cat %>
                                </option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Price -->
                        <div class="sell-form-field">
                            <label for="price">Price (INR)</label>
                            <input type="number"
                                   id="price"
                                   name="price"
                                   value="<%= product.getPrice() %>"
                                   min="0"
                                   placeholder="e.g., 3500"
                                   required>
                        </div>

                        <!-- Condition (dropdown like sellproduct.jsp) -->
                        <div class="sell-form-field">
                            <label for="condition">Condition</label>
                            <select name="condition" id="condition" required>
                                <%
                                    String cond = product.getCondition();
                                    if (cond == null) cond = "";
                                %>
                                <option value="">-- Select Condition --</option>
                                <option value="New"  <%= "New".equalsIgnoreCase(cond)  ? "selected" : "" %>>New</option>
                                <option value="Used" <%= "Used".equalsIgnoreCase(cond) ? "selected" : "" %>>Used</option>
                            </select>
                        </div>

                        <!-- Contact -->
                        <div class="sell-form-field">
                            <label for="contact">Contact Info</label>
                            <input type="text"
                                   id="contact"
                                   name="contact"
                                   value="<%= product.getContact() %>"
                                   placeholder="Mobile / Email"
                                   required>
                        </div>

                        <!-- City -->
                        <div class="sell-form-field">
                            <label for="city">City</label>
                            <select name="city" id="city" required>
                                <option value="">Select City</option>
                                <%
                                    String[] cities = {
                                        "Mumbai", "Delhi", "Bengaluru", "Pune", "Chennai", "Ahmedabad",
                                        "Kolkata", "Hyderabad", "Jaipur", "Lucknow", "Bhopal", "Indore",
                                        "Patna", "Ranchi", "Nagpur", "Surat", "Vadodara", "Noida",
                                        "Gurgaon", "Thane"
                                    };
                                    String currentCity = product.getCity();
                                    if (currentCity == null) currentCity = "";
                                    for (String c : cities) {
                                %>
                                <option value="<%= c %>"
                                    <%= c.equalsIgnoreCase(currentCity) ? "selected" : "" %>>
                                    <%= c %>
                                </option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Front Image: current + new -->
                        <div class="sell-form-field">
                            <label>Current Front Image</label>
                            <img id="existingFront"
                                 class="preview-img"
                                 src="<%= request.getContextPath() + "/" + product.getImagePath() %>"
                                 alt="Current Front Image">

                            <label for="frontImageInput">Upload New Front Image (optional)</label>
                            <input type="file"
                                   name="image"
                                   id="frontImageInput"
                                   accept="image/*">
                            <img id="frontPreview"
                                 class="preview-img"
                                 alt="New Front Preview">
                        </div>

                        <!-- Back Image: current + new -->
                        <div class="sell-form-field">
                            <label>Current Back Image</label>
                            <%
                                String backImagePath = product.getBackImagePath();
                                if (backImagePath != null) backImagePath = backImagePath.trim();
                                if (backImagePath != null && !backImagePath.isEmpty()) {
                            %>
                                <img id="existingBack"
                                     class="preview-img"
                                     src="<%= request.getContextPath() + "/" + backImagePath %>"
                                     alt="Current Back Image">
                            <%
                                } else {
                            %>
                                <p style="font-size:12px;color:#6b7280;margin-top:4px;">
                                    No back image uploaded.
                                </p>
                            <%
                                }
                            %>

                            <label for="backImageInput">Upload New Back Image (optional)</label>
                            <input type="file"
                                   name="backImage"
                                   id="backImageInput"
                                   accept="image/*">
                            <img id="backPreview"
                                 class="preview-img"
                                 alt="New Back Preview">
                        </div>

                    </div>

                    <!-- Actions -->
                    <div class="sell-form-actions">
                        <button type="submit" class="primary-gradient-btn">
                            <i class="fa-solid fa-floppy-disk"></i> Update Product
                        </button>

                       
                    </div>
                </form>
            </div>
        </section>
    </main>

    <!-- Scroll-to-top button -->
    <button id="scrollTopBtn" title="Go to top">↑</button>

    <%@ include file="footer.jsp" %>

    <!-- Image preview JS (similar to sellproduct.jsp) -->
    <script>
    // Front new image preview
    document.getElementById("frontImageInput").addEventListener("change", function (event) {
        const img = document.getElementById("frontPreview");
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function () {
                img.src = reader.result;
                img.style.display = "block";
            };
            reader.readAsDataURL(file);
        } else {
            img.style.display = "none";
        }
    });

    // Back new image preview
    document.getElementById("backImageInput").addEventListener("change", function (event) {
        const img = document.getElementById("backPreview");
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function () {
                img.src = reader.result;
                img.style.display = "block";
            };
            reader.readAsDataURL(file);
        } else {
            img.style.display = "none";
        }
    });
    </script>

    <!-- SweetAlert2 for validation (optional but nice) -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
    function validateEditForm() {
        const title = document.getElementById("title").value.trim();
        const description = document.getElementById("description").value.trim();
        const category = document.getElementById("category").value;
        const price = document.getElementById("price").value;
        const condition = document.getElementById("condition").value;
        const contact = document.getElementById("contact").value.trim();
        const city = document.getElementById("city").value;

        if (!title || !description || !category || !price || !condition || !contact || !city) {
            Swal.fire({
                icon: 'warning',
                title: 'Missing Fields!',
                text: 'Please fill in all the required fields.',
                confirmButtonColor: '#2575fc'
            });
            return false;
        }

        const card = document.querySelector(".sell-form-card");
        if (card) {
            card.style.transition = "transform 0.3s ease, opacity 0.3s ease";
            card.style.transform = "scale(0.98)";
            card.style.opacity = "0.93";
        }

        return true;
    }
    </script>

    <!--  Scroll-to-top behaviour -->
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