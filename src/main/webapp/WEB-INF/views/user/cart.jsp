<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="Cart — Kathmandu Furniture" />
    <jsp:param name="pageFolder" value="user" />
    <jsp:param name="currentCssFile" value="cart" />
    <jsp:param name="headerCssFile" value="header" />
    <jsp:param name="footerCssFile" value="footer" />
</jsp:include>

<body>
<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<div class="cart-page">

    <%-- Progress Stepper --%>
    <div class="cart-stepper">
        <div class="step active">
            <div class="step-circle">1</div>
            <span>Cart</span>
        </div>
        <div class="step-line"></div>
        <div class="step">
            <div class="step-circle">2</div>
            <span>Checkout</span>
        </div>
        <div class="step-line"></div>
        <div class="step">
            <div class="step-circle">3</div>
            <span>Payment</span>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="cart-layout">

                <%-- Left: Cart Items --%>
                <div class="cart-items-section">
                    <div class="cart-items-header">
                        <h2 class="cart-section-title">
                            Shopping Cart
                            <span class="cart-count">${fn:length(cartItems)} item${fn:length(cartItems) != 1 ? 's' : ''}</span>
                        </h2>
                    </div>

                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-item">
                            <a href="${pageContext.request.contextPath}/user/product-details?id=${item.product.id}" class="cart-item-img-wrap">
                                <img src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(item.product.image)}"
                                     alt="${fn:escapeXml(item.product.productName)}" />
                            </a>

                            <div class="cart-item-body">
                                <div class="cart-item-top">
                                    <div class="cart-item-meta">
                                        <a class="cart-item-name" href="${pageContext.request.contextPath}/user/product-details?id=${item.product.id}">
                                            <c:out value="${item.product.productName}"/>
                                        </a>
                                        <span class="cart-item-cat"><c:out value="${item.product.category}"/></span>
                                    </div>
                                    <div class="cart-item-price-block">
                                        <span class="cart-item-subtotal">Rs. <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></span>
                                        <span class="cart-item-unit">Rs. <fmt:formatNumber value="${item.product.price}" pattern="#,##0.00"/> each</span>
                                    </div>
                                </div>

                                <div class="cart-item-bottom">
                                    <%-- Quantity stepper --%>
                                    <form class="cart-qty-form" method="post" action="${pageContext.request.contextPath}/user/cart">
                                        <input type="hidden" name="action"    value="update"/>
                                        <input type="hidden" name="productId" value="${item.product.id}"/>
                                        <div class="cart-qty-row">
                                            <button type="submit" name="quantity" value="${item.quantity - 1}" class="cart-qty-btn" title="Decrease">−</button>
                                            <span class="cart-qty-display">${item.quantity}</span>
                                            <button type="submit" name="quantity" value="${item.quantity + 1}" class="cart-qty-btn" title="Increase">+</button>
                                        </div>
                                    </form>

                                    <%-- Remove --%>
                                    <form method="post" action="${pageContext.request.contextPath}/user/cart">
                                        <input type="hidden" name="action"    value="remove"/>
                                        <input type="hidden" name="productId" value="${item.product.id}"/>
                                        <button type="submit" class="cart-icon-btn" title="Remove item">
                                            <i class="fa-regular fa-trash-can"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <%-- Right: Order Summary --%>
                <div class="cart-summary">
                    <h3 class="summary-title">Order Summary</h3>

                    <div class="summary-rows">
                        <div class="summary-row">
                            <span>Sub Total</span>
                            <span>Rs. <fmt:formatNumber value="${cartTotal}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="summary-row">
                            <span>Discount</span>
                            <span>Rs. 0.00</span>
                        </div>
                        <div class="summary-row">
                            <span>Tax (VAT 13%)</span>
                            <span>Rs. <fmt:formatNumber value="${cartTotal * 0.13}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="summary-row">
                            <span>Shipping</span>
                            <span class="free-label">Free</span>
                        </div>
                    </div>

                    <div class="summary-total">
                        <span>Total</span>
                        <span>Rs. <fmt:formatNumber value="${cartTotal + cartTotal * 0.13}" pattern="#,##0.00"/></span>
                    </div>

                    <a class="cart-checkout-btn" href="${pageContext.request.contextPath}/user/checkout">
                        Proceed to Checkout
                    </a>

                    <div class="summary-delivery">
                        <i class="fa-solid fa-truck-fast"></i>
                        Estimated Delivery: 3–7 Business Days
                    </div>

                    <div class="coupon-section">
                        <p class="coupon-label">Have a Coupon?</p>
                        <div class="coupon-row">
                            <input type="text" class="coupon-input" placeholder="Enter coupon code" />
                            <button class="coupon-apply-btn">Apply</button>
                        </div>
                    </div>
                </div>

            </div>

            <a class="cart-continue" href="${pageContext.request.contextPath}/user/products">← Continue Shopping</a>

        </c:when>
        <c:otherwise>
            <div class="cart-empty">
                <svg viewBox="0 0 24 24" stroke-width="1.5">
                    <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                    <line x1="3" y1="6" x2="21" y2="6"/>
                    <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
                <h3>Your cart is empty</h3>
                <p>Looks like you haven't added anything yet.</p>
                <a href="${pageContext.request.contextPath}/user/products">Shop Now</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp" />
</body>
</html>
