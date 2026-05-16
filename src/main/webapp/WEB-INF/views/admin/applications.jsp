<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Applications — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/applications.css" />
</head>

<body>
  <div class="admin-layout">
    <jsp:include page="../../templates/admin/sidebar.jsp">
      <jsp:param name="activePage" value="applications"/>
    </jsp:include>

    <main class="main-content">

      <header class="topbar">
        <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
          <button class="hamburger-btn" id="hamburgerBtn">
            <i class="fa-solid fa-bars"></i>
          </button>
          <div>
            <h2>Applications</h2>
            <p>View and manage job applications submitted by candidates.</p>
          </div>
        </div>
      </header>

      <!-- Controls row -->
      <div class="controls-row">
        <form method="get" action="${pageContext.request.contextPath}/admin/applications"
              style="display:contents;">

          <select name="vacancyId" class="filter-select" onchange="this.form.submit()">
            <option value="0" ${vacancyId == 0 ? 'selected' : ''}>All Vacancies</option>
            <c:forEach var="v" items="${vacancies}">
              <option value="${v.id}" ${vacancyId == v.id ? 'selected' : ''}>
                <c:out value="${v.title}"/>
              </option>
            </c:forEach>
          </select>

          <select name="status" class="filter-select" onchange="this.form.submit()">
            <option value="all"        ${statusFilter == 'all'        ? 'selected' : ''}>All Status</option>
            <option value="Pending"    ${statusFilter == 'Pending'    ? 'selected' : ''}>Pending</option>
            <option value="Reviewed"   ${statusFilter == 'Reviewed'   ? 'selected' : ''}>Reviewed</option>
            <option value="Shortlisted"${statusFilter == 'Shortlisted'? 'selected' : ''}>Shortlisted</option>
            <option value="Rejected"   ${statusFilter == 'Rejected'   ? 'selected' : ''}>Rejected</option>
          </select>

          <div class="search-wrap">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" name="search" class="search-input"
                   placeholder="Search by name or email…" value="${fn:escapeXml(search)}" />
            <button type="submit" class="search-btn" title="Search">
              <i class="fa-solid fa-magnifying-glass"></i>
            </button>
          </div>
        </form>

        <a href="${pageContext.request.contextPath}/admin/job-vacancies" class="manage-vacancies-btn">
          <i class="fa-solid fa-briefcase"></i> Manage Vacancies
        </a>
      </div>

      <!-- Table panel -->
      <div class="panel">
        <div class="table-wrap">
          <table class="app-table">
            <thead>
              <tr>
                <th>No</th>
                <th>Applicant</th>
                <th>Applied For</th>
                <th>Phone</th>
                <th>Applied On</th>
                <th>Resume</th>
                <th>Status</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty applications}">
                  <c:forEach var="a" items="${applications}" varStatus="s">
                    <tr>
                      <td class="col-no">${startIndex + s.index + 1}</td>
                      <td>
                        <div class="app-cell">
                          <div class="app-avatar">
                            ${fn:substring(a.applicantName, 0, 1)}
                          </div>
                          <div>
                            <div class="app-name"><c:out value="${a.applicantName}"/></div>
                            <div class="app-email"><c:out value="${not empty a.email ? a.email : '—'}"/></div>
                          </div>
                        </div>
                      </td>
                      <td>
                        <span class="vacancy-badge">
                          <c:out value="${not empty a.vacancyTitle ? a.vacancyTitle : '—'}"/>
                        </span>
                      </td>
                      <td style="font-family:'Courier New',monospace;font-size:12.5px;">
                        <c:out value="${not empty a.phone ? a.phone : '—'}"/>
                      </td>
                      <td style="font-size:13px;color:var(--t3);white-space:nowrap;">
                        <c:choose>
                          <c:when test="${not empty a.appliedAt}">
                            <fmt:formatDate value="${a.appliedAt}" pattern="dd MMM yyyy"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${not empty a.resumePath}">
                            <a href="${pageContext.request.contextPath}/static/images/${fn:escapeXml(a.resumePath)}"
                               class="resume-btn" target="_blank" download>
                              <i class="fa-solid fa-file-arrow-down"></i> Download
                            </a>
                          </c:when>
                          <c:otherwise><span style="color:var(--t4);font-size:13px;">—</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${a.status == 'Shortlisted'}">
                            <span class="app-status shortlisted">Shortlisted</span>
                          </c:when>
                          <c:when test="${a.status == 'Reviewed'}">
                            <span class="app-status reviewed">Reviewed</span>
                          </c:when>
                          <c:when test="${a.status == 'Rejected'}">
                            <span class="app-status rejected">Rejected</span>
                          </c:when>
                          <c:otherwise>
                            <span class="app-status pending">Pending</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <button class="dot-btn" onclick="toggleDD(event,'${a.id}')">⋯</button>
                        <div class="app-dropdown" id="dd_${a.id}">
                          <c:forEach var="st" items="${['Pending','Reviewed','Shortlisted','Rejected']}">
                            <form method="post" action="${pageContext.request.contextPath}/admin/applications" class="dd-form">
                              <input type="hidden" name="action"    value="status"/>
                              <input type="hidden" name="id"        value="${a.id}"/>
                              <input type="hidden" name="newStatus" value="${st}"/>
                              <button type="submit" class="dd-item ${st == 'Rejected' ? 'danger' : st == 'Shortlisted' ? 'approve' : ''}">
                                <c:out value="${st}"/>
                              </button>
                            </form>
                          </c:forEach>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="8" class="app-empty">
                      <i class="fa-regular fa-folder-open"></i>
                      No applications found.
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <c:url var="prevUrl" value="${pageContext.request.contextPath}/admin/applications">
          <c:param name="search"     value="${search}"/>
          <c:param name="status"     value="${statusFilter}"/>
          <c:param name="vacancyId"  value="${vacancyId}"/>
          <c:param name="page"       value="${currentPage - 1}"/>
        </c:url>
        <c:url var="nextUrl" value="${pageContext.request.contextPath}/admin/applications">
          <c:param name="search"     value="${search}"/>
          <c:param name="status"     value="${statusFilter}"/>
          <c:param name="vacancyId"  value="${vacancyId}"/>
          <c:param name="page"       value="${currentPage + 1}"/>
        </c:url>

        <div class="pagination-bar">
          <span class="pg-info">
            <c:choose>
              <c:when test="${totalCount > 0}">
                Showing ${startIndex + 1} to ${startIndex + fn:length(applications)} of ${totalCount} entries
              </c:when>
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

  <div id="appToast" data-toast="${param.toast}">
    <span id="appToastIcon"></span>
    <span id="appToastMsg"></span>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  <script>
    function toggleDD(e, id) {
      e.stopPropagation();
      document.querySelectorAll(".app-dropdown.open").forEach(function(d) {
        if (d.id !== "dd_" + id) d.classList.remove("open");
      });
      var dd = document.getElementById("dd_" + id);
      if (dd) dd.classList.toggle("open");
    }
    document.addEventListener("click", function() {
      document.querySelectorAll(".app-dropdown.open").forEach(function(d) { d.classList.remove("open"); });
    });

    (function() {
      var msgs = { updated: ["✅", "Application status updated."], error: ["❌", "Something went wrong."] };
      var t = document.getElementById("appToast").dataset.toast || "";
      if (msgs[t]) {
        window.addEventListener("load", function() {
          document.getElementById("appToastIcon").textContent = msgs[t][0];
          document.getElementById("appToastMsg").textContent  = msgs[t][1];
          var el = document.getElementById("appToast");
          el.classList.add("show");
          setTimeout(function() { el.classList.remove("show"); }, 3500);
        });
      }
    })();
  </script>
</body>
</html>
