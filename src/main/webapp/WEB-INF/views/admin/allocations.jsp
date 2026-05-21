<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="${pageContext.request.contextPath}/templates/admin/head-common.jsp"/>
  <title>Allocations — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/allocations.css"/>
</head>
<body>
<div class="admin-layout">
  <jsp:include page="${pageContext.request.contextPath}/templates/admin/sidebar.jsp">
    <jsp:param name="activePage" value="allocations"/>
  </jsp:include>

  <main class="main-content">
    <header class="topbar">
      <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
        <button class="hamburger-btn" id="hamburgerBtn"><i class="fa-solid fa-bars"></i></button>
        <div>
          <h2>Issue / Allocation</h2>
          <p>Assign furniture items to users or departments and track returns.</p>
        </div>
      </div>
    </header>

    <!-- Stat cards -->
    <div class="alloc-stats">
      <div class="alloc-stat-card">
        <div class="alloc-stat-icon si-blue"><i class="fa-solid fa-boxes-stacked"></i></div>
        <div><div class="alloc-stat-val">${totalAll}</div><div class="alloc-stat-lbl">Total</div></div>
      </div>
      <div class="alloc-stat-card">
        <div class="alloc-stat-icon si-green"><i class="fa-solid fa-arrow-right-from-bracket"></i></div>
        <div><div class="alloc-stat-val">${countIssued}</div><div class="alloc-stat-lbl">Issued</div></div>
      </div>
      <div class="alloc-stat-card">
        <div class="alloc-stat-icon si-green" style="background:#ecfdf5;color:#059669;"><i class="fa-solid fa-rotate-left"></i></div>
        <div><div class="alloc-stat-val">${countReturned}</div><div class="alloc-stat-lbl">Returned</div></div>
      </div>
      <div class="alloc-stat-card">
        <div class="alloc-stat-icon si-red"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div><div class="alloc-stat-val">${countOverdue}</div><div class="alloc-stat-lbl">Overdue</div></div>
      </div>
    </div>

    <!-- Controls -->
    <div class="controls-row">
      <form method="get" action="${pageContext.request.contextPath}/admin/allocations"
            style="display:contents;">
        <select name="status" class="filter-select" onchange="this.form.submit()">
          <option value="all"      ${status == 'all'      ? 'selected' : ''}>All Status</option>
          <option value="Issued"   ${status == 'Issued'   ? 'selected' : ''}>Issued</option>
          <option value="Returned" ${status == 'Returned' ? 'selected' : ''}>Returned</option>
          <option value="Overdue"  ${status == 'Overdue'  ? 'selected' : ''}>Overdue</option>
        </select>
        <div class="search-wrap">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <input type="text" name="search" class="search-input"
                 placeholder="Search product or person..." value="${fn:escapeXml(search)}"/>
          <button type="submit" class="search-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
      </form>
      <a href="${pageContext.request.contextPath}/admin/allocations?action=new" class="btn-new-alloc">
        <i class="fa-solid fa-plus"></i> New Allocation
      </a>
    </div>

    <!-- Table -->
    <div class="panel">
      <div class="table-wrap">
        <table class="alloc-table">
          <thead>
            <tr>
              <th class="col-alno">No</th>
              <th class="col-prod">Product</th>
              <th class="col-alloc">Allocated To</th>
              <th class="col-qty">Qty</th>
              <th class="col-issue">Issue Date</th>
              <th class="col-expret">Exp. Return</th>
              <th class="col-status">Status</th>
              <th class="col-act"></th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty allocations}">
                <c:forEach var="a" items="${allocations}" varStatus="s">
                  <tr>
                    <td class="col-alno">${startIndex + s.index + 1}</td>
                    <td class="col-prod">
                      <div class="prod-cell">
                        <c:choose>
                          <c:when test="${not empty a.productImage}">
                            <img class="prod-thumb"
                                 src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(a.productImage)}"
                                 alt=""/>
                          </c:when>
                          <c:otherwise>
                            <div class="prod-thumb-ph"><i class="fa-solid fa-couch"></i></div>
                          </c:otherwise>
                        </c:choose>
                        <div>
                          <div class="prod-name"><c:out value="${a.productName}"/></div>
                          <div class="prod-cat"><c:out value="${a.productCategory}"/></div>
                        </div>
                      </div>
                    </td>
                    <td class="col-alloc"><c:out value="${a.allocatedTo}"/></td>
                    <td class="col-qty" style="text-align:center;">${a.quantity}</td>
                    <td class="col-issue">
                      <c:if test="${not empty a.issueDate}">
                        <fmt:formatDate value="${a.issueDate}" pattern="dd MMM yyyy"/>
                      </c:if>
                    </td>
                    <td class="col-expret">
                      <c:choose>
                        <c:when test="${not empty a.expectedReturnDate}">
                          <fmt:formatDate value="${a.expectedReturnDate}" pattern="dd MMM yyyy"/>
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                      </c:choose>
                    </td>
                    <td class="col-status">
                      <c:choose>
                        <c:when test="${a.status == 'Issued'}">
                          <span class="status-badge s-issued">Issued</span>
                        </c:when>
                        <c:when test="${a.status == 'Returned'}">
                          <span class="status-badge s-returned">Returned</span>
                        </c:when>
                        <c:otherwise>
                          <span class="status-badge s-overdue">Overdue</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="col-act action-cell">
                      <button class="dot-btn" onclick="toggleAlDD(event,'${a.id}')">⋯</button>
                      <div class="al-dropdown" id="ald_${a.id}">
                        <c:if test="${a.status != 'Returned'}">
                          <form class="al-dd-form" method="post"
                                action="${pageContext.request.contextPath}/admin/allocations">
                            <input type="hidden" name="action" value="return"/>
                            <input type="hidden" name="id" value="${a.id}"/>
                            <button type="submit" class="al-item ok">
                              <i class="fa-solid fa-rotate-left"></i> Mark Returned
                            </button>
                          </form>
                          <div class="al-sep"></div>
                        </c:if>
                        <form class="al-dd-form" method="post"
                              action="${pageContext.request.contextPath}/admin/allocations">
                          <input type="hidden" name="action" value="delete"/>
                          <input type="hidden" name="id" value="${a.id}"/>
                          <button type="submit" class="al-item danger"
                                  onclick="return confirm('Delete this allocation record?')">
                            <i class="fa-solid fa-trash"></i> Delete
                          </button>
                        </form>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="8" class="al-empty">
                    <i class="fa-solid fa-boxes-stacked"></i>
                    No allocations found.
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

      <%-- Pagination --%>
      <c:url var="prevUrl" value="${pageContext.request.contextPath}/admin/allocations">
        <c:param name="search" value="${search}"/>
        <c:param name="status" value="${status}"/>
        <c:param name="page"   value="${currentPage - 1}"/>
      </c:url>
      <c:url var="nextUrl" value="${pageContext.request.contextPath}/admin/allocations">
        <c:param name="search" value="${search}"/>
        <c:param name="status" value="${status}"/>
        <c:param name="page"   value="${currentPage + 1}"/>
      </c:url>
      <div class="pagination-bar">
        <span class="pg-info">
          <c:choose>
            <c:when test="${totalCount > 0}">
              Showing ${startIndex + 1} to ${startIndex + fn:length(allocations)} of ${totalCount}
            </c:when>
            <c:otherwise>No entries</c:otherwise>
          </c:choose>
        </span>
        <div class="pg-controls">
          <span class="pg-label">Page ${currentPage} of ${totalPages}</span>
          <c:choose>
            <c:when test="${currentPage > 1}"><a href="${prevUrl}" class="pg-btn">Previous</a></c:when>
            <c:otherwise><button class="pg-btn" disabled>Previous</button></c:otherwise>
          </c:choose>
          <c:choose>
            <c:when test="${currentPage < totalPages}"><a href="${nextUrl}" class="pg-btn">Next</a></c:when>
            <c:otherwise><button class="pg-btn" disabled>Next</button></c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </main>
</div>

<div id="alToast" data-toast="${param.toast}">
  <span id="alToastIcon"></span><span id="alToastMsg"></span>
</div>

<script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
<script>
  function toggleAlDD(e, id) {
    e.stopPropagation();
    var btn = e.currentTarget;
    var dd  = document.getElementById("ald_" + id);
    if (!dd) return;
    var isOpen = dd.classList.contains("open");
    document.querySelectorAll(".al-dropdown.open").forEach(function(d) { d.classList.remove("open"); });
    if (!isOpen) {
      var rect = btn.getBoundingClientRect();
      dd.style.top   = (rect.bottom + 4) + "px";
      dd.style.right = (window.innerWidth - rect.right) + "px";
      dd.style.left  = "auto";
      dd.classList.add("open");
    }
  }
  document.addEventListener("click", function() {
    document.querySelectorAll(".al-dropdown.open").forEach(function(d) { d.classList.remove("open"); });
  });

  (function() {
    var msgs = {
      created:  ["✅","Allocation created successfully."],
      returned: ["✅","Marked as returned."],
      deleted:  ["🗑️","Allocation deleted."],
      error:    ["❌","Something went wrong. Please try again."]
    };
    var key = document.getElementById("alToast").dataset.toast || "";
    if (msgs[key]) {
      window.addEventListener("load", function() {
        document.getElementById("alToastIcon").textContent = msgs[key][0];
        document.getElementById("alToastMsg").textContent  = msgs[key][1];
        var el = document.getElementById("alToast");
        el.classList.add("show");
        setTimeout(function() { el.classList.remove("show"); }, 3500);
      });
    }
  })();
</script>
</body>
</html>
