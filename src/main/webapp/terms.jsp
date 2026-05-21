<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
  <jsp:param name="title"          value="Terms of Service — Kathmandu Furniture House"/>
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
      <h1>Terms of Service</h1>
      <p>Please read these terms carefully before using our website or placing an order.</p>
      <div class="info-divider"></div>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-file-contract"></i> Acceptance of Terms</h2>
      <p>By accessing or using the Kathmandu Furniture House website and placing orders, you agree to be bound by these Terms of Service. If you do not agree with any part of these terms, please do not use our services.</p>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-user"></i> Account Responsibility</h2>
      <ul>
        <li>You are responsible for maintaining the confidentiality of your account credentials.</li>
        <li>You must provide accurate and complete information when registering.</li>
        <li>You must notify us immediately of any unauthorised use of your account.</li>
        <li>Accounts are for personal use only and may not be transferred to another person.</li>
      </ul>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-cart-shopping"></i> Orders &amp; Payments</h2>
      <ul>
        <li>All prices are listed in Nepalese Rupees (NPR) and are inclusive of applicable taxes.</li>
        <li>We reserve the right to cancel any order if the product is unavailable or pricing errors occur.</li>
        <li>Payment must be completed at the time of checkout. Orders are confirmed only after payment is received.</li>
        <li>We accept cash on delivery, bank transfer, and selected digital payment methods.</li>
      </ul>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-truck"></i> Delivery</h2>
      <p>Delivery timelines are estimates and not guaranteed. We are not liable for delays caused by circumstances beyond our control, including natural events, strikes, or transportation disruptions. Risk of loss transfers to you upon delivery.</p>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-rotate-left"></i> Returns &amp; Refunds</h2>
      <p>Returns are accepted within 30 days of delivery for standard orders in original, unused condition. Custom and made-to-order furniture is non-refundable unless there is a verified manufacturing defect. See our <a href="${pageContext.request.contextPath}/faqs.jsp" style="color:#111827;font-weight:700;">FAQs</a> for the full return process.</p>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-ban"></i> Prohibited Use</h2>
      <p>You may not use our website to:</p>
      <ul>
        <li>Submit false, fraudulent, or misleading information</li>
        <li>Place orders with no intent to pay or receive</li>
        <li>Attempt to access other users' accounts</li>
        <li>Scrape or copy content without permission</li>
      </ul>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-circle-info"></i> Changes to Terms</h2>
      <p>We reserve the right to update these Terms of Service at any time. Continued use of our website after changes are posted constitutes acceptance of the revised terms. We will notify registered users of significant changes via email.</p>
    </div>

  </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp"/>
</body>
</html>
