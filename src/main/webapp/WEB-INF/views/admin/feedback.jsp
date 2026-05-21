<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Feedback — Kathmandu Furniture Admin</title>
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
            <h2>Feedback</h2>
            <p>Review customer feedback and comments.</p>
          </div>
        </div>
      </header>

      <%-- Export URL --%>
      <c:url var="exportUrl" value="${pageContext.request.contextPath}/admin/feedback">
        <c:param name="export"   value="csv"/>
        <c:param name="search"   value="${search}"/>
        <c:param name="searchBy" value="${searchBy}"/>
        <c:param name="status"   value="${status}"/>
      </c:url>

      <!-- Controls -->
      <div class="controls-row">
        <form method="get" action="${pageContext.request.contextPath}/admin/feedback" style="display:contents;">

          <select name="status" class="filter-select" onchange="this.form.submit()">
            <option value="all"      ${status == 'all'      ? 'selected':''}>All Status</option>
            <option value="New"      ${status == 'New'      ? 'selected':''}>New</option>
            <option value="Reviewed" ${status == 'Reviewed' ? 'selected':''}>Reviewed</option>
          </select>

          <div class="search-wrap">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" name="search" class="search-input"
                   placeholder="Search..." value="${fn:escapeXml(search)}" />
            <div class="search-divider"></div>
            <select name="searchBy" class="searchby-select" onchange="this.form.submit()">
              <option value="name"    ${searchBy == 'name'    ? 'selected':''}>Name</option>
              <option value="id"      ${searchBy == 'id'      ? 'selected':''}>ID</option>
              <option value="email"   ${searchBy == 'email'   ? 'selected':''}>Email</option>
              <option value="subject" ${searchBy == 'subject' ? 'selected':''}>Subject</option>
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
              <col style="width:7%;"/>
              <col style="width:16%;"/>
              <col style="width:17%;"/>
              <col style="width:18%;"/>
              <col style="width:22%;"/>
              <col style="width:8%;"/>
              <col style="width:8%;"/>
            </colgroup>
            <thead>
              <tr>
                <th>No</th>
                <th>ID</th>
                <th class="th-name">Name</th>
                <th>Email</th>
                <th>Subject</th>
                <th>Message</th>
                <th>Date</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty feedbacks}">
                  <c:forEach var="fb" items="${feedbacks}" varStatus="s">
                    <c:set var="initials" value="${not empty fb.userName ? fn:substring(fb.userName,0,1) : '?'}"/>
                    <tr>
                      <td>${startIndex + s.index + 1}</td>
                      <td class="col-oid">FB-${fb.id}</td>
                      <td class="td-name">
                        <div class="name-cell">
                          <div class="order-avatar" style="${fn:toLowerCase(fb.status) == 'new' ? 'background:var(--gold);' : ''}">
                            <c:out value="${initials}"/>
                          </div>
                          <div>
                            <span class="name-txt"><c:out value="${not empty fb.userName ? fb.userName : '—'}"/></span>
                            <c:if test="${fn:toLowerCase(fb.status) == 'new'}">
                              <span style="display:inline-block;margin-left:6px;background:#ef4444;color:#fff;font-size:9px;font-weight:700;padding:1px 6px;border-radius:20px;vertical-align:middle;">NEW</span>
                            </c:if>
                          </div>
                        </div>
                      </td>
                      <td style="font-size:12.5px;">
                        <span class="trunc" style="max-width:140px;display:inline-block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;vertical-align:bottom;"
                              title="<c:out value='${fb.email}'/>">
                          <c:out value="${not empty fb.email ? fb.email : '—'}"/>
                        </span>
                      </td>
                      <td style="font-size:12.5px;"><c:out value="${not empty fb.subject ? fb.subject : '—'}"/></td>
                      <td class="td-addr" style="font-size:12.5px;">
                        <c:choose>
                          <c:when test="${not empty fb.message and fn:length(fb.message) > 60}">
                            <c:out value="${fn:substring(fb.message, 0, 60)}"/>...
                          </c:when>
                          <c:otherwise><c:out value="${not empty fb.message ? fb.message : '—'}"/></c:otherwise>
                        </c:choose>
                      </td>
                      <td style="white-space:nowrap;font-size:12.5px;color:var(--t3);">
                        <c:choose>
                          <c:when test="${not empty fb.createdAt}">
                            <fmt:formatDate value="${fb.createdAt}" pattern="dd MMM yyyy"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/feedback?id=${fb.id}" class="view-btn">
                          <i class="fa-regular fa-eye"></i> View
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="8" class="ord-empty">
                      <i class="fa-regular fa-comment-dots"></i>
                      <c:choose>
                        <c:when test="${empty search and status == 'all'}">No feedback found.</c:when>
                        <c:otherwise>No feedback matches your search.</c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <%-- Pagination --%>
        <c:url var="prevUrl" value="${pageContext.request.contextPath}/admin/feedback">
          <c:param name="search"   value="${search}"/>
          <c:param name="searchBy" value="${searchBy}"/>
          <c:param name="status"   value="${status}"/>
          <c:param name="page"     value="${currentPage - 1}"/>
        </c:url>
        <c:url var="nextUrl" value="${pageContext.request.contextPath}/admin/feedback">
          <c:param name="search"   value="${search}"/>
          <c:param name="searchBy" value="${searchBy}"/>
          <c:param name="status"   value="${status}"/>
          <c:param name="page"     value="${currentPage + 1}"/>
        </c:url>

        <div class="pagination-bar">
          <span class="pg-info">
            <c:choose>
              <c:when test="${totalCount > 0}">Showing ${startIndex + 1} to ${startIndex + fn:length(feedbacks)} of ${totalCount} entries</c:when>
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

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
</body>
</html>
