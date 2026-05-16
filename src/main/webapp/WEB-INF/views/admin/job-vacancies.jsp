<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Job Vacancies — Kathmandu Furniture Admin</title>
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
            <h2>Job Vacancies</h2>
            <p>Create and manage job openings for applicants.</p>
          </div>
        </div>
      </header>

      <div class="controls-row">
        <a href="${pageContext.request.contextPath}/admin/applications" class="detail-back" style="margin-bottom:0;">
          <i class="fa-solid fa-arrow-left"></i> Back to Applications
        </a>
        <a href="${pageContext.request.contextPath}/admin/job-form" class="add-vacancy-btn">
          <i class="fa-solid fa-plus"></i> Add Vacancy
        </a>
      </div>

      <div class="panel">
        <div class="table-wrap">
          <table class="vacancy-table">
            <thead>
              <tr>
                <th>No</th>
                <th>Title</th>
                <th>Department</th>
                <th>Location</th>
                <th>Type</th>
                <th>Salary (Rs.)</th>
                <th>Applications</th>
                <th>Status</th>
                <th>Posted</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty vacancies}">
                  <c:forEach var="v" items="${vacancies}" varStatus="s">
                    <tr>
                      <td class="col-no">${startIndex + s.index + 1}</td>
                      <td class="vac-title"><c:out value="${v.title}"/></td>
                      <td style="font-size:13px;color:var(--t2);">
                        <c:out value="${not empty v.department ? v.department : '—'}"/>
                      </td>
                      <td style="font-size:13px;color:var(--t3);">
                        <c:out value="${not empty v.location ? v.location : '—'}"/>
                      </td>
                      <td>
                        <c:if test="${not empty v.type}">
                          <span class="type-badge"><c:out value="${v.type}"/></span>
                        </c:if>
                        <c:if test="${empty v.type}">—</c:if>
                      </td>
                      <td style="font-size:13px;">
                        <c:choose>
                          <c:when test="${v.salaryMin > 0 or v.salaryMax > 0}">
                            <fmt:formatNumber value="${v.salaryMin}" pattern="#,##0"/> –
                            <fmt:formatNumber value="${v.salaryMax}" pattern="#,##0"/>
                          </c:when>
                          <c:otherwise><span style="color:var(--t4);">—</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/applications?vacancyId=${v.id}"
                           class="app-count-badge">
                          <i class="fa-regular fa-file-lines"></i> ${v.applicationCount}
                        </a>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${v.status == 'Active'}">
                            <span class="vac-status active">Active</span>
                          </c:when>
                          <c:when test="${v.status == 'Closed'}">
                            <span class="vac-status closed">Closed</span>
                          </c:when>
                          <c:otherwise>
                            <span class="vac-status draft">Draft</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td style="font-size:12.5px;color:var(--t3);white-space:nowrap;">
                        <c:if test="${not empty v.createdAt}">
                          <fmt:formatDate value="${v.createdAt}" pattern="dd MMM yyyy"/>
                        </c:if>
                      </td>
                      <td>
                        <div style="display:flex;gap:6px;align-items:center;">
                          <a href="${pageContext.request.contextPath}/admin/job-form?id=${v.id}"
                             class="view-btn">
                            <i class="fa-solid fa-pen-to-square"></i> Edit
                          </a>
                          <form method="post" action="${pageContext.request.contextPath}/admin/job-vacancies"
                                onsubmit="return confirm('Delete this vacancy?');" style="margin:0;">
                            <input type="hidden" name="action" value="delete"/>
                            <input type="hidden" name="id"     value="${v.id}"/>
                            <button type="submit" class="del-vac-btn">
                              <i class="fa-solid fa-trash"></i>
                            </button>
                          </form>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="10" class="app-empty">
                      <i class="fa-solid fa-briefcase"></i>
                      No vacancies yet. <a href="${pageContext.request.contextPath}/admin/job-form">Add one</a>.
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <c:url var="prevUrl" value="${pageContext.request.contextPath}/admin/job-vacancies">
          <c:param name="page" value="${currentPage - 1}"/>
        </c:url>
        <c:url var="nextUrl" value="${pageContext.request.contextPath}/admin/job-vacancies">
          <c:param name="page" value="${currentPage + 1}"/>
        </c:url>

        <div class="pagination-bar">
          <span class="pg-info">
            <c:choose>
              <c:when test="${totalCount > 0}">Showing ${startIndex + 1} to ${startIndex + fn:length(vacancies)} of ${totalCount} entries</c:when>
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

  <div id="vacToast" data-toast="${param.toast}">
    <span id="vacToastIcon"></span><span id="vacToastMsg"></span>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  <script>
    (function() {
      var msgs = {
        added:   ["✅", "Vacancy created successfully."],
        updated: ["✅", "Vacancy updated successfully."],
        deleted: ["🗑️", "Vacancy deleted."],
        error:   ["❌", "Something went wrong."]
      };
      var t = document.getElementById("vacToast").dataset.toast || "";
      if (msgs[t]) {
        window.addEventListener("load", function() {
          document.getElementById("vacToastIcon").textContent = msgs[t][0];
          document.getElementById("vacToastMsg").textContent  = msgs[t][1];
          var el = document.getElementById("vacToast");
          el.classList.add("show");
          setTimeout(function() { el.classList.remove("show"); }, 3500);
        });
      }
    })();
  </script>
</body>
</html>
