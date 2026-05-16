<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="${product.productName} — Kathmandu Furniture" />
    <jsp:param name="pageFolder" value="user" />
    <jsp:param name="currentCssFile" value="product-details" />
    <jsp:param name="headerCssFile" value="header" />
    <jsp:param name="footerCssFile" value="footer" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/global.css" />

<body>
<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<div class="pd-page">

    <%-- Breadcrumb --%>
    <nav class="pd-breadcrumb">
        <a href="${pageContext.request.contextPath}/user/home">Home</a>
        <span>›</span>
        <a href="${pageContext.request.contextPath}/user/products">Products</a>
        <c:if test="${not empty product.category}">
            <span>›</span>
            <c:choose>
                <c:when test="${product.category == 'Sofas & Seating'}">
                    <a href="${pageContext.request.contextPath}/user/sofas"><c:out value="${product.category}"/></a>
                </c:when>
                <c:when test="${product.category == 'Beds & Mattresses'}">
                    <a href="${pageContext.request.contextPath}/user/beds"><c:out value="${product.category}"/></a>
                </c:when>
                <c:when test="${product.category == 'Tables & Desks'}">
                    <a href="${pageContext.request.contextPath}/user/tables"><c:out value="${product.category}"/></a>
                </c:when>
                <c:when test="${product.category == 'Chairs & Stools'}">
                    <a href="${pageContext.request.contextPath}/user/chairs"><c:out value="${product.category}"/></a>
                </c:when>
                <c:when test="${product.category == 'Decor & Rugs'}">
                    <a href="${pageContext.request.contextPath}/user/decor"><c:out value="${product.category}"/></a>
                </c:when>
                <c:when test="${product.category == 'Storage & Cabinets'}">
                    <a href="${pageContext.request.contextPath}/user/storage"><c:out value="${product.category}"/></a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/user/products"><c:out value="${product.category}"/></a>
                </c:otherwise>
            </c:choose>
        </c:if>
        <span>›</span>
        <span style="color:#333;"><c:out value="${product.productName}"/></span>
    </nav>

    <div class="pd-layout">

        <%-- Left: Product Image --%>
        <div class="pd-image-wrap">
            <img src="${pageContext.request.contextPath}/static/images/products/${product.image}"
                 alt="${fn:escapeXml(product.productName)}"
                 onerror="this.src='${pageContext.request.contextPath}/static/images/placeholder.png'" />
        </div>

        <%-- Right: Product Info --%>
        <div class="pd-info">

            <div class="pd-category"><c:out value="${product.category}"/></div>
            <h1 class="pd-name"><c:out value="${product.productName}"/></h1>
            <div class="pd-price">Rs. <c:out value="${product.price}"/></div>

            <%-- Availability badge --%>
            <div>
                <c:choose>
                    <c:when test="${product.availability == 'Coming Soon'}">
                        <span class="pd-badge coming-soon">Coming Soon</span>
                    </c:when>
                    <c:when test="${product.availability == 'Out of Stock'}">
                        <span class="pd-badge out-of-stock">Out of Stock</span>
                    </c:when>
                    <c:otherwise>
                        <span class="pd-badge in-stock">In Stock</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="pd-divider"></div>

            <%-- Color swatches --%>
            <c:if test="${not empty product.colors}">
                <div>
                    <div class="pd-swatch-label">Colour</div>
                    <div class="pd-swatches">
                        <c:forEach var="colorHex" items="${fn:split(product.colors, ',')}">
                            <button class="pd-swatch" data-color="${fn:trim(colorHex)}"
                                    title="${fn:trim(colorHex)}" onclick="selectSwatch(this)"></button>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <%-- Specifications --%>
            <c:if test="${not empty product.specifications}">
                <div>
                    <div class="pd-specs-label">Description</div>
                    <div class="pd-specs-text"><c:out value="${product.specifications}"/></div>
                </div>
            </c:if>

            <div class="pd-divider"></div>

            <%-- Add to Cart --%>
            <div class="pd-actions">
                <form method="post" action="${pageContext.request.contextPath}/user/product-details">
                    <input type="hidden" name="action" value="addToCart" />
                    <input type="hidden" name="productId" value="${product.id}" />
                    <div class="pd-qty-row" style="margin-bottom:12px;">
                        <button type="button" class="pd-qty-btn" onclick="changeQty(-1)">−</button>
                        <input class="pd-qty-input" type="number" id="qtyInput" name="quantity"
                               value="1" min="1" max="99" />
                        <button type="button" class="pd-qty-btn" onclick="changeQty(1)">+</button>
                    </div>
                    <button type="submit" class="pd-add-cart"
                            ${product.availability == 'Coming Soon' || product.availability == 'Out of Stock' ? 'disabled style="opacity:0.5;cursor:not-allowed;"' : ''}>
                        Add to Cart
                    </button>
                </form>

                <%-- Wishlist toggle --%>
                <form method="post" action="${pageContext.request.contextPath}/user/product-details">
                    <input type="hidden" name="action" value="toggleWishlist" />
                    <input type="hidden" name="productId" value="${product.id}" />
                    <button type="submit" class="pd-wishlist-btn ${inWishlist ? 'active' : ''}">
                        <svg viewBox="0 0 24 24" fill="${inWishlist ? 'currentColor' : 'none'}"
                             stroke="currentColor" stroke-width="1.8" stroke-linejoin="round">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                        </svg>
                        ${inWishlist ? 'Remove from Wishlist' : 'Add to Wishlist'}
                    </button>
                </form>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp" />

<script>
    document.querySelectorAll('.pd-swatch[data-color]').forEach(function(s) {
        s.style.background = s.dataset.color;
    });
    function selectSwatch(btn) {
        document.querySelectorAll('.pd-swatch').forEach(function(s) { s.classList.remove('selected'); });
        btn.classList.add('selected');
    }
    function changeQty(delta) {
        var input = document.getElementById('qtyInput');
        var val = parseInt(input.value) + delta;
        if (val < 1) val = 1;
        if (val > 99) val = 99;
        input.value = val;
    }
</script>
</body>
</html>

