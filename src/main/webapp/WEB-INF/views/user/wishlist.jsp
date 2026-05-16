<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="Wishlist — Kathmandu Furniture" />
    <jsp:param name="pageFolder" value="user" />
    <jsp:param name="currentCssFile" value="products" />
    <jsp:param name="headerCssFile" value="header" />
    <jsp:param name="footerCssFile" value="footer" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/global.css" />

<body>
<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<div class="products-page">

    <h1 style="font-size:22px;font-weight:700;color:#111;margin-bottom:32px;">
        My Wishlist (${fn:length(wishlistProducts)} item${fn:length(wishlistProducts) != 1 ? 's' : ''})
    </h1>

    <c:choose>
        <c:when test="${not empty wishlistProducts}">
            <div class="product-grid">
                <c:forEach var="product" items="${wishlistProducts}">
                    <div class="product-card" style="position:relative;">

                        <a href="${pageContext.request.contextPath}/user/product-details?id=${product.id}"
                           style="display:block;text-decoration:none;color:inherit;">
                            <div class="card-image-wrap">
                                <img src="${pageContext.request.contextPath}/static/images/products/${product.image}"
                                     alt="${fn:escapeXml(product.productName)}"
                                     onerror="this.src='${pageContext.request.contextPath}/static/images/placeholder.png'"/>
                            </div>
                        </a>

                        <%-- Remove from wishlist --%>
                        <form method="post" action="${pageContext.request.contextPath}/user/wishlist"
                              style="position:absolute;top:10px;right:10px;">
                            <input type="hidden" name="action" value="remove"/>
                            <input type="hidden" name="productId" value="${product.id}"/>
                            <button type="submit" class="favorite-btn active" title="Remove from wishlist">
                                <svg viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="1.5">
                                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                                </svg>
                            </button>
                        </form>

                        <c:if test="${not empty product.colors}">
                            <div class="color-swatches">
                                <c:forEach var="colorHex" items="${fn:split(product.colors, ',')}">
                                    <span class="swatch" data-color="${fn:trim(colorHex)}"></span>
                                </c:forEach>
                            </div>
                        </c:if>

                        <div class="product-name"><c:out value="${product.productName}"/></div>
                        <div class="product-category"><c:out value="${product.category}"/></div>
                        <div class="product-price">Rs. <c:out value="${product.price}"/></div>

                        <%-- Add to Cart from wishlist --%>
                        <form method="post" action="${pageContext.request.contextPath}/user/cart" style="margin-top:10px;">
                            <input type="hidden" name="action" value="add"/>
                            <input type="hidden" name="productId" value="${product.id}"/>
                            <input type="hidden" name="quantity" value="1"/>
                            <button type="submit"
                                    style="width:100%;padding:10px;background:#111;color:#fff;border:none;font-size:13px;font-weight:600;cursor:pointer;letter-spacing:0.04em;font-family:inherit;">
                                Add to Cart
                            </button>
                        </form>

                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="products-empty" style="padding:80px 0;text-align:center;">
                <svg viewBox="0 0 24 24" fill="none" stroke="#ccc" stroke-width="1.5"
                     style="width:48px;height:48px;display:block;margin:0 auto 16px;">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                </svg>
                <h3 style="font-size:18px;color:#555;margin-bottom:8px;">Your wishlist is empty</h3>
                <p style="color:#aaa;font-size:14px;margin-bottom:24px;">Save items you love and find them here.</p>
                <a href="${pageContext.request.contextPath}/user/products"
                   style="padding:12px 28px;background:#111;color:#fff;border-radius:3px;text-decoration:none;font-size:14px;font-weight:600;">
                    Browse Products
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp" />

<script>
    document.querySelectorAll('.swatch[data-color]').forEach(function(s) {
        s.style.background = s.dataset.color;
    });
</script>
</body>
</html>

