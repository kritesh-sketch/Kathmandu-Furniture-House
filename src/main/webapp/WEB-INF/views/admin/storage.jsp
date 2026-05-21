<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Storage &amp; Rack Management — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/storage.css"/>
</head>
<body>
<div class="admin-layout">
  <jsp:include page="../../templates/admin/sidebar.jsp">
    <jsp:param name="activePage" value="storage"/>
  </jsp:include>

  <main class="main-content">
    <header class="topbar">
      <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
        <button class="hamburger-btn" id="hamburgerBtn"><i class="fa-solid fa-bars"></i></button>
        <div>
          <h2>Storage &amp; Rack Management</h2>
          <p>Assign warehouse zones, manage rack numbers, and track furniture locations.</p>
        </div>
      </div>
    </header>

    <!-- Stat Cards -->
    <div class="st-stats">
      <div class="st-stat-card">
        <div class="st-stat-icon si-blue"><i class="fa-solid fa-warehouse"></i></div>
        <div><div class="st-stat-val">${totalLocations}</div><div class="st-stat-lbl">Total Locations</div></div>
      </div>
      <div class="st-stat-card">
        <div class="st-stat-icon si-green"><i class="fa-solid fa-circle-check"></i></div>
        <div><div class="st-stat-val">${countAvailable}</div><div class="st-stat-lbl">Available</div></div>
      </div>
      <div class="st-stat-card">
        <div class="st-stat-icon si-red"><i class="fa-solid fa-box-archive"></i></div>
        <div><div class="st-stat-val">${countFull}</div><div class="st-stat-lbl">Full</div></div>
      </div>
      <div class="st-stat-card">
        <div class="st-stat-icon si-purple"><i class="fa-solid fa-cubes"></i></div>
        <div><div class="st-stat-val">${totalItems}</div><div class="st-stat-lbl">Items Stored</div></div>
      </div>
    </div>

    <!-- Controls -->
    <div class="controls-row">
      <div class="controls-left">
        <div class="st-tabs">
          <a href="${pageContext.request.contextPath}/admin/storage?tab=locations"
             class="st-tab${tab == 'locations' || empty tab ? ' active' : ''}">
            <i class="fa-solid fa-map-pin"></i> Locations
          </a>
          <a href="${pageContext.request.contextPath}/admin/storage?tab=assignments"
             class="st-tab${tab == 'assignments' ? ' active' : ''}">
            <i class="fa-solid fa-cubes"></i> Assignments
          </a>
        </div>
        <form method="get" action="${pageContext.request.contextPath}/admin/storage" style="display:contents;">
          <input type="hidden" name="tab" value="${tab}"/>
          <div class="search-wrap">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" name="search" class="search-input"
                   placeholder="Search..." value="${fn:escapeXml(search)}"/>
            <button type="submit" class="search-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
          </div>
        </form>
      </div>
      <div class="controls-right">
        <c:choose>
          <c:when test="${tab == 'assignments'}">
            <a href="${pageContext.request.contextPath}/admin/storage?action=assign" class="btn-new">
              <i class="fa-solid fa-plus"></i> Assign Product
            </a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/admin/storage?action=newLocation" class="btn-new">
              <i class="fa-solid fa-plus"></i> New Location
            </a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- ── Locations tab ── -->
    <c:if test="${tab == 'locations' || empty tab}">
      <c:choose>
        <c:when test="${not empty locations}">
          <div class="st-grid">
            <c:forEach var="loc" items="${locations}">
              <c:set var="pct" value="${loc.capacity > 0 ? (loc.assignedCount * 100 / loc.capacity) : 0}"/>
              <div class="st-card">
                <div class="st-card-top">
                  <div class="st-zone-icon"><i class="fa-solid fa-map-pin"></i></div>
                  <div class="st-card-actions">
                    <a href="${pageContext.request.contextPath}/admin/storage?action=editLocation&id=${loc.id}"
                       class="st-icon-btn" title="Edit"><i class="fa-solid fa-pen"></i></a>
                    <form method="post" action="${pageContext.request.contextPath}/admin/storage"
                          style="margin:0;" onsubmit="return confirm('Delete this location?')">
                      <input type="hidden" name="action" value="deleteLocation"/>
                      <input type="hidden" name="id" value="${loc.id}"/>
                      <button type="submit" class="st-icon-btn danger" title="Delete">
                        <i class="fa-solid fa-trash"></i>
                      </button>
                    </form>
                  </div>
                </div>
                <div>
                  <div class="st-rack-label">Rack <c:out value="${loc.rackNumber}"/></div>
                  <div class="st-zone-label"><c:out value="${loc.zone}"/></div>
                </div>
                <c:if test="${not empty loc.description}">
                  <div class="st-desc"><c:out value="${loc.description}"/></div>
                </c:if>
                <c:if test="${loc.capacity > 0}">
                  <div>
                    <div class="st-cap-row">
                      <span>${loc.assignedCount} / ${loc.capacity} items</span>
                      <span>${pct}%</span>
                    </div>
                    <div class="st-cap-bar">
                      <div class="st-cap-fill${pct >= 100 ? ' full' : pct >= 75 ? ' warn' : ''}"
                           style="width:${pct > 100 ? 100 : pct}%"></div>
                    </div>
                  </div>
                </c:if>
                <div style="display:flex;align-items:center;justify-content:space-between;">
                  <c:choose>
                    <c:when test="${loc.status == 'Available'}">
                      <span class="st-badge sb-available">Available</span>
                    </c:when>
                    <c:when test="${loc.status == 'Full'}">
                      <span class="st-badge sb-full">Full</span>
                    </c:when>
                    <c:otherwise>
                      <span class="st-badge sb-inactive">Inactive</span>
                    </c:otherwise>
                  </c:choose>
                  <a href="${pageContext.request.contextPath}/admin/storage?action=assign&locationId=${loc.id}"
                     class="st-assign-btn">
                    <i class="fa-solid fa-plus"></i> Assign
                  </a>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="panel">
            <div class="st-empty">
              <i class="fa-solid fa-warehouse"></i>
              No storage locations found.
              <br/><br/>
              <a href="${pageContext.request.contextPath}/admin/storage?action=newLocation" class="btn-new" style="display:inline-flex;">
                <i class="fa-solid fa-plus"></i> Add First Location
              </a>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </c:if>

    <!-- ── Assignments tab ── -->
    <c:if test="${tab == 'assignments'}">
      <div class="panel">
        <div class="table-wrap">
          <table class="st-table">
            <thead>
              <tr>
                <th class="col-sprod">Product</th>
                <th class="col-sloc">Location</th>
                <th class="col-sqty">Qty</th>
                <th class="col-sdate">Assigned On</th>
                <th class="col-sact"></th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty assignments}">
                  <c:forEach var="a" items="${assignments}">
                    <tr>
                      <td class="col-sprod">
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
                      <td class="col-sloc">
                        <span class="loc-badge">
                          <i class="fa-solid fa-map-pin" style="font-size:10px;"></i>
                          <c:out value="${a.locationLabel}"/>
                        </span>
                      </td>
                      <td class="col-sqty" style="text-align:center;">${a.quantity}</td>
                      <td class="col-sdate">
                        <c:if test="${not empty a.assignedDate}">
                          <fmt:formatDate value="${a.assignedDate}" pattern="dd MMM yyyy"/>
                        </c:if>
                      </td>
                      <td class="col-sact action-cell">
                        <form method="post" action="${pageContext.request.contextPath}/admin/storage"
                              style="margin:0;" onsubmit="return confirm('Remove this assignment?')">
                          <input type="hidden" name="action" value="deleteAssignment"/>
                          <input type="hidden" name="id" value="${a.id}"/>
                          <button type="submit" class="del-btn" title="Remove">
                            <i class="fa-solid fa-trash"></i>
                          </button>
                        </form>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="5" class="st-empty">
                      <i class="fa-solid fa-cubes"></i>
                      No product assignments yet.
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </c:if>

  </main>
</div>

<div id="stToast" data-toast="${param.toast}">
  <span id="stToastIcon"></span><span id="stToastMsg"></span>
</div>

<script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
<script>
  (function() {
    var msgs = {
      locCreated:   ["✅","Storage location created."],
      locUpdated:   ["✅","Storage location updated."],
      locDeleted:   ["🗑️","Location deleted."],
      assigned:     ["✅","Product assigned to location."],
      assignDeleted:["🗑️","Assignment removed."],
      error:        ["❌","Something went wrong. Please try again."]
    };
    var key = document.getElementById("stToast").dataset.toast || "";
    if (msgs[key]) {
      window.addEventListener("load", function() {
        document.getElementById("stToastIcon").textContent = msgs[key][0];
        document.getElementById("stToastMsg").textContent  = msgs[key][1];
        var el = document.getElementById("stToast");
        el.classList.add("show");
        setTimeout(function() { el.classList.remove("show"); }, 3500);
      });
    }
  })();
</script>
</body>
</html>
