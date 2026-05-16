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
            id="productForm">

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
              <input type="text" id="category" name="category" class="form-input"
                     placeholder="e.g. Table & Desk"
                     value="<c:out value='${product.category}'/>" />
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
                <option value="In Stock"       ${fn:toLowerCase(product.availability) == 'in stock'       ? 'selected' : ''}>In Stock</option>
                <option value="Out of Stock"   ${fn:toLowerCase(product.availability) == 'out of stock'   ? 'selected' : ''}>Out of Stock</option>
                <option value="Limited Stock"  ${fn:toLowerCase(product.availability) == 'limited stock'  ? 'selected' : ''}>Limited Stock</option>
              </select>
            </div>

            <div class="form-group">
              <label class="form-label" for="status">Status</label>
              <select id="status" name="status" class="form-select">
                <option value="Active"   ${fn:toLowerCase(product.status) == 'active'   ? 'selected' : ''}>Active</option>
                <option value="Inactive" ${fn:toLowerCase(product.status) == 'inactive' ? 'selected' : ''}>Inactive</option>
              </select>
            </div>

            <div class="form-group">
              <label class="form-label" for="image">Image Filename</label>
              <input type="text" id="image" name="image" class="form-input"
                     placeholder="e.g. dining-table.jpg"
                     value="<c:out value='${product.image}'/>" />
              <span class="form-hint">Filename only — file must exist in /static/images/</span>
            </div>

          </div>
        </div>

        <!-- Colors -->
        <div class="form-card">
          <div class="form-section-title">Colors</div>
          <div class="color-pickers-row" id="colorPickersRow">
            <!-- injected by JS -->
            <button type="button" class="add-color-btn" id="addColorBtn"
                    onclick="addColorPicker('#888888')">
              <i class="fa-solid fa-plus"></i> Add Color
            </button>
          </div>
          <%-- hidden field carries comma-separated hex values to the server --%>
          <input type="hidden" id="colorsHidden" name="colors"
                 value="<c:out value='${product.colors}'/>" />
        </div>

        <!-- Rating -->
        <div class="form-card">
          <div class="form-section-title">Rating</div>
          <div class="star-input-row">
            <div class="star-btns" id="starBtns">
              <button type="button" class="star-btn" data-val="1"><i class="fa-solid fa-star"></i></button>
              <button type="button" class="star-btn" data-val="2"><i class="fa-solid fa-star"></i></button>
              <button type="button" class="star-btn" data-val="3"><i class="fa-solid fa-star"></i></button>
              <button type="button" class="star-btn" data-val="4"><i class="fa-solid fa-star"></i></button>
              <button type="button" class="star-btn" data-val="5"><i class="fa-solid fa-star"></i></button>
            </div>
            <input type="number" id="ratingInput" name="rating" class="rating-num-input"
                   min="0" max="5" step="0.5"
                   value="${product.rating > 0 ? product.rating : '0'}" />
            <span class="rating-hint">0.0 – 5.0 &nbsp;(click a star or type)</span>
          </div>
        </div>

        <!-- Specifications -->
        <div class="form-card">
          <div class="form-section-title">Specifications</div>
          <div class="form-group">
            <textarea id="specifications" name="specifications" class="form-textarea"
                      rows="6" placeholder="Enter product specifications, materials, dimensions…"><c:out value="${product.specifications}"/></textarea>
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

    /* ── Star rating ── */
    var ratingInput = document.getElementById("ratingInput");
    var starBtns    = Array.from(document.querySelectorAll(".star-btn"));

    function paintStars(val) {
      starBtns.forEach(function(btn) {
        btn.classList.toggle("lit", btn.dataset.val <= val);
      });
    }

    starBtns.forEach(function(btn) {
      btn.addEventListener("click", function() {
        ratingInput.value = btn.dataset.val;
        paintStars(btn.dataset.val);
      });
    });

    ratingInput.addEventListener("input", function() {
      paintStars(parseFloat(this.value) || 0);
    });

    /* Initial paint */
    paintStars(parseFloat(ratingInput.value) || 0);
  </script>
</body>
</html>
