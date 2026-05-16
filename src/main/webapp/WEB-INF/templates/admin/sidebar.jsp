<div class="sidebar-overlay" id="sidebarOverlay"></div>
<aside class="sidebar" id="sidebar">
  <a href="${pageContext.request.contextPath}/" class="logo" style="text-decoration:none;color:inherit;">
    <img src="${pageContext.request.contextPath}/static/images/logo-2.png" alt="Kathmandu Furniture" style="height:40px;width:auto;" />
  </a>
  <nav class="main-nav">
    <a href="${pageContext.request.contextPath}/admin/dashboard"
       class="nav-item${param.activePage == 'dashboard' ? ' active' : ''}">
      <i class="fa-solid fa-house"></i> <span>Dashboard</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/user-registration"
       class="nav-item${param.activePage == 'user-registration' ? ' active' : ''}">
      <i class="fa-solid fa-users"></i> <span>User Registration</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/products"
       class="nav-item${param.activePage == 'products' ? ' active' : ''}">
      <i class="fa-solid fa-box"></i> <span>Products</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/applications"
       class="nav-item${param.activePage == 'applications' ? ' active' : ''}">
      <i class="fa-solid fa-file-lines"></i> <span>Applications</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/orders"
       class="nav-item${param.activePage == 'orders' ? ' active' : ''}">
      <i class="fa-solid fa-clipboard-list"></i> <span>Orders</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/return-orders"
       class="nav-item${param.activePage == 'return-orders' ? ' active' : ''}">
      <i class="fa-solid fa-rotate-left"></i> <span>Return Orders</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/feedback"
       class="nav-item${param.activePage == 'feedback' ? ' active' : ''}">
      <i class="fa-regular fa-comment-dots"></i> <span>Feedback</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/offers"
       class="nav-item${param.activePage == 'offers' ? ' active' : ''}">
      <i class="fa-solid fa-tag"></i> <span>Offers</span>
    </a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/admin/account"
       class="nav-item${param.activePage == 'account' ? ' active' : ''}">
      <i class="fa-regular fa-user"></i> <span>Account</span>
    </a>
    <a href="#" class="nav-item"
       onclick="event.preventDefault();if(confirm('Logout?'))window.location.href='${pageContext.request.contextPath}/login';">
      <i class="fa-solid fa-arrow-right-from-bracket"></i> <span>Logout</span>
    </a>
  </div>
</aside>
