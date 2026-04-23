<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>StudentBazaar - Index</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/studentbazaar.css">
</head>
<body class="page-bg">
<div class="page-wrapper">

    <%@ include file="header.jsp" %>
    <!-- HERO SECTION -->
<section class="hero-section">
    <!-- LEFT: gradient hero card with text -->
    <div class="hero-left">
        <div class="hero-cta-card reveal-card">
            <div class="hero-eyebrow">Campus-only marketplace</div>
            <h1 class="hero-title">
                Buy & sell everything you need for college — in one safe place.
            </h1>
            <p class="hero-subtitle">
                StudentBazaar connects verified students to trade books, gadgets, notes, and hostel essentials.
                No random outsiders, no spam — just your campus.
            </p>

            <div class="hero-badges">
                <span class="hero-badge">Verified college email / ID</span>
                <span class="hero-badge">Zero listing charges</span>
                <span class="hero-badge">Fast campus meetups</span>
            </div>

            <div class="hero-actions">
                <button class="btn-primary" onclick="location.href='buyproduct.jsp'">Start Buying</button>
                <button class="btn-secondary" onclick="location.href='sellproduct.jsp'">Sell an Item</button>
            </div>

            <div class="hero-stats">
                <div class="hero-stat">
                    <strong>100+</strong>
                    active listings every week
                </div>
                <div class="hero-stat">
                    <strong>₹50k+</strong>
                    saved by students via resale
                </div>
                <div class="hero-stat">
                    <strong>Campus-only</strong>
                    access with secure sign-up
                </div>
            </div>
        </div>
    </div>

    <!-- RIGHT: carousel card (same content as before) -->
    <div class="hero-right">
        <div class="hero-card reveal-card">
            <div class="hero-card-header">
                <div class="hero-card-title">Live campus deals</div>
                <span class="hero-card-pill">Updated in real-time</span>
            </div>

            <div class="hero-carousel">
                <div class="carousel-inner">
                    <div class="carousel-slide active">
                        <div>
                            <div class="carousel-icon">📚</div>
                            <div class="carousel-text-title">Semester book bundle for 2nd year IT</div>
                            <div class="carousel-text-body">
                                Buy complete subject set at 60% off MRP from a senior who just passed the exams.
                            </div>
                        </div>
                        <div class="carousel-footer">
                            Posted 15 mins ago · Pickup near Library Block
                        </div>
                    </div>

                    <div class="carousel-slide">
                        <div>
                            <div class="carousel-icon">🎧</div>
                            <div class="carousel-text-title">Noise-cancelling headset, barely used</div>
                            <div class="carousel-text-body">
                                Perfect for online lectures, editing, or late-night coding marathons in the hostel.
                            </div>
                        </div>
                        <div class="carousel-footer">
                            Verified seller · COD at Campus Canteen
                        </div>
                    </div>

                    <div class="carousel-slide">
                        <div>
                            <div class="carousel-icon">🪑</div>
                            <div class="carousel-text-title">Hostel furniture combo</div>
                            <div class="carousel-text-body">
                                Study table, chair, and lamp set from a graduating senior — ready to move into your room.
                            </div>
                        </div>
                        <div class="carousel-footer">
                            Limited stock · Reserved quickly every semester
                        </div>
                    </div>
                </div>

                <div class="carousel-controls">
                    <button type="button" id="prevSlide" class="carousel-btn">‹</button>
                    <button type="button" id="nextSlide" class="carousel-btn">›</button>
                </div>
                <div class="carousel-dots">
                    <span class="carousel-dot active"></span>
                    <span class="carousel-dot"></span>
                    <span class="carousel-dot"></span>
                </div>
            </div>
        </div>
    </div>
</section>
       <!-- FEATURE SECTION -->
    <section class="section-wrapper">
        <h2 class="section-heading">Why students love StudentBazaar</h2>
        <p class="section-subtitle">
            Built around real campus life — quick, affordable, and safe exchanges between classmates.
        </p>

        <div class="feature-grid">
            <div class="feature-card reveal-card">
                <div class="feature-icon">⚡</div>
                <div class="feature-title">Instant campus discovery</div>
                <p class="feature-body">
                    Browse items listed by students in your college, branch, or hostel within seconds. No need to dig through generic classifieds.
                </p>
            </div>
            <div class="feature-card reveal-card">
                <div class="feature-icon">💬</div>
                <div class="feature-title">Chat & meet safely</div>
                <p class="feature-body">
                    Coordinate via college mail or campus-safe contact options. Decide a meetup spot like library, canteen or department lobby.
                </p>
            </div>
            <div class="feature-card reveal-card">
                <div class="feature-icon">💸</div>
                <div class="feature-title">Save more every semester</div>
                <p class="feature-body">
                    Reuse seniors’ books, lab coats, calculators, and gadgets. Reduce waste and keep your budget in control.
                </p>
            </div>
            <div class="feature-card reveal-card">
                <div class="feature-icon">🧑‍🎓</div>
                <div class="feature-title">Students-only access</div>
                <p class="feature-body">
                    Only verified college students can sign up and post listings. That keeps the marketplace focused and spam-free.
                </p>
            </div>
            <div class="feature-card reveal-card">
                <div class="feature-icon">📦</div>
                <div class="feature-title">Simple posting workflow</div>
                <p class="feature-body">
                    Add photos, set a fair price, and publish your listing in under a minute. Manage everything from your dashboard.
                </p>
            </div>
            <div class="feature-card reveal-card">
                <div class="feature-icon">🔒</div>
                <div class="feature-title">Focus on safety</div>
                <p class="feature-body">
                    Report suspicious behaviour, track your deals, and control what details are visible. Built with student safety in mind.
                </p>
            </div>
        </div>
    </section>

    <!-- CATEGORY SECTION -->
    <section class="section-wrapper">
        <h2 class="section-heading">Top categories on campus</h2>
        <p class="section-subtitle">
            Start browsing by category — you can always filter more once you’re inside.
        </p>

        <div class="category-grid">
            <div class="category-card reveal-card">
                <div>📚 Textbooks & Notes</div>
                <span class="category-chip">Most active</span>
                <small>Semester books, guides, handwritten notes and lab records.</small>
            </div>
            <div class="category-card reveal-card">
                <div>💻 Laptops & Gadgets</div>
                <span class="category-chip">High value</span>
                <small>Used laptops, tablets, earphones, smartwatches and more.</small>
            </div>
            <div class="category-card reveal-card">
                <div>🧥 Fashion & Accessories</div>
                <span class="category-chip">Trending</span>
                <small>Casual wear, college hoodies, shoes and bags.</small>
            </div>
            <div class="category-card reveal-card">
                <div>🏠 Hostel Essentials</div>
                <span class="category-chip">Must-have</span>
                <small>Study tables, chairs, lamps, storage racks and mirrors.</small>
            </div>
            <div class="category-card reveal-card">
                <div>🎯 Clubs & Events</div>
                <span class="category-chip">Limited</span>
                <small>Event passes, club merch, props and costumes.</small>
            </div>
            <div class="category-card reveal-card">
                <div>🎮 Fun & Hobbies</div>
                <span class="category-chip">Weekend picks</span>
                <small>Board games, instruments, cameras and sports gear.</small>
            </div>
        </div>
    </section>

    <%@ include file="footer.jsp" %>

</div>
</body>
</html>