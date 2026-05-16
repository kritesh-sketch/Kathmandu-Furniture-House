<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="Decor &amp; Rugs — Kathmandu Furniture" />
    <jsp:param name="pageFolder" value="user" />
    <jsp:param name="currentCssFile" value="products" />
    <jsp:param name="headerCssFile" value="header" />
    <jsp:param name="footerCssFile" value="footer" />
</jsp:include>
<body>
<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<div class="products-page">
<div class="product-grid">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach var="product" items="${products}">
                    <a class="product-card" href="${pageContext.request.contextPath}/user/product-details?id=${product.id}">
                        <div class="card-image-wrap">
                            <img src="${pageContext.request.contextPath}/static/images/products/${product.image}"
                                 alt="${fn:escapeXml(product.productName)}"
                                 onerror="this.src='${pageContext.request.contextPath}/static/images/placeholder.png'"/>
                            <button class="favorite-btn" onclick="toggleFav(event,this)" aria-label="Add to wishlist">
                                <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" stroke-width="1.5" stroke-linejoin="round"/></svg>
                            </button>
                        </div>
                        <c:if test="${product.availability == 'Coming Soon'}"><div class="status-label coming-soon">Coming Soon</div></c:if>
                        <c:if test="${product.status == 'New' && product.availability != 'Coming Soon'}"><div class="status-label just-in">Just In</div></c:if>
                        <c:if test="${not empty product.colors}">
                            <div class="color-swatches">
                                <c:forEach var="c" items="${fn:split(product.colors, ',')}">
                                    <span class="swatch" data-color="${fn:trim(c)}"></span>
                                </c:forEach>
                            </div>
                        </c:if>
                        <div class="product-name"><c:out value="${product.productName}"/></div>
                        <div class="product-category"><c:out value="${product.category}"/></div>
                        <div class="product-price">Rs. <c:out value="${product.price}"/></div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="products-empty">No products found in Decor &amp; Rugs.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp" />
<script>
    function toggleFav(e,btn){e.preventDefault();e.stopPropagation();btn.classList.toggle('active');}
    document.querySelectorAll('.swatch[data-color]').forEach(function(s){s.style.background=s.dataset.color;});
</script>
</body>
</html>

