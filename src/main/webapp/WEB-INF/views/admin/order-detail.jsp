<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Order ORD-${order.id} — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/orders.css" />
  <style>
    /* ── Order detail overrides ── */
    .od-page { max-width: 1100px; }

    .od-back-row {
      display: flex; align-items: center; gap: 10px; margin-bottom: 24px;
    }

    /* Two-column grid */
    .od-grid {
      display: grid;
      grid-template-columns: 300px 1fr;
      gap: 22px;
      align-items: start;
    }

    /* ── Left: summary card ── */
    .od-summary-card {
      background: var(--panel);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      overflow: hidden;
      position: sticky;
      top: 20px;
    }
    .od-summary-top {
      padding: 26px 22px 20px;
      background: linear-gradient(135deg,#fdf3e3 0%,#fff8ee 100%);
      border-bottom: 1px solid var(--border);
      text-align: center;
    }
    .od-order-num {
      font-size: 11px; font-weight: 700; letter-spacing: .08em;
      text-transform: uppercase; color: var(--t3); margin-bottom: 6px;
    }
    .od-order-id {
      font-family: "Courier New", monospace;
      font-size: 26px; font-weight: 800;
      color: var(--t1); margin-bottom: 14px;
    }
    .od-badges { display: flex; flex-wrap: wrap; gap: 7px; justify-content: center; }

    .od-total-block {
      padding: 18px 22px;
      border-bottom: 1px solid var(--border);
      background: #fafbfc;
      text-align: center;
    }
    .od-total-lbl { font-size: 11px; font-weight: 600; color: var(--t4); text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px; }
    .od-total-val {
      font-size: 24px; font-weight: 800; color: var(--t1);
    }
    .od-total-val span { font-size: 14px; font-weight: 600; color: var(--t3); }

    .od-meta { padding: 16px 22px; }
    .od-meta-row {
      display: flex; justify-content: space-between; align-items: center;
      padding: 9px 0; border-bottom: 1px solid #f2f3f6;
      font-size: 13px;
    }
    .od-meta-row:last-child { border-bottom: none; }
    .od-meta-lbl { font-size: 11.5px; font-weight: 600; color: var(--t4); text-transform: uppercase; letter-spacing: .4px; }
    .od-meta-val { font-weight: 600; color: var(--t1); }

    /* ── Right: panels ── */
    .od-panels { display: flex; flex-direction: column; gap: 18px; }

    .od-panel {
      background: var(--panel);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      overflow: hidden;
    }
    .od-panel-hdr {
      display: flex; align-items: center; gap: 9px;
      padding: 14px 20px;
      border-bottom: 1px solid var(--border);
      background: #fafbfc;
      font-size: 13px; font-weight: 700; color: var(--t1);
    }
    .od-panel-hdr i { color: var(--gold); font-size: 14px; }
    .od-panel-body { padding: 6px 0; }

    .od-row {
      display: flex; align-items: flex-start; gap: 16px;
      padding: 11px 20px;
      border-bottom: 1px solid #f6f7fa;
      font-size: 13px;
    }
    .od-row:last-child { border-bottom: none; }
    .od-lbl {
      flex: 0 0 160px; font-size: 12px; font-weight: 600;
      color: var(--t3); text-transform: uppercase; letter-spacing: .4px;
      padding-top: 1px;
    }
    .od-val { flex: 1; color: var(--t1); font-weight: 500; line-height: 1.55; }

    /* Spec grid for custom order dimensions etc */
    .od-spec-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; padding: 16px 20px; }
    .od-spec-item { background: #f9fafb; border: 1px solid var(--border); border-radius: 8px; padding: 12px 14px; }
    .od-spec-lbl { font-size: 10.5px; font-weight: 700; color: var(--t4); text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px; }
    .od-spec-val { font-size: 18px; font-weight: 800; color: var(--t1); }
    .od-spec-unit { font-size: 11px; font-weight: 500; color: var(--t3); }

    /* Standalone description / notes panels */
    .od-prose-panel {
      background: var(--panel);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      overflow: hidden;
    }
    .od-prose-panel--desc { border-top: 3px solid var(--gold); }
    .od-prose-panel--notes { border-top: 3px solid #818cf8; }

    .od-prose-meta {
      display: flex; align-items: center; justify-content: space-between;
      padding: 14px 20px 10px;
    }
    .od-prose-label {
      display: flex; align-items: center; gap: 8px;
      font-size: 12px; font-weight: 700;
      text-transform: uppercase; letter-spacing: .6px;
      color: var(--t3);
    }
    .od-prose-panel--desc  .od-prose-label i { color: var(--gold); }
    .od-prose-panel--notes .od-prose-label i { color: #818cf8; }

    .od-prose-body {
      margin: 0;
      padding: 0 20px 20px;
      font-size: 14px;
      color: var(--t1);
      line-height: 1.8;
      font-weight: 400;
    }
    .od-prose-panel--notes .od-prose-body {
      color: var(--t2);
      font-style: italic;
    }

    /* Ref image */
    .od-ref-img {
      display: block;
      max-width: 100%; max-height: 340px;
      object-fit: contain;
      border-radius: 10px;
      border: 1px solid var(--border);
      margin: 16px 20px;
    }

    /* status badge colours */
    .status-badge {
      display: inline-flex; align-items: center; gap: 5px;
      font-size: 11.5px; font-weight: 600;
      padding: 4px 10px; border-radius: 20px;
    }
    .status-badge .dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
    .status-badge.pending    { background:#fff3cd; color:#856404; }
    .status-badge.confirmed  { background:#d1ecf1; color:#0c5460; }
    .status-badge.processing { background:#cce5ff; color:#004085; }
    .status-badge.shipped    { background:#d4edda; color:#155724; }
    .status-badge.delivered  { background:#d4edda; color:#155724; }
    .status-badge.cancelled  { background:#f8d7da; color:#721c24; }

    @media (max-width: 860px) {
      .od-grid { grid-template-columns: 1fr; }
      .od-summary-card { position: static; }
    }
    @media (max-width: 540px) {
      .od-lbl { flex: 0 0 110px; }
      .od-spec-grid { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>
  <div class="admin-layout">
    <jsp:include page="../../templates/admin/sidebar.jsp">
      <jsp:param name="activePage" value="orders"/>
    </jsp:include>

    <main class="main-content od-page">

      <header class="topbar">
        <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
          <button class="hamburger-btn" id="hamburgerBtn"><i class="fa-solid fa-bars"></i></button>
          <div>
            <h2>Order Detail</h2>
            <p>Viewing full details for order ORD-${order.id}.</p>
          </div>
        </div>
      </header>

      <div class="od-back-row">
        <a href="${pageContext.request.contextPath}/admin/orders" class="detail-back" style="margin-bottom:0;">
          <i class="fa-solid fa-arrow-left"></i> Back to Orders
        </a>
      </div>

      <div class="od-grid">

        <%-- ── LEFT: Summary card ── --%>
        <div class="od-summary-card">

          <div class="od-summary-top">
            <div class="od-order-num">Order Number</div>
            <div class="od-order-id">ORD-${order.id}</div>
            <div class="od-badges">
              <%-- Type badge --%>
              <c:choose>
                <c:when test="${fn:toLowerCase(order.orderType) == 'customize'}">
                  <span class="type-badge customize"><i class="fa-solid fa-pen-ruler"></i><c:out value="${order.orderType}"/></span>
                </c:when>
                <c:when test="${not empty order.orderType}">
                  <span class="type-badge normal"><i class="fa-solid fa-box"></i><c:out value="${order.orderType}"/></span>
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

          <%-- Total amount block --%>
          <div class="od-total-block">
            <div class="od-total-lbl">Total Amount</div>
            <div class="od-total-val">
              <c:choose>
                <c:when test="${order.totalAmount != null}">
                  <span>Rs.</span> <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                </c:when>
                <c:otherwise><span style="font-size:15px;color:var(--t3);">To be confirmed</span></c:otherwise>
              </c:choose>
            </div>
          </div>

          <%-- Quick meta --%>
          <div class="od-meta">
            <div class="od-meta-row">
              <span class="od-meta-lbl">Quantity</span>
              <span class="od-meta-val">${order.quantity > 0 ? order.quantity : '—'}</span>
            </div>
            <div class="od-meta-row">
              <span class="od-meta-lbl">Payment</span>
              <span class="od-meta-val"><c:out value="${not empty order.paymentMethod ? order.paymentMethod : '—'}"/></span>
            </div>
            <c:if test="${not empty order.deadline}">
              <div class="od-meta-row">
                <span class="od-meta-lbl">Deadline</span>
                <span class="od-meta-val"><c:out value="${order.deadline}"/></span>
              </div>
            </c:if>
            <div class="od-meta-row">
              <span class="od-meta-lbl">Order Date</span>
              <span class="od-meta-val" style="font-size:12px;">
                <c:choose>
                  <c:when test="${not empty order.orderDate}">
                    <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/>
                  </c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </span>
            </div>
          </div>
        </div>

        <%-- ── RIGHT: Detail panels ── --%>
        <div class="od-panels">

          <%-- Customer Information --%>
          <div class="od-panel">
            <div class="od-panel-hdr">
              <i class="fa-solid fa-user"></i> Customer Information
            </div>
            <div class="od-panel-body">
              <div class="od-row">
                <span class="od-lbl">Full Name</span>
                <span class="od-val"><c:out value="${not empty order.fullName ? order.fullName : '—'}"/></span>
              </div>
              <div class="od-row">
                <span class="od-lbl">Phone Number</span>
                <span class="od-val" style="font-family:'Courier New',monospace;">
                  <c:out value="${not empty order.phoneNumber ? order.phoneNumber : '—'}"/>
                </span>
              </div>
              <div class="od-row">
                <span class="od-lbl">Delivery Address</span>
                <span class="od-val"><c:out value="${not empty order.deliveryLocation ? order.deliveryLocation : '—'}"/></span>
              </div>
            </div>
          </div>

          <%-- Order Summary --%>
          <div class="od-panel">
            <div class="od-panel-hdr">
              <i class="fa-solid fa-receipt"></i> Order Summary
            </div>
            <div class="od-panel-body">
              <c:if test="${not empty order.productName}">
                <div class="od-row">
                  <span class="od-lbl">Product</span>
                  <span class="od-val" style="font-weight:700;"><c:out value="${order.productName}"/></span>
                </div>
              </c:if>
              <c:if test="${not empty order.furnitureType}">
                <div class="od-row">
                  <span class="od-lbl">Furniture Type</span>
                  <span class="od-val"><c:out value="${order.furnitureType}"/></span>
                </div>
              </c:if>
              <div class="od-row">
                <span class="od-lbl">Quantity</span>
                <span class="od-val">${order.quantity > 0 ? order.quantity : '—'}</span>
              </div>
              <div class="od-row">
                <span class="od-lbl">Payment Method</span>
                <span class="od-val"><c:out value="${not empty order.paymentMethod ? order.paymentMethod : '—'}"/></span>
              </div>
              <div class="od-row">
                <span class="od-lbl">Total Amount</span>
                <span class="od-val" style="font-weight:700;">
                  <c:choose>
                    <c:when test="${order.totalAmount != null}">Rs. <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></c:when>
                    <c:otherwise>To be confirmed</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="od-row">
                <span class="od-lbl">Installation</span>
                <span class="od-val"><c:out value="${not empty order.installationRequired ? order.installationRequired : '—'}"/></span>
              </div>
            </div>
          </div>

          <%-- Description panel --%>
          <c:if test="${not empty order.description}">
            <div class="od-prose-panel od-prose-panel--desc">
              <div class="od-prose-meta">
                <span class="od-prose-label">
                  <i class="fa-solid fa-quote-left"></i> Description
                </span>
              </div>
              <p class="od-prose-body"><c:out value="${order.description}"/></p>
            </div>
          </c:if>

          <%-- Customer Notes panel --%>
          <c:if test="${not empty order.notes}">
            <div class="od-prose-panel od-prose-panel--notes">
              <div class="od-prose-meta">
                <span class="od-prose-label">
                  <i class="fa-solid fa-note-sticky"></i> Customer Notes
                </span>
              </div>
              <p class="od-prose-body"><c:out value="${order.notes}"/></p>
            </div>
          </c:if>

          <%-- Custom Order Specifications (only for Customize orders) --%>
          <c:if test="${fn:toLowerCase(order.orderType) == 'customize'}">
            <div class="od-panel">
              <div class="od-panel-hdr">
                <i class="fa-solid fa-pen-ruler"></i> Custom Order Specifications
              </div>
              <div class="od-panel-body">
                <c:if test="${not empty order.design}">
                  <div class="od-row">
                    <span class="od-lbl">Design</span>
                    <span class="od-val"><c:out value="${order.design}"/></span>
                  </div>
                </c:if>
                <c:if test="${not empty order.material}">
                  <div class="od-row">
                    <span class="od-lbl">Material</span>
                    <span class="od-val"><c:out value="${order.material}"/></span>
                  </div>
                </c:if>
                <c:if test="${order.size > 0}">
                  <div class="od-row">
                    <span class="od-lbl">Size</span>
                    <span class="od-val">${order.size}</span>
                  </div>
                </c:if>
                <c:if test="${not empty order.budgetRange}">
                  <div class="od-row">
                    <span class="od-lbl">Budget Range</span>
                    <span class="od-val"><c:out value="${order.budgetRange}"/></span>
                  </div>
                </c:if>
                <c:if test="${not empty order.deadline}">
                  <div class="od-row">
                    <span class="od-lbl">Deadline</span>
                    <span class="od-val"><c:out value="${order.deadline}"/></span>
                  </div>
                </c:if>
                <c:if test="${not empty order.purpose}">
                  <div class="od-row">
                    <span class="od-lbl">Purpose</span>
                    <span class="od-val"><c:out value="${order.purpose}"/></span>
                  </div>
                </c:if>

                <%-- Dimensions spec grid (Length × Breadth × Height) --%>
                <c:if test="${order.height != null or order.width != null}">
                  <div class="od-spec-grid" style="grid-template-columns:1fr 1fr 1fr;">
                    <c:if test="${order.width != null}">
                      <div class="od-spec-item">
                        <div class="od-spec-lbl">Length</div>
                        <div class="od-spec-val">${order.width} <span class="od-spec-unit">cm</span></div>
                      </div>
                    </c:if>
                    <c:if test="${order.breadth != null}">
                      <div class="od-spec-item">
                        <div class="od-spec-lbl">Breadth</div>
                        <div class="od-spec-val">${order.breadth} <span class="od-spec-unit">cm</span></div>
                      </div>
                    </c:if>
                    <c:if test="${order.height != null}">
                      <div class="od-spec-item">
                        <div class="od-spec-lbl">Height</div>
                        <div class="od-spec-val">${order.height} <span class="od-spec-unit">cm</span></div>
                      </div>
                    </c:if>
                  </div>
                </c:if>
              </div>
            </div>
          </c:if>

          <%-- Reference Image --%>
          <c:if test="${not empty order.referenceImage}">
            <div class="od-panel">
              <div class="od-panel-hdr">
                <i class="fa-solid fa-image"></i> Reference Image
              </div>
              <img src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(order.referenceImage)}"
                   alt="Reference image" class="od-ref-img"/>
            </div>
          </c:if>

        </div>
        <%-- end od-panels --%>
      </div>
      <%-- end od-grid --%>

    </main>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
</body>
</html>
