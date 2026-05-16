<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>
    <c:choose>
      <c:when test="${mode == 'edit'}">Edit Vacancy — Kathmandu Furniture Admin</c:when>
      <c:otherwise>Add Vacancy — Kathmandu Furniture Admin</c:otherwise>
    </c:choose>
  </title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/product-form.css" />
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
            <c:choose>
              <c:when test="${mode == 'edit'}"><h2>Edit Vacancy</h2><p>Update job vacancy details.</p></c:when>
              <c:otherwise><h2>Add Vacancy</h2><p>Create a new job opening for applicants.</p></c:otherwise>
            </c:choose>
          </div>
        </div>
      </header>

      <a href="${pageContext.request.contextPath}/admin/job-vacancies" class="form-back">
        <i class="fa-solid fa-arrow-left"></i> Back to Vacancies
      </a>

      <form method="post" action="${pageContext.request.contextPath}/admin/job-form">
        <c:if test="${mode == 'edit'}">
          <input type="hidden" name="id" value="${vacancy.id}"/>
        </c:if>

        <!-- Basic Info -->
        <div class="form-card">
          <div class="form-section-title">Vacancy Details</div>
          <div class="form-grid">

            <div class="form-group full-width">
              <label class="form-label">Job Title <span style="color:#ef4444;">*</span></label>
              <input type="text" name="title" class="form-input" required
                     placeholder="e.g. Senior Furniture Designer"
                     value="<c:out value='${vacancy.title}'/>"/>
            </div>

            <div class="form-group">
              <label class="form-label">Department</label>
              <input type="text" name="department" class="form-input"
                     placeholder="e.g. Design, Sales, Operations"
                     value="<c:out value='${vacancy.department}'/>"/>
            </div>

            <div class="form-group">
              <label class="form-label">Location</label>
              <input type="text" name="location" class="form-input"
                     placeholder="e.g. Kathmandu, Remote"
                     value="<c:out value='${vacancy.location}'/>"/>
            </div>

            <div class="form-group">
              <label class="form-label">Employment Type</label>
              <select name="type" class="form-select">
                <option value="Full-time"  ${vacancy.type == 'Full-time'  ? 'selected' : ''}>Full-time</option>
                <option value="Part-time"  ${vacancy.type == 'Part-time'  ? 'selected' : ''}>Part-time</option>
                <option value="Contract"   ${vacancy.type == 'Contract'   ? 'selected' : ''}>Contract</option>
                <option value="Internship" ${vacancy.type == 'Internship' ? 'selected' : ''}>Internship</option>
              </select>
            </div>

            <div class="form-group">
              <label class="form-label">Status</label>
              <select name="status" class="form-select">
                <option value="Active" ${vacancy.status == 'Active' || empty vacancy.status ? 'selected' : ''}>Active</option>
                <option value="Draft"  ${vacancy.status == 'Draft'  ? 'selected' : ''}>Draft</option>
                <option value="Closed" ${vacancy.status == 'Closed' ? 'selected' : ''}>Closed</option>
              </select>
            </div>

          </div>
        </div>

        <!-- Salary -->
        <div class="form-card">
          <div class="form-section-title">Salary Range (Rs.)</div>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Minimum</label>
              <input type="number" name="salaryMin" class="form-input" min="0"
                     placeholder="e.g. 25000"
                     value="${vacancy.salaryMin > 0 ? vacancy.salaryMin : ''}"/>
            </div>
            <div class="form-group">
              <label class="form-label">Maximum</label>
              <input type="number" name="salaryMax" class="form-input" min="0"
                     placeholder="e.g. 50000"
                     value="${vacancy.salaryMax > 0 ? vacancy.salaryMax : ''}"/>
            </div>
          </div>
        </div>

        <!-- Description & Requirements -->
        <div class="form-card">
          <div class="form-section-title">Job Description</div>
          <div class="form-group">
            <textarea name="description" class="form-textarea" rows="5"
                      placeholder="Describe the role, responsibilities, and expectations…"><c:out value="${vacancy.description}"/></textarea>
          </div>
        </div>

        <div class="form-card">
          <div class="form-section-title">Requirements</div>
          <div class="form-group">
            <textarea name="requirements" class="form-textarea" rows="5"
                      placeholder="List qualifications, skills, and experience required…"><c:out value="${vacancy.requirements}"/></textarea>
          </div>
        </div>

        <!-- Actions -->
        <div class="form-actions">
          <a href="${pageContext.request.contextPath}/admin/job-vacancies" class="btn-cancel">Cancel</a>
          <button type="submit" class="btn-save">
            <c:choose>
              <c:when test="${mode == 'edit'}"><i class="fa-solid fa-floppy-disk"></i> Save Changes</c:when>
              <c:otherwise><i class="fa-solid fa-plus"></i> Create Vacancy</c:otherwise>
            </c:choose>
          </button>
        </div>

      </form>
    </main>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
</body>
</html>
