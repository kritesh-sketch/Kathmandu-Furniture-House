<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title"          value="Wishlist — Kathmandu Furniture"/>
    <jsp:param name="pageFolder"     value="user"/>
    <jsp:param name="currentCssFile" value="products"/>
    <jsp:param name="headerCssFile"  value="header"/>
    <jsp:param name="footerCssFile"  value="footer"/>
</jsp:include>
<body>
<jsp:include page="/WEB-INF/templates/user/header.jsp"/>

<div class="products-page">

    <nav class="cat-breadcrumb">
        <a href="${pageContext.request.contextPath}/user/home">Home</a> ›
        <span>My Wishlist</span>
    </nav>

    <div class="cat-header">
        <div class="cat-icon-wrap"><i class="fa-solid fa-heart"></i></div>
        <div class="cat-header-text">
            <h1 class="cat-title">My Wishlist</h1>
            <p class="cat-subtitle">${fn:length(wishlistProducts)} item${fn:length(wishlistProducts) != 1 ? 's' : ''}</p>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty wishlistProducts}">
            <div class="product-grid">
                <c:forEach var="product" items="${wishlistProducts}">
                    <div class="product-card" style="position:relative;">

                        <a href="${pageContext.request.contextPath}/user/product-details?id=${product.id}"
                           style="display:block;text-decoration:none;color:inherit;">
                            <div class="card-image-wrap">
                                <img src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(product.image)}"
                                     alt="${fn:escapeXml(product.productName)}"
                                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex';"/>
                                <div class="card-img-placeholder" style="display:none;"><i class="fa-solid fa-heart"></i></div>
                            </div>
                        </a>

                        <c:if test="${product.availability == 'Coming Soon'}">
                            <div class="status-label coming-soon">Coming Soon</div>
                        </c:if>
                        <c:if test="${product.status == 'New' && product.availability != 'Coming Soon'}">
                            <div class="status-label just-in">Just In</div>
                        </c:if>

                        <c:if test="${not empty product.colors}">
                            <div class="color-swatches">
                                <c:forEach var="col" items="${fn:split(product.colors, ',')}">
                                    <span class="swatch" data-color="${fn:trim(col)}"></span>
                                </c:forEach>
                            </div>
                        </c:if>

                        <div class="product-name"><c:out value="${product.productName}"/></div>
                        <div class="product-category"><c:out value="${product.category}"/></div>
                        <div class="product-price">Rs. <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></div>

                        <div style="display:flex;gap:8px;margin-top:10px;padding:0 4px 4px;">
                            <form method="post" action="${pageContext.request.contextPath}/user/cart" style="flex:1;">
                                <input type="hidden" name="action"    value="add"/>
                                <input type="hidden" name="productId" value="${product.id}"/>
                                <input type="hidden" name="quantity"  value="1"/>
                                <button type="submit" class="wl-cart-btn">Add to Cart</button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/user/wishlist">
                                <input type="hidden" name="action"    value="remove"/>
                                <input type="hidden" name="productId" value="${product.id}"/>
                                <button type="submit" class="wl-remove-btn" title="Remove from wishlist">
                                    <i class="fa-solid fa-heart-crack"></i>
                                </button>
                            </form>
                        </div>

                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="products-empty" style="padding:80px 0;">
                <i class="fa-regular fa-heart" style="font-size:48px;color:#d1d5db;display:block;margin-bottom:16px;"></i>
                <h3 style="font-size:18px;color:#555;margin-bottom:8px;">Your wishlist is empty</h3>
                <p style="color:#aaa;font-size:14px;margin-bottom:24px;">Save items you love and find them here.</p>
                <a href="${pageContext.request.contextPath}/user/products"
                   style="padding:12px 28px;background:#111;color:#fff;border-radius:6px;text-decoration:none;font-size:14px;font-weight:600;">
                    Browse Products
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp"/>
<script>
    document.querySelectorAll('.swatch[data-color]').forEach(function(s) {
        s.style.background = s.dataset.color;
    });
</script>
</body>
</html>
