<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<footer class="site-footer">
    <div class="footer-inner">
        <div class="footer-columns">
            <div class="footer-column">
                <h4>About</h4>
                <a href="#">Our Story</a>
                <a href="#">Campus Partners</a>
                <a href="#">Press</a>
            </div>
            <div class="footer-column">
                <h4>Help</h4>
                <a href="#">Support</a>
                <a href="#">Contact</a>
                <a href="#">Safety Tips</a>
            </div>
            <div class="footer-column">
                <h4>Legal</h4>
                <a href="#">Terms</a>
                <a href="#">Privacy</a>
                <a href="#">Cookies</a>
            </div>
            <div class="footer-column footer-newsletter">
                <h4>Stay Updated</h4>
                <form onsubmit="handleNewsletter(event)">
                    <input type="email" id="newsletterEmail" placeholder="Your email address">
                    <button type="submit">Subscribe</button>
                </form>
            </div>
        </div>

        <div class="footer-bottom">
            &copy; 2025 StudentBazaar. Built for campus marketplaces.
        </div>
    </div>
</footer>

<button id="scrollTopBtn" title="Back to top">↑</button>

<script>
    // Scroll-to-top button
    const scrollBtn = document.getElementById("scrollTopBtn");
    window.addEventListener("scroll", () => {
        const show = document.documentElement.scrollTop > 220;
        scrollBtn.style.display = show ? "block" : "none";
    });
    scrollBtn.addEventListener("click", () => {
        window.scrollTo({ top: 0, behavior: "smooth" });
    });

    // Reveal-on-scroll for cards
    const revealCards = document.querySelectorAll(".reveal-card");
    const revealObserver = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add("visible");
            }
        });
    }, { threshold: 0.2 });
    revealCards.forEach(card => revealObserver.observe(card));

    // Hero carousel
    const slides = document.querySelectorAll(".carousel-slide");
    const dots = document.querySelectorAll(".carousel-dot");
    let currentSlide = 0;

    function showSlide(idx) {
        if (!slides.length) return;
        currentSlide = (idx + slides.length) % slides.length;
        slides.forEach((s, i) => s.classList.toggle("active", i === currentSlide));
        dots.forEach((d, i) => d.classList.toggle("active", i === currentSlide));
    }

    const prevBtn = document.getElementById("prevSlide");
    const nextBtn = document.getElementById("nextSlide");
    if (prevBtn && nextBtn) {
        prevBtn.addEventListener("click", () => showSlide(currentSlide - 1));
        nextBtn.addEventListener("click", () => showSlide(currentSlide + 1));
    }

    if (slides.length) {
        showSlide(0);
        setInterval(() => showSlide(currentSlide + 1), 6000);
    }

    // newsletter dummy handler
    function handleNewsletter(e) {
        e.preventDefault();
        const input = document.getElementById("newsletterEmail");
        if (!input.value.trim()) {
            alert("Please enter your email.");
            return;
        }
        alert("Thank you for subscribing to StudentBazaar updates! 🎉");
        input.value = "";
    }
</script>