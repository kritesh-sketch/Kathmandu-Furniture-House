<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../templates/admin/head-common.jsp"/>
  <title>Account — Kathmandu Furniture Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/product-form.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/account.css" />
</head>

<body>
  <div class="admin-layout">
    <jsp:include page="../../templates/admin/sidebar.jsp">
      <jsp:param name="activePage" value="account"/>
    </jsp:include>

    <main class="main-content">

      <!-- Topbar -->
      <header class="topbar">
        <div class="header-titles" style="display:flex;align-items:center;gap:12px;">
          <button class="hamburger-btn" id="hamburgerBtn">
            <i class="fa-solid fa-bars"></i>
          </button>
          <div>
            <h2><c:out value="${admin.fullName}"/></h2>
            <p><c:out value="${not empty admin.email ? admin.email : admin.mobileNumber}"/></p>
          </div>
        </div>
      </header>

      <div class="account-grid">

        <!-- ── Left: profile card ── -->
        <div class="profile-card">

          <!-- Avatar + upload trigger -->
          <form method="post" action="${pageContext.request.contextPath}/admin/account"
                enctype="multipart/form-data" id="imgForm">
            <input type="hidden" name="action" value="image"/>
            <input type="file" name="profileImage" id="profileImageInput"
                   accept=".jpg,.jpeg,.png,.webp" style="display:none;"
                   onchange="previewAndSubmit(this)"/>
            <div class="avatar-upload-wrap" onclick="document.getElementById('profileImageInput').click()">
              <c:choose>
                <c:when test="${not empty admin.image}">
                  <img id="avatarPreview"
                       src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(admin.image)}"
                       alt="Profile" class="profile-img"/>
                </c:when>
                <c:otherwise>
                  <div class="profile-avatar" id="avatarPreview">
                    ${not empty admin.firstName ? fn:substring(admin.firstName,0,1) : 'A'}${not empty admin.lastName ? fn:substring(admin.lastName,0,1) : ''}
                  </div>
                </c:otherwise>
              </c:choose>
              <div class="avatar-overlay">
                <i class="fa-solid fa-camera"></i>
              </div>
            </div>
          </form>

          <div class="profile-name"><c:out value="${admin.fullName}"/></div>
          <div class="profile-role">Administrator</div>
          <div class="profile-meta">
            <div class="meta-row">
              <i class="fa-regular fa-envelope"></i>
              <span><c:out value="${not empty admin.email ? admin.email : '—'}"/></span>
            </div>
            <div class="meta-row">
              <i class="fa-solid fa-phone"></i>
              <span><c:out value="${not empty admin.mobileNumber ? admin.mobileNumber : '—'}"/></span>
            </div>
            <div class="meta-row">
              <i class="fa-regular fa-calendar"></i>
              <span>
                <c:choose>
                  <c:when test="${not empty admin.createdAt}">
                    Member since <fmt:formatDate value="${admin.createdAt}" pattern="MMM yyyy"/>
                  </c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </span>
            </div>
          </div>
        </div>

        <!-- ── Right: forms ── -->
        <div class="account-panels">

          <!-- Edit Profile -->
          <div class="account-panel">
            <div class="account-panel-header">
              <h3><i class="fa-regular fa-user"></i> Edit Profile</h3>
            </div>
            <div class="account-panel-body">
              <form method="post" action="${pageContext.request.contextPath}/admin/account">
                <input type="hidden" name="action" value="profile"/>
                <div class="form-grid">
                  <div class="form-group">
                    <label class="form-label">First Name</label>
                    <input type="text" name="firstName" class="form-input" required
                           value="<c:out value='${admin.firstName}'/>"/>
                  </div>
                  <div class="form-group">
                    <label class="form-label">Last Name</label>
                    <input type="text" name="lastName" class="form-input" required
                           value="<c:out value='${admin.lastName}'/>"/>
                  </div>
                  <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-input" required
                           value="<c:out value='${admin.email}'/>"/>
                  </div>
                  <div class="form-group">
                    <label class="form-label">Phone Number</label>
                    <input type="text" name="mobileNumber" class="form-input"
                           value="<c:out value='${admin.mobileNumber}'/>"/>
                  </div>
                  <div class="form-group">
                    <label class="form-label">Date of Birth</label>
                    <input type="date" name="dob" class="form-input"
                           value="<c:out value='${admin.dob}'/>"/>
                  </div>
                  <div class="form-group">
                    <label class="form-label">Gender</label>
                    <select name="gender" class="form-select">
                      <option value="">— Select —</option>
                      <option value="Male"   ${admin.gender == 'Male'   ? 'selected' : ''}>Male</option>
                      <option value="Female" ${admin.gender == 'Female' ? 'selected' : ''}>Female</option>
                      <option value="Other"  ${admin.gender == 'Other'  ? 'selected' : ''}>Other</option>
                    </select>
                  </div>
                </div>
                <div class="form-actions-inline">
                  <button type="submit" class="btn-save">
                    <i class="fa-solid fa-floppy-disk"></i> Save Changes
                  </button>
                </div>
              </form>
            </div>
          </div>

          <!-- Change Password -->
          <div class="account-panel">
            <div class="account-panel-header">
              <h3><i class="fa-solid fa-lock"></i> Change Password</h3>
            </div>
            <div class="account-panel-body">
              <form method="post" action="${pageContext.request.contextPath}/admin/account">
                <input type="hidden" name="action" value="password"/>
                <div class="form-grid single-col">
                  <div class="form-group">
                    <label class="form-label">Current Password</label>
                    <div class="pw-wrap">
                      <input type="password" name="currentPassword" id="curPw"
                             class="form-input" required placeholder="Enter current password"/>
                      <button type="button" class="pw-eye" onclick="togglePw('curPw',this)">
                        <i class="fa-regular fa-eye"></i>
                      </button>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="form-label">New Password</label>
                    <div class="pw-wrap">
                      <input type="password" name="newPassword" id="newPw"
                             class="form-input" required placeholder="Enter new password"/>
                      <button type="button" class="pw-eye" onclick="togglePw('newPw',this)">
                        <i class="fa-regular fa-eye"></i>
                      </button>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="form-label">Confirm New Password</label>
                    <div class="pw-wrap">
                      <input type="password" name="confirmPassword" id="confPw"
                             class="form-input" required placeholder="Re-enter new password"/>
                      <button type="button" class="pw-eye" onclick="togglePw('confPw',this)">
                        <i class="fa-regular fa-eye"></i>
                      </button>
                    </div>
                  </div>
                </div>
                <div class="form-actions-inline">
                  <button type="submit" class="btn-save">
                    <i class="fa-solid fa-key"></i> Update Password
                  </button>
                </div>
              </form>
            </div>
          </div>

        </div>
        <%-- end account-panels --%>
      </div>
      <%-- end account-grid --%>

    </main>
  </div>

  <div id="accToast" data-toast="${param.toast}">
    <span id="accToastIcon"></span>
    <span id="accToastMsg"></span>
  </div>

  <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  <script>
    function togglePw(id, btn) {
      var inp = document.getElementById(id);
      var icon = btn.querySelector("i");
      if (inp.type === "password") {
        inp.type = "text";
        icon.className = "fa-regular fa-eye-slash";
      } else {
        inp.type = "password";
        icon.className = "fa-regular fa-eye";
      }
    }

    function previewAndSubmit(input) {
      if (!input.files || !input.files[0]) return;
      var reader = new FileReader();
      reader.onload = function(e) {
        var preview = document.getElementById("avatarPreview");
        if (preview.tagName === "IMG") {
          preview.src = e.target.result;
        } else {
          var img = document.createElement("img");
          img.src = e.target.result;
          img.id = "avatarPreview";
          img.className = "profile-img";
          img.alt = "Profile";
          preview.parentNode.replaceChild(img, preview);
        }
      };
      reader.readAsDataURL(input.files[0]);
      document.getElementById("imgForm").submit();
    }

    (function() {
      var msgs = {
        profile:  ["✅", "Profile updated successfully."],
        password: ["✅", "Password changed successfully."],
        image:    ["✅", "Profile photo updated."],
        wrongpw:  ["❌", "Current password is incorrect."],
        mismatch: ["❌", "New passwords do not match."],
        error:    ["❌", "Something went wrong. Please try again."]
      };
      var t = document.getElementById("accToast").dataset.toast || "";
      if (msgs[t]) {
        window.addEventListener("load", function() {
          document.getElementById("accToastIcon").textContent = msgs[t][0];
          document.getElementById("accToastMsg").textContent  = msgs[t][1];
          var el = document.getElementById("accToast");
          el.classList.add("show");
          setTimeout(function() { el.classList.remove("show"); }, 3500);
        });
      }
    })();
  </script>
</body>
</html>
