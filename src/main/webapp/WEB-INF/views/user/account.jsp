<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="My Account — Kathmandu Furniture" />
    <jsp:param name="pageFolder" value="user" />
    <jsp:param name="currentCssFile" value="account" />
    <jsp:param name="headerCssFile" value="header" />
    <jsp:param name="footerCssFile" value="footer" />
</jsp:include>

<body>

<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<div class="uacc-page">
  <div class="uacc-grid">

    <!-- ── Left: Profile Card ── -->
    <div class="uacc-profile-card">
      <form method="post" action="${pageContext.request.contextPath}/user/account"
            enctype="multipart/form-data" id="imgForm">
        <input type="hidden" name="action" value="image"/>
        <input type="file" name="profileImage" id="profileImageInput"
               accept=".jpg,.jpeg,.png,.webp" style="display:none;"
               onchange="uaccPreviewAndSubmit(this)"/>
        <div class="uacc-avatar-wrap" onclick="document.getElementById('profileImageInput').click()">
          <c:choose>
            <c:when test="${not empty user.image}">
              <img id="uaccAvatarPreview"
                   src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(user.image)}"
                   alt="Profile" class="uacc-avatar-img"/>
            </c:when>
            <c:otherwise>
              <div class="uacc-avatar-initials" id="uaccAvatarPreview">
                ${not empty user.firstName ? fn:substring(user.firstName,0,1) : 'U'}${not empty user.lastName ? fn:substring(user.lastName,0,1) : ''}
              </div>
            </c:otherwise>
          </c:choose>
          <div class="uacc-avatar-overlay">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/>
              <circle cx="12" cy="13" r="4"/>
            </svg>
          </div>
        </div>
      </form>

      <div class="uacc-profile-name"><c:out value="${user.firstName} ${user.lastName}"/></div>
      <div class="uacc-profile-badge">Member</div>

      <div class="uacc-meta">
        <div class="uacc-meta-row">
          <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
            <polyline points="22,6 12,13 2,6"/>
          </svg>
          <span><c:out value="${not empty user.email ? user.email : '—'}"/></span>
        </div>
        <div class="uacc-meta-row">
          <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.61 3.4 2 2 0 0 1 3.6 1.22h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.81a16 16 0 0 0 6.29 6.29l.95-.95a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/>
          </svg>
          <span><c:out value="${not empty user.mobileNumber ? user.mobileNumber : '—'}"/></span>
        </div>
        <div class="uacc-meta-row">
          <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="1.8">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
            <line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/>
            <line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
          <span>
            <c:choose>
              <c:when test="${not empty user.createdAt}">
                Member since <fmt:formatDate value="${user.createdAt}" pattern="MMM yyyy"/>
              </c:when>
              <c:otherwise>—</c:otherwise>
            </c:choose>
          </span>
        </div>
      </div>

      <!-- Quick nav links -->
      <div class="uacc-side-nav">
        <button class="uacc-side-btn active" onclick="uaccSwitch('overview', this)">
          <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
          Overview
        </button>
        <button class="uacc-side-btn" onclick="uaccSwitch('orders', this)">
          <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/><path d="M9 12h6M9 16h4"/></svg>
          My Orders
          <c:if test="${totalOrders > 0}"><span class="uacc-badge">${totalOrders}</span></c:if>
        </button>
        <button class="uacc-side-btn" onclick="uaccSwitch('profile', this)">
          <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
          Edit Profile
        </button>
        <button class="uacc-side-btn" onclick="uaccSwitch('security', this)">
          <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          Security
        </button>
      </div>
    </div>

    <!-- ── Right: Tab Content ── -->
    <div class="uacc-right">

      <!-- ══ TAB: Overview ══ -->
      <div id="tab-overview" class="uacc-tab active">

        <!-- Stat cards -->
        <div class="uacc-stats">
          <div class="uacc-stat-card">
            <div class="uacc-stat-icon si-blue"><i class="fa-solid fa-box"></i></div>
            <div>
              <div class="uacc-stat-val">${not empty totalOrders ? totalOrders : 0}</div>
              <div class="uacc-stat-lbl">Total Orders</div>
            </div>
          </div>
          <div class="uacc-stat-card">
            <div class="uacc-stat-icon si-amber"><i class="fa-solid fa-clock"></i></div>
            <div>
              <div class="uacc-stat-val">${not empty pendingOrders ? pendingOrders : 0}</div>
              <div class="uacc-stat-lbl">Pending</div>
            </div>
          </div>
          <div class="uacc-stat-card">
            <div class="uacc-stat-icon si-green"><i class="fa-solid fa-circle-check"></i></div>
            <div>
              <div class="uacc-stat-val">${not empty deliveredOrders ? deliveredOrders : 0}</div>
              <div class="uacc-stat-lbl">Delivered</div>
            </div>
          </div>
          <div class="uacc-stat-card">
            <div class="uacc-stat-icon si-purple"><i class="fa-solid fa-wallet"></i></div>
            <div>
              <div class="uacc-stat-val">Rs.<fmt:formatNumber value="${not empty totalSpent ? totalSpent : 0}" pattern="#,##0"/></div>
              <div class="uacc-stat-lbl">Total Spent</div>
            </div>
          </div>
        </div>

        <!-- Recent Orders -->
        <div class="uacc-panel">
          <div class="uacc-panel-header">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/></svg>
            Recent Orders
            <button class="uacc-view-all" onclick="uaccSwitch('orders', document.querySelectorAll('.uacc-side-btn')[1])">View All</button>
          </div>
          <div class="uacc-panel-body" style="padding:0;">
            <c:choose>
              <c:when test="${not empty orders}">
                <table class="uacc-order-table">
                  <thead>
                    <tr>
                      <th>Order ID</th>
                      <th>Product</th>
                      <th>Date</th>
                      <th>Amount</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="o" items="${orders}" end="2">
                      <tr>
                        <td class="uacc-order-id">#<c:out value="${o.id}"/></td>
                        <td class="uacc-order-product"><c:out value="${not empty o.productName ? o.productName : o.furnitureType}"/></td>
                        <td class="uacc-order-date">
                          <c:choose>
                            <c:when test="${not empty o.orderDate}">
                              <fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy"/>
                            </c:when>
                            <c:otherwise>—</c:otherwise>
                          </c:choose>
                        </td>
                        <td class="uacc-order-amt">Rs.<fmt:formatNumber value="${o.totalAmount}" pattern="#,##0.00"/></td>
                        <td><span class="uacc-status ${fn:toLowerCase(o.status)}"><c:out value="${o.status}"/></span></td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:when>
              <c:otherwise>
                <div class="uacc-empty">
                  <i class="fa-solid fa-box-open"></i>
                  <p>No orders yet. Start shopping!</p>
                  <a href="${pageContext.request.contextPath}/user/home" class="uacc-shop-btn">Browse Products</a>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- Quick links -->
        <div class="uacc-quick-links">
          <a href="${pageContext.request.contextPath}/user/wishlist" class="uacc-quick-link">
            <i class="fa-regular fa-heart"></i>
            <span>Wishlist</span>
          </a>
          <a href="${pageContext.request.contextPath}/user/home" class="uacc-quick-link">
            <i class="fa-solid fa-couch"></i>
            <span>Shop Now</span>
          </a>
          <a href="${pageContext.request.contextPath}/user/help" class="uacc-quick-link">
            <i class="fa-regular fa-circle-question"></i>
            <span>Help &amp; FAQ</span>
          </a>
        </div>
      </div>

      <!-- ══ TAB: My Orders ══ -->
      <div id="tab-orders" class="uacc-tab">
        <div class="uacc-panel">
          <div class="uacc-panel-header">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/><path d="M9 12h6M9 16h4"/></svg>
            Order History
          </div>
          <div class="uacc-panel-body" style="padding:0;">
            <c:choose>
              <c:when test="${not empty orders}">
                <table class="uacc-order-table uacc-order-full">
                  <thead>
                    <tr>
                      <th>Order ID</th>
                      <th>Product</th>
                      <th>Type</th>
                      <th>Qty</th>
                      <th>Date</th>
                      <th>Payment</th>
                      <th>Amount</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="o" items="${orders}">
                      <tr>
                        <td class="uacc-order-id">#<c:out value="${o.id}"/></td>
                        <td class="uacc-order-product">
                          <c:out value="${not empty o.productName ? o.productName : o.furnitureType}"/>
                          <c:if test="${not empty o.deliveryLocation}">
                            <span class="uacc-order-loc"><i class="fa-solid fa-location-dot"></i> <c:out value="${o.deliveryLocation}"/></span>
                          </c:if>
                        </td>
                        <td>
                          <span class="uacc-type-badge ${fn:toLowerCase(o.orderType)}">
                            <c:out value="${not empty o.orderType ? o.orderType : 'Normal'}"/>
                          </span>
                        </td>
                        <td class="uacc-order-qty">${o.quantity}</td>
                        <td class="uacc-order-date">
                          <c:choose>
                            <c:when test="${not empty o.orderDate}">
                              <fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy"/>
                            </c:when>
                            <c:otherwise>—</c:otherwise>
                          </c:choose>
                        </td>
                        <td class="uacc-order-pay"><c:out value="${not empty o.paymentMethod ? o.paymentMethod : '—'}"/></td>
                        <td class="uacc-order-amt">Rs.<fmt:formatNumber value="${o.totalAmount}" pattern="#,##0.00"/></td>
                        <td><span class="uacc-status ${fn:toLowerCase(o.status)}"><c:out value="${o.status}"/></span></td>
                      </tr>
                      <!-- Order tracking bar -->
                      <tr class="uacc-track-row">
                        <td colspan="8">
                          <div class="uacc-track">
                            <c:set var="st" value="${fn:toLowerCase(o.status)}"/>
                            <div class="uacc-track-step ${st == 'pending' or st == 'confirmed' or st == 'processing' or st == 'shipped' or st == 'delivered' ? 'done' : ''}">
                              <div class="uacc-track-dot"></div><span>Confirmed</span>
                            </div>
                            <div class="uacc-track-line ${st == 'processing' or st == 'shipped' or st == 'delivered' ? 'done' : ''}"></div>
                            <div class="uacc-track-step ${st == 'processing' or st == 'shipped' or st == 'delivered' ? 'done' : ''}">
                              <div class="uacc-track-dot"></div><span>Processing</span>
                            </div>
                            <div class="uacc-track-line ${st == 'shipped' or st == 'delivered' ? 'done' : ''}"></div>
                            <div class="uacc-track-step ${st == 'shipped' or st == 'delivered' ? 'done' : ''}">
                              <div class="uacc-track-dot"></div><span>Shipped</span>
                            </div>
                            <div class="uacc-track-line ${st == 'delivered' ? 'done' : ''}"></div>
                            <div class="uacc-track-step ${st == 'delivered' ? 'done' : ''}">
                              <div class="uacc-track-dot"></div><span>Delivered</span>
                            </div>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:when>
              <c:otherwise>
                <div class="uacc-empty">
                  <i class="fa-solid fa-box-open"></i>
                  <p>No orders yet. Start shopping!</p>
                  <a href="${pageContext.request.contextPath}/user/home" class="uacc-shop-btn">Browse Products</a>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- ══ TAB: Edit Profile ══ -->
      <div id="tab-profile" class="uacc-tab">
        <div class="uacc-panel">
          <div class="uacc-panel-header">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Edit Profile
          </div>
          <div class="uacc-panel-body">
            <form method="post" action="${pageContext.request.contextPath}/user/account">
              <input type="hidden" name="action" value="profile"/>
              <div class="uacc-form-grid">

                <div class="uacc-field-group">
                  <label class="uacc-field-label">First Name</label>
                  <input type="text" name="firstName" class="uacc-input" required
                         value="<c:out value='${user.firstName}'/>"/>
                </div>
                <div class="uacc-field-group">
                  <label class="uacc-field-label">Last Name</label>
                  <input type="text" name="lastName" class="uacc-input" required
                         value="<c:out value='${user.lastName}'/>"/>
                </div>
                <div class="uacc-field-group">
                  <label class="uacc-field-label">Email</label>
                  <input type="email" name="email" class="uacc-input"
                         placeholder="Enter email"
                         value="<c:out value='${user.email}'/>"/>
                </div>
                <div class="uacc-field-group">
                  <label class="uacc-field-label">Phone Number</label>
                  <input type="text" name="mobileNumber" class="uacc-input"
                         placeholder="Enter phone number"
                         value="<c:out value='${user.mobileNumber}'/>"/>
                </div>
                <div class="uacc-field-group uacc-full">
                  <label class="uacc-field-label">Date of Birth</label>
                  <div class="uacc-dob-row">
                    <select name="birthMonth" class="uacc-select">
                      <option value="" disabled ${empty dobMonth ? 'selected' : ''}>Month</option>
                      <option value="1"  ${dobMonth == 1  ? 'selected' : ''}>January</option>
                      <option value="2"  ${dobMonth == 2  ? 'selected' : ''}>February</option>
                      <option value="3"  ${dobMonth == 3  ? 'selected' : ''}>March</option>
                      <option value="4"  ${dobMonth == 4  ? 'selected' : ''}>April</option>
                      <option value="5"  ${dobMonth == 5  ? 'selected' : ''}>May</option>
                      <option value="6"  ${dobMonth == 6  ? 'selected' : ''}>June</option>
                      <option value="7"  ${dobMonth == 7  ? 'selected' : ''}>July</option>
                      <option value="8"  ${dobMonth == 8  ? 'selected' : ''}>August</option>
                      <option value="9"  ${dobMonth == 9  ? 'selected' : ''}>September</option>
                      <option value="10" ${dobMonth == 10 ? 'selected' : ''}>October</option>
                      <option value="11" ${dobMonth == 11 ? 'selected' : ''}>November</option>
                      <option value="12" ${dobMonth == 12 ? 'selected' : ''}>December</option>
                    </select>
                    <select name="birthDay" class="uacc-select">
                      <option value="" disabled ${empty dobDay ? 'selected' : ''}>Day</option>
                      <c:forEach var="d" begin="1" end="31">
                        <option value="${d}" ${dobDay == d ? 'selected' : ''}>${d}</option>
                      </c:forEach>
                    </select>
                    <select name="birthYear" class="uacc-select">
                      <option value="" disabled ${empty dobYear ? 'selected' : ''}>Year</option>
                      <c:forEach var="i" begin="0" end="87">
                        <c:set var="y" value="${2007 - i}"/>
                        <option value="${y}" ${dobYear == y ? 'selected' : ''}>${y}</option>
                      </c:forEach>
                    </select>
                  </div>
                </div>
                <div class="uacc-field-group">
                  <label class="uacc-field-label">Gender</label>
                  <select name="gender" class="uacc-select">
                    <option value="">— Select —</option>
                    <option value="Male"   ${user.gender == 'Male'   ? 'selected' : ''}>Male</option>
                    <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                    <option value="Other"  ${user.gender == 'Other'  ? 'selected' : ''}>Prefer not to say</option>
                  </select>
                </div>

              </div>
              <div class="uacc-form-actions">
                <button type="submit" class="uacc-btn">
                  <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                  Save Changes
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- ══ TAB: Security ══ -->
      <div id="tab-security" class="uacc-tab">
        <div class="uacc-panel">
          <div class="uacc-panel-header">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            Change Password
          </div>
          <div class="uacc-panel-body">
            <form method="post" action="${pageContext.request.contextPath}/user/account">
              <input type="hidden" name="action" value="password"/>
              <div class="uacc-form-grid single">

                <div class="uacc-field-group">
                  <label class="uacc-field-label">Current Password</label>
                  <div class="uacc-pw-wrap">
                    <input type="password" name="currentPassword" id="curPw" class="uacc-input"
                           required placeholder="Enter current password"/>
                    <button type="button" class="uacc-pw-eye" onclick="uaccTogglePw('curPw')">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                    </button>
                  </div>
                </div>
                <div class="uacc-field-group">
                  <label class="uacc-field-label">New Password</label>
                  <div class="uacc-pw-wrap">
                    <input type="password" name="newPassword" id="newPw" class="uacc-input"
                           required placeholder="Enter new password"/>
                    <button type="button" class="uacc-pw-eye" onclick="uaccTogglePw('newPw')">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                    </button>
                  </div>
                  <small style="color:#888;font-size:12px;">Min 8 characters, uppercase, number &amp; special character (@$!%*?&amp;)</small>
                </div>
                <div class="uacc-field-group">
                  <label class="uacc-field-label">Confirm New Password</label>
                  <div class="uacc-pw-wrap">
                    <input type="password" name="confirmPassword" id="confPw" class="uacc-input"
                           required placeholder="Re-enter new password"/>
                    <button type="button" class="uacc-pw-eye" onclick="uaccTogglePw('confPw')">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                    </button>
                  </div>
                </div>

              </div>
              <div class="uacc-form-actions">
                <button type="submit" class="uacc-btn">
                  <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                  Update Password
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp" />

<div id="uaccToast" data-toast="${param.toast}">
  <span id="uaccToastIcon"></span>
  <span id="uaccToastMsg"></span>
</div>

<script>
  function uaccSwitch(tabId, btn) {
    document.querySelectorAll('.uacc-tab').forEach(function(t){ t.classList.remove('active'); });
    document.querySelectorAll('.uacc-side-btn').forEach(function(b){ b.classList.remove('active'); });
    document.getElementById('tab-' + tabId).classList.add('active');
    if (btn) btn.classList.add('active');
  }

  /* Wire up data-tab buttons (for "View All" etc) */
  document.querySelectorAll('[data-tab]').forEach(function(el) {
    el.addEventListener('click', function() {
      uaccSwitch(this.dataset.tab, document.querySelector('.uacc-side-btn[data-id=' + this.dataset.tab + ']'));
    });
  });

  function uaccTogglePw(id) {
    var inp = document.getElementById(id);
    inp.type = inp.type === 'password' ? 'text' : 'password';
  }

  function uaccPreviewAndSubmit(input) {
    if (!input.files || !input.files[0]) return;
    var reader = new FileReader();
    reader.onload = function(e) {
      var preview = document.getElementById('uaccAvatarPreview');
      if (preview.tagName === 'IMG') {
        preview.src = e.target.result;
      } else {
        var img = document.createElement('img');
        img.src = e.target.result;
        img.id = 'uaccAvatarPreview';
        img.className = 'uacc-avatar-img';
        img.alt = 'Profile';
        preview.parentNode.replaceChild(img, preview);
      }
    };
    reader.readAsDataURL(input.files[0]);
    document.getElementById('imgForm').submit();
  }

  /* Toast on redirect */
  (function() {
    var msgs = {
      profile:     ['✅', 'Profile updated successfully.'],
      password:    ['✅', 'Password changed successfully.'],
      image:       ['✅', 'Profile photo updated.'],
      wrongpw:     ['❌', 'Current password is incorrect.'],
      weakpw:      ['❌', 'Password must be 8+ characters with an uppercase letter, a number, and a special character (@$!%*?&).'],
      mismatch:    ['❌', 'New passwords do not match.'],
      email_taken: ['❌', 'That email address is already used by another account.'],
      phone_taken: ['❌', 'That phone number is already used by another account.'],
      error:       ['❌', 'Something went wrong. Please try again.']
    };
    var key = document.getElementById('uaccToast').dataset.toast || '';
    if (msgs[key]) {
      window.addEventListener('load', function() {
        document.getElementById('uaccToastIcon').textContent = msgs[key][0];
        document.getElementById('uaccToastMsg').textContent  = msgs[key][1];
        var el = document.getElementById('uaccToast');
        el.classList.add('show');
        setTimeout(function() { el.classList.remove('show'); }, 3500);
      });
      /* Switch to relevant tab on toast */
      if (key === 'profile' || key === 'email_taken' || key === 'phone_taken')
        uaccSwitch('profile', document.querySelectorAll('.uacc-side-btn')[2]);
      if (key === 'password' || key === 'wrongpw' || key === 'mismatch' || key === 'weakpw')
        uaccSwitch('security', document.querySelectorAll('.uacc-side-btn')[3]);
    }
  })();
</script>

</body>
</html>
