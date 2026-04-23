<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - StudentBazaar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/studentbazaar.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="page-bg">
<div class="page-wrapper">

    <%@ include file="header.jsp" %>

    <section class="auth-section">
        <div class="auth-card auth-card--wide reveal-card">
            <h2 class="auth-title">Create your StudentBazaar account</h2>
            <p class="auth-subtitle">
                Sign up with your campus details to start buying and selling with verified students.
            </p>

            <!-- ✅ enctype kept for file upload -->
            <form action="RegisterServlet" method="post" autocomplete="off"
                  onsubmit="return validateRegisterForm()" enctype="multipart/form-data">

                <div class="auth-grid">
                    <div class="full-width">
                        <label for="name" class="auth-label">Full Name</label>
                        <input type="text" name="name" id="name" class="auth-input"
                               placeholder="Full Name" required>
                    </div>

                    <div>
                        <label for="phone" class="auth-label">Phone Number</label>
                        <input type="text" name="phone" id="phone" class="auth-input"
                               placeholder="10-digit mobile" required>
                    </div>

                    <div>
                        <label for="email" class="auth-label">Email Address</label>
                        <input type="email" name="email" id="email" class="auth-input"
                               placeholder="Email Address" required autocomplete="off">
                    </div>

                    <div class="password-wrapper">
                        <label for="password" class="auth-label">Password</label>
                        <input type="password" name="password" id="password" class="auth-input"
                               placeholder="Password" required autocomplete="new-password">
                        <span class="toggle-password" onclick="togglePassword('password')">👁</span>
                    </div>

                    <div class="password-wrapper">
                        <label for="confirmPassword" class="auth-label">Confirm Password</label>
                        <input type="password" name="confirmPassword" id="confirmPassword"
                               class="auth-input" placeholder="Confirm Password" required
                               autocomplete="new-password">
                        <span class="toggle-password" onclick="togglePassword('confirmPassword')">👁</span>
                    </div>

                    <div class="full-width">
                        <label for="college" class="auth-label">College Name</label>
                        <input type="text" name="college" id="college" class="auth-input"
                               placeholder="College Name" required>
                    </div>

                    <div>
                        <label for="city" class="auth-label">City</label>
                        <input type="text" name="city" id="city" class="auth-input"
                               placeholder="City" required>
                    </div>

                    <div>
                        <label for="course" class="auth-label">Course</label>
                        <input type="text" name="course" id="course" class="auth-input"
                               placeholder="e.g., BSc IT" required>
                    </div>

                    <div>
                        <label for="year" class="auth-label">Year of Study</label>
                        <input type="number" name="year" id="year" class="auth-input"
                               placeholder="e.g., 3" required>
                    </div>

                    <!-- ✅ ONLY ID CARD for now -->
                    <div class="full-width">
                        <label for="idCardImage" class="auth-label">
                            Student ID Card <span style="color:#ef4444;font-weight:normal;">(required)</span>
                        </label>
                        <input type="file" id="idCardImage" name="idCardImage"
                               accept="image/jpeg,image/png,image/webp"
                               class="auth-input">
                        <small class="field-hint">
                            Upload your valid college ID card • JPG/PNG/WebP • Max 2 MB
                        </small>
                    </div>
                </div>

                <div class="auth-actions">
                    <button type="submit" class="btn-primary auth-btn">Register</button>
                </div>
            </form>
        </div>
    </section>

    <%@ include file="footer.jsp" %>

</div>

<!-- JS: validation + password toggle + SweetAlert handling -->
<script>
    function togglePassword(id) {
        const input = document.getElementById(id);
        if (!input) return;
        input.type = input.type === "password" ? "text" : "password";
    }

    function validateRegisterForm() {
        const name = document.getElementById("name").value.trim();
        const phone = document.getElementById("phone").value.trim();
        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value.trim();
        const confirmPassword = document.getElementById("confirmPassword").value.trim();
        const college = document.getElementById("college").value.trim();
        const city = document.getElementById("city").value.trim();
        const course = document.getElementById("course").value.trim();
        const year = document.getElementById("year").value.trim();

        const idInput = document.getElementById("idCardImage");

        if (!name || !phone || !email || !password || !confirmPassword ||
            !college || !city || !course || !year) {
            Swal.fire("Missing Fields", "Please fill in all fields.", "warning");
            return false;
        }

        const emailRegex = /^[^@]+@[^@]+\.[^@]+$/;
        if (!emailRegex.test(email)) {
            Swal.fire("Invalid Email", "Please enter a valid email address.", "error");
            return false;
        }

        if (password.length < 6) {
            Swal.fire("Weak Password", "Password should be at least 6 characters.", "error");
            return false;
        }

        if (password !== confirmPassword) {
            Swal.fire("Password Mismatch", "Passwords do not match.", "error");
            return false;
        }

        if (phone.length !== 10 || !/^\d{10}$/.test(phone)) {
            Swal.fire("Invalid Phone", "Enter a valid 10-digit phone number.", "error");
            return false;
        }

        const yearNum = parseInt(year);
        if (isNaN(yearNum) || yearNum < 1 || yearNum > 5) {
            Swal.fire("Invalid Year", "Year of study must be between 1 and 5.", "error");
            return false;
        }

        // ID card must be present & valid
        const maxSize = 2 * 1024 * 1024;
        const allowedTypes = ["image/jpeg", "image/png", "image/webp"];

        if (!idInput.files || idInput.files.length === 0) {
            Swal.fire("Student ID required",
                "Please upload your college ID card to continue.",
                "warning");
            return false;
        }

        const file = idInput.files[0];

        if (!allowedTypes.includes(file.type)) {
            Swal.fire("Invalid Student ID card",
                "Please upload a JPG, PNG or WebP ID card.",
                "warning");
            return false;
        }

        if (file.size > maxSize) {
            Swal.fire("Student ID too large",
                "Maximum file size is 2 MB.",
                "warning");
            return false;
        }

        return true;
    }
</script>

<% if ("exception".equals(request.getParameter("error"))) { %>
<script>
    Swal.fire("Registration Failed", "An account with this email may already exist.", "error");
</script>
<% } else if ("insert".equals(request.getParameter("error"))) { %>
<script>
    Swal.fire("Error", "Could not register. Please try again.", "error");
</script>
<% } %>

</body>
</html>