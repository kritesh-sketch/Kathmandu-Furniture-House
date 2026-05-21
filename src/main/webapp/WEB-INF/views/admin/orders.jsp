<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Orders &mdash; Kathmandu Furniture Admin</title>
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
            <h2>Orders</h2>
            <p>View and manage all customer orders.</p>
          </div>
        </div>
      </header>

      <%-- Export URL --%>
      <c:url var="exportUrl" value="/admin/orders">
        <c:param name="export"   value="csv"/>
        <c:param name="search"   value="${search}"/>
        <c:param name="searchBy" value="${searchBy}"/>
        <c:param name="status"   value="${status}"/>
        <c:param name="type"     value="${type}"/>
      </c:url>

      <!-- Controls -->
      <div class="controls-row">
        <form method="get" action="${pageContext.request.contextPath}/admin/orders" style="display:contents;">

          <select name="status" class="filter-select" onchange="this.form.submit()">
            <option value="all"        ${status == 'all'        ? 'selected':''}>All Status</option>
            <option value="Pending"    ${status == 'Pending'    ? 'selected':''}>Pending</option>
            <option value="Confirmed"  ${status == 'Confirmed'  ? 'selected':''}>Confirmed</option>
            <option value="Processing" ${status == 'Processing' ? 'selected':''}>Processing</option>
            <option value="Shipped"    ${status == 'Shipped'    ? 'selected':''}>Shipped</option>
            <option value="Delivered"  ${status == 'Delivered'  ? 'selected':''}>Delivered</option>
            <option value="Cancelled"  ${status == 'Cancelled'  ? 'selected':''}>Cancelled</option>
          </select>

          <select name="type" class="filter-select" onchange="this.form.submit()">
            <option value="all"       ${type == 'all'       ? 'selected':''}>All Types</option>
            <option value="Normal"    ${type == 'Normal'    ? 'selected':''}>Normal</option>
            <option value="Customize" ${type == 'Customize' ? 'selected':''}>Customize</option>
          </select>

          <div class="search-wrap">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" name="search" class="search-input"
                   placeholder="Search..." value="${fn:escapeXml(search)}" />
            <div class="search-divider"></div>
            <select name="searchBy" class="searchby-select" onchange="this.form.submit()">
              <option value="name"    ${searchBy == 'name'    ? 'selected':''}>Name</option>
              <option value="id"      ${searchBy == 'id'      ? 'selected':''}>Order ID</option>
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
              <col class="col-no"/>
              <col class="col-oid"/>
              <col class="col-name"/>
              <col class="col-phone"/>
              <col class="col-addr"/>
              <col class="col-product"/>
              <col class="col-qty"/>
              <col class="col-type"/>
              <col class="col-pay"/>
              <col class="col-action"/>
            </colgroup>
            <thead>
              <tr>
                <th>No</th>
                <th>Order ID</th>
                <th class="th-name">Full Name</th>
                <th>Phone</th>
                <th>Delivery Address</th>
                <th>Product</th>
                <th>Qty</th>
                <th>Type</th>
                <th>Payment</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty orders}">
                  <c:forEach var="o" items="${orders}" varStatus="s">
                    <c:set var="initials" value="${not empty o.fullName ? fn:substring(o.fullName,0,1) : '?'}"/>
                    <tr>
                      <td>${startIndex + s.index + 1}</td>
                      <td class="col-oid">ORD-${o.id}</td>
                      <td class="td-name">
                        <div class="name-cell">
                          <div class="order-avatar"><c:out value="${initials}"/></div>
                          <span class="name-txt"><c:out value="${not empty o.fullName ? o.fullName : '&mdash;'}"/></span>
                        </div>
                      </td>
                      <td style="font-family:'Courier New',monospace;font-size:12px;">
                        <c:out value="${not empty o.phoneNumber ? o.phoneNumber : '&mdash;'}"/>
                      </td>
                      <td class="td-addr" style="font-size:12.5px;">
                        <c:out value="${not empty o.deliveryLocation ? o.deliveryLocation : '&mdash;'}"/>
                      </td>
                      <td><c:out value="${not empty o.furnitureType ? o.furnitureType : '&mdash;'}"/></td>
                      <td style="font-weight:700;color:var(--t1);">${o.quantity > 0 ? o.quantity : '&mdash;'}</td>
                      <td>
                        <c:choose>
                          <c:when test="${fn:toLowerCase(o.orderType) == 'customize'}">
                            <span class="type-badge customize"><c:out value="${o.orderType}"/></span>
                          </c:when>
                          <c:when test="${not empty o.orderType}">
                            <span class="type-badge normal"><c:out value="${o.orderType}"/></span>
                          </c:when>
                          <c:otherwise><span style="color:var(--t4);">&mdash;</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td style="font-size:12.5px;"><c:out value="${not empty o.paymentMethod ? o.paymentMethod : '&mdash;'}"/></td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/orders?id=${o.id}" class="view-btn">
                          <i class="fa-regular fa-eye"></i> View
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="10" class="ord-empty">
                      <i class="fa-solid fa-clipboard-list"></i>
                      <c:choose>
                        <c:when test="${empty search and status == 'all' and type == 'all'}">No orders found.</c:when>
                        <c:otherwise>No orders match your search.</c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <%-- Pagination --%>
        <c:url var="prevUrl" value="/admin/orders">
          <c:param name="search" value="${search}"/><c:param name="searchBy" value="${searchBy}"/>
          <c:param name="status" value="${status}"/><c:param name="type" value="${type}"/>
          <c:param name="page"   value="${currentPage - 1}"/>
        </c:url>
        <c:url var="nextUrl" value="/admin/orders">
          <c:param name="search" value="${search}"/><c:param name="searchBy" value="${searchBy}"/>
          <c:param name="status" value="${status}"/><c:param name="type" value="${type}"/>
          <c:param name="page"   value="${currentPage + 1}"/>
        </c:url>

        <div class="pagination-bar">
          <span class="pg-info">
            <c:choose>
              <c:when test="${totalCount > 0}">Showing ${startIndex + 1} to ${startIndex + fn:length(orders)} of ${totalCount} entries</c:when>
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

  <div id="ordToast"><span id="ordToastIcon"></span><span id="ordToastMsg"></span></div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
</body>
</html>
