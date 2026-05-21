<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
  <jsp:param name="title"          value="About Us — Kathmandu Furniture House"/>
  <jsp:param name="pageFolder"     value="user"/>
  <jsp:param name="currentCssFile" value="info"/>
  <jsp:param name="headerCssFile"  value="header"/>
  <jsp:param name="footerCssFile"  value="footer"/>
</jsp:include>
<body>
<jsp:include page="/WEB-INF/templates/user/header.jsp"/>

<div class="info-page">
  <div class="info-container">

    <div class="info-hero">
      <h1>About Us</h1>
      <p>Crafting quality furniture for Nepali homes since 1998.</p>
      <div class="info-divider"></div>
    </div>

    <!-- Stats -->
    <div class="about-stats">
      <div class="about-stat">
        <div class="about-stat-val">25+</div>
        <div class="about-stat-lbl">Years in Business</div>
      </div>
      <div class="about-stat">
        <div class="about-stat-val">10k+</div>
        <div class="about-stat-lbl">Happy Customers</div>
      </div>
      <div class="about-stat">
        <div class="about-stat-val">500+</div>
        <div class="about-stat-lbl">Products</div>
      </div>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-house"></i> Our Story</h2>
      <p>Kathmandu Furniture House was founded in 1998 with a simple mission: bring high-quality, affordable furniture to every home in Nepal. Starting from a small showroom in Pokhara, we have grown into one of the most trusted furniture brands in the country.</p>
      <p>Every piece we sell is designed with care, built to last, and crafted to fit the lifestyle of modern Nepali families. From classic wood designs to contemporary minimalist styles, our catalogue reflects the diversity of our customers.</p>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-bullseye"></i> Our Mission</h2>
      <p>To provide durable, beautiful, and affordable furniture that transforms houses into homes — with a shopping experience that is simple, honest, and enjoyable.</p>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-star"></i> Why Choose Us</h2>
      <ul>
        <li>Locally crafted furniture using sustainably sourced materials</li>
        <li>Free delivery within Pokhara and major cities across Nepal</li>
        <li>Professional installation service available on request</li>
        <li>30-day return policy on all standard orders</li>
        <li>Custom furniture orders tailored to your exact specifications</li>
        <li>Dedicated after-sales support and warranty on all products</li>
      </ul>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-location-dot"></i> Visit Our Showroom</h2>
      <p><strong>Address:</strong> Lakeside Road, Pokhara, Gandaki Province, Nepal</p>
      <p><strong>Hours:</strong> Sunday – Friday, 9:00 AM – 7:00 PM</p>
      <p><strong>Phone:</strong> +977 9800000000</p>
      <p><strong>Email:</strong> info@kathmanduFurniture.com</p>
    </div>

  </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp"/>
</body>
</html>
