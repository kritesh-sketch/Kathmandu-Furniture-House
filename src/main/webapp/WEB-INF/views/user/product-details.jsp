<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            <img src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(product.image)}"
                 alt="${fn:escapeXml(product.productName)}"
                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex';" />
            <div class="pd-img-placeholder" style="display:none;">
                <i class="fa-solid fa-couch"></i>
                <span><c:out value="${product.productName}"/></span>
            </div>
        </div>

        <%-- Right: Product Info --%>
        <div class="pd-info">

            <div class="pd-category"><c:out value="${product.category}"/></div>
            <h1 class="pd-name"><c:out value="${product.productName}"/></h1>

            <div class="pd-price">Rs. <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></div>

            <c:if test="${not empty product.description}">
                <p class="pd-description"><c:out value="${product.description}"/></p>
            </c:if>

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

            <%-- Dimensions: L / B / H spec boxes --%>
            <c:if test="${not empty product.dimensions}">
                <c:set var="dims" value="${fn:split(product.dimensions, '|')}"/>
                <div class="pd-dim-grid">
                    <div class="pd-dim-box">
                        <div class="pd-dim-lbl">Length</div>
                        <div class="pd-dim-val">${fn:length(dims) > 0 ? dims[0] : '—'} <span class="pd-dim-unit">cm</span></div>
                    </div>
                    <div class="pd-dim-box">
                        <div class="pd-dim-lbl">Breadth</div>
                        <div class="pd-dim-val">${fn:length(dims) > 1 ? dims[1] : '—'} <span class="pd-dim-unit">cm</span></div>
                    </div>
                    <div class="pd-dim-box">
                        <div class="pd-dim-lbl">Height</div>
                        <div class="pd-dim-val">${fn:length(dims) > 2 ? dims[2] : '—'} <span class="pd-dim-unit">cm</span></div>
                    </div>
                </div>
            </c:if>

            <div class="pd-divider"></div>

            <%-- Quantity + Actions --%>
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <%-- Logged-in: full actions --%>
                    <div class="pd-actions">
                        <div class="pd-qty-row">
                            <button type="button" class="pd-qty-btn" onclick="changeQty(-1)">−</button>
                            <input class="pd-qty-input" type="number" id="qtyDisplay" value="1" min="1" max="99" />
                            <button type="button" class="pd-qty-btn" onclick="changeQty(1)">+</button>
                        </div>
                        <div class="pd-btn-row">
                            <form method="post" action="${pageContext.request.contextPath}/user/product-details">
                                <input type="hidden" name="action" value="addToCart" />
                                <input type="hidden" name="productId" value="${product.id}" />
                                <input type="hidden" name="quantity" id="qtyHidden" value="1" />
                                <button type="submit" class="pd-add-cart"
                                        ${product.availability == 'Coming Soon' || product.availability == 'Out of Stock' ? 'disabled style="opacity:0.5;cursor:not-allowed;"' : ''}>
                                    Add to Cart
                                </button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/user/product-details">
                                <input type="hidden" name="action" value="toggleWishlist" />
                                <input type="hidden" name="productId" value="${product.id}" />
                                <button type="submit" class="pd-wishlist-btn ${inWishlist ? 'active' : ''}">
                                    <svg viewBox="0 0 24 24" fill="${inWishlist ? 'currentColor' : 'none'}"
                                         stroke="currentColor" stroke-width="1.8" stroke-linejoin="round">
                                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                                    </svg>
                                    Wishlist
                                </button>
                            </form>
                        </div>
                        <c:if test="${product.availability == 'Out of Stock' || product.availability == 'Coming Soon'}">
                            <a href="${pageContext.request.contextPath}/user/request?productId=${product.id}"
                               class="pd-request-btn">
                                <i class="fa-solid fa-pen-ruler"></i> Request This Item
                            </a>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <%-- Guest: sign-in prompt --%>
                    <div class="pd-signin-prompt">
                        <p>Sign in to add this item to your cart, save to wishlist, or make a custom request.</p>
                        <a href="${pageContext.request.contextPath}/login" class="pd-add-cart"
                           style="display:block;text-align:center;text-decoration:none;padding:15px;">
                            Sign In to Purchase
                        </a>
                        <a href="${pageContext.request.contextPath}/user/join-us" class="pd-request-btn"
                           style="margin-top:8px;">
                            Create an Account
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

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
        var display = document.getElementById('qtyDisplay');
        var val = parseInt(display.value) + delta;
        if (val < 1) val = 1;
        if (val > 99) val = 99;
        display.value = val;
        document.getElementById('qtyHidden').value = val;
    }
    function toggleAcc(header) {
        var body  = header.nextElementSibling;
        var arrow = header.querySelector('.pd-acc-arrow');
        var isOpen = body.classList.toggle('open');
        arrow.style.transform = isOpen ? 'rotate(180deg)' : 'rotate(0deg)';
    }
    // initialise arrows for already-open panels
    document.querySelectorAll('.pd-acc-body.open').forEach(function(b) {
        b.previousElementSibling.querySelector('.pd-acc-arrow').style.transform = 'rotate(180deg)';
    });

</script>
</body>
</html>

