<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="Kathmandu Furniture - Home" />
    <jsp:param name="pageFolder" value="user" />
    <jsp:param name="currentCssFile" value="home" />
    <jsp:param name="headerCssFile" value="header" />
    <jsp:param name="footerCssFile" value="footer" />
</jsp:include>


<body>

<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<!-- Landing View 3-Column Hero -->
<div class="hero-container">
    <div class="video-column">
        <video class="background-video" autoplay muted loop playsinline>
            <source src="${pageContext.request.contextPath}/static/videos/homeProductDisplayVideo.mp4" type="video/mp4" />
        </video>
    </div>
    <div class="video-column">
        <video class="background-video" autoplay muted loop playsinline>
            <source src="${pageContext.request.contextPath}/static/videos/homeProductDisplayVideo.mp4" type="video/mp4" />
        </video>
    </div>
    <div class="video-column">
        <video class="background-video" autoplay muted loop playsinline>
            <source src="${pageContext.request.contextPath}/static/videos/homeProductDisplayVideo.mp4" type="video/mp4" />
        </video>
    </div>

    <div class="overlay"></div>

    <div class="hero-content">
        <h1 class="hero-heading">Kathmandu Furniture</h1>
        <p class="hero-subheading">
            Crafted for Comfort. Designed for Life.
        </p>
        <a href="${pageContext.request.contextPath}/user/products" class="hero-button">Shop</a>
    </div>
</div>

<!-- Promotional Features Section -->
<section class="features-section">
    <div class="feature-card">
        <img src="${pageContext.request.contextPath}/static/images/user/heritage_wardrobe_banner.png" alt="Heritage Collection" class="feature-image" />
        <div class="feature-card-overlay"></div>
        <div class="feature-content">
            <p class="feature-subtitle">Heritage Collection</p>
            <h2 class="feature-title">Celebrate History</h2>
            <a href="${pageContext.request.contextPath}/user/products" class="feature-button">Shop</a>
        </div>
    </div>
    <div class="feature-card">
        <img src="${pageContext.request.contextPath}/static/images/user/modern_living_banner.png" alt="The Modern Living Edit" class="feature-image" />
        <div class="feature-card-overlay"></div>
        <div class="feature-content">
            <p class="feature-subtitle">The Modern Living Edit</p>
            <h2 class="feature-title">Different Space.<br>Same Standard.</h2>
            <a href="${pageContext.request.contextPath}/user/products" class="feature-button">Shop</a>
        </div>
    </div>
</section>

<!-- Furniture Theme 3-Column Section -->
<section class="furniture-section">
    <div class="furniture-card">
        <img src="${pageContext.request.contextPath}/static/images/user/girl_on_sofa.png" alt="Living Room with Modern Sofa" class="furniture-image" />
        <div class="furniture-btn-container">
            <a href="${pageContext.request.contextPath}/user/sofas" class="furniture-button">Shop Living Room</a>
        </div>
    </div>
    <div class="furniture-card">
        <img src="${pageContext.request.contextPath}/static/images/user/girl_at_desk.png" alt="Chic Modern Dining" class="furniture-image" />
        <div class="furniture-btn-container">
            <a href="${pageContext.request.contextPath}/user/tables" class="furniture-button">Shop Dining</a>
        </div>
    </div>
    <div class="furniture-card">
        <img src="${pageContext.request.contextPath}/static/images/user/girl_in_bedroom.png" alt="Elegant Modern Bedroom" class="furniture-image" />
        <div class="furniture-btn-container">
            <a href="${pageContext.request.contextPath}/user/beds" class="furniture-button">Shop Bedroom</a>
        </div>
    </div>
</section>

<!-- Spotlight Section -->
<section class="spotlight-section">
    <div class="spotlight-header">
        <h2>SPOTLIGHT</h2>
        <p>Classic silhouettes and cutting-edge innovation to build your home from the ground up.</p>
    </div>

    <div class="spotlight-grid">
        <c:choose>
            <c:when test="${not empty spotlightProducts}">
                <c:forEach var="product" items="${spotlightProducts}">
                    <a href="${pageContext.request.contextPath}/user/product-details?id=${product.id}" class="spotlight-item">
                        <img src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(product.image)}"
                             alt="${fn:escapeXml(product.productName)}">
                        <p>${product.productName}</p>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <!-- Fallback to static items if no data in DB -->
                <a href="#" class="spotlight-item">
                    <img src="${pageContext.request.contextPath}/static/images/sofa-removebg-preview.png" alt="Sofa">
                    <p>Modern Sofa</p>
                </a>
                <a href="#" class="spotlight-item">
                    <img src="${pageContext.request.contextPath}/static/images/chair-removebg-preview.png" alt="Chair">
                    <p>Dining Chair</p>
                </a>
                <!-- ... other items ... -->
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="/WEB-INF/templates/user/footer.jsp" />

</body>
</html>
