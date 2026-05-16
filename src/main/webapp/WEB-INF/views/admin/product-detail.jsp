<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title><c:out value="${product.productName}"/> — Kathmandu Furniture Admin</title>
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
            <h2>Product Detail</h2>
            <p>Viewing full details for <c:out value="${product.productName}"/>.</p>
          </div>
        </div>
      </header>

      <!-- Back + Edit row -->
      <div style="display:flex;align-items:center;gap:10px;margin-bottom:20px;">
        <a href="${pageContext.request.contextPath}/admin/products" class="detail-back" style="margin-bottom:0;">
          <i class="fa-solid fa-arrow-left"></i> Back to Products
        </a>
        <a href="${pageContext.request.contextPath}/admin/product-form?id=${product.id}" class="edit-btn">
          <i class="fa-solid fa-pen-to-square"></i> Edit Product
        </a>
      </div>

      <!-- Two-column detail layout -->
      <div class="detail-grid">

        <!-- ── Left: image + price card ── -->
        <div class="detail-image-card">
          <div class="detail-img-wrap">
            <c:choose>
              <c:when test="${not empty product.image}">
                <img src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(product.image)}"
                     alt="${fn:escapeXml(product.productName)}"
                     onerror="this.parentNode.innerHTML='<div class=&quot;detail-img-placeholder&quot;><i class=&quot;fa-regular fa-image&quot;></i></div>';" />
              </c:when>
              <c:otherwise>
                <div class="detail-img-placeholder">
                  <i class="fa-regular fa-image"></i>
                </div>
              </c:otherwise>
            </c:choose>
          </div>

          <div class="detail-price-block">
            <div class="detail-price-label">Price</div>
            <div class="detail-price-value">
              <span>Rs.</span><fmt:formatNumber value="${product.price}" pattern="#,##0.00"/>
            </div>
            <div class="detail-badges">
              <%-- Availability badge --%>
              <c:choose>
                <c:when test="${fn:containsIgnoreCase(product.availability, 'in stock') or fn:containsIgnoreCase(product.availability, 'available')}">
                  <span class="avail-badge in-stock">
                    <span class="dot"></span><c:out value="${product.availability}"/>
                  </span>
                </c:when>
                <c:when test="${fn:containsIgnoreCase(product.availability, 'out') or fn:containsIgnoreCase(product.availability, 'unavailable')}">
                  <span class="avail-badge out-stock">
                    <span class="dot"></span><c:out value="${product.availability}"/>
                  </span>
                </c:when>
                <c:otherwise>
                  <c:if test="${not empty product.availability}">
                    <span class="avail-badge other">
                      <span class="dot"></span><c:out value="${product.availability}"/>
                    </span>
                  </c:if>
                </c:otherwise>
              </c:choose>
              <%-- Status badge --%>
              <c:choose>
                <c:when test="${fn:toLowerCase(product.status) == 'active'}">
                  <span class="status-pill active"><c:out value="${product.status}"/></span>
                </c:when>
                <c:otherwise>
                  <span class="status-pill inactive">
                    <c:out value="${not empty product.status ? product.status : 'Inactive'}"/>
                  </span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>

        <!-- ── Right: info panels ── -->
        <div class="detail-panels">

          <!-- Product Info -->
          <div class="detail-panel">
            <div class="detail-panel-header">
              <h3><i class="fa-solid fa-circle-info"></i> Product Info</h3>
            </div>
            <div class="detail-panel-body">
              <div class="info-row">
                <span class="info-label">Product ID</span>
                <span class="info-value col-id">PRD-${product.id}</span>
              </div>
              <div class="info-row">
                <span class="info-label">Name</span>
                <span class="info-value"><c:out value="${product.productName}"/></span>
              </div>
              <div class="info-row">
                <span class="info-label">Category</span>
                <span class="info-value">
                  <c:choose>
                    <c:when test="${not empty product.category}">
                      <span class="prod-cat"><c:out value="${product.category}"/></span>
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="info-row">
                <span class="info-label">Price</span>
                <span class="info-value" style="font-weight:700;color:var(--t1);">
                  Rs. <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/>
                </span>
              </div>
              <div class="info-row">
                <span class="info-label">Availability</span>
                <span class="info-value">
                  <c:out value="${not empty product.availability ? product.availability : '—'}"/>
                </span>
              </div>
              <div class="info-row">
                <span class="info-label">Status</span>
                <span class="info-value">
                  <c:out value="${not empty product.status ? product.status : '—'}"/>
                </span>
              </div>
              <div class="info-row">
                <span class="info-label">Colors</span>
                <span class="info-value">
                  <c:choose>
                    <c:when test="${not empty product.colors}">
                      <div class="color-swatches">
                        <c:forEach var="col" items="${fn:split(product.colors, ',')}">
                          <span class="color-swatch"
                                data-color="${fn:trim(col)}"
                                title="${fn:trim(col)}"></span>
                        </c:forEach>
                      </div>
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="info-row">
                <span class="info-label">Rating</span>
                <span class="info-value">
                  <c:choose>
                    <c:when test="${product.rating > 0}">
                      <div class="star-row">
                        <span class="stars">
                          <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                              <c:when test="${product.rating >= i}">
                                <i class="fa-solid fa-star"></i>
                              </c:when>
                              <c:when test="${product.rating >= i - 0.5}">
                                <i class="fa-solid fa-star-half-stroke"></i>
                              </c:when>
                              <c:otherwise>
                                <i class="fa-regular fa-star empty-star"></i>
                              </c:otherwise>
                            </c:choose>
                          </c:forEach>
                        </span>
                        <span class="rating-num"><fmt:formatNumber value="${product.rating}" pattern="0.0"/></span>
                        <span class="rating-count">/ 5.0</span>
                      </div>
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                  </c:choose>
                </span>
              </div>
            </div>
          </div>

          <!-- Specifications -->
          <div class="detail-panel">
            <div class="detail-panel-header">
              <h3><i class="fa-solid fa-list-check"></i> Specifications</h3>
            </div>
            <div class="detail-panel-body">
              <c:choose>
                <c:when test="${not empty product.specifications}">
                  <p class="spec-text"><c:out value="${product.specifications}"/></p>
                </c:when>
                <c:otherwise>
                  <p class="spec-empty">No specifications provided.</p>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

        </div>
        <%-- end detail-panels --%>
      </div>
      <%-- end detail-grid --%>

    </main>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  <script>
    /* Apply color swatches from data-color attribute */
    document.querySelectorAll("[data-color]").forEach(function(el) {
      el.style.background = el.dataset.color;
    });
  </script>
</body>
</html>
