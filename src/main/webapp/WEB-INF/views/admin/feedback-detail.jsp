<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Feedback FB-${fb.id} — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/orders.css" />
</head>
<body>
  <div class="admin-layout">
    <jsp:include page="../../templates/admin/sidebar.jsp">
      <jsp:param name="activePage" value="feedback"/>
    </jsp:include>

    <main class="main-content">
      <header class="topbar">
        <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
          <button class="hamburger-btn" id="hamburgerBtn"><i class="fa-solid fa-bars"></i></button>
          <div>
            <h2>Feedback Detail</h2>
            <p>Full details for feedback FB-${fb.id}.</p>
          </div>
        </div>
      </header>

      <!-- Back link -->
      <div style="margin-bottom:20px;">
        <a href="${pageContext.request.contextPath}/admin/feedback" class="detail-back">
          <i class="fa-solid fa-arrow-left"></i> Back to Feedback
        </a>
      </div>

      <div class="detail-grid">

        <!-- ── Left: summary card ── -->
        <div class="order-summary-card">
          <div class="order-summary-header">
            <div class="order-id-display">FB-${fb.id}</div>
            <div class="order-summary-badges">
              <c:set var="stLow" value="${fn:toLowerCase(fb.status)}"/>
              <c:choose>
                <c:when test="${stLow == 'new'}">
                  <span class="status-badge pending"><span class="dot"></span><c:out value="${fb.status}"/></span>
                </c:when>
                <c:when test="${stLow == 'reviewed'}">
                  <span class="status-badge delivered"><span class="dot"></span><c:out value="${fb.status}"/></span>
                </c:when>
                <c:otherwise>
                  <c:if test="${not empty fb.status}">
                    <span class="status-badge ${stLow}"><span class="dot"></span><c:out value="${fb.status}"/></span>
                  </c:if>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="order-summary-body">
            <div class="summary-row">
              <span class="summary-lbl">Submitted</span>
              <span class="summary-val">
                <c:choose>
                  <c:when test="${not empty fb.createdAt}">
                    <fmt:formatDate value="${fb.createdAt}" pattern="dd MMM yyyy, HH:mm"/>
                  </c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </span>
            </div>
            <div class="summary-row">
              <span class="summary-lbl">Subject</span>
              <span class="summary-val"><c:out value="${not empty fb.subject ? fb.subject : '—'}"/></span>
            </div>
          </div>

          <!-- Mark as read / unread toggle -->
          <div style="padding:16px 22px;border-top:1px solid var(--border);">
            <form method="post" action="${pageContext.request.contextPath}/admin/feedback"
                  style="display:flex;gap:8px;align-items:center;">
              <input type="hidden" name="feedbackId" value="${fb.id}"/>
              <input type="hidden" name="redirectId" value="${fb.id}"/>
              <select name="status" class="filter-select" style="flex:1;height:34px;font-size:12px;">
                <option value="New"      ${fb.status == 'New'      ? 'selected':''}>New</option>
                <option value="Reviewed" ${fb.status == 'Reviewed' ? 'selected':''}>Reviewed</option>
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
                <span class="info-value"><c:out value="${not empty fb.userName ? fb.userName : '—'}"/></span>
              </div>
              <div class="info-row">
                <span class="info-label">Email</span>
                <span class="info-value" style="font-family:'Courier New',monospace;font-size:13px;">
                  <c:out value="${not empty fb.email ? fb.email : '—'}"/>
                </span>
              </div>
            </div>
          </div>

          <!-- Feedback Content -->
          <div class="detail-panel">
            <div class="detail-panel-header">
              <h3><i class="fa-regular fa-comment-dots"></i> Feedback Content</h3>
            </div>
            <div class="detail-panel-body">
              <div class="info-row">
                <span class="info-label">Subject</span>
                <span class="info-value"><c:out value="${not empty fb.subject ? fb.subject : '—'}"/></span>
              </div>
              <div class="info-row" style="align-items:flex-start;">
                <span class="info-label" style="padding-top:2px;">Message</span>
                <span class="info-value" style="white-space:pre-wrap;line-height:1.6;">
                  <c:out value="${not empty fb.message ? fb.message : '—'}"/>
                </span>
              </div>
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
          document.getElementById("ordToastMsg").textContent  = "Feedback status updated.";
          toast.classList.add("show");
          setTimeout(function() { toast.classList.remove("show"); }, 3500);
        });
      }
    })();
  </script>
</body>
</html>
