<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sell Product - StudentBazaar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Your main theme CSS (same as register / category pages) -->
    <link rel="stylesheet" href="css/studentbazaar.css">

    <!-- Font Awesome (for any icons used in header / buttons) -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body class="page-bg">

    <%@ include file="header.jsp" %>

    <main class="sell-page-main">

       <!-- 🔹 SELL PRODUCT HERO (blue card, same as Browse hero) -->
<section class="sell-hero-wrapper">
    <div class="category-hero-card">
        <!-- Left side text (reuses category-hero styles) -->
        <div class="category-hero-text">
            <div class="category-hero-title">Post Your Product</div>
            <div class="category-hero-subtitle">
                Turn your unused items into cash and help other students save on campus essentials.
            </div>
            <div class="category-hero-mini">
                Reach verified students on your campus with safe, trusted listings.
            </div>
        </div>

        <!-- Right side: meta + button -->
        <div class="sell-hero-meta">
            <div>Smart marketplace — verified students only</div>
            <span>Safe campus listings</span>

            <!-- Gradient button at bottom-right -->
            <a href="ViewMyProductServlet" class="sell-hero-edit-btn">
                My Posts
            </a>
        </div>
    </div>
</section>
               <!--  Form card -->
        <section class="sell-form-shell rainbow-frame">
            <div class="rainbow-inner sell-form-card">
                <div class="sell-form-header">
                    <h2>Listing Details</h2>
                    <p>Fill in the details below to create a clear, trustworthy listing for buyers.</p>
                </div>

                <!-- LOGIC: same action, enctype, field names -->
                <form action="<%= request.getContextPath() %>/UploadProductServlet"
                      method="post"
                      enctype="multipart/form-data"
                      onsubmit="return validateSellForm()">

                    <div class="sell-form-grid">

                        <!-- Title -->
                        <div class="sell-form-field full-width">
                            <label for="title">Product Title</label>
                            <input type="text"
                                   id="title"
                                   name="title"
                                   placeholder="e.g., Lenovo Laptop"
                                   required>
                        </div>

                        <!-- Description -->
                        <div class="sell-form-field full-width">
                            <label for="description">Product Description</label>
                            <textarea id="description"
                                      name="description"
                                      placeholder="Describe the product, usage, and any key details"
                                      rows="4"
                                      required></textarea>
                        </div>

                        <!-- Category -->
                        <div class="sell-form-field">
                            <label for="category">Category</label>
                            <select name="category" id="category" required>
                                <option value="" disabled selected>Select Category</option>
                                <option value="Mobiles">Mobiles</option>
                                <option value="Books">Books</option>
                                <option value="Shoes">Shoes</option>
                                <option value="Bags">Bags</option>
                                <option value="Watches">Watches</option>
                                <option value="Stationery">Stationery</option>
                                <option value="Speakers">Speakers</option>
                                <option value="Clothes">Clothes</option>
                                <option value="Gaming">Gaming</option>
                                <option value="Headphones">Headphones</option>
                                <option value="Laptops">Laptops</option>
                                <option value="Furniture">Furniture</option>
                                <option value="Bicycles">Bicycles</option>
                                <option value="Bikes">Bikes</option>
                                <option value="Power Banks">Power Banks</option>
                                <option value="Sports">Sports</option>
                                <option value="Earbuds">Earbuds</option>
                                <option value="Wall Clocks">Wall Clocks</option>
                                <option value="Lamps">Lamps</option>
                                <option value="Water Bottles">Water Bottles</option>
                                <option value="Accessories">Accessories</option>
                                <option value="Musical Instruments">Musical Instruments</option>
                                <option value="Project Kits">Project Kits</option>
                                <option value="Study Tables">Study Tables</option>
                                <option value="Decor Items">Decor Items</option>
                                <option value="Perfumes">Perfumes</option>
                                <option value="Printers">Printers</option>
                                <option value="Table Fans">Table Fans</option>
                                <option value="Bed Sheets">Bed Sheets</option>
                                <option value="Mugs">Mugs</option>
                                <option value="Calculators">Calculators</option>
                                <option value="Keyboards and Mice">Keyboards and Mice</option>
                                <option value="Extension Boards">Extension Boards</option>
                                <option value="Beauty Products">Beauty Products</option>
                                <option value="Cleaning Essentials">Cleaning Essentials</option>
                                <option value="Fitness Equipment">Fitness Equipment</option>
                                <option value="Indoor Games">Indoor Games</option>
                                <option value="Kitchen Appliances">Kitchen Appliances</option>
                                <option value="Pet Supplies">Pet Supplies</option>
                                <option value="Self-Care Products">Self-Care Products</option>
                            </select>
                        </div>

                        <!-- Price -->
                        <div class="sell-form-field">
                            <label for="price">Price (INR)</label>
                            <input type="number"
                                   id="price"
                                   name="price"
                                   placeholder="e.g., 3500"
                                   min="0"
                                   required>
                        </div>

                        <!-- Condition -->
                        <div class="sell-form-field">
                            <label for="condition">Condition</label>
                            <select name="condition" id="condition" required>
                                <option value="">-- Select Condition --</option>
                                <option value="New">New</option>
                                <option value="Used">Used</option>
                            </select>
                        </div>

                        <!-- Contact -->
                        <div class="sell-form-field">
                            <label for="contact">Contact Info</label>
                            <input type="text"
                                   id="contact"
                                   name="contact"
                                   placeholder="Mobile / Email"
                                   required>
                        </div>

                        <!-- City -->
                        <div class="sell-form-field">
                            <label for="city">City</label>
                            <select name="city" id="city" required>
                                <option value="" disabled selected>Select City</option>
                                <option value="Mumbai">Mumbai</option>
                                <option value="Delhi">Delhi</option>
                                <option value="Hyderabad">Hyderabad</option>
                                <option value="Pune">Pune</option>
                                <option value="Kolkata">Kolkata</option>
                                <option value="Ahmedabad">Ahmedabad</option>
                                <option value="Bangalore">Bangalore</option>
                                <option value="Chennai">Chennai</option>
                            </select>
                        </div>

                        <!-- Front Image -->
                        <div class="sell-form-field">
                            <label for="frontImageInput">Upload Front Image</label>
                            <input type="file"
                                   name="image"
                                   id="frontImageInput"
                                   accept="image/*"
                                   required>
                            <img id="frontPreview"
                                 class="preview-img"
                                 alt="Front Image Preview">
                        </div>

                        <!-- Back Image -->
                        <div class="sell-form-field">
                            <label for="backImageInput">Upload Back Image (optional)</label>
                            <input type="file"
                                   name="backImage"
                                   id="backImageInput"
                                   accept="image/*">
                            <img id="backPreview"
                                 class="preview-img"
                                 alt="Back Image Preview">
                        </div>

                    </div>

                    <div class="sell-form-actions">
                        <button type="submit" class="primary-gradient-btn">
                            Post Ad
                        </button>
                    </div>
                </form>
            </div>
        </section>
    </main>

    <!-- Scroll-to-top button (same style across app) -->
    <button id="scrollTopBtn" title="Go to top">↑</button>

    <%@ include file="footer.jsp" %>

    <!-- ✅ Image preview JS -->
    <script>
    // Front image preview
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

    // Back image preview
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

    <!-- SweetAlert2 (for validation) -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!--  Form validation -->
    <script>
    function validateSellForm() {
        const title = document.getElementById("title").value.trim();
        const description = document.getElementById("description").value.trim();
        const category = document.getElementById("category").value;
        const price = document.getElementById("price").value;
        const condition = document.getElementById("condition").value;
        const contact = document.getElementById("contact").value.trim();
        const image = document.querySelector('input[name="image"]').files[0];

        if (!title || !description || !category || !price || !condition || !contact || !image) {
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

    <!-- Scroll-to-top -->
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