<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Offers — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/orders.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/offers.css" />
</head>
<body>
  <div class="admin-layout">
    <jsp:include page="../../templates/admin/sidebar.jsp">
      <jsp:param name="activePage" value="offers"/>
    </jsp:include>

    <main class="main-content">
      <header class="topbar">
        <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
          <button class="hamburger-btn" id="hamburgerBtn"><i class="fa-solid fa-bars"></i></button>
          <div>
            <h2>Offers</h2>
            <p>Create and manage special event offers for customers.</p>
          </div>
        </div>
      </header>

      <!-- Controls -->
      <div class="controls-row">
        <form method="get" action="${pageContext.request.contextPath}/admin/offers" style="display:contents;">

          <select name="status" class="filter-select" onchange="this.form.submit()">
            <option value="all"      ${status == 'all'      ? 'selected':''}>All Status</option>
            <option value="Active"   ${status == 'Active'   ? 'selected':''}>Active</option>
            <option value="Inactive" ${status == 'Inactive' ? 'selected':''}>Inactive</option>
            <option value="Expired"  ${status == 'Expired'  ? 'selected':''}>Expired</option>
          </select>

          <div class="search-wrap">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" name="search" class="search-input"
                   placeholder="Search…" value="${fn:escapeXml(search)}" />
            <div class="search-divider"></div>
            <select name="searchBy" class="searchby-select" onchange="this.form.submit()">
              <option value="title" ${searchBy == 'title' ? 'selected':''}>Title</option>
              <option value="event" ${searchBy == 'event' ? 'selected':''}>Event</option>
              <option value="code"  ${searchBy == 'code'  ? 'selected':''}>Code</option>
            </select>
            <button type="submit" class="search-btn" title="Search">
              <i class="fa-solid fa-magnifying-glass"></i>
            </button>
          </div>
        </form>

        <a href="${pageContext.request.contextPath}/admin/offers?action=new" class="add-offer-btn">
          <i class="fa-solid fa-plus"></i> Add Offer
        </a>
      </div>

      <!-- Table -->
      <div class="panel">
        <div class="table-wrap">
          <table class="orders-table">
            <colgroup>
              <col style="width:4%;"/>
              <col style="width:20%;"/>
              <col style="width:13%;"/>
              <col style="width:10%;"/>
              <col style="width:9%;"/>
              <col style="width:10%;"/>
              <col style="width:10%;"/>
              <col style="width:10%;"/>
              <col style="width:14%;"/>
            </colgroup>
            <thead>
              <tr>
                <th>No</th>
                <th class="th-name">Title</th>
                <th>Event</th>
                <th>Code</th>
                <th>Type</th>
                <th>Value</th>
                <th>Start</th>
                <th>End</th>
                <th>Status / Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty offers}">
                  <c:forEach var="o" items="${offers}" varStatus="s">
                    <tr>
                      <td>${startIndex + s.index + 1}</td>
                      <td class="td-name">
                        <div style="display:flex;align-items:center;gap:9px;">
                          <div class="offer-icon-sm"><i class="fa-solid fa-tag"></i></div>
                          <div>
                            <div class="name-txt"><c:out value="${o.title}"/></div>
                            <c:if test="${not empty o.description}">
                              <div style="font-size:11.5px;color:var(--t3);margin-top:2px;max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                <c:out value="${o.description}"/>
                              </div>
                            </c:if>
                          </div>
                        </div>
                      </td>
                      <td style="font-size:12.5px;"><c:out value="${not empty o.eventName ? o.eventName : '—'}"/></td>
                      <td>
                        <c:choose>
                          <c:when test="${not empty o.discountCode}">
                            <span class="code-badge"><c:out value="${o.discountCode}"/></span>
                          </c:when>
                          <c:otherwise><span style="color:var(--t4);">—</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td style="font-size:12.5px;"><c:out value="${not empty o.discountType ? o.discountType : '—'}"/></td>
                      <td style="font-weight:700;color:var(--t1);">
                        <c:choose>
                          <c:when test="${o.discountType == 'Percentage' and o.discountPercent > 0}">
                            ${o.discountPercent}%
                          </c:when>
                          <c:when test="${o.discountAmount > 0}">
                            $${o.discountAmount}
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td style="font-size:12px;white-space:nowrap;color:var(--t3);">
                        <c:choose>
                          <c:when test="${not empty o.startDate}">
                            <fmt:formatDate value="${o.startDate}" pattern="dd MMM yyyy"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td style="font-size:12px;white-space:nowrap;color:var(--t3);">
                        <c:choose>
                          <c:when test="${not empty o.endDate}">
                            <fmt:formatDate value="${o.endDate}" pattern="dd MMM yyyy"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <div style="display:flex;align-items:center;gap:6px;justify-content:center;flex-wrap:wrap;">
                          <c:set var="stLow" value="${fn:toLowerCase(o.status)}"/>
                          <span class="status-badge ${stLow == 'active' ? 'delivered' : stLow == 'expired' ? 'cancelled' : 'pending'}">
                            <span class="dot"></span><c:out value="${not empty o.status ? o.status : 'Active'}"/>
                          </span>
                          <a href="${pageContext.request.contextPath}/admin/offers?id=${o.id}" class="view-btn" style="padding:4px 9px;">
                            <i class="fa-solid fa-pen-to-square"></i>
                          </a>
                          <form method="post" action="${pageContext.request.contextPath}/admin/offers"
                                style="display:inline;" onsubmit="return confirm('Delete this offer?');">
                            <input type="hidden" name="action" value="delete"/>
                            <input type="hidden" name="id"     value="${o.id}"/>
                            <button type="submit" class="del-btn" title="Delete">
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
                    <td colspan="9" class="ord-empty">
                      <i class="fa-solid fa-tag"></i>
                      <c:choose>
                        <c:when test="${empty search and status == 'all'}">No offers posted yet.</c:when>
                        <c:otherwise>No offers match your search.</c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <%-- Pagination --%>
        <c:url var="prevUrl" value="${pageContext.request.contextPath}/admin/offers">
          <c:param name="search"   value="${search}"/>
          <c:param name="searchBy" value="${searchBy}"/>
          <c:param name="status"   value="${status}"/>
          <c:param name="page"     value="${currentPage - 1}"/>
        </c:url>
        <c:url var="nextUrl" value="${pageContext.request.contextPath}/admin/offers">
          <c:param name="search"   value="${search}"/>
          <c:param name="searchBy" value="${searchBy}"/>
          <c:param name="status"   value="${status}"/>
          <c:param name="page"     value="${currentPage + 1}"/>
        </c:url>

        <div class="pagination-bar">
          <span class="pg-info">
            <c:choose>
              <c:when test="${totalCount > 0}">Showing ${startIndex + 1} to ${startIndex + fn:length(offers)} of ${totalCount} entries</c:when>
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

  <div id="offToast" data-toast="${param.toast}"><span id="offToastIcon"></span><span id="offToastMsg"></span></div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  <script>
    (function() {
      var msgs = { created: ["✅","Offer created successfully."], updated: ["✅","Offer updated."], deleted: ["🗑️","Offer deleted."] };
      var t = document.getElementById("offToast").dataset.toast || "";
      if (msgs[t]) {
        window.addEventListener("load", function() {
          var toast = document.getElementById("offToast");
          document.getElementById("offToastIcon").textContent = msgs[t][0];
          document.getElementById("offToastMsg").textContent  = msgs[t][1];
          toast.classList.add("show");
          setTimeout(function() { toast.classList.remove("show"); }, 3500);
        });
      }
    })();
  </script>
</body>
</html>
