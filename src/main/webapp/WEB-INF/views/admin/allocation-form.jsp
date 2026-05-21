<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>New Allocation — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/allocations.css"/>
</head>
<body>
<div class="admin-layout">
  <jsp:include page="../../templates/admin/sidebar.jsp">
    <jsp:param name="activePage" value="allocations"/>
  </jsp:include>

  <main class="main-content">
    <header class="topbar">
      <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
        <button class="hamburger-btn" id="hamburgerBtn"><i class="fa-solid fa-bars"></i></button>
        <div>
          <h2>New Allocation</h2>
          <p>Assign a furniture item to a user or department.</p>
        </div>
      </div>
    </header>

    <div class="alloc-form-wrap">
      <form method="post" action="${pageContext.request.contextPath}/admin/allocations">
        <input type="hidden" name="action" value="create"/>

        <!-- Product & Quantity -->
        <div class="alloc-panel">
          <div class="alloc-panel-header">
            <i class="fa-solid fa-couch"></i> Furniture Item
          </div>
          <div class="alloc-panel-body">
            <div class="alloc-form-grid">
              <div class="alloc-field alloc-full">
                <label class="alloc-label">Product <span style="color:#e53935">*</span></label>
                <select name="productId" class="alloc-select" required>
                  <option value="" disabled selected>— Select product —</option>
                  <c:forEach var="p" items="${products}">
                    <option value="${p.id}">
                      <c:out value="${p.productName}"/> (<c:out value="${p.category}"/>)
                    </option>
                  </c:forEach>
                </select>
              </div>
              <div class="alloc-field">
                <label class="alloc-label">Quantity <span style="color:#e53935">*</span></label>
                <input type="number" name="quantity" class="alloc-input"
                       min="1" value="1" required/>
              </div>
            </div>
          </div>
        </div>

        <!-- Allocate To -->
        <div class="alloc-panel">
          <div class="alloc-panel-header">
            <i class="fa-solid fa-user-tag"></i> Allocate To
          </div>
          <div class="alloc-panel-body">
            <div class="alloc-field alloc-full" style="margin-bottom:16px;">
              <label class="alloc-label">Allocation Type</label>
              <div class="alloc-radio-row">
                <label>
                  <input type="radio" name="allocType" value="user" checked
                         onchange="toggleAllocType(this.value)"/>
                  Registered User
                </label>
                <label>
                  <input type="radio" name="allocType" value="dept"
                         onchange="toggleAllocType(this.value)"/>
                  Department / External
                </label>
              </div>
            </div>
            <div id="userSection" class="alloc-field alloc-full">
              <label class="alloc-label">Select User</label>
              <select name="userId" class="alloc-select">
                <option value="" disabled selected>— Select active user —</option>
                <c:forEach var="u" items="${activeUsers}">
                  <option value="${u.id}">
                    <c:out value="${u.firstName} ${u.lastName}"/>
                    (<c:out value="${not empty u.email ? u.email : u.mobileNumber}"/>)
                  </option>
                </c:forEach>
              </select>
            </div>
            <div id="deptSection" class="alloc-field alloc-full" style="display:none;">
              <label class="alloc-label">Department / Name</label>
              <input type="text" name="department" class="alloc-input"
                     placeholder="e.g. HR Department, School Library..."/>
            </div>
          </div>
        </div>

        <!-- Dates & Notes -->
        <div class="alloc-panel">
          <div class="alloc-panel-header">
            <i class="fa-regular fa-calendar"></i> Dates &amp; Notes
          </div>
          <div class="alloc-panel-body">
            <div class="alloc-form-grid">
              <div class="alloc-field">
                <label class="alloc-label">Issue Date <span style="color:#e53935">*</span></label>
                <input type="date" name="issueDate" class="alloc-input" required
                       value="${today}"/>
              </div>
              <div class="alloc-field">
                <label class="alloc-label">Expected Return Date</label>
                <input type="date" name="expectedReturnDate" class="alloc-input"/>
              </div>
              <div class="alloc-field alloc-full">
                <label class="alloc-label">Notes</label>
                <textarea name="notes" class="alloc-textarea"
                          placeholder="Optional notes about this allocation..."></textarea>
              </div>
            </div>
            <div class="alloc-form-actions">
              <a href="${pageContext.request.contextPath}/admin/allocations" class="btn-cancel">
                Cancel
              </a>
              <button type="submit" class="btn-save">
                <i class="fa-solid fa-floppy-disk"></i> Create Allocation
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
  function toggleAllocType(val) {
    document.getElementById("userSection").style.display = val === "user" ? "" : "none";
    document.getElementById("deptSection").style.display = val === "dept" ? "" : "none";
  }
  // Set today's date as default for issue date
  document.addEventListener("DOMContentLoaded", function() {
    var d = document.querySelector("input[name='issueDate']");
    if (d && !d.value) d.value = new Date().toISOString().split("T")[0];
  });
</script>
</body>
</html>
