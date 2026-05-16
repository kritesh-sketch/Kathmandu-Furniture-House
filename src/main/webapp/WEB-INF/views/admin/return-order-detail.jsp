<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Return RET-${ret.returnId} — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/orders.css" />
</head>
<body>
  <div class="admin-layout">
    <jsp:include page="../../templates/admin/sidebar.jsp">
      <jsp:param name="activePage" value="return-orders"/>
    </jsp:include>

    <main class="main-content">
      <header class="topbar">
        <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
          <button class="hamburger-btn" id="hamburgerBtn"><i class="fa-solid fa-bars"></i></button>
          <div>
            <h2>Return Detail</h2>
            <p>Full details for return request RET-${ret.returnId}.</p>
          </div>
        </div>
      </header>

      <!-- Back link -->
      <div style="margin-bottom:20px;">
        <a href="${pageContext.request.contextPath}/admin/return-orders" class="detail-back">
          <i class="fa-solid fa-arrow-left"></i> Back to Return Orders
        </a>
      </div>

      <div class="detail-grid">

        <!-- ── Left: summary card ── -->
        <div class="order-summary-card">
          <div class="order-summary-header">
            <div class="order-id-display">RET-${ret.returnId}</div>
            <div class="order-summary-badges">
              <c:set var="stLow" value="${fn:toLowerCase(ret.status)}"/>
              <c:if test="${not empty ret.status}">
                <span class="status-badge ${stLow}">
                  <span class="dot"></span><c:out value="${ret.status}"/>
                </span>
              </c:if>
            </div>
          </div>
          <div class="order-summary-body">
            <div class="summary-row">
              <span class="summary-lbl">Original Order</span>
              <span class="summary-val" style="font-family:'Courier New',monospace;">ORD-${ret.orderId}</span>
            </div>
            <div class="summary-row">
              <span class="summary-lbl">Return Date</span>
              <span class="summary-val"><c:out value="${not empty ret.returnDate ? ret.returnDate : '—'}"/></span>
            </div>
            <div class="summary-row">
              <span class="summary-lbl">Refund Amount</span>
              <span class="summary-val" style="font-weight:700;color:#059669;">
                <c:choose>
                  <c:when test="${ret.refundAmount > 0}">$<c:out value="${ret.refundAmount}"/></c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </span>
            </div>
          </div>

          <!-- Status update form -->
          <div style="padding:16px 22px;border-top:1px solid var(--border);">
            <p style="font-size:11px;font-weight:600;color:var(--t4);text-transform:uppercase;letter-spacing:.5px;margin-bottom:10px;">Update Status</p>
            <form method="post" action="${pageContext.request.contextPath}/admin/return-orders"
                  style="display:flex;gap:8px;align-items:center;">
              <input type="hidden" name="returnId"   value="${ret.returnId}"/>
              <input type="hidden" name="redirectId" value="${ret.returnId}"/>
              <select name="status" class="filter-select" style="flex:1;height:34px;font-size:12px;">
                <option value="Pending"   ${ret.status == 'Pending'   ? 'selected':''}>Pending</option>
                <option value="Approved"  ${ret.status == 'Approved'  ? 'selected':''}>Approved</option>
                <option value="Rejected"  ${ret.status == 'Rejected'  ? 'selected':''}>Rejected</option>
                <option value="Completed" ${ret.status == 'Completed' ? 'selected':''}>Completed</option>
              </select>
              <button type="submit" class="view-btn" style="white-space:nowrap;">
                <i class="fa-solid fa-check"></i> Save
              </button>
            </form>
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
                <span class="info-value"><c:out value="${not empty ret.customer ? ret.customer : '—'}"/></span>
              </div>
              <div class="info-row">
                <span class="info-label">Phone Number</span>
                <span class="info-value" style="font-family:'Courier New',monospace;">
                  <c:out value="${not empty ret.phoneNumber ? ret.phoneNumber : '—'}"/>
                </span>
              </div>
            </div>
          </div>

          <!-- Return Details -->
          <div class="detail-panel">
            <div class="detail-panel-header">
              <h3><i class="fa-solid fa-rotate-left"></i> Return Details</h3>
            </div>
            <div class="detail-panel-body">
              <div class="info-row">
                <span class="info-label">Original Order</span>
                <span class="info-value" style="font-family:'Courier New',monospace;font-weight:700;">
                  ORD-${ret.orderId}
                </span>
              </div>
              <div class="info-row">
                <span class="info-label">Product</span>
                <span class="info-value"><c:out value="${not empty ret.product ? ret.product : '—'}"/></span>
              </div>
              <div class="info-row">
                <span class="info-label">Return Date</span>
                <span class="info-value"><c:out value="${not empty ret.returnDate ? ret.returnDate : '—'}"/></span>
              </div>
              <div class="info-row">
                <span class="info-label">Refund Amount</span>
                <span class="info-value" style="font-weight:700;color:#059669;">
                  <c:choose>
                    <c:when test="${ret.refundAmount > 0}">$<c:out value="${ret.refundAmount}"/></c:when>
                    <c:otherwise>—</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <c:if test="${not empty ret.reason}">
                <div class="info-row">
                  <span class="info-label">Return Reason</span>
                  <span class="info-value"><c:out value="${ret.reason}"/></span>
                </div>
              </c:if>
            </div>
          </div>

        </div>
        <%-- end detail-panels --%>
      </div>
      <%-- end detail-grid --%>

    </main>
  </div>

  <div id="ordToast" data-toast="${param.toast}"><span id="ordToastIcon"></span><span id="ordToastMsg"></span></div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  <script>
    (function() {
      var t = document.getElementById("ordToast").dataset.toast || "";
      if (t === "updated") {
        window.addEventListener("load", function() {
          var toast = document.getElementById("ordToast");
          document.getElementById("ordToastIcon").textContent = "✅";
          document.getElementById("ordToastMsg").textContent  = "Return status updated.";
          toast.classList.add("show");
          setTimeout(function() { toast.classList.remove("show"); }, 3500);
        });
      }
    })();
  </script>
</body>
</html>
