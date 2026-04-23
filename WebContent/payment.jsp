<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get email from session – used by SendOTPServlet
    String userEmail = (String) session.getAttribute("userEmail");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>StudentBazaar - Payment</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Main theme CSS -->
    <link rel="stylesheet" href="css/studentbazaar.css">

    <!-- Icons (if needed in header/footer) -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <!-- SweetAlert2 for validation messages -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="page-bg">

    <%@ include file="header.jsp" %>

    <main class="payment-page-main">

        <!--  Payment form card with rainbow border -->
        <section class="payment-card-shell rainbow-frame">
            <div class="rainbow-inner payment-card">

                <div class="payment-card-header">
                    <h1>Enter Payment Details</h1>
                    <p>Provide your details to receive an OTP and complete the purchase.</p>
                </div>

                <form action="<%= request.getContextPath() %>/SendOTPServlet"
                      method="post"
                      onsubmit="return validatePaymentForm()">

                    <div class="payment-form-grid">

                        <!-- Full name -->
                        <div class="payment-field full-width">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name"
                                   placeholder="e.g., John wick" required>
                        </div>

                        <!-- Phone -->
                        <div class="payment-field">
                            <label for="phone">Phone Number</label>
                            <input type="text" id="phone" name="phone"
                                   placeholder="10-digit mobile" maxlength="10" required>
                        </div>

                        <!-- Hidden email from session -->
                        <input type="hidden" name="userEmail" value="<%= userEmail %>">

                        <!-- Card number -->
                        <div class="payment-field">
                            <label for="cardNumber">Card Number</label>
                            <input type="text" id="cardNumber" name="cardNumber"
                                   placeholder="XXXX XXXX XXXX XXXX"
                                   maxlength="19" required>
                           
                        </div>

                        <!-- CVV -->
                        <div class="payment-field">
                            <label for="cvv">CVV</label>
                            <input type="text" id="cvv" name="cvv"
                                   placeholder="3 digits" maxlength="3" required>
                        </div>

                        <!-- Expiry -->
                        <div class="payment-field">
                            <label for="expiry">Expiry (MM/YY)</label>
                            <input type="text" id="expiry" name="expiry"
                                   placeholder="MM/YY" maxlength="5" required>
                        </div>

                        <!-- Shipping address -->
                        <div class="payment-field full-width">
                            <label for="address">Shipping Address</label>
                            <input type="text" id="address" name="address"
                                   placeholder="Flat / Street / City / PIN" required>
                        </div>

                    </div>

                    <div class="payment-actions">
                        <button type="submit" class="primary-gradient-btn">
                            Get OTP
                        </button>
                    </div>
                </form>

            </div>
        </section>

    </main>

    <%@ include file="footer.jsp" %>

    <!--  Card & expiry formatting + validation -->
    <script>
    // Format card number as XXXX XXXX XXXX XXXX
    (function () {
        const cardInput = document.getElementById('cardNumber');
        if (cardInput) {
            cardInput.addEventListener('input', function (e) {
                let value = e.target.value.replace(/\D/g, '');
                let formatted = value.match(/.{1,4}/g);
                if (formatted) {
                    e.target.value = formatted.join(' ');
                } else {
                    e.target.value = value;
                }
            });
        }

        const expiryInput = document.getElementById('expiry');
        if (expiryInput) {
            expiryInput.addEventListener('input', function (e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length > 2) {
                    value = value.slice(0, 2) + '/' + value.slice(2, 4);
                }
                e.target.value = value;
            });
        }
    })();

    function validatePaymentForm() {
        const card = (document.getElementById("cardNumber").value || '').replace(/\s/g, '');
        const cvv  = (document.getElementById("cvv").value || '');
        const phone = (document.getElementById("phone").value || '');
        const expiry = (document.getElementById("expiry").value || '');

        if (!/^\d{16}$/.test(card)) {
            Swal.fire("Error", "Card number must be 16 digits.", "error");
            return false;
        }

        if (!/^\d{3}$/.test(cvv)) {
            Swal.fire("Error", "CVV must be 3 digits.", "error");
            return false;
        }

        if (!/^\d{10}$/.test(phone)) {
            Swal.fire("Error", "Phone number must be 10 digits.", "error");
            return false;
        }

        if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiry)) {
            Swal.fire("Error", "Expiry must be in MM/YY format (01–12).", "error");
            return false;
        }

        return true; // allow form submit to SendOTPServlet
    }
    </script>

</body>
</html>