<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Return Orders — Kathmandu Furniture Admin</title>
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
            <h2>Return Orders</h2>
            <p>View and manage customer return requests after delivery.</p>
          </div>
        </div>
      </header>

      <%-- Export URL --%>
      <c:url var="exportUrl" value="${pageContext.request.contextPath}/admin/return-orders">
        <c:param name="export"   value="csv"/>
        <c:param name="search"   value="${search}"/>
        <c:param name="searchBy" value="${searchBy}"/>
        <c:param name="status"   value="${status}"/>
      </c:url>

      <!-- Controls -->
      <div class="controls-row">
        <form method="get" action="${pageContext.request.contextPath}/admin/return-orders" style="display:contents;">

          <select name="status" class="filter-select" onchange="this.form.submit()">
            <option value="all"       ${status == 'all'       ? 'selected':''}>All Status</option>
            <option value="Pending"   ${status == 'Pending'   ? 'selected':''}>Pending</option>
            <option value="Approved"  ${status == 'Approved'  ? 'selected':''}>Approved</option>
            <option value="Rejected"  ${status == 'Rejected'  ? 'selected':''}>Rejected</option>
            <option value="Completed" ${status == 'Completed' ? 'selected':''}>Completed</option>
          </select>

          <div class="search-wrap">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" name="search" class="search-input"
                   placeholder="Search…" value="${fn:escapeXml(search)}" />
            <div class="search-divider"></div>
            <select name="searchBy" class="searchby-select" onchange="this.form.submit()">
              <option value="name"    ${searchBy == 'name'    ? 'selected':''}>Customer</option>
              <option value="id"      ${searchBy == 'id'      ? 'selected':''}>Return ID</option>
              <option value="orderid" ${searchBy == 'orderid' ? 'selected':''}>Order ID</option>
              <option value="phone"   ${searchBy == 'phone'   ? 'selected':''}>Phone</option>
              <option value="product" ${searchBy == 'product' ? 'selected':''}>Product</option>
            </select>
            <button type="submit" class="search-btn" title="Search">
              <i class="fa-solid fa-magnifying-glass"></i>
            </button>
          </div>
        </form>

        <a href="${exportUrl}" class="export-btn">
          <i class="fa-solid fa-file-csv"></i> Export CSV
          <i class="fa-solid fa-arrow-down" style="font-size:10px;"></i>
        </a>
      </div>

      <!-- Table -->
      <div class="panel">
        <div class="table-wrap">
          <table class="orders-table">
            <colgroup>
              <col style="width:4%;"/>
              <col style="width:8%;"/>
              <col style="width:7%;"/>
              <col style="width:14%;"/>
              <col style="width:10%;"/>
              <col style="width:12%;"/>
              <col style="width:14%;"/>
              <col style="width:10%;"/>
              <col style="width:11%;"/>
              <col style="width:10%;"/>
            </colgroup>
            <thead>
              <tr>
                <th>No</th>
                <th>Return ID</th>
                <th>Order ID</th>
                <th class="th-name">Customer</th>
                <th>Phone</th>
                <th>Product</th>
                <th>Reason</th>
                <th>Return Date</th>
                <th>Status</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty returns}">
                  <c:forEach var="r" items="${returns}" varStatus="s">
                    <c:set var="initials" value="${not empty r.customer ? fn:substring(r.customer,0,1) : '?'}"/>
                    <tr>
                      <td>${startIndex + s.index + 1}</td>
                      <td class="col-oid">RET-${r.returnId}</td>
                      <td class="col-oid">ORD-${r.orderId}</td>
                      <td class="td-name">
                        <div class="name-cell">
                          <div class="order-avatar"><c:out value="${initials}"/></div>
                          <span class="name-txt"><c:out value="${not empty r.customer ? r.customer : '—'}"/></span>
                        </div>
                      </td>
                      <td style="font-family:'Courier New',monospace;font-size:12px;">
                        <c:out value="${not empty r.phoneNumber ? r.phoneNumber : '—'}"/>
                      </td>
                      <td><c:out value="${not empty r.product ? r.product : '—'}"/></td>
                      <td class="td-addr" style="font-size:12.5px;">
                        <c:out value="${not empty r.reason ? r.reason : '—'}"/>
                      </td>
                      <td style="white-space:nowrap;font-size:12.5px;">
                        <c:out value="${not empty r.returnDate ? r.returnDate : '—'}"/>
                      </td>
                      <td>
                        <c:set var="stLow" value="${fn:toLowerCase(r.status)}"/>
                        <c:choose>
                          <c:when test="${not empty r.status}">
                            <span class="status-badge ${stLow}">
                              <span class="dot"></span><c:out value="${r.status}"/>
                            </span>
                          </c:when>
                          <c:otherwise><span style="color:var(--t4);">—</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/return-orders?id=${r.returnId}" class="view-btn">
                          <i class="fa-regular fa-eye"></i> View
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="10" class="ord-empty">
                      <i class="fa-solid fa-rotate-left"></i>
                      <c:choose>
                        <c:when test="${empty search and status == 'all'}">No return orders found.</c:when>
                        <c:otherwise>No return orders match your search.</c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <%-- Pagination --%>
        <c:url var="prevUrl" value="${pageContext.request.contextPath}/admin/return-orders">
          <c:param name="search"   value="${search}"/>
          <c:param name="searchBy" value="${searchBy}"/>
          <c:param name="status"   value="${status}"/>
          <c:param name="page"     value="${currentPage - 1}"/>
        </c:url>
        <c:url var="nextUrl" value="${pageContext.request.contextPath}/admin/return-orders">
          <c:param name="search"   value="${search}"/>
          <c:param name="searchBy" value="${searchBy}"/>
          <c:param name="status"   value="${status}"/>
          <c:param name="page"     value="${currentPage + 1}"/>
        </c:url>

        <div class="pagination-bar">
          <span class="pg-info">
            <c:choose>
              <c:when test="${totalCount > 0}">Showing ${startIndex + 1} to ${startIndex + fn:length(returns)} of ${totalCount} entries</c:when>
              <c:otherwise>No entries found</c:otherwise>
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
