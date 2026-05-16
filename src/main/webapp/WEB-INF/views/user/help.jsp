<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="Help — Kathmandu Furniture" />
    <jsp:param name="pageFolder" value="user" />
    <jsp:param name="currentCssFile" value="help" />
    <jsp:param name="headerCssFile" value="header" />
    <jsp:param name="footerCssFile" value="footer" />
</jsp:include>

<body>

<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<div class="help-page">

    <div class="help-hero">
        <h1>How Can We Help?</h1>
        <p>Find answers to common questions about orders, delivery, and our products.</p>
    </div>

    <%-- Contact Cards --%>
    <h2 class="help-section-title">Get in Touch</h2>
    <div class="contact-grid">
        <div class="contact-card">
            <svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.61 3.4 2 2 0 0 1 3.6 1.22h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.81a16 16 0 0 0 6.29 6.29l.95-.95a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
            <h3>Phone</h3>
            <p><a href="tel:9991108081">9991108081</a><br/>Mon–Sat, 10am–6pm</p>
        </div>
        <div class="contact-card">
            <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
            <h3>Email</h3>
            <p><a href="mailto:info@hammeronline.in">info@hammeronline.in</a><br/>Response within 24 hours</p>
        </div>
        <div class="contact-card">
            <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            <h3>Store</h3>
            <p>Kathmandu, Nepal<br/><a href="https://www.google.com/maps/search/kathmandu+furniture" target="_blank">Get Directions</a></p>
        </div>
    </div>

    <%-- FAQ --%>
    <h2 class="help-section-title">Frequently Asked Questions</h2>
    <div class="faq-list">

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How long does delivery take? <span class="faq-icon">+</span>
            </button>
            <div class="faq-answer">
                Standard delivery within Kathmandu valley takes 3–5 business days. Outside the valley, delivery may take 7–14 business days depending on location. You will receive a tracking notification once your order is dispatched.
            </div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can I return or exchange a product? <span class="faq-icon">+</span>
            </button>
            <div class="faq-answer">
                Yes, we accept returns within 7 days of delivery provided the item is unused and in its original packaging. Please contact us at info@hammeronline.in to initiate a return. Custom-made furniture is non-returnable.
            </div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Do you offer assembly services? <span class="faq-icon">+</span>
            </button>
            <div class="faq-answer">
                Yes, free assembly is included for all furniture purchased within the Kathmandu valley. Our team will contact you to schedule a convenient installation time after delivery.
            </div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What payment methods are accepted? <span class="faq-icon">+</span>
            </button>
            <div class="faq-answer">
                We accept cash on delivery, bank transfer, eSewa, Khalti, and all major credit/debit cards. For large orders, EMI options may be available — please contact us for details.
            </div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Do products come with a warranty? <span class="faq-icon">+</span>
            </button>
            <div class="faq-answer">
                All our furniture comes with a minimum 1-year warranty against manufacturing defects. Some premium items carry a 3-year warranty. Warranty details are listed on each product page.
            </div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can I customise furniture dimensions or colour? <span class="faq-icon">+</span>
            </button>
            <div class="faq-answer">
                Yes! We offer customisation for most of our furniture lines. Please visit our store or email us with your requirements and we will provide a quote within 2 business days.
            </div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I track my order? <span class="faq-icon">+</span>
            </button>
            <div class="faq-answer">
                Once your order is dispatched you will receive an SMS and email with a tracking link. You can also log in to your account and visit the Track Your Order section for real-time status updates.
            </div>
        </div>

    </div>

</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp" />

<script>
    function toggleFaq(btn) {
        var item = btn.parentElement;
        item.classList.toggle('open');
    }
</script>

</body>
</html>

