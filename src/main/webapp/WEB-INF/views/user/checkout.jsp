<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title"          value="Checkout — Kathmandu Furniture" />
    <jsp:param name="pageFolder"     value="user" />
    <jsp:param name="currentCssFile" value="checkout" />
    <jsp:param name="headerCssFile"  value="header" />
    <jsp:param name="footerCssFile"  value="footer" />
</jsp:include>

<body>
<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<div class="co-page">

    <nav class="co-breadcrumb">
        <a href="${pageContext.request.contextPath}/user/home">Home</a>
        <span>›</span>
        <a href="${pageContext.request.contextPath}/user/cart">Cart</a>
        <span>›</span>
        <span>Checkout</span>
    </nav>

    <h1 class="co-title">Checkout</h1>

    <c:if test="${param.error == 'true'}">
        <div class="co-alert co-alert--error">Something went wrong placing your order. Please try again.</div>
    </c:if>

    <div class="co-layout">

        <%-- LEFT: Delivery form --%>
        <div class="co-form-wrap">
            <form method="post" action="${pageContext.request.contextPath}/user/checkout" id="checkoutForm">

                <section class="co-section">
                    <h2 class="co-section-title">Delivery Details</h2>
                    <div class="co-grid">
                        <div class="co-field co-field--full">
                            <label>Full Name <span class="co-req">*</span></label>
                            <input type="text" name="fullName" required placeholder="Your full name" />
                        </div>
                        <div class="co-field">
                            <label>Phone Number <span class="co-req">*</span></label>
                            <input type="tel" name="phoneNumber" required placeholder="98XXXXXXXX" />
                        </div>
                        <div class="co-field co-field--full">
                            <label>Delivery Address <span class="co-req">*</span></label>
                            <input type="text" name="deliveryLocation" required placeholder="Street, City, District" />
                        </div>
                    </div>
                </section>

                <section class="co-section">
                    <h2 class="co-section-title">Payment Method</h2>
                    <div class="co-payment-options">
                        <label class="co-payment-option">
                            <input type="radio" name="paymentMethod" value="Cash on Delivery" checked />
                            <div class="co-payment-card">
                                <i class="fa-solid fa-money-bill-wave"></i>
                                <span>Cash on Delivery</span>
                            </div>
                        </label>
                        <label class="co-payment-option">
                            <input type="radio" name="paymentMethod" value="eSewa" />
                            <div class="co-payment-card">
                                <i class="fa-solid fa-mobile-screen"></i>
                                <span>eSewa</span>
                            </div>
                        </label>
                        <label class="co-payment-option">
                            <input type="radio" name="paymentMethod" value="Khalti" />
                            <div class="co-payment-card">
                                <i class="fa-solid fa-wallet"></i>
                                <span>Khalti</span>
                            </div>
                        </label>
                        <label class="co-payment-option">
                            <input type="radio" name="paymentMethod" value="Bank Transfer" />
                            <div class="co-payment-card">
                                <i class="fa-solid fa-building-columns"></i>
                                <span>Bank Transfer</span>
                            </div>
                        </label>
                    </div>
                </section>

            </form>
        </div>

        <%-- RIGHT: Order summary + Place Order --%>
        <div class="co-summary">
            <h2 class="co-section-title">Order Summary</h2>

            <div class="co-summary-items">
                <c:forEach var="item" items="${cartItems}">
                    <div class="co-summary-item">
                        <img src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(item.product.image)}"
                             alt="${fn:escapeXml(item.product.productName)}"
                        <div class="co-summary-item-info">
                            <span class="co-summary-item-name"><c:out value="${item.product.productName}"/></span>
                            <span class="co-summary-item-qty">Qty: ${item.quantity}</span>
                        </div>
                        <span class="co-summary-item-price">
                            Rs. <fmt:formatNumber value="${item.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                        </span>
                    </div>
                </c:forEach>
            </div>

            <div class="co-summary-totals">
                <div class="co-total-row">
                    <span>Subtotal</span>
                    <span>Rs. <fmt:formatNumber value="${cartTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>
                <div class="co-total-row">
                    <span>Shipping</span>
                    <span class="co-free">Free</span>
                </div>
                <div class="co-total-row co-total-row--grand">
                    <span>Total</span>
                    <span>Rs. <fmt:formatNumber value="${cartTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>
            </div>

            <button type="submit" form="checkoutForm" class="co-place-order-btn">
                Place Order
            </button>
            <a class="co-back-link" href="${pageContext.request.contextPath}/user/cart">← Back to Cart</a>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp" />

<script>
    document.querySelectorAll('.co-payment-option input').forEach(function(radio) {
        radio.addEventListener('change', function() {
            document.querySelectorAll('.co-payment-card').forEach(function(c) { c.classList.remove('selected'); });
            this.closest('.co-payment-option').querySelector('.co-payment-card').classList.add('selected');
        });
    });
    document.querySelector('.co-payment-option input:checked')
        .closest('.co-payment-option').querySelector('.co-payment-card').classList.add('selected');
</script>
</body>
</html>
