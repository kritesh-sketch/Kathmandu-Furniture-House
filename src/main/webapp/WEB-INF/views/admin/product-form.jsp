<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>
    <c:choose>
      <c:when test="${mode == 'edit'}">Edit Product — Kathmandu Furniture Admin</c:when>
      <c:otherwise>Add Product — Kathmandu Furniture Admin</c:otherwise>
    </c:choose>
  </title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/product-form.css" />
</head>

<body>
  <div class="admin-layout">
    <jsp:include page="../../templates/admin/sidebar.jsp">
      <jsp:param name="activePage" value="products"/>
    </jsp:include>

    <!-- ── Main content ── -->
    <main class="main-content">

      <!-- Topbar -->
      <header class="topbar">
        <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
          <button class="hamburger-btn" id="hamburgerBtn">
            <i class="fa-solid fa-bars"></i>
          </button>
          <div>
            <c:choose>
              <c:when test="${mode == 'edit'}">
                <h2>Edit Product</h2>
                <p>Update the details for <c:out value="${product.productName}"/>.</p>
              </c:when>
              <c:otherwise>
                <h2>Add Product</h2>
                <p>Fill in the details to add a new product to the catalogue.</p>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </header>

      <!-- Back link -->
      <a href="${pageContext.request.contextPath}/admin/products" class="form-back">
        <i class="fa-solid fa-arrow-left"></i> Back to Products
      </a>

      <!-- ── Form ── -->
      <form method="post" action="${pageContext.request.contextPath}/admin/product-form"
            id="productForm" enctype="multipart/form-data">

        <c:if test="${mode == 'edit'}">
          <input type="hidden" name="id" value="${product.id}" />
        </c:if>

        <!-- Basic Info -->
        <div class="form-card">
          <div class="form-section-title">Basic Information</div>
          <div class="form-grid">

            <div class="form-group full-width">
              <label class="form-label" for="productName">Product Name</label>
              <input type="text" id="productName" name="productName" class="form-input"
                     placeholder="e.g. Solid Wood Dining Table"
                     value="<c:out value='${product.productName}'/>" required />
            </div>

            <div class="form-group">
              <label class="form-label" for="category">Category</label>
              <select id="category" name="category" class="form-input" required>
                <option value="">-- Select Category --</option>
                <option value="Sofas &amp; Seating"    ${product.category == 'Sofas & Seating'    ? 'selected' : ''}>Sofas &amp; Seating</option>
                <option value="Beds &amp; Mattresses"  ${product.category == 'Beds & Mattresses'  ? 'selected' : ''}>Beds &amp; Mattresses</option>
                <option value="Tables &amp; Desks"     ${product.category == 'Tables & Desks'     ? 'selected' : ''}>Tables &amp; Desks</option>
                <option value="Chairs &amp; Stools"    ${product.category == 'Chairs & Stools'    ? 'selected' : ''}>Chairs &amp; Stools</option>
                <option value="Decor &amp; Rugs"       ${product.category == 'Decor & Rugs'       ? 'selected' : ''}>Decor &amp; Rugs</option>
                <option value="Storage &amp; Cabinets" ${product.category == 'Storage & Cabinets' ? 'selected' : ''}>Storage &amp; Cabinets</option>
              </select>
            </div>

            <div class="form-group">
              <label class="form-label" for="price">Price (Rs.)</label>
              <input type="number" id="price" name="price" class="form-input"
                     placeholder="0.00" step="0.01" min="0"
                     value="${product.price > 0 ? product.price : ''}" required />
            </div>

            <div class="form-group">
              <label class="form-label" for="availability">Availability</label>
              <select id="availability" name="availability" class="form-select">
                <option value="In Stock"      ${fn:toLowerCase(product.availability) == 'in stock'      ? 'selected' : ''}>In Stock</option>
                <option value="Out of Stock"  ${fn:toLowerCase(product.availability) == 'out of stock'  ? 'selected' : ''}>Out of Stock</option>
                <option value="Coming Soon"   ${fn:toLowerCase(product.availability) == 'coming soon'   ? 'selected' : ''}>Coming Soon</option>
              </select>
            </div>

            <div class="form-group">
              <label class="form-label" for="status">Status</label>
              <select id="status" name="status" class="form-select">
                <option value="Active"   ${fn:toLowerCase(product.status) == 'active'   ? 'selected' : ''}>Active</option>
                <option value="Inactive" ${fn:toLowerCase(product.status) == 'inactive' ? 'selected' : ''}>Inactive</option>
              </select>
            </div>

            <div class="form-group full-width">
              <label class="form-label">Product Image</label>
              <input type="hidden" name="existingImage" value="<c:out value='${product.image}'/>"/>
              <div class="pf-upload-zone" id="pfUploadZone">
                <div class="pf-upload-icon"><i class="fa-solid fa-cloud-arrow-up"></i></div>
                <p class="pf-upload-title">Click to upload or drag &amp; drop</p>
                <p class="pf-upload-sub">JPG, PNG, WEBP &mdash; max 5 MB</p>
                <input type="file" id="image" name="image"
                       accept=".jpg,.jpeg,.png,.webp"
                       class="pf-upload-input"
                       onchange="previewProductImage(this)"/>
              </div>
              <div class="pf-img-preview-row" id="pfImgPreviewRow"
                   style="${mode == 'edit' and not empty product.image ? '' : 'display:none;'}">
                <img id="imgPreview"
                     src="${mode == 'edit' and not empty product.image
                           ? pageContext.request.contextPath.concat('/static/images/').concat(product.image)
                           : ''}"
                     alt="Preview" class="pf-preview-img"/>
                <div class="pf-preview-info">
                  <span class="pf-preview-name" id="pfPreviewName">
                    <c:choose>
                      <c:when test="${mode == 'edit' and not empty product.image}">Current image</c:when>
                      <c:otherwise>No file chosen</c:otherwise>
                    </c:choose>
                  </span>
                  <c:if test="${mode == 'edit' and not empty product.image}">
                    <span class="form-hint">Upload a new file to replace it.</span>
                  </c:if>
                  <button type="button" class="pf-remove-img" onclick="removeProductImage()">
                    <i class="fa-solid fa-xmark"></i> Remove
                  </button>
                </div>
              </div>
            </div>

          </div>
        </div>

        <!-- Colors -->
        <div class="form-card">
          <div class="form-section-title">Colors</div>
          <div class="color-pickers-row" id="colorPickersRow">
            <button type="button" class="add-color-btn" id="addColorBtn"
                    onclick="addColorPicker('#888888')">
              <i class="fa-solid fa-plus"></i> Add Color
            </button>
          </div>
          <input type="hidden" id="colorsHidden" name="colors"
                 value="<c:out value='${product.colors}'/>" />
        </div>

        <!-- Dimensions -->
        <div class="form-card">
          <div class="form-section-title">Dimensions (cm)</div>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label" for="lengthCm">Length</label>
              <input type="number" id="lengthCm" name="lengthCm" class="form-input"
                     placeholder="e.g. 120" step="0.1" min="0"
                     value="${not empty dimParts[0] ? dimParts[0] : ''}" />
            </div>
            <div class="form-group">
              <label class="form-label" for="breadthCm">Breadth</label>
              <input type="number" id="breadthCm" name="breadthCm" class="form-input"
                     placeholder="e.g. 85" step="0.1" min="0"
                     value="${not empty dimParts[1] ? dimParts[1] : ''}" />
            </div>
            <div class="form-group">
              <label class="form-label" for="heightCm">Height</label>
              <input type="number" id="heightCm" name="heightCm" class="form-input"
                     placeholder="e.g. 90" step="0.1" min="0"
                     value="${not empty dimParts[2] ? dimParts[2] : ''}" />
            </div>
          </div>
        </div>

        <!-- Actions -->
        <div class="form-actions">
          <a href="${pageContext.request.contextPath}/admin/products" class="btn-cancel">Cancel</a>
          <button type="submit" class="btn-save">
            <c:choose>
              <c:when test="${mode == 'edit'}">
                <i class="fa-solid fa-floppy-disk"></i> Save Changes
              </c:when>
              <c:otherwise>
                <i class="fa-solid fa-plus"></i> Add Product
              </c:otherwise>
            </c:choose>
          </button>
        </div>

      </form>

    </main>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  <script>
    /* ── Color pickers ── */
    function addColorPicker(hex) {
      var row = document.getElementById("colorPickersRow");
      var addBtn = document.getElementById("addColorBtn");
      var wrap = document.createElement("div");
      wrap.className = "color-picker-wrap";

      var inp = document.createElement("input");
      inp.type = "color";
      inp.className = "color-picker-input";
      inp.value = hex || "#888888";
      inp.addEventListener("input", syncColors);

      var rm = document.createElement("button");
      rm.type = "button";
      rm.className = "color-remove-btn";
      rm.title = "Remove";
      rm.innerHTML = "&times;";
      rm.addEventListener("click", function() {
        row.removeChild(wrap);
        syncColors();
      });

      wrap.appendChild(inp);
      wrap.appendChild(rm);
      row.insertBefore(wrap, addBtn);
      syncColors();
    }

    function syncColors() {
      var vals = Array.from(document.querySelectorAll(".color-picker-input"))
                      .map(function(el) { return el.value; });
      document.getElementById("colorsHidden").value = vals.join(",");
    }

    /* Load existing colors on page load */
    (function() {
      var existing = document.getElementById("colorsHidden").value;
      if (existing && existing.trim() !== "") {
        existing.split(",").forEach(function(hex) {
          var h = hex.trim();
          if (h) addColorPicker(h);
        });
      }
    })();

    /* ── Product image upload zone ── */
    var zone      = document.getElementById("pfUploadZone");
    var previewRow = document.getElementById("pfImgPreviewRow");
    var previewName = document.getElementById("pfPreviewName");
    var fileInput = document.getElementById("image");

    zone.addEventListener("click", function() { fileInput.click(); });
    zone.addEventListener("dragover", function(e) { e.preventDefault(); zone.classList.add("drag-over"); });
    zone.addEventListener("dragleave", function()  { zone.classList.remove("drag-over"); });
    zone.addEventListener("drop", function(e) {
      e.preventDefault();
      zone.classList.remove("drag-over");
      if (e.dataTransfer.files.length) {
        fileInput.files = e.dataTransfer.files;
        previewProductImage(fileInput);
      }
    });

    function previewProductImage(input) {
      if (!input.files || !input.files[0]) return;
      var file = input.files[0];
      var reader = new FileReader();
      reader.onload = function(e) {
        document.getElementById("imgPreview").src = e.target.result;
        if (previewName) previewName.textContent = file.name;
        zone.style.display = "none";
        previewRow.style.display = "flex";
      };
      reader.readAsDataURL(file);
    }

    function removeProductImage() {
      fileInput.value = "";
      document.getElementById("imgPreview").src = "";
      if (previewName) previewName.textContent = "No file chosen";
      previewRow.style.display = "none";
      zone.style.display = "flex";
    }
  </script>
</body>
</html>
