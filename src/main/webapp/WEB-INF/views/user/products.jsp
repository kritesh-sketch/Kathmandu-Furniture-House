<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="Kathmandu Furniture - Products" />
    <jsp:param name="pageFolder" value="user" />
    <jsp:param name="currentCssFile" value="products" />
    <jsp:param name="headerCssFile" value="header" />
    <jsp:param name="footerCssFile" value="footer" />
</jsp:include>

<!-- Custom styling for this page -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/header.css>
<style>
    main {
        padding: 40px 48px;
    }
    @media (max-width: 900px) {
        main {
            padding: 24px;
        }
    }
</style>

<body>

<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<main>
    <div class="product-grid">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach var="product" items="${products}">
                    <a class="product-card" href="product-details?id=${product.id}">
                        <div class="card-image-wrap">
                            <img src="${pageContext.request.contextPath}/static/images/products/${product.image}" alt="${product.productName}">
                        </div>

                        <%-- Logic for status labels --%>
                        <c:if test="${product.status == 'New' || product.availability == 'Coming Soon'}">
                            <div class="status-label ${product.availability == 'Coming Soon' ? 'coming-soon' : 'just-in'}">
                                ${product.availability == 'Coming Soon' ? 'Coming Soon' : 'Just In'}
                            </div>
                        </c:if>

                        <div class="product-name">${product.productName}</div>
                        <div class="product-category">${product.availability}</div>
                        <div class="product-price">$${product.price}</div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>No products found.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pagination Dot Demo -->
    <div class="pagination">
        <button class="page-dot active"></button>
        <button class="page-dot"></button>
        <button class="page-dot"></button>
    </div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp" />
</main>
</body>
</html>
