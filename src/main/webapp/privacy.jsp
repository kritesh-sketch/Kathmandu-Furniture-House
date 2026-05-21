<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
  <jsp:param name="title"          value="Privacy Policy — Kathmandu Furniture House"/>
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
      <h1>Privacy Policy</h1>
      <p>Last updated: January 2026</p>
      <div class="info-divider"></div>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-shield-halved"></i> Information We Collect</h2>
      <p>When you create an account or place an order, we collect the following information:</p>
      <ul>
        <li>Full name, email address, and phone number</li>
        <li>Delivery address and order details</li>
        <li>Payment method (we do not store full card details)</li>
        <li>Profile photo (if uploaded)</li>
        <li>Date of birth and gender (optional, for personalisation)</li>
      </ul>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-gear"></i> How We Use Your Information</h2>
      <p>We use the information we collect to:</p>
      <ul>
        <li>Process and fulfil your orders</li>
        <li>Send order confirmations and delivery updates</li>
        <li>Respond to your enquiries and support requests</li>
        <li>Personalise your shopping experience</li>
        <li>Improve our website, products, and services</li>
        <li>Send promotional offers (only with your consent)</li>
      </ul>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-lock"></i> Data Security</h2>
      <p>We take the security of your personal data seriously. All passwords are stored using industry-standard BCrypt hashing. Our servers use HTTPS encryption to protect data in transit. We do not sell or share your personal information with third parties for marketing purposes.</p>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-cookie"></i> Cookies</h2>
      <p>We use session cookies to keep you logged in during your visit. These cookies are deleted when you close your browser. We do not use tracking cookies or third-party advertising cookies.</p>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-user-shield"></i> Your Rights</h2>
      <p>You have the right to:</p>
      <ul>
        <li>Access and update your personal information at any time via My Account</li>
        <li>Request deletion of your account and associated data</li>
        <li>Opt out of promotional communications</li>
        <li>Request a copy of the data we hold about you</li>
      </ul>
      <p>To exercise any of these rights, contact us at <strong>info@kathmanduFurniture.com</strong>.</p>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-envelope"></i> Contact</h2>
      <p>If you have questions about this Privacy Policy, please contact us at <strong>info@kathmanduFurniture.com</strong> or call <strong>+977 9800000000</strong>.</p>
    </div>

  </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp"/>
</body>
</html>
