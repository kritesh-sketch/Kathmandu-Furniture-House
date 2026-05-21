<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
  <jsp:param name="title"          value="FAQs — Kathmandu Furniture House"/>
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
      <h1>Frequently Asked Questions</h1>
      <p>Find answers to the most common questions about our products and services.</p>
      <div class="info-divider"></div>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-box"></i> Orders &amp; Delivery</h2>

      <div class="faq-item">
        <div class="faq-q">How long does delivery take? <i class="fa-solid fa-chevron-down"></i></div>
        <div class="faq-a">Standard delivery within Pokhara takes 2–4 business days. Delivery to other cities in Nepal takes 5–10 business days depending on the location. Custom orders may take additional time based on production.</div>
      </div>

      <div class="faq-item">
        <div class="faq-q">Is delivery free? <i class="fa-solid fa-chevron-down"></i></div>
        <div class="faq-a">Yes! We offer free delivery within Pokhara for all orders. For deliveries outside Pokhara, a shipping fee may apply depending on the distance and weight of the furniture.</div>
      </div>

      <div class="faq-item">
        <div class="faq-q">Can I track my order? <i class="fa-solid fa-chevron-down"></i></div>
        <div class="faq-a">Yes. Once your order is confirmed, you can track its status from the My Account page under the "My Orders" section. You will see whether your order is Pending, Processing, Shipped, or Delivered.</div>
      </div>

      <div class="faq-item">
        <div class="faq-q">Can I change or cancel my order after placing it? <i class="fa-solid fa-chevron-down"></i></div>
        <div class="faq-a">You can request a cancellation or change within 24 hours of placing the order by contacting us via phone or email. Once the order is in processing, changes may not be possible.</div>
      </div>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-rotate-left"></i> Returns &amp; Refunds</h2>

      <div class="faq-item">
        <div class="faq-q">What is your return policy? <i class="fa-solid fa-chevron-down"></i></div>
        <div class="faq-a">We accept returns within 30 days of delivery for standard orders, provided the item is unused, in its original condition, and in original packaging. Custom orders are non-refundable unless there is a manufacturing defect.</div>
      </div>

      <div class="faq-item">
        <div class="faq-q">How do I initiate a return? <i class="fa-solid fa-chevron-down"></i></div>
        <div class="faq-a">Contact our support team via email at info@kathmanduFurniture.com or call +977 9800000000. Provide your order ID and reason for return. Our team will arrange a pickup within 3–5 business days.</div>
      </div>

      <div class="faq-item">
        <div class="faq-q">When will I receive my refund? <i class="fa-solid fa-chevron-down"></i></div>
        <div class="faq-a">Refunds are processed within 7–10 business days after we receive and inspect the returned item. Refunds are issued to the original payment method.</div>
      </div>
    </div>

    <div class="info-card">
      <h2><i class="fa-solid fa-screwdriver-wrench"></i> Products &amp; Customization</h2>

      <div class="faq-item">
        <div class="faq-q">Do you offer custom furniture? <i class="fa-solid fa-chevron-down"></i></div>
        <div class="faq-a">Yes! We offer fully customizable furniture. You can specify the material, dimensions, design style, color, and other requirements. Place a custom order from any product page or contact us directly.</div>
      </div>

      <div class="faq-item">
        <div class="faq-q">Do your products come with a warranty? <i class="fa-solid fa-chevron-down"></i></div>
        <div class="faq-a">Yes. Most products come with a 1-year warranty covering manufacturing defects. Some premium products carry extended warranties — check the product detail page for specific warranty information.</div>
      </div>

      <div class="faq-item">
        <div class="faq-q">Is installation included? <i class="fa-solid fa-chevron-down"></i></div>
        <div class="faq-a">Free installation is included for large furniture items such as wardrobes, beds, and modular shelving within Pokhara. For other locations, installation can be arranged at an additional cost.</div>
      </div>
    </div>

  </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp"/>

<script>
  document.querySelectorAll('.faq-q').forEach(function(q) {
    q.addEventListener('click', function() {
      var item = this.closest('.faq-item');
      item.classList.toggle('open');
    });
  });
</script>
</body>
</html>
