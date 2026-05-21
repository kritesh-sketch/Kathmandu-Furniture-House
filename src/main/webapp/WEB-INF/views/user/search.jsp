<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title"          value="Search — Kathmandu Furniture"/>
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
        <span>Search Results</span>
    </nav>

    <div class="cat-header">
        <div class="cat-icon-wrap"><i class="fa-solid fa-magnifying-glass"></i></div>
        <div class="cat-header-text">
            <h1 class="cat-title">
                <c:choose>
                    <c:when test="${not empty query}">Results for "<c:out value="${query}"/>"</c:when>
                    <c:otherwise>Search Products</c:otherwise>
                </c:choose>
            </h1>
            <p class="cat-subtitle">
                <c:choose>
                    <c:when test="${not empty query}">
                        ${fn:length(results)} product${fn:length(results) != 1 ? 's' : ''} found
                    </c:when>
                    <c:otherwise>Enter a keyword to find products</c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>

    <%-- Inline search bar so users can refine without scrolling to the nav --%>
    <form method="get" action="${pageContext.request.contextPath}/user/search"
          style="display:flex;gap:10px;max-width:520px;margin:0 0 32px;">
        <input type="text" name="q" value="${fn:escapeXml(query)}"
               placeholder="Search products, materials, styles..."
               style="flex:1;padding:10px 16px;border:1.5px solid #e5e7eb;border-radius:8px;font-size:14px;outline:none;font-family:inherit;"/>
        <button type="submit"
                style="padding:10px 22px;background:#111827;color:#fff;border:none;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer;font-family:inherit;">
            Search
        </button>
    </form>

    <c:choose>
        <c:when test="${not empty results}">
            <div class="product-grid">
                <c:forEach var="product" items="${results}">
                    <a class="product-card" href="${pageContext.request.contextPath}/user/product-details?id=${product.id}">
                        <div class="card-image-wrap">
                            <img src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(product.image)}"
                                 alt="${fn:escapeXml(product.productName)}"
                                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex';"/>
                            <div class="card-img-placeholder" style="display:none;">
                                <i class="fa-solid fa-couch"></i>
                            </div>
                        </div>
                        <c:if test="${product.availability == 'Coming Soon'}">
                            <div class="status-label coming-soon">Coming Soon</div>
                        </c:if>
                        <c:if test="${product.status == 'New' && product.availability != 'Coming Soon'}">
                            <div class="status-label just-in">Just In</div>
                        </c:if>
                        <c:if test="${product.availability == 'Out of Stock'}">
                            <div class="status-label" style="background:#fee2e2;color:#dc2626;">Out of Stock</div>
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
                    </a>
                </c:forEach>
            </div>
        </c:when>
        <c:when test="${not empty query}">
            <div class="products-empty" style="padding:80px 0;">
                <i class="fa-solid fa-box-open" style="font-size:48px;color:#d1d5db;display:block;margin-bottom:16px;"></i>
                <h3 style="font-size:18px;color:#555;margin-bottom:8px;">No products found for "<c:out value="${query}"/>"</h3>
                <p style="color:#aaa;font-size:14px;margin-bottom:24px;">Try different keywords or browse all products.</p>
                <a href="${pageContext.request.contextPath}/user/products"
                   style="padding:12px 28px;background:#111;color:#fff;border-radius:6px;text-decoration:none;font-size:14px;font-weight:600;">
                    Browse All Products
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="products-empty" style="padding:80px 0;">
                <i class="fa-solid fa-magnifying-glass" style="font-size:48px;color:#d1d5db;display:block;margin-bottom:16px;"></i>
                <p style="color:#aaa;font-size:14px;">Type a keyword above to search.</p>
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
