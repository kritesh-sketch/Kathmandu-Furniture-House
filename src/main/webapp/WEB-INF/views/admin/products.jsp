<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Products — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/products.css" />
</head>

<body>
  <div class="admin-layout">
    <jsp:include page="../../templates/admin/sidebar.jsp">
      <jsp:param name="activePage" value="products"/>
    </jsp:include>

    <!-- ── Main content ── -->
    <main class="main-content">

      <!-- Topbar -->
      <header class="topbar">
        <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
          <button class="hamburger-btn" id="hamburgerBtn">
            <i class="fa-solid fa-bars"></i>
          </button>
          <div>
            <h2>Products</h2>
            <p>Browse and manage all products in the catalogue.</p>
          </div>
        </div>
      </header>

      <%-- Build export URL preserving current filters --%>
      <c:url var="exportUrl" value="${pageContext.request.contextPath}/admin/products">
        <c:param name="export"   value="csv"/>
        <c:param name="search"   value="${search}"/>
        <c:param name="category" value="${category}"/>
      </c:url>

      <!-- Controls row — GET form for server-side filter/search -->
      <div class="controls-row">
        <form method="get" action="${pageContext.request.contextPath}/admin/products"
              style="display:contents;">

          <select name="category" class="filter-select" onchange="this.form.submit()">
            <option value="all" ${category == 'all' ? 'selected' : ''}>All Categories</option>
            <c:forEach var="cat" items="${categories}">
              <option value="${fn:escapeXml(cat)}"
                      ${category == cat ? 'selected' : ''}><c:out value="${cat}"/></option>
            </c:forEach>
          </select>

          <div class="search-wrap">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" name="search" class="search-input"
                   placeholder="Search products…" value="${fn:escapeXml(search)}" />
            <button type="submit" class="search-btn" title="Search">
              <i class="fa-solid fa-magnifying-glass"></i>
            </button>
          </div>
        </form>

        <a href="${exportUrl}" class="export-btn">
          <i class="fa-solid fa-file-csv"></i> Export CSV
          <i class="fa-solid fa-arrow-down" style="font-size:10px;"></i>
        </a>
        <a href="${pageContext.request.contextPath}/admin/product-form" class="add-product-btn">
          <i class="fa-solid fa-plus"></i> Add Product
        </a>
      </div>

      <!-- Table panel -->
      <div class="panel">
        <div class="table-wrap">
          <table class="products-table">
            <colgroup>
              <col class="col-no" />
              <col class="col-product" />
              <col class="col-price" />
              <col class="col-colors" />
              <col class="col-rating" />
              <col class="col-avail" />
              <col class="col-status" />
              <col class="col-action" />
            </colgroup>
            <thead>
              <tr>
                <th>No</th>
                <th class="th-product">Product</th>
                <th>Price</th>
                <th>Colors</th>
                <th>Rating</th>
                <th>Availability</th>
                <th>Status</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty products}">
                  <c:forEach var="p" items="${products}" varStatus="s">
                    <tr>
                      <td class="col-no">${startIndex + s.index + 1}</td>
                      <td class="td-product">
                        <div class="prod-cell">
                          <c:choose>
                            <c:when test="${not empty p.image}">
                              <img class="prod-thumb"
                                   src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(p.image)}"
                                   alt="${fn:escapeXml(p.productName)}"
                                   onerror="this.style.display='none';this.nextElementSibling.style.display='flex';" />
                              <div class="prod-thumb-placeholder" style="display:none;">
                                <i class="fa-regular fa-image"></i>
                              </div>
                            </c:when>
                            <c:otherwise>
                              <div class="prod-thumb-placeholder">
                                <i class="fa-regular fa-image"></i>
                              </div>
                            </c:otherwise>
                          </c:choose>
                          <div class="prod-info">
                            <span class="prod-name"><c:out value="${p.productName}"/></span>
                            <c:if test="${not empty p.category}">
                              <span class="prod-cat"><c:out value="${p.category}"/></span>
                            </c:if>
                          </div>
                        </div>
                      </td>
                      <td class="price-cell">
                        <span class="price-currency">Rs.</span><fmt:formatNumber value="${p.price}" pattern="#,##0.00"/>
                      </td>
                      <%-- Colors --%>
                      <td>
                        <c:choose>
                          <c:when test="${not empty p.colors}">
                            <div class="swatches-sm">
                              <c:forEach var="col" items="${fn:split(p.colors, ',')}">
                                <span class="color-swatch-sm"
                                      data-color="${fn:trim(col)}"
                                      title="${fn:trim(col)}"></span>
                              </c:forEach>
                            </div>
                          </c:when>
                          <c:otherwise><span style="color:var(--t4);font-size:13px;">—</span></c:otherwise>
                        </c:choose>
                      </td>
                      <%-- Rating --%>
                      <td>
                        <c:choose>
                          <c:when test="${p.rating > 0}">
                            <div style="display:flex;align-items:center;gap:5px;">
                              <span class="stars stars-sm">
                                <c:forEach begin="1" end="5" var="i">
                                  <c:choose>
                                    <c:when test="${p.rating >= i}">
                                      <i class="fa-solid fa-star"></i>
                                    </c:when>
                                    <c:when test="${p.rating >= i - 0.5}">
                                      <i class="fa-solid fa-star-half-stroke"></i>
                                    </c:when>
                                    <c:otherwise>
                                      <i class="fa-regular fa-star empty-star"></i>
                                    </c:otherwise>
                                  </c:choose>
                                </c:forEach>
                              </span>
                              <span class="rating-num-sm"><fmt:formatNumber value="${p.rating}" pattern="0.0"/></span>
                            </div>
                          </c:when>
                          <c:otherwise><span style="color:var(--t4);font-size:13px;">—</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${fn:containsIgnoreCase(p.availability, 'in stock') or fn:containsIgnoreCase(p.availability, 'available')}">
                            <span class="avail-badge in-stock">
                              <span class="dot"></span><c:out value="${p.availability}"/>
                            </span>
                          </c:when>
                          <c:when test="${fn:containsIgnoreCase(p.availability, 'out') or fn:containsIgnoreCase(p.availability, 'unavailable')}">
                            <span class="avail-badge out-stock">
                              <span class="dot"></span><c:out value="${p.availability}"/>
                            </span>
                          </c:when>
                          <c:otherwise>
                            <span class="avail-badge other">
                              <span class="dot"></span>
                              <c:out value="${not empty p.availability ? p.availability : '—'}"/>
                            </span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${fn:toLowerCase(p.status) == 'active'}">
                            <span class="status-pill active"><c:out value="${p.status}"/></span>
                          </c:when>
                          <c:otherwise>
                            <span class="status-pill inactive">
                              <c:out value="${not empty p.status ? p.status : 'Inactive'}"/>
                            </span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/products?id=${p.id}"
                           class="view-btn">
                          <i class="fa-regular fa-eye"></i> View
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="8" class="prod-empty">
                      <i class="fa-solid fa-box-open"></i>
                      <c:choose>
                        <c:when test="${empty search and category == 'all'}">
                          No products found in the catalogue.
                        </c:when>
                        <c:otherwise>
                          No products match your search.
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <%-- Pagination links --%>
        <c:url var="prevUrl" value="${pageContext.request.contextPath}/admin/products">
          <c:param name="search"   value="${search}"/>
          <c:param name="category" value="${category}"/>
          <c:param name="page"     value="${currentPage - 1}"/>
        </c:url>
        <c:url var="nextUrl" value="${pageContext.request.contextPath}/admin/products">
          <c:param name="search"   value="${search}"/>
          <c:param name="category" value="${category}"/>
          <c:param name="page"     value="${currentPage + 1}"/>
        </c:url>

        <div class="pagination-bar">
          <span class="pg-info">
            <c:choose>
              <c:when test="${totalCount > 0}">
                Showing ${startIndex + 1} to ${startIndex + fn:length(products)}
                of ${totalCount} entries
              </c:when>
              <c:otherwise>No entries found</c:otherwise>
            </c:choose>
          </span>
          <div class="pg-controls">
            <span class="pg-label">Page ${currentPage} of ${totalPages}</span>
            <c:choose>
              <c:when test="${currentPage > 1}">
                <a href="${prevUrl}" class="pg-btn">Previous</a>
              </c:when>
              <c:otherwise>
                <button class="pg-btn" disabled>Previous</button>
              </c:otherwise>
            </c:choose>
            <c:choose>
              <c:when test="${currentPage < totalPages}">
                <a href="${nextUrl}" class="pg-btn">Next</a>
              </c:when>
              <c:otherwise>
                <button class="pg-btn" disabled>Next</button>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

    </main>
  </div>

  <div id="prodToast" style="position:fixed;bottom:24px;right:24px;background:#0f1117;color:#fff;padding:11px 18px;border-radius:10px;font-size:13px;font-weight:500;box-shadow:0 8px 32px rgba(0,0,0,.2);display:flex;align-items:center;gap:9px;opacity:0;transform:translateY(12px);transition:all .26s ease;z-index:9999;pointer-events:none;">
    <span id="prodToastIcon"></span><span id="prodToastMsg"></span>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  <script>
    /* Apply color swatches from data-color attribute */
    document.querySelectorAll("[data-color]").forEach(function(el) {
      el.style.background = el.dataset.color;
    });
    /* Toast from redirect param */
    function showToast(icon, msg) {
      var t = document.getElementById("prodToast");
      document.getElementById("prodToastIcon").textContent = icon;
      document.getElementById("prodToastMsg").textContent  = msg;
      t.style.opacity = "1"; t.style.transform = "translateY(0)";
      setTimeout(function() { t.style.opacity = "0"; t.style.transform = "translateY(12px)"; }, 3500);
    }
    <c:choose>
      <c:when test="${param.toast == 'added'}">window.addEventListener("load", function() { showToast("✅", "Product added successfully."); });</c:when>
      <c:when test="${param.toast == 'updated'}">window.addEventListener("load", function() { showToast("✅", "Product updated successfully."); });</c:when>
      <c:when test="${param.toast == 'error'}">window.addEventListener("load", function() { showToast("❌", "Something went wrong. Please try again."); });</c:when>
    </c:choose>
  </script>
</body>
</html>
