<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
  <jsp:param name="title"          value="Shipping Policy — Kathmandu Furniture House"/>
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
      <h1>Shipping Policy</h1>
      <p>Everything you need to know about how we deliver your furniture.</p>
      <div class="info-divider"></div>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-truck-fast"></i> Delivery Timelines</h2>
      <table class="ship-table">
        <thead>
          <tr>
            <th>Location</th>
            <th>Standard Delivery</th>
            <th>Delivery Fee</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Pokhara (city area)</td>
            <td>2 – 4 business days</td>
            <td>Free</td>
          </tr>
          <tr>
            <td>Pokhara (outskirts)</td>
            <td>3 – 5 business days</td>
            <td>Rs. 200 – 500</td>
          </tr>
          <tr>
            <td>Kathmandu Valley</td>
            <td>5 – 7 business days</td>
            <td>Rs. 500 – 1,000</td>
          </tr>
          <tr>
            <td>Other major cities</td>
            <td>7 – 10 business days</td>
            <td>Rs. 800 – 1,500</td>
          </tr>
          <tr>
            <td>Remote areas</td>
            <td>10 – 15 business days</td>
            <td>Calculated at checkout</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-screwdriver-wrench"></i> Installation</h2>
      <p>Free professional installation is included for the following items delivered within Pokhara:</p>
      <ul>
        <li>Wardrobes and storage units</li>
        <li>Beds and bedroom furniture</li>
        <li>Modular shelving and cabinets</li>
      </ul>
      <p>For deliveries outside Pokhara, installation can be arranged at an additional cost of Rs. 500 – 2,000 depending on the product and location. Please contact us to schedule installation.</p>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-circle-exclamation"></i> Important Notes</h2>
      <ul>
        <li>Delivery times are estimates and may vary due to high demand, public holidays, or weather conditions.</li>
        <li>Please ensure someone is available at the delivery address to receive the furniture.</li>
        <li>Inspect your furniture upon delivery. If there is any visible damage, note it with the delivery team before signing.</li>
        <li>Large items may require ground-floor delivery in buildings without lifts — please inform us in advance.</li>
        <li>Custom orders are shipped after production is complete. Expected lead time is 2 – 4 weeks.</li>
      </ul>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-headset"></i> Delivery Support</h2>
      <p>If you have questions about your delivery or need to reschedule, please contact us:</p>
      <p><strong>Phone:</strong> +977 9800000000</p>
      <p><strong>Email:</strong> info@kathmanduFurniture.com</p>
      <p><strong>Hours:</strong> Sunday – Friday, 9:00 AM – 7:00 PM</p>
    </div>

  </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp"/>
</body>
</html>
