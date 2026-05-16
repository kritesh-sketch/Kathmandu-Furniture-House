<!-- Site Navigation Header -->
<header class="site-header" id="siteHeader">
  <div class="top-nav">
    <div class="top-nav-links">
      <a href="https://www.google.com/maps/search/kathmansu+furniture/@28.1363018,83.4438245,9z?entry=ttu&g_ep=EgoyMDI2MDQyOC4wIKXMDSoASAFQAw%3D%3D"
        target="_blank">Find a Store</a>
      <a href="${pageContext.request.contextPath}/user/help">Help</a>
      <a href="${pageContext.request.contextPath}/user/join-us">Join Us</a>
      <a href="${pageContext.request.contextPath}/user/login">Sign In</a>
    </div>
  </div>
  <nav class="main-nav">
    <a href="${pageContext.request.contextPath}/user/home" class="site-logo">
      <img src="${pageContext.request.contextPath}/static/images/logo-2.png" alt="Site Logo">
    </a>
    <div class="nav-links">
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/user/sofas">Sofas &amp; Seating</a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/user/beds">Beds &amp; Mattresses</a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/user/tables">Tables &amp; Desks</a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/user/chairs">Chairs &amp; Stools</a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/user/decor">Decor &amp; Rugs</a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/user/storage">Storage &amp; Cabinets</a>
      </div>
    </div>
    <div class="nav-actions">
      <div class="search-spacer-left"></div>
      <div class="search-container">
        <svg viewBox="0 0 24 24">
          <circle cx="11" cy="11" r="7" />
          <line x1="21" y1="21" x2="16" y2="16" />
        </svg>
        <input type="text" placeholder="Search" id="searchInput" />
      </div>
      <div class="search-spacer-right"></div>
      <a href="${pageContext.request.contextPath}/user/wishlist" class="nav-action-btn" aria-label="Wishlist">
        <svg viewBox="0 0 24 24">
          <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
        </svg>
      </a>
      <a href="${pageContext.request.contextPath}/user/cart" class="nav-action-btn" aria-label="Cart">
        <svg viewBox="0 0 24 24">
          <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
          <line x1="3" y1="6" x2="21" y2="6" />
          <path d="M16 10a4 4 0 0 1-8 0" />
        </svg>
      </a>
      <button class="cancel-btn" id="cancelSearch">Cancel</button>
    </div>
  </nav>

  <div class="search-backdrop">
    <div class="search-overlay-content">
      <div class="popular-terms">
        <h4>Popular Search Terms</h4>
        <div class="term-pills">
          <a href="${pageContext.request.contextPath}/user/sofas" class="term-pill">Sofas</a>
          <a href="${pageContext.request.contextPath}/user/beds" class="term-pill">Beds</a>
          <a href="${pageContext.request.contextPath}/user/tables" class="term-pill">Dining Table</a>
          <a href="${pageContext.request.contextPath}/user/chairs" class="term-pill">Office Chair</a>
          <a href="${pageContext.request.contextPath}/user/decor" class="term-pill">Rugs</a>
          <a href="${pageContext.request.contextPath}/user/storage" class="term-pill">Wardrobes</a>
          <a href="${pageContext.request.contextPath}/user/products" class="term-pill">New Arrivals</a>
          <a href="${pageContext.request.contextPath}/user/beds" class="term-pill">Mattresses</a>
        </div>
      </div>
    </div>
  </div>
</header>
