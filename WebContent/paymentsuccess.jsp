<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Success - StudentBazaar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Main theme CSS -->
    <link rel="stylesheet" href="css/studentbazaar.css">

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="page-bg">

    <%@ include file="header.jsp" %>

    <main class="paymentsuccess-page-main">
        <section class="paymentsuccess-card-shell rainbow-frame">
            <div class="rainbow-inner paymentsuccess-card">
                <div class="paymentsuccess-icon">
                    ✓
                </div>
                <h1>Payment Successful</h1>
                <p class="paymentsuccess-text">
                    Thank you for shopping on StudentBazaar!  
                    Your order has been placed and a confirmation has been sent to your email.
                </p>
                <p class="paymentsuccess-note">
                    You’ll be redirected shortly to your dashboard to continue exploring deals.
                </p>

                <div class="paymentsuccess-fallback">
                    If you are not redirected, click
                    <a href="home.jsp">here to go to Home</a>.
                </div>
            </div>
        </section>
    </main>

    <%@ include file="footer.jsp" %>

    <!-- SweetAlert popup + redirect (same logic as before) -->
    <script>
        Swal.fire({
            title: 'Payment Successful!',
            text: 'Thank you for shopping on StudentBazaar!',
            icon: 'success',
            confirmButtonText: 'Continue Shopping'
        }).then(() => {
            // same redirect as your original code
            window.location.href = 'home.jsp'; // or buyproduct.jsp if you ever change it
        });
    </script>

</body>
</html>