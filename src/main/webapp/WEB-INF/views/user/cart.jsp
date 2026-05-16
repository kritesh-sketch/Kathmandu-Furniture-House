<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="Cart — Kathmandu Furniture" />
    <jsp:param name="pageFolder" value="user" />
    <jsp:param name="currentCssFile" value="cart" />
    <jsp:param name="headerCssFile" value="header" />
    <jsp:param name="footerCssFile" value="footer" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/global.css" />

<body>
<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<div class="cart-page">
    <h1 class="cart-title">Your Cart (${fn:length(cartItems)} item${fn:length(cartItems) != 1 ? 's' : ''})</h1>

    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="cart-layout">

                <%-- Cart Items --%>
                <div class="cart-items">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-item">
                            <a href="${pageContext.request.contextPath}/user/product-details?id=${item.product.id}" class="cart-item-img">
                                <img src="${pageContext.request.contextPath}/static/images/products/${item.product.image}"
                                     alt="${fn:escapeXml(item.product.productName)}"
                                     onerror="this.src='${pageContext.request.contextPath}/static/images/placeholder.png'"/>
                            </a>

                            <div class="cart-item-info">
                                <a class="cart-item-name" href="${pageContext.request.contextPath}/user/product-details?id=${item.product.id}">
                                    <c:out value="${item.product.productName}"/>
                                </a>
                                <span class="cart-item-cat"><c:out value="${item.product.category}"/></span>
                                <span class="cart-item-price">Rs. <c:out value="${item.product.price}"/> each</span>
                            </div>

                            <div class="cart-item-actions">
                                <%-- Quantity update --%>
                                <form class="cart-qty-form" method="post" action="${pageContext.request.contextPath}/user/cart">
                                    <input type="hidden" name="action" value="update"/>
                                    <input type="hidden" name="productId" value="${item.product.id}"/>
                                    <div class="cart-qty-row">
                                        <button type="submit" name="quantity" value="${item.quantity - 1}" class="cart-qty-btn">−</button>
                                        <span class="cart-qty-display">${item.quantity}</span>
                                        <button type="submit" name="quantity" value="${item.quantity + 1}" class="cart-qty-btn">+</button>
                                    </div>
                                </form>
                                <%-- Remove --%>
                                <form method="post" action="${pageContext.request.contextPath}/user/cart">
                                    <input type="hidden" name="action" value="remove"/>
                                    <input type="hidden" name="productId" value="${item.product.id}"/>
                                    <button type="submit" class="cart-remove-btn">Remove</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <%-- Order Summary --%>
                <div class="cart-summary">
                    <h3>Order Summary</h3>
                    <c:forEach var="item" items="${cartItems}">
                        <div class="summary-row">
                            <span><c:out value="${item.product.productName}"/> × ${item.quantity}</span>
                            <span>Rs. <c:out value="${item.subtotal}"/></span>
                        </div>
                    </c:forEach>
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span style="color:#2e7d32;font-weight:600;">Free</span>
                    </div>
                    <div class="summary-row total">
                        <span>Total</span>
                        <span>Rs. <c:out value="${cartTotal}"/></span>
                    </div>
                    <button class="cart-checkout-btn" type="button">Proceed to Checkout</button>
                    <a class="cart-continue" href="${pageContext.request.contextPath}/user/products">← Continue Shopping</a>
                </div>

            </div>
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

