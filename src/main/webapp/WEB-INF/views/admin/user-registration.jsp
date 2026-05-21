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

    <main class="main-content">

      <header class="topbar">
        <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
          <button class="hamburger-btn" id="hamburgerBtn">
            <i class="fa-solid fa-bars"></i>
          </button>
          <div>
            <h2>User Registration</h2>
            <p style="white-space:normal;">Review and manage all registered users.</p>
          </div>
        </div>
      </header>

      <!-- Stat cards -->
      <div class="ur-stats-row">
        <div class="ur-stat-card">
          <div class="ur-stat-icon si-slate"><i class="fa-solid fa-users"></i></div>
          <div>
            <div class="ur-stat-val">${totalUsers}</div>
            <div class="ur-stat-lbl">Total Users</div>
          </div>
        </div>
        <div class="ur-stat-card">
          <div class="ur-stat-icon si-green"><i class="fa-solid fa-user-check"></i></div>
          <div>
            <div class="ur-stat-val">${countActive}</div>
            <div class="ur-stat-lbl">Active</div>
          </div>
        </div>
        <div class="ur-stat-card">
          <div class="ur-stat-icon si-amber"><i class="fa-regular fa-clock"></i></div>
          <div>
            <div class="ur-stat-val">${countPending}</div>
            <div class="ur-stat-lbl">Pending</div>
          </div>
        </div>
        <div class="ur-stat-card">
          <div class="ur-stat-icon si-gray"><i class="fa-solid fa-user-slash"></i></div>
          <div>
            <div class="ur-stat-val">${countInactive}</div>
            <div class="ur-stat-lbl">Inactive</div>
          </div>
        </div>
      </div>

      <%-- Export URL preserving filters --%>
      <c:url var="exportUrl" value="${pageContext.request.contextPath}/admin/user-registration">
        <c:param name="export"   value="csv"/>
        <c:param name="search"   value="${search}"/>
        <c:param name="searchBy" value="${searchBy}"/>
        <c:param name="gender"   value="${gender}"/>
        <c:param name="status"   value="${status}"/>
      </c:url>

      <!-- Controls row -->
      <div class="controls-row">
        <form method="get" action="${pageContext.request.contextPath}/admin/user-registration"
              style="display:contents;">

          <select name="status" class="filter-select" onchange="this.form.submit()">
            <option value="all"      ${status == 'all'      ? 'selected' : ''}>All Status</option>
            <option value="Active"   ${status == 'Active'   ? 'selected' : ''}>Active</option>
            <option value="Pending"  ${status == 'Pending'  ? 'selected' : ''}>Pending</option>
            <option value="Inactive" ${status == 'Inactive' ? 'selected' : ''}>Inactive</option>
          </select>

          <select name="gender" class="filter-select" onchange="this.form.submit()">
            <option value="all"    ${gender == 'all'    ? 'selected' : ''}>All Genders</option>
            <option value="Male"   ${gender == 'Male'   ? 'selected' : ''}>Male</option>
            <option value="Female" ${gender == 'Female' ? 'selected' : ''}>Female</option>
            <option value="Other"  ${gender == 'Other'  ? 'selected' : ''}>Other</option>
          </select>

          <div class="search-wrap">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" name="search" class="search-input"
                   placeholder="Search..." value="${fn:escapeXml(search)}" />
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
                <th class="col-no">No</th>
                <th class="col-uid">User ID</th>
                <th class="col-name">Name</th>
                <th class="col-email">Email</th>
                <th class="col-phone">Phone No.</th>
                <th class="col-dob">DOB</th>
                <th class="col-status">Status</th>
                <th class="col-reg">Registered</th>
                <th class="col-action"></th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty users}">
                  <c:forEach var="user" items="${users}" varStatus="s">
                    <tr>
                      <td class="col-no">${startIndex + s.index + 1}</td>
                      <td class="col-uid">USR-${user.id}</td>
                      <td class="col-name">
                        <span class="name-txt"><c:out value="${user.fullName}"/></span>
                      </td>
                      <td class="col-email">
                        <span class="trunc" title="<c:out value='${user.email}'/>">
                          <c:out value="${not empty user.email ? user.email : '—'}"/>
                        </span>
                      </td>
                      <td class="col-phone">
                        <c:out value="${not empty user.mobileNumber ? user.mobileNumber : '—'}"/>
                      </td>
                      <td class="col-dob">
                        <c:choose>
                          <c:when test="${not empty user.dob}">
                            <fmt:parseDate value="${user.dob}" pattern="yyyy-MM-dd"
                                           var="parsedDob" parseLocale="en"/>
                            <fmt:formatDate value="${parsedDob}" pattern="dd MMM yyyy"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td class="col-status" style="text-align:center;">
                        <c:choose>
                          <c:when test="${user.status == 'Active'}">
                            <i class="fa-solid fa-user-check status-icon si-active" title="Active"></i>
                          </c:when>
                          <c:when test="${user.status == 'Pending'}">
                            <i class="fa-regular fa-clock status-icon si-pending" title="Pending"></i>
                          </c:when>
                          <c:otherwise>
                            <i class="fa-solid fa-user-slash status-icon si-inactive" title="Inactive"></i>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td class="col-reg">
                        <c:choose>
                          <c:when test="${not empty user.createdAt}">
                            <fmt:formatDate value="${user.createdAt}" pattern="dd MMM yyyy"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td class="col-action action-cell">
                        <button class="dot-btn" onclick="toggleDD(event,'${user.id}')">⋯</button>
                        <div class="ur-dropdown" id="dd_${user.id}">
                          <c:choose>
                            <c:when test="${user.status == 'Pending'}">
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
                            </c:when>
                            <c:when test="${user.status == 'Active'}">
                              <form class="dd-form" method="post"
                                    action="${pageContext.request.contextPath}/admin/user-registration">
                                <input type="hidden" name="userId" value="${user.id}"/>
                                <input type="hidden" name="action" value="deactivate"/>
                                <button type="submit" class="dd-item danger">
                                  <i class="fa-solid fa-user-slash"></i> Deactivate
                                </button>
                              </form>
                            </c:when>
                            <c:otherwise><%-- Inactive --%>
                              <form class="dd-form" method="post"
                                    action="${pageContext.request.contextPath}/admin/user-registration">
                                <input type="hidden" name="userId" value="${user.id}"/>
                                <input type="hidden" name="action" value="activate"/>
                                <button type="submit" class="dd-item approve">
                                  <i class="fa-solid fa-user-check"></i> Activate
                                </button>
                              </form>
                              <div class="dd-sep"></div>
                              <form class="dd-form" method="post"
                                    action="${pageContext.request.contextPath}/admin/user-registration">
                                <input type="hidden" name="userId" value="${user.id}"/>
                                <input type="hidden" name="action" value="reject"/>
                                <button type="submit" class="dd-item danger">
                                  <i class="fa-solid fa-trash"></i> Delete
                                </button>
                              </form>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="9" class="ur-empty">
                      <i class="fa-solid fa-users"></i>
                      <c:choose>
                        <c:when test="${empty search and gender == 'all' and status == 'all'}">
                          No users found.
                        </c:when>
                        <c:otherwise>No users match your filters.</c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <%-- Pagination --%>
        <c:url var="prevUrl" value="${pageContext.request.contextPath}/admin/user-registration">
          <c:param name="search"   value="${search}"/>
          <c:param name="searchBy" value="${searchBy}"/>
          <c:param name="gender"   value="${gender}"/>
          <c:param name="status"   value="${status}"/>
          <c:param name="page"     value="${currentPage - 1}"/>
        </c:url>
        <c:url var="nextUrl" value="${pageContext.request.contextPath}/admin/user-registration">
          <c:param name="search"   value="${search}"/>
          <c:param name="searchBy" value="${searchBy}"/>
          <c:param name="gender"   value="${gender}"/>
          <c:param name="status"   value="${status}"/>
          <c:param name="page"     value="${currentPage + 1}"/>
        </c:url>

        <div class="pagination-bar">
          <span class="pg-info">
            <c:choose>
              <c:when test="${totalCount > 0}">
                Showing ${startIndex + 1} to ${startIndex + fn:length(users)}
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
    function toggleDD(e, id) {
      e.stopPropagation();
      var btn = e.currentTarget;
      var dd  = document.getElementById("dd_" + id);
      if (!dd) return;
      var isOpen = dd.classList.contains("open");
      document.querySelectorAll(".ur-dropdown.open").forEach(function(d) {
        d.classList.remove("open");
      });
      if (!isOpen) {
        var rect = btn.getBoundingClientRect();
        dd.style.top   = (rect.bottom + 4) + "px";
        dd.style.right = (window.innerWidth - rect.right) + "px";
        dd.style.left  = "auto";
        dd.classList.add("open");
      }
    }
    document.addEventListener("click", function() {
      document.querySelectorAll(".ur-dropdown.open")
              .forEach(function(d) { d.classList.remove("open"); });
    });

    function showToast(icon, msg) {
      var t = document.getElementById("urToast");
      document.getElementById("urToastIcon").textContent = icon;
      document.getElementById("urToastMsg").textContent  = msg;
      t.classList.add("show");
      setTimeout(function() { t.classList.remove("show"); }, 3500);
    }
    (function() {
      var msgs = {
        approved:    ["✅", "User approved and activated."],
        rejected:    ["🚫", "User rejected and removed."],
        deactivated: ["⛔", "User deactivated."],
        activated:   ["✅", "User activated."]
      };
      var key = document.getElementById("urToast").dataset.toast || "";
      if (msgs[key]) {
        window.addEventListener("load", function() {
          showToast(msgs[key][0], msgs[key][1]);
        });
      }
    })();
  </script>
</body>
</html>
