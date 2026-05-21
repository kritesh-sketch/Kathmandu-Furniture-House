<div class="sidebar-overlay" id="sidebarOverlay"></div>
<aside class="sidebar" id="sidebar">
  <a href="${pageContext.request.contextPath}/" class="logo" style="text-decoration:none;color:inherit;display:flex;flex-direction:column;align-items:center;gap:6px;padding:0 12px;">
    <img src="${pageContext.request.contextPath}/static/images/kathmanduFurnitureLogo.png" alt="Kathmandu Furniture" style="height:40px;width:auto;" />
    <span style="font-size:12px;font-weight:700;letter-spacing:.3px;color:var(--t1);white-space:nowrap;margin-bottom:8px;">Kathmandu Furniture House</span>
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
<a href="${pageContext.request.contextPath}/admin/orders"
       class="nav-item${param.activePage == 'orders' ? ' active' : ''}">
      <i class="fa-solid fa-clipboard-list"></i> <span>Orders</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/allocations"
       class="nav-item${param.activePage == 'allocations' ? ' active' : ''}">
      <i class="fa-solid fa-boxes-stacked"></i> <span>Allocations</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/storage"
       class="nav-item${param.activePage == 'storage' ? ' active' : ''}">
      <i class="fa-solid fa-warehouse"></i> <span>Storage</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/analytics"
       class="nav-item${param.activePage == 'analytics' ? ' active' : ''}">
      <i class="fa-solid fa-chart-line"></i> <span>Analytics</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/feedback"
       class="nav-item${param.activePage == 'feedback' ? ' active' : ''}">
      <i class="fa-regular fa-comment-dots"></i> <span>Feedback</span>
    </a>

  </nav>
  <div class="sidebar-footer">
    <a href="#" class="nav-item"
       onclick="event.preventDefault();if(confirm('Logout?'))window.location.href='${pageContext.request.contextPath}/logout';">
      <i class="fa-solid fa-arrow-right-from-bracket"></i> <span>Logout</span>
    </a>
  </div>
</aside>
