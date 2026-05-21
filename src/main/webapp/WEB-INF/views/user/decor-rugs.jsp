<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title"          value="Decor &amp; Rugs — Kathmandu Furniture"/>
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
        <a href="${pageContext.request.contextPath}/user/products">Products</a> ›
        <span>Decor &amp; Rugs</span>
    </nav>

    <div class="cat-header">
        <div class="cat-icon-wrap"><i class="fa-solid fa-leaf"></i></div>
        <div class="cat-header-text">
            <h1 class="cat-title">Decor &amp; Rugs</h1>
            <p class="cat-subtitle">${totalCount} product${totalCount != 1 ? 's' : ''}</p>
        </div>
    </div>

    <form id="filterForm" method="get" action="${pageContext.request.contextPath}/user/decor">

        <div class="pf-topbar">
            <div class="pf-chips">
                <c:if test="${not empty search}">
                    <span class="pf-chip">Search: "<c:out value="${search}"/>" <a class="pf-chip-x" href="#" onclick="clearParam('search')">×</a></span>
                </c:if>
                <c:if test="${not empty availability}">
                    <span class="pf-chip"><c:out value="${availability}"/> <a class="pf-chip-x" href="#" onclick="clearParam('availability')">×</a></span>
                </c:if>
                <c:if test="${not empty minPrice or not empty maxPrice}">
                    <span class="pf-chip">
                        Rs.<c:out value="${not empty minPrice ? minPrice : '0'}"/> – Rs.<c:out value="${not empty maxPrice ? maxPrice : maxPriceDb}"/>
                        <a class="pf-chip-x" href="#" onclick="clearParam('minPrice');clearParam('maxPrice')">×</a>
                    </span>
                </c:if>
                <c:if test="${not empty search or not empty availability or not empty minPrice or not empty maxPrice}">
                    <a href="${pageContext.request.contextPath}/user/decor" class="pf-clear-all">Clear all</a>
                </c:if>
            </div>
            <button type="button" class="pf-mobile-toggle" onclick="document.getElementById('pfSidebar').classList.toggle('open')">
                <i class="fa-solid fa-sliders"></i> Filters
            </button>
        </div>

        <div class="pf-layout">
            <aside class="pf-sidebar" id="pfSidebar">
                <div class="pf-sidebar-inner">
                    <div class="pf-sidebar-head">
                        <span><i class="fa-solid fa-sliders"></i> Filters</span>
                        <button type="button" class="pf-close-btn" onclick="document.getElementById('pfSidebar').classList.remove('open')">
                            <i class="fa-solid fa-xmark"></i>
                        </button>
                    </div>
                    <div class="pf-group">
                        <div class="pf-group-label">Search</div>
                        <div class="pf-search-wrap">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" name="search" class="pf-search-input" placeholder="Search products..." value="${fn:escapeXml(search)}"/>
                        </div>
                    </div>
                    <div class="pf-group">
                        <div class="pf-group-label">Sort By</div>
                        <select name="sort" class="pf-select" onchange="document.getElementById('filterForm').submit()">
                            <option value=""           ${empty sort             ? 'selected' : ''}>Newest First</option>
                            <option value="price-asc"  ${sort == 'price-asc'   ? 'selected' : ''}>Price: Low to High</option>
                            <option value="price-desc" ${sort == 'price-desc'  ? 'selected' : ''}>Price: High to Low</option>
                            <option value="rating"     ${sort == 'rating'      ? 'selected' : ''}>Top Rated</option>
                        </select>
                    </div>
                    <div class="pf-group">
                        <div class="pf-group-label">Price Range (Rs.)</div>
                        <div class="pf-price-row">
                            <input type="number" name="minPrice" class="pf-price-input" placeholder="Min" min="0" value="${fn:escapeXml(minPrice)}"/>
                            <span class="pf-price-sep">—</span>
                            <input type="number" name="maxPrice" class="pf-price-input" placeholder="Max" min="0" value="${fn:escapeXml(maxPrice)}"/>
                        </div>
                    </div>
                    <div class="pf-group">
                        <div class="pf-group-label">Availability</div>
                        <div class="pf-check-group">
                            <label class="pf-check ${availability == 'In Stock' ? 'checked' : ''}">
                                <input type="radio" name="availability" value="In Stock" ${availability == 'In Stock' ? 'checked' : ''} onchange="this.form.submit()"/>
                                <span class="pf-dot avail-green"></span> In Stock
                            </label>
                            <label class="pf-check ${availability == 'Coming Soon' ? 'checked' : ''}">
                                <input type="radio" name="availability" value="Coming Soon" ${availability == 'Coming Soon' ? 'checked' : ''} onchange="this.form.submit()"/>
                                <span class="pf-dot avail-amber"></span> Coming Soon
                            </label>
                            <label class="pf-check ${availability == 'Out of Stock' ? 'checked' : ''}">
                                <input type="radio" name="availability" value="Out of Stock" ${availability == 'Out of Stock' ? 'checked' : ''} onchange="this.form.submit()"/>
                                <span class="pf-dot avail-red"></span> Out of Stock
                            </label>
                            <c:if test="${not empty availability}">
                                <label class="pf-check">
                                    <input type="radio" name="availability" value="" onchange="this.form.submit()"/> Clear
                                </label>
                            </c:if>
                        </div>
                    </div>
                    <div class="pf-actions">
                        <button type="submit" class="pf-apply-btn">Apply Filters</button>
                        <a href="${pageContext.request.contextPath}/user/decor" class="pf-reset-btn">Reset</a>
                    </div>
                </div>
            </aside>

            <div class="pf-main">
                <div class="pf-result-bar">
                    <span class="pf-count"><strong>${totalCount}</strong> product${totalCount != 1 ? 's' : ''}</span>
                </div>
                <div class="product-grid">
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="product" items="${products}">
                                <a class="product-card" href="${pageContext.request.contextPath}/user/product-details?id=${product.id}">
                                    <div class="card-image-wrap">
                                        <img src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(product.image)}"
                                             alt="${fn:escapeXml(product.productName)}"
                                             onerror="this.style.display='none';this.nextElementSibling.style.display='flex';"/>
                                        <div class="card-img-placeholder" style="display:none;"><i class="fa-solid fa-leaf"></i></div>
                                        <button class="favorite-btn" onclick="toggleFav(event,this)" aria-label="Add to wishlist">
                                            <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" stroke-width="1.5" stroke-linejoin="round"/></svg>
                                        </button>
                                    </div>
                                    <c:if test="${product.availability == 'Coming Soon'}"><div class="status-label coming-soon">Coming Soon</div></c:if>
                                    <c:if test="${product.status == 'New' && product.availability != 'Coming Soon'}"><div class="status-label just-in">Just In</div></c:if>
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
                        </c:when>
                        <c:otherwise>
                            <div class="products-empty">
                                <i class="fa-solid fa-box-open"></i>
                                <p>No products match your filters.</p>
                                <a href="${pageContext.request.contextPath}/user/decor" class="pf-reset-btn">Clear Filters</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp"/>
<script>
    function toggleFav(e, btn) { e.preventDefault(); e.stopPropagation(); btn.classList.toggle('active'); }
    document.querySelectorAll('.swatch[data-color]').forEach(function(s) { s.style.background = s.dataset.color; });
    function clearParam(name) {
        var form = document.getElementById('filterForm');
        form.querySelectorAll('[name="' + name + '"]').forEach(function(el) {
            if (el.type === 'radio' || el.type === 'checkbox') el.checked = false; else el.value = '';
        });
        form.submit();
    }
    document.addEventListener('click', function(e) {
        var sidebar = document.getElementById('pfSidebar');
        if (sidebar.classList.contains('open') && !sidebar.contains(e.target) && !e.target.closest('.pf-mobile-toggle'))
            sidebar.classList.remove('open');
    });
</script>
</body>
</html>
