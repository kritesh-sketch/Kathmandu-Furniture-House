<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>User Registration — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/user-registration.css" />
</head>

<body>
  <div class="admin-layout">
    <jsp:include page="../../templates/admin/sidebar.jsp">
      <jsp:param name="activePage" value="user-registration"/>
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
            <h2>User Registration</h2>
            <p>Review and manage new user sign-ups — approve or reject access.</p>
          </div>
        </div>
      </header>

      <%-- Build export URL preserving current filters --%>
      <c:url var="exportUrl" value="${pageContext.request.contextPath}/admin/user-registration">
        <c:param name="export"   value="csv"/>
        <c:param name="search"   value="${search}"/>
        <c:param name="searchBy" value="${searchBy}"/>
        <c:param name="gender"   value="${gender}"/>
      </c:url>

      <!-- Controls row — GET form for server-side filter/search -->
      <div class="controls-row">
        <form method="get" action="${pageContext.request.contextPath}/admin/user-registration"
              style="display:contents;">
          <select name="gender" class="filter-select" onchange="this.form.submit()">
            <option value="all"    ${gender == 'all'    ? 'selected' : ''}>All Genders</option>
            <option value="Male"   ${gender == 'Male'   ? 'selected' : ''}>Male</option>
            <option value="Female" ${gender == 'Female' ? 'selected' : ''}>Female</option>
            <option value="Other"  ${gender == 'Other'  ? 'selected' : ''}>Other</option>
          </select>

          <div class="search-wrap">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" name="search" class="search-input"
                   placeholder="Search…" value="${fn:escapeXml(search)}" />
            <div class="search-divider"></div>
            <select name="searchBy" class="searchby-select" onchange="this.form.submit()">
              <option value="name"  ${searchBy == 'name'  ? 'selected' : ''}>Name</option>
              <option value="id"    ${searchBy == 'id'    ? 'selected' : ''}>User ID</option>
              <option value="email" ${searchBy == 'email' ? 'selected' : ''}>Email</option>
              <option value="phone" ${searchBy == 'phone' ? 'selected' : ''}>Phone</option>
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

      <!-- Table panel -->
      <div class="panel">
        <div class="table-wrap">
          <table class="users-table">
            <thead>
              <tr>
                <th style="width:42px;">No</th>
                <th>User ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone No.</th>
                <th>DOB</th>
                <th>Registered</th>
                <th style="width:48px;"></th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty pendingUsers}">
                  <c:forEach var="user" items="${pendingUsers}" varStatus="s">
                    <tr>
                      <td class="col-no">${startIndex + s.index + 1}</td>
                      <td class="col-uid">USR-${user.id}</td>
                      <td>
                        <div class="name-cell">
                          <div class="ur-avatar">
                            ${not empty user.firstName ? fn:substring(user.firstName,0,1) : '?'}${not empty user.lastName ? fn:substring(user.lastName,0,1) : ''}
                          </div>
                          <span class="name-txt"><c:out value="${user.fullName}"/></span>
                        </div>
                      </td>
                      <td>
                        <span class="trunc" title="<c:out value='${user.email}'/>">
                          <c:out value="${not empty user.email ? user.email : '—'}"/>
                        </span>
                      </td>
                      <td style="white-space:nowrap;font-family:'Courier New',monospace;font-size:12.5px;">
                        <c:out value="${not empty user.mobileNumber ? user.mobileNumber : '—'}"/>
                      </td>
                      <td style="font-size:13px;white-space:nowrap;">
                        <c:choose>
                          <c:when test="${not empty user.dob}">
                            <fmt:parseDate value="${user.dob}" pattern="yyyy-MM-dd"
                                           var="parsedDob" parseLocale="en"/>
                            <fmt:formatDate value="${parsedDob}" pattern="dd MMM yyyy"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td style="white-space:nowrap;font-size:13px;color:var(--t3);">
                        <c:choose>
                          <c:when test="${not empty user.createdAt}">
                            <fmt:formatDate value="${user.createdAt}" pattern="dd MMM yyyy"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td class="action-cell">
                        <button class="dot-btn" onclick="toggleDD(event,'${user.id}')">⋯</button>
                        <div class="ur-dropdown" id="dd_${user.id}">
                          <form class="dd-form" method="post"
                                action="${pageContext.request.contextPath}/admin/user-registration">
                            <input type="hidden" name="userId" value="${user.id}"/>
                            <input type="hidden" name="action" value="approve"/>
                            <button type="submit" class="dd-item approve">
                              <i class="fa-solid fa-check"></i> Approve
                            </button>
                          </form>
                          <div class="dd-sep"></div>
                          <form class="dd-form" method="post"
                                action="${pageContext.request.contextPath}/admin/user-registration">
                            <input type="hidden" name="userId" value="${user.id}"/>
                            <input type="hidden" name="action" value="reject"/>
                            <button type="submit" class="dd-item danger">
                              <i class="fa-solid fa-ban"></i> Reject
                            </button>
                          </form>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="8" class="ur-empty">
                      <i class="fa-regular fa-clock"></i>
                      <c:choose>
                        <c:when test="${empty search and gender == 'all'}">
                          No pending users found.
                        </c:when>
                        <c:otherwise>
                          No users match your search.
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
        <c:url var="prevUrl" value="${pageContext.request.contextPath}/admin/user-registration">
          <c:param name="search"   value="${search}"/>
          <c:param name="searchBy" value="${searchBy}"/>
          <c:param name="gender"   value="${gender}"/>
          <c:param name="page"     value="${currentPage - 1}"/>
        </c:url>
        <c:url var="nextUrl" value="${pageContext.request.contextPath}/admin/user-registration">
          <c:param name="search"   value="${search}"/>
          <c:param name="searchBy" value="${searchBy}"/>
          <c:param name="gender"   value="${gender}"/>
          <c:param name="page"     value="${currentPage + 1}"/>
        </c:url>

        <div class="pagination-bar">
          <span class="pg-info">
            <c:choose>
              <c:when test="${totalCount > 0}">
                Showing ${startIndex + 1} to ${startIndex + fn:length(pendingUsers)}
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

  <div id="urToast" data-toast="${param.toast}">
    <span id="urToastIcon"></span>
    <span id="urToastMsg"></span>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  <script>
    /* ── UI only: approve/reject dropdown ── */
    function toggleDD(e, id) {
      e.stopPropagation();
      document.querySelectorAll(".ur-dropdown.open").forEach(function(d) {
        if (d.id !== "dd_" + id) d.classList.remove("open");
      });
      var dd = document.getElementById("dd_" + id);
      if (dd) dd.classList.toggle("open");
    }
    document.addEventListener("click", function() {
      document.querySelectorAll(".ur-dropdown.open")
              .forEach(function(d) { d.classList.remove("open"); });
    });

    /* ── UI only: toast from redirect param ── */
    function showToast(icon, msg) {
      var t = document.getElementById("urToast");
      document.getElementById("urToastIcon").textContent = icon;
      document.getElementById("urToastMsg").textContent  = msg;
      t.classList.add("show");
      setTimeout(function() { t.classList.remove("show"); }, 3500);
    }
    (function() {
      var t = document.getElementById("urToast").dataset.toast || "";
      if (t === "approved") window.addEventListener("load", function() { showToast("✅", "User has been approved."); });
      else if (t === "rejected") window.addEventListener("load", function() { showToast("🚫", "User has been rejected and removed."); });
    })();
  </script>
</body>
</html>
