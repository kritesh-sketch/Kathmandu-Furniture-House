<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="${pageContext.request.contextPath}/templates/admin/head-common.jsp"/>
  <title>Assign Product to Storage — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/storage.css"/>
</head>
<body>
<div class="admin-layout">
  <jsp:include page="${pageContext.request.contextPath}/templates/admin/sidebar.jsp">
    <jsp:param name="activePage" value="storage"/>
  </jsp:include>

  <main class="main-content">
    <header class="topbar">
      <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
        <button class="hamburger-btn" id="hamburgerBtn"><i class="fa-solid fa-bars"></i></button>
        <div>
          <h2>Assign Product to Storage</h2>
          <p>Link a furniture item to a warehouse rack location.</p>
        </div>
      </div>
    </header>

    <div class="st-form-wrap">
      <form method="post" action="${pageContext.request.contextPath}/admin/storage">
        <input type="hidden" name="action" value="createAssignment"/>

        <div class="st-panel">
          <div class="st-panel-header">
            <i class="fa-solid fa-cubes"></i> Assignment Details
          </div>
          <div class="st-panel-body">
            <div class="st-form-grid">

              <div class="st-field st-full">
                <label class="st-label">Product <span style="color:#e53935">*</span></label>
                <select name="productId" class="st-select" required>
                  <option value="" disabled selected>— Select product —</option>
                  <c:forEach var="p" items="${products}">
                    <option value="${p.id}">
                      <c:out value="${p.productName}"/> (<c:out value="${p.category}"/>)
                    </option>
                  </c:forEach>
                </select>
              </div>

              <div class="st-field st-full">
                <label class="st-label">Storage Location <span style="color:#e53935">*</span></label>
                <select name="locationId" class="st-select" required>
                  <option value="" disabled selected>— Select location —</option>
                  <c:forEach var="loc" items="${locations}">
                    <option value="${loc.id}"
                            ${loc.id == selectedLocationId ? 'selected' : ''}>
                      <c:out value="${loc.zone}"/> / Rack <c:out value="${loc.rackNumber}"/>
                      (${loc.assignedCount}/${loc.capacity > 0 ? loc.capacity : '∞'})
                    </option>
                  </c:forEach>
                </select>
              </div>

              <div class="st-field">
                <label class="st-label">Quantity <span style="color:#e53935">*</span></label>
                <input type="number" name="quantity" class="st-input" min="1" value="1" required/>
              </div>

              <div class="st-field">
                <label class="st-label">Assigned Date <span style="color:#e53935">*</span></label>
                <input type="date" name="assignedDate" class="st-input" required id="assignedDate"/>
              </div>

              <div class="st-field st-full">
                <label class="st-label">Notes</label>
                <textarea name="notes" class="st-textarea"
                          placeholder="Optional notes..."></textarea>
              </div>

            </div>
            <div class="st-form-actions">
              <a href="${pageContext.request.contextPath}/admin/storage?tab=assignments" class="btn-cancel">
                Cancel
              </a>
              <button type="submit" class="btn-save">
                <i class="fa-solid fa-floppy-disk"></i> Assign to Storage
              </button>
            </div>
          </div>
        </div>

      </form>
    </div>
  </main>
</div>
<script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
<script>
  document.getElementById("assignedDate").value = new Date().toISOString().split("T")[0];
</script>
</body>
</html>
