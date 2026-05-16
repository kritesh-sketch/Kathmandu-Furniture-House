<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>
    <c:choose>
      <c:when test="${mode == 'edit'}">Edit Offer — Kathmandu Furniture Admin</c:when>
      <c:otherwise>Add Offer — Kathmandu Furniture Admin</c:otherwise>
    </c:choose>
  </title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/product-form.css" />
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
            <h2>
              <c:choose>
                <c:when test="${mode == 'edit'}">Edit Offer</c:when>
                <c:otherwise>Add New Offer</c:otherwise>
              </c:choose>
            </h2>
            <p>
              <c:choose>
                <c:when test="${mode == 'edit'}">Update the offer details below.</c:when>
                <c:otherwise>Create a new special event offer for customers.</c:otherwise>
              </c:choose>
            </p>
          </div>
        </div>
      </header>

      <div style="margin-bottom:20px;">
        <a href="${pageContext.request.contextPath}/admin/offers" class="detail-back">
          <i class="fa-solid fa-arrow-left"></i> Back to Offers
        </a>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/admin/offers">
        <c:if test="${mode == 'edit'}">
          <input type="hidden" name="id" value="${offer.id}"/>
        </c:if>

        <div class="form-cards-wrap">

          <!-- ── Card 1: Basic Info ── -->
          <div class="form-card">
            <div class="form-card-header">
              <h3><i class="fa-solid fa-circle-info"></i> Offer Details</h3>
            </div>
            <div class="form-card-body">
              <div class="form-grid">

                <div class="form-group" style="grid-column:1/-1;">
                  <label class="form-label">Offer Title <span class="req">*</span></label>
                  <input type="text" name="title" class="form-input" required
                         placeholder="e.g. Dashain Festival Sale"
                         value="<c:out value='${offer.title}'/>"/>
                </div>

                <div class="form-group">
                  <label class="form-label">Event / Occasion</label>
                  <input type="text" name="eventName" class="form-input"
                         placeholder="e.g. Dashain 2081, Christmas 2024"
                         value="<c:out value='${offer.eventName}'/>"/>
                </div>

                <div class="form-group">
                  <label class="form-label">Discount Code</label>
                  <input type="text" name="discountCode" class="form-input"
                         placeholder="e.g. DASHAIN20" style="text-transform:uppercase;"
                         value="<c:out value='${offer.discountCode}'/>"/>
                </div>

                <div class="form-group">
                  <label class="form-label">Status</label>
                  <select name="status" class="form-select">
                    <option value="Active"   ${offer.status == 'Active'   || empty offer.status ? 'selected' : ''}>Active</option>
                    <option value="Inactive" ${offer.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                    <option value="Expired"  ${offer.status == 'Expired'  ? 'selected' : ''}>Expired</option>
                  </select>
                </div>

                <div class="form-group" style="grid-column:1/-1;">
                  <label class="form-label">Description</label>
                  <textarea name="description" class="form-textarea" rows="3"
                            placeholder="Briefly describe this offer…"><c:out value="${offer.description}"/></textarea>
                </div>

              </div>
            </div>
          </div>

          <!-- ── Card 2: Discount Value ── -->
          <div class="form-card">
            <div class="form-card-header">
              <h3><i class="fa-solid fa-percent"></i> Discount Value</h3>
            </div>
            <div class="form-card-body">
              <div class="form-grid">

                <div class="form-group">
                  <label class="form-label">Discount Type</label>
                  <select name="discountType" id="discountType" class="form-select"
                          onchange="toggleDiscountFields()">
                    <option value="Percentage" ${offer.discountType == 'Percentage' || empty offer.discountType ? 'selected' : ''}>Percentage (%)</option>
                    <option value="Fixed"      ${offer.discountType == 'Fixed'      ? 'selected' : ''}>Fixed Amount ($)</option>
                  </select>
                </div>

                <div class="form-group" id="percentGroup">
                  <label class="form-label">Discount Percent (%)</label>
                  <input type="number" name="discountPercent" id="discountPercent"
                         class="form-input" min="0" max="100" step="0.01"
                         placeholder="e.g. 20"
                         value="${offer.discountPercent > 0 ? offer.discountPercent : ''}"/>
                </div>

                <div class="form-group" id="amountGroup" style="display:none;">
                  <label class="form-label">Discount Amount ($)</label>
                  <input type="number" name="discountAmount" id="discountAmount"
                         class="form-input" min="0" step="0.01"
                         placeholder="e.g. 500"
                         value="${offer.discountAmount > 0 ? offer.discountAmount : ''}"/>
                </div>

              </div>
            </div>
          </div>

          <!-- ── Card 3: Date Range ── -->
          <div class="form-card">
            <div class="form-card-header">
              <h3><i class="fa-regular fa-calendar"></i> Validity Period</h3>
            </div>
            <div class="form-card-body">
              <div class="form-grid">

                <div class="form-group">
                  <label class="form-label">Start Date</label>
                  <input type="date" name="startDate" class="form-input"
                         value="<c:choose><c:when test='${not empty offer.startDate}'><fmt:formatDate value='${offer.startDate}' pattern='yyyy-MM-dd'/></c:when></c:choose>"/>
                </div>

                <div class="form-group">
                  <label class="form-label">End Date</label>
                  <input type="date" name="endDate" class="form-input"
                         value="<c:choose><c:when test='${not empty offer.endDate}'><fmt:formatDate value='${offer.endDate}' pattern='yyyy-MM-dd'/></c:when></c:choose>"/>
                </div>

              </div>
            </div>
          </div>

        </div>
        <%-- end form-cards-wrap --%>

        <!-- Action buttons -->
        <div class="form-actions">
          <button type="submit" class="btn-save">
            <i class="fa-solid fa-floppy-disk"></i>
            <c:choose>
              <c:when test="${mode == 'edit'}">Update Offer</c:when>
              <c:otherwise>Create Offer</c:otherwise>
            </c:choose>
          </button>
          <a href="${pageContext.request.contextPath}/admin/offers" class="btn-cancel">Cancel</a>
        </div>

      </form>

    </main>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  <script>
    function toggleDiscountFields() {
      var type = document.getElementById("discountType").value;
      document.getElementById("percentGroup").style.display = type === "Percentage" ? "" : "none";
      document.getElementById("amountGroup").style.display  = type === "Fixed"      ? "" : "none";
    }
    toggleDiscountFields();
  </script>
</body>
</html>
