<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Set, java.util.HashSet, com.studentbazaar.model.Product, com.studentbazaar.dao.CartDAO" %>
<%@ page import="java.sql.*" %>
<%
    // ====== DATA SETUP ======
    List<Product> products = (List<Product>) request.getAttribute("products");
    String category = (String) request.getAttribute("category");
    if (category == null) category = "All Products";
    if (products == null) products = java.util.Collections.emptyList();

    Integer cartCount = 0;
    String userEmail = null;
    String username = null;

    if (session != null) {
        userEmail = (String) session.getAttribute("userEmail");
        username  = (String) session.getAttribute("username");
        try {
            if (userEmail != null) {
                java.util.List<Product> cartList = CartDAO.getCartItems(userEmail);
                cartCount = (cartList != null) ? cartList.size() : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    String priceSort  = request.getParameter("priceSort")  == null ? "" : request.getParameter("priceSort");
    String ratingSort = request.getParameter("ratingSort") == null ? "" : request.getParameter("ratingSort");

    // SOLD products
    Set<Integer> soldProductIds = new HashSet<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/studentbazaar",
                "root",
                ""
        );
        String soldQuery = "SELECT DISTINCT product_id FROM orders";
        PreparedStatement soldPs = conn.prepareStatement(soldQuery);
        ResultSet soldRs = soldPs.executeQuery();
        while (soldRs.next()) {
            soldProductIds.add(soldRs.getInt("product_id"));
        }
        soldRs.close();
        soldPs.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    String studentStatus = (String) session.getAttribute("studentStatus");
    boolean isVerifiedUser = (studentStatus != null && studentStatus.equalsIgnoreCase("Verified"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>StudentBazaar - <%= category %></title>

    <!-- Global site CSS (same as login/register/dashboard) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/studentbazaar.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body class="category-page">

<div class="page-bg category-page">
    <!-- Shared header -->
    <jsp:include page="header.jsp"/>

    <div class="layout-wrapper category-wrapper">

        <!-- ========= HERO CARD (CATEGORY) ========= -->
        <div class="category-hero-card">
            <div class="category-hero-text">
                <h1 class="category-hero-title">
                    Browse: <%= category %>
                </h1>
                <p class="category-hero-subtitle">
                    Smart marketplace for students — filter by price and reviews.
                </p>
                <p class="category-hero-mini">
                    Showing <strong><%= products.size() %></strong> items in this category.
                </p>
            </div>
            <div class="category-hero-actions">
    <form method="get"
          action="<%= request.getContextPath() %>/CategoryServlet"
          class="category-filter-form">
        <input type="hidden" name="category" value="<%= category %>"/>

        <select name="priceSort"
                class="filter-select"
                onchange="this.form.submit()">
            <option value="">Price</option>
            <option value="low"  <%= "low".equals(priceSort)  ? "selected" : "" %>>Low to High</option>
            <option value="high" <%= "high".equals(priceSort) ? "selected" : "" %>>High to Low</option>
        </select>

        <select name="ratingSort"
                class="filter-select"
                onchange="this.form.submit()">
            <option value="">Review</option>
            <option value="rating_high" <%= "rating_high".equals(ratingSort) ? "selected" : "" %>>
                High to Low
            </option>
            <option value="rating_low"  <%= "rating_low".equals(ratingSort)  ? "selected" : "" %>>
                Low to High
            </option>
        </select>
    </form>
</div>

           
                   </div>

        <!-- Section title -->
        <h2 class="category-section-title">Available Listings</h2>

        <!-- ========= ACCORDION STRIP ========= -->
        <div class="category-container">
            <div class="accordion" id="productAccordion">
                <%
                    for (Product p : products) {
                        String pid = "prod-" + p.getId();

                        String img1 = (p.getImagePath()!=null && !p.getImagePath().isEmpty())
                                      ? p.getImagePath()
                                      : (request.getContextPath()+"/img/default.jpg");

                        String img2 = (p.getBackImagePath()!=null && !p.getBackImagePath().isEmpty())
                                      ? p.getBackImagePath()
                                      : "";

                        String posted = "N/A";
                        try {
                            java.lang.reflect.Method gm = p.getClass().getMethod("getPostedOn");
                            Object val = gm.invoke(p);
                            if (val != null) posted = val.toString();
                        } catch (Exception ignore) {}

                        boolean isSold = soldProductIds.contains(p.getId());

                        String uploader = null;
                        try {
                            uploader = p.getUploader();
                        } catch (Exception e) {
                            uploader = null;
                        }

                        boolean isOwnListing = false;
                        if (uploader != null) {
                            if (userEmail != null && uploader.equalsIgnoreCase(userEmail)) {
                                isOwnListing = true;
                            } else if (username != null && uploader.equalsIgnoreCase(username)) {
                                isOwnListing = true;
                            }
                        }

                        boolean canBuy = (!isSold && !isOwnListing);
                %>
                <div class="accordion-item" id="<%= pid %>">
                    <div class="accordion-header" data-target="<%= pid %>-panel">
                        <div class="thumb">
                            <img src="<%= img1 %>" alt="thumb">
                        </div>

                        <div class="hdr-info">
                            <div class="hdr-main-row">
                                <div>
                                    <div class="hdr-title"><%= p.getTitle() %></div>
                                    <div class="hdr-meta">
                                        ₹<%= p.getPrice() %> • <%= p.getCity() %> • <%= p.getCategory() %>
                                    </div>
                                </div>

                                <div class="hdr-right-row">
                                    <div class="badge"><%= p.getDiscount() %>%</div>

                                    <% if (isSold) { %>
                                        <span class="pill-badge sold">SOLD</span>
                                    <% } else if (isOwnListing) { %>
                                        <span class="pill-badge own">YOUR LISTING</span>
                                    <% } %>

                                    <i class="fas fa-chevron-down expand-icon" aria-hidden="true"></i>
                                </div>
                            </div>

                            <div class="hdr-posted">
                                Posted: <%= posted %>
                            </div>

                            <% if (isSold) { %>
                                <div class="sold-note sold-note-sold">
                                    Already purchased by a student.
                                </div>
                            <% } else if (isOwnListing) { %>
                                <div class="sold-note sold-note-own">
                                    This is your own listing. Other students can buy it.
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Detail panel (filled by JS) -->
                    <div class="panel" id="<%= pid %>-panel"></div>
                </div>
                <% } %>
            </div>

            <!-- Detail area clone will be appended here by JS -->
        </div>

        <!-- Scroll to top -->
        <button id="scrollTopBtn" title="Go to top">↑</button>

    </div> <!-- /layout-wrapper.category-wrapper -->

    <!-- Shared footer -->
    <jsp:include page="footer.jsp"/>
</div> <!-- /page-bg.category-page -->

<!-- ========= CHAT MODAL ========= -->
<div id="chatBox" class="chat-modal">
    <div class="chat-content">
        <span class="chat-close" onclick="closeChatBox()">×</span>

        <div id="chatBody">
            <div class="seller-msg typing" id="typing">
                <span class="dot"></span><span class="dot"></span><span class="dot"></span>
            </div>
        </div>

        <div class="chat-input-row">
            <input id="chatInput"
                   class="chat-input"
                   placeholder="Type your message...">
            <button class="chat-send-btn" onclick="sendMessage()">Send</button>
        </div>
    </div>
</div>

<!-- ========= JS: panels, SOLD/OWN, slider, cart, chat ========= -->
<script>
(function () {
    // Build JS product array
    var products = [
        <% for (int i = 0; i < products.size(); i++) {
            Product p = products.get(i);
            String pid = "prod-" + p.getId();

            String img1 = (p.getImagePath()!=null && !p.getImagePath().isEmpty())
                          ? p.getImagePath()
                          : (request.getContextPath()+"/img/default.jpg");

            String img2 = (p.getBackImagePath()!=null && !p.getBackImagePath().isEmpty())
                          ? p.getBackImagePath()
                          : "";

            String rating = String.valueOf(p.getRating());
            String posted = "N/A";
            try {
                java.lang.reflect.Method gm = p.getClass().getMethod("getPostedOn");
                Object v = gm.invoke(p);
                if (v != null) posted = v.toString();
            } catch (Exception e) {}

            boolean isSoldJS = soldProductIds.contains(p.getId());

            String uploaderJS = null;
            try {
                uploaderJS = p.getUploader();
            } catch (Exception e) {
                uploaderJS = null;
            }

            boolean isOwnJS = false;
            if (uploaderJS != null) {
                if (userEmail != null && uploaderJS.equalsIgnoreCase(userEmail)) {
                    isOwnJS = true;
                } else if (username != null && uploaderJS.equalsIgnoreCase(username)) {
                    isOwnJS = true;
                }
            }
        %>{
            id: "<%= pid %>",
            title: "<%= p.getTitle().replace("\"","\\\"") %>",
            price: "<%= p.getPrice() %>",
            city: "<%= p.getCity() %>",
            category: "<%= p.getCategory() %>",
            discount: "<%= p.getDiscount() %>",
            img1: "<%= img1 %>",
            img2: "<%= img2 %>",
            contact: "<%= p.getContact() %>",
            condition: "<%= p.getCondition() %>",
            rating: <%= rating %>,
            posted: "<%= posted %>",
            pidVal: "<%= p.getId() %>",
            isSold: <%= isSoldJS %>,
            isOwn: <%= isOwnJS %>,
            isVerifiedUser: <%= isVerifiedUser %>
        }<%= (i < products.size() - 1) ? "," : "" %>
        <% } %>
    ];

    // Fill detail panels
    products.forEach(function (prod) {
        var panel = document.getElementById(prod.id + "-panel");
        if (!panel) return;

        var left = document.createElement('div');
        left.className = 'panel-left';

        var sliderHtml =
            '<div class="slider" data-img1="' + prod.img1 + '" data-img2="' + prod.img2 + '">' +
                '<img src="' + prod.img1 + '" alt="img" class="slide-img">' +
                (prod.img2 ? '<img src="' + prod.img2 + '" alt="img" class="slide-img" style="display:none;">' : '') +
                '<button class="nav-btn prev">&lsaquo;</button>' +
                '<button class="nav-btn next">&rsaquo;</button>' +
            '</div>';

        left.innerHTML = sliderHtml;

        var details = document.createElement('div');
        details.className = 'details';
        details.innerHTML =
            '<h3 class="panel-title">' + prod.title + '</h3>' +
            '<div class="rating">' + renderStars(prod.rating) +
            ' <span style="font-size:13px;color:#6b7280;">(' + prod.rating + ')</span></div>' +
            '<p><strong>Price:</strong> ₹' + prod.price + '</p>' +
            '<p><strong>Condition:</strong> ' + prod.condition + '</p>' +
            '<p><strong>Contact:</strong> ' + prod.contact + '</p>';

        if (prod.isSold) {
            details.innerHTML += '<p class="sold-note sold-note-sold">Already purchased by a student.</p>';
        } else if (prod.isOwn) {
            details.innerHTML += '<p class="sold-note sold-note-own">This is your own listing. You cannot purchase it.</p>';
        }

        left.appendChild(details);

        var right = document.createElement('div');
        right.className = 'panel-right';

        var rightInner = '<div>';

        if (prod.isSold) {
            rightInner += '<button type="button" class="action-btn btn-disabled" disabled>' +
                          'Already Sold</button>';
        } else if (prod.isOwn) {
            rightInner += '<button type="button" class="action-btn btn-disabled" disabled>' +
                          'Your Product (Not Buyable)</button>';
        } else if (!prod.isVerifiedUser) {

            rightInner += '<button type="button" class="action-btn btn-disabled" onclick="showNotVerified()">' +
                          'Not Verified</button>';

        } else {

            rightInner +=
                '<form action="' + '<%= request.getContextPath() %>' + '/AddToCartServlet" ' +
                'method="post" onsubmit="return handleAddToCart(this, event);">' +
                '<input type="hidden" name="productId" value="' + prod.pidVal + '">' +
                '<input type="hidden" name="category" value="' + encodeURIComponent("<%= category %>") + '">' +
                '<button type="submit" class="action-btn">Add to Cart</button>' +
                '</form>';
        }
        rightInner +=
            '<button class="action-btn chat-btn" type="button" onclick="openChatBox()">' +
            'Chat with Seller</button>' +
            '<div style="margin-top:6px;"><strong>Location</strong></div>' +
            '<iframe class="map-embed" src="https://www.google.com/maps?q=' +
            encodeURIComponent(prod.city) + '&output=embed"></iframe>' +
            '</div>';

        right.innerHTML = rightInner;

        var grid = document.createElement('div');
        grid.className = 'panel-grid';
        grid.appendChild(left);
        grid.appendChild(right);

        panel.appendChild(grid);
    });

    function renderStars(rating) {
        var r = rating || 0;
        var full = Math.floor(r);
        var half = (r % 1) !== 0;
        var empty = 5 - full - (half ? 1 : 0);
        var s = '';
        for (var i = 0; i < full; i++)  s += '<i class="fas fa-star rating-star"></i>';
        if (half)                       s += '<i class="fas fa-star-half-alt rating-star"></i>';
        for (var j = 0; j < empty; j++) s += '<i class="far fa-star rating-star"></i>';
        return s;
    }

    // Slider navigation
    document.addEventListener('click', function (e) {
        if (e.target.matches('.slider .prev') || e.target.matches('.slider .next')) {
            var slider = e.target.closest('.slider');
            if (!slider) return;

            var imgs = slider.querySelectorAll('.slide-img');
            if (imgs.length <= 1) return;

            var currentIdx = -1;
            for (var i = 0; i < imgs.length; i++) {
                if (imgs[i].style.display !== 'none') {
                    currentIdx = i;
                    break;
                }
            }
            if (currentIdx === -1) currentIdx = 0;

            var nextIdx;
            if (e.target.classList.contains('prev')) {
                nextIdx = (currentIdx - 1 + imgs.length) % imgs.length;
            } else {
                nextIdx = (currentIdx + 1) % imgs.length;
            }

            imgs.forEach(function (im, idx) {
                im.style.display = (idx === nextIdx) ? 'block' : 'none';
            });
        }
    });

    // Add to cart
    window.handleAddToCart = function (form, evt) {
        evt = evt || window.event;
        if (evt.preventDefault) evt.preventDefault();

        Swal.fire({
            icon: 'success',
            title: 'Added to Cart!',
            showConfirmButton: false,
            timer: 800
        });

        try {
            new Audio('<%= request.getContextPath() %>/sounds/cart-add.mp3')
                .play()
                .catch(function () {});
        } catch (e) {}

        var cartIcon = document.getElementById('cart-count');
        if (cartIcon) {
            var v = parseInt(cartIcon.textContent || '0');
            cartIcon.textContent = v + 1;
        }

        setTimeout(function () {
            form.submit();
        }, 850);

        return false;
    };

    
    
 // Accordion → full detail area below (with toggle)
    (function () {
        var container = document.querySelector('.category-container');
        if (!container) return;

        var detailArea = null;
        var currentOpenId = null;

        document.querySelectorAll('.accordion-item').forEach(function (item) {
            item.addEventListener('click', function (e) {
                var tag = e.target.tagName.toLowerCase();
                if (tag === 'button' || tag === 'a' || e.target.closest('form')) return;

                var prodId = item.id;

                // If same card is already open → close it
                if (currentOpenId === prodId && detailArea && detailArea.innerHTML.trim() !== '') {
                    detailArea.innerHTML = '';
                    currentOpenId = null;
                    return;
                }

                // Ensure detail area exists
                if (!detailArea) {
                    detailArea = document.createElement('div');
                    detailArea.id = 'full-detail-area';
                    detailArea.className = 'detail-area';
                    container.appendChild(detailArea);
                }

                currentOpenId = prodId;

                var panel = document.getElementById(prodId + '-panel');
                if (!panel) return;

                var clone = panel.cloneNode(true);
                clone.classList.add('open', 'panel-clone');

                detailArea.innerHTML = '';
                detailArea.appendChild(clone);

                // Reset slider to first image
                var imgs = clone.querySelectorAll('.slide-img');
                imgs.forEach(function (im, idx) {
                    im.style.display = (idx === 0) ? 'block' : 'none';
                });

                setTimeout(function () {
                    detailArea.scrollIntoView({behavior: 'smooth', block: 'start'});
                }, 80);
            });
        });

        // Click outside accordion + detail closes it
        document.addEventListener('click', function (e) {
            var insideAccordion = !!e.target.closest('.accordion');
            var insideDetail    = !!e.target.closest('#full-detail-area');
            if (!insideAccordion && !insideDetail) {
                var da = document.getElementById('full-detail-area');
                if (da) da.innerHTML = '';
                currentOpenId = null;
            }
        });
    })();
    })();
</script>

<!-- Scroll to top logic -->
<script>
(function () {
    var scrollBtn = document.getElementById("scrollTopBtn");
    if (!scrollBtn) return;

    window.addEventListener('scroll', function () {
        var s = document.body.scrollTop || document.documentElement.scrollTop;
        scrollBtn.style.display = (s > 300) ? "block" : "none";
    });

    scrollBtn.addEventListener('click', function () {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
})();
</script>

<!-- Chat helpers -->
<script>
function sendMessage() {
    var input = document.getElementById('chatInput');
    if (!input) return;

    var val = input.value.trim();
    if (!val) return;

    var body = document.getElementById('chatBody');
    if (!body) return;

    var div = document.createElement('div');
    div.className = 'user-msg';
    div.textContent = val;
    body.appendChild(div);

    input.value = '';
    body.scrollTop = body.scrollHeight;
}

function openChatBox() {
    var chat = document.getElementById('chatBox');
    if (chat) chat.classList.add('open');

    var typing = document.getElementById('typing');
    if (typing) {
        setTimeout(function () {
            typing.classList.remove('typing');
            typing.textContent = 'Hi, how can I help you?';
        }, 1200);
    }
}

function closeChatBox() {
    var chat = document.getElementById('chatBox');
    if (chat) chat.classList.remove('open');

    var input = document.getElementById('chatInput');
    if (input) input.value = '';

    var chatBody = document.getElementById('chatBody');
    if (chatBody) {
        chatBody.innerHTML =
            '<div class="seller-msg typing" id="typing">' +
            '<span class="dot"></span><span class="dot"></span><span class="dot"></span>' +
            '</div>';
    }
}
</script>
<script>
function showNotVerified() {
    Swal.fire({
        icon: 'warning',
        title: 'Verification Required',
        text: 'Your account is not verified. Please upload a valid student ID.',
        confirmButtonColor: '#f39c12'
    });
}
</script>
</body>
</html>