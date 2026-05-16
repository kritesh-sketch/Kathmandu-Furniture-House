<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Order ORD-${order.id} — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/orders.css" />
</head>
<body>
  <div class="admin-layout">
    <jsp:include page="../../templates/admin/sidebar.jsp">
      <jsp:param name="activePage" value="orders"/>
    </jsp:include>

    <main class="main-content">
      <header class="topbar">
        <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
          <button class="hamburger-btn" id="hamburgerBtn"><i class="fa-solid fa-bars"></i></button>
          <div>
            <h2>Order Detail</h2>
            <p>Full details for order ORD-${order.id}.</p>
          </div>
        </div>
      </header>

      <!-- Back link -->
      <div style="margin-bottom:20px;">
        <a href="${pageContext.request.contextPath}/admin/orders" class="detail-back">
          <i class="fa-solid fa-arrow-left"></i> Back to Orders
        </a>
      </div>

      <div class="detail-grid">

        <!-- ── Left: order summary card ── -->
        <div class="order-summary-card">
          <div class="order-summary-header">
            <div class="order-id-display">ORD-${order.id}</div>
            <div class="order-summary-badges">
              <%-- Type badge --%>
              <c:choose>
                <c:when test="${fn:toLowerCase(order.orderType) == 'customize'}">
                  <span class="type-badge customize"><c:out value="${order.orderType}"/></span>
                </c:when>
                <c:when test="${not empty order.orderType}">
                  <span class="type-badge normal"><c:out value="${order.orderType}"/></span>
                </c:when>
              </c:choose>
              <%-- Status badge --%>
              <c:set var="stLow" value="${fn:toLowerCase(order.status)}"/>
              <c:if test="${not empty order.status}">
                <span class="status-badge ${stLow}">
                  <span class="dot"></span><c:out value="${order.status}"/>
                </span>
              </c:if>
            </div>
          </div>
          <div class="order-summary-body">
            <div class="summary-row">
              <span class="summary-lbl">Payment</span>
              <span class="summary-val"><c:out value="${not empty order.paymentMethod ? order.paymentMethod : '—'}"/></span>
            </div>
            <div class="summary-row">
              <span class="summary-lbl">Quantity</span>
              <span class="summary-val">${order.quantity > 0 ? order.quantity : '—'}</span>
            </div>
            <div class="summary-row">
              <span class="summary-lbl">Deadline</span>
              <span class="summary-val"><c:out value="${not empty order.deadline ? order.deadline : '—'}"/></span>
            </div>
            <div class="summary-row">
              <span class="summary-lbl">Installation</span>
              <span class="summary-val"><c:out value="${not empty order.installationRequired ? order.installationRequired : '—'}"/></span>
            </div>
          </div>
        </div>

        <!-- ── Right: detail panels ── -->
        <div class="detail-panels">

          <!-- Customer Info -->
          <div class="detail-panel">
            <div class="detail-panel-header">
              <h3><i class="fa-solid fa-user"></i> Customer Info</h3>
            </div>
            <div class="detail-panel-body">
              <div class="info-row">
                <span class="info-label">Full Name</span>
                <span class="info-value"><c:out value="${not empty order.fullName ? order.fullName : '—'}"/></span>
              </div>
              <div class="info-row">
                <span class="info-label">Phone Number</span>
                <span class="info-value" style="font-family:'Courier New',monospace;">
                  <c:out value="${not empty order.phoneNumber ? order.phoneNumber : '—'}"/>
                </span>
              </div>
              <div class="info-row">
                <span class="info-label">Delivery Address</span>
                <span class="info-value"><c:out value="${not empty order.deliveryLocation ? order.deliveryLocation : '—'}"/></span>
              </div>
            </div>
          </div>

          <!-- Order Details -->
          <div class="detail-panel">
            <div class="detail-panel-header">
              <h3><i class="fa-solid fa-cart-shopping"></i> Order Details</h3>
            </div>
            <div class="detail-panel-body">
              <div class="info-row">
                <span class="info-label">Product</span>
                <span class="info-value"><c:out value="${not empty order.furnitureType ? order.furnitureType : '—'}"/></span>
              </div>
              <div class="info-row">
                <span class="info-label">Quantity</span>
                <span class="info-value">${order.quantity > 0 ? order.quantity : '—'}</span>
              </div>
              <div class="info-row">
                <span class="info-label">Type</span>
                <span class="info-value">
                  <c:choose>
                    <c:when test="${fn:toLowerCase(order.orderType) == 'customize'}">
                      <span class="type-badge customize"><c:out value="${order.orderType}"/></span>
                    </c:when>
                    <c:when test="${not empty order.orderType}">
                      <span class="type-badge normal"><c:out value="${order.orderType}"/></span>
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="info-row">
                <span class="info-label">Payment Method</span>
                <span class="info-value"><c:out value="${not empty order.paymentMethod ? order.paymentMethod : '—'}"/></span>
              </div>
              <%-- Height & Width --%>
              <c:if test="${order.height != null or order.width != null}">
                <div class="info-row">
                  <span class="info-label">Dimensions</span>
                  <span class="info-value">
                    <div class="dim-row">
                      <c:if test="${order.height != null}">
                        <div class="dim-item">
                          <span class="dim-lbl">Height</span>
                          <span class="dim-val">${order.height} <span class="dim-unit">cm</span></span>
                        </div>
                      </c:if>
                      <c:if test="${order.width != null}">
                        <div class="dim-item">
                          <span class="dim-lbl">Width</span>
                          <span class="dim-val">${order.width} <span class="dim-unit">cm</span></span>
                        </div>
                      </c:if>
                    </div>
                  </span>
                </div>
              </c:if>
            </div>
          </div>

          <!-- Additional Info -->
          <c:if test="${not empty order.design or not empty order.material or not empty order.purpose or not empty order.recommendation}">
            <div class="detail-panel">
              <div class="detail-panel-header">
                <h3><i class="fa-solid fa-circle-info"></i> Additional Info</h3>
              </div>
              <div class="detail-panel-body">
                <c:if test="${not empty order.design}">
                  <div class="info-row">
                    <span class="info-label">Design</span>
                    <span class="info-value"><c:out value="${order.design}"/></span>
                  </div>
                </c:if>
                <c:if test="${not empty order.material}">
                  <div class="info-row">
                    <span class="info-label">Material</span>
                    <span class="info-value"><c:out value="${order.material}"/></span>
                  </div>
                </c:if>
                <c:if test="${not empty order.purpose}">
                  <div class="info-row">
                    <span class="info-label">Purpose</span>
                    <span class="info-value"><c:out value="${order.purpose}"/></span>
                  </div>
                </c:if>
                <c:if test="${not empty order.recommendation}">
                  <div class="info-row">
                    <span class="info-label">Notes</span>
                    <span class="info-value"><c:out value="${order.recommendation}"/></span>
                  </div>
                </c:if>
              </div>
            </div>
          </c:if>

        </div>
        <%-- end detail-panels --%>
      </div>
      <%-- end detail-grid --%>

    </main>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
</body>
</html>
