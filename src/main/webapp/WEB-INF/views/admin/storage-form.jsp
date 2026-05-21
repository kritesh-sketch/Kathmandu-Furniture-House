<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>${empty location ? 'New' : 'Edit'} Location — Kathmandu Furniture Admin</title>
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
          <h2>${empty location ? 'New Storage Location' : 'Edit Storage Location'}</h2>
          <p>${empty location ? 'Define a new warehouse zone and rack.' : 'Update location details.'}</p>
        </div>
      </div>
    </header>

    <div class="st-form-wrap">
      <form method="post" action="${pageContext.request.contextPath}/admin/storage">
        <input type="hidden" name="action" value="${empty location ? 'createLocation' : 'updateLocation'}"/>
        <c:if test="${not empty location}">
          <input type="hidden" name="id" value="${location.id}"/>
        </c:if>

        <div class="st-panel">
          <div class="st-panel-header">
            <i class="fa-solid fa-map-pin"></i>
            Location Details
          </div>
          <div class="st-panel-body">
            <div class="st-form-grid">

              <div class="st-field">
                <label class="st-label">Warehouse Zone <span style="color:#e53935">*</span></label>
                <input type="text" name="zone" class="st-input" required
                       placeholder="e.g. Warehouse A"
                       value="<c:out value='${location.zone}'/>"/>
              </div>

              <div class="st-field">
                <label class="st-label">Rack Number <span style="color:#e53935">*</span></label>
                <input type="text" name="rackNumber" class="st-input" required
                       placeholder="e.g. R-01"
                       value="<c:out value='${location.rackNumber}'/>"/>
              </div>

              <div class="st-field">
                <label class="st-label">Capacity (items)</label>
                <input type="number" name="capacity" class="st-input" min="0"
                       value="${not empty location ? location.capacity : 0}"/>
              </div>

              <div class="st-field">
                <label class="st-label">Status</label>
                <select name="status" class="st-select">
                  <option value="Available" ${location.status == 'Available' || empty location ? 'selected' : ''}>Available</option>
                  <option value="Full"      ${location.status == 'Full'      ? 'selected' : ''}>Full</option>
                  <option value="Inactive"  ${location.status == 'Inactive'  ? 'selected' : ''}>Inactive</option>
                </select>
              </div>

              <div class="st-field st-full">
                <label class="st-label">Description</label>
                <textarea name="description" class="st-textarea"
                          placeholder="Optional — describe what's stored here..."><c:out value="${location.description}"/></textarea>
              </div>

            </div>
            <div class="st-form-actions">
              <a href="${pageContext.request.contextPath}/admin/storage" class="btn-cancel">Cancel</a>
              <button type="submit" class="btn-save">
                <i class="fa-solid fa-floppy-disk"></i>
                ${empty location ? 'Create Location' : 'Save Changes'}
              </button>
            </div>
          </div>
        </div>

      </form>
    </div>
  </main>
</div>
<script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
</body>
</html>
