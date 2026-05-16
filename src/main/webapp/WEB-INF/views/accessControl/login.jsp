<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="/static/css/accessControl/login.css" />

<body>
<!-- Logo Section -->
<%--<jsp:include page="${pageContext.request.contextPath}/WEB-INF/templates/accessControl/header.jsp" />--%>

<!-- Welcome text -->
<section class="login-information">
    <div class="welcome-text">
        <p class="text">
            Explore <br />the <br />
            things <br />
            <span style="color: #7b7b7b">you love</span>.
        </p>
    </div>

    <!-- Login Images -->
    <div class="display-image">
        <!-- FIRST IMAGE -->

        <div class="image-display">
            <img src="${pageContext.request.contextPath}/static/images/book.png" alt="Image display in login" />
        </div>

        <!-- Second image -->

        <div class="image-display">
            <img src="./../images/19 Beige Curtains Living Room Ideas for Warm Minimal Look.jpg" alt="" />
        </div>

        <!-- Third Image -->
        <div class="image-display">
            <img
                    src="./../images/Tappeto Corridoio Morbido per Camera da letto_Soggiorno soffice e peluche - 100_150cm _ Bianco.jpg"
                    alt="Image 3" />
        </div>
    </div>
    <!-- Login entry section -->
    <section class="login-form">
        <form action="${pageContext.request.contextPath}/login" method="post">
            <h1 class="login-form-heading">Log into Mattress</h1>

            <c:if test="${not empty error}">
                <p class="error"><c:out value="${error}" /></p>
            </c:if>

            <div class="entry-box">
                <input type="text" class="input-box" name="contact" placeholder="Email or mobile number"
                       value="<c:out value='${param.contact}' default='${cookie.contact.value}' />" required />
                <input type="password" class="input-box" placeholder="Password" required/>
            </div>
            <button class="login-btn" type="submit">Log in</button>
            <p>Forget password ?</p>
            <a href="${pageContext.request.contextPath}/register">
                <button class="crt-act-btn">Create a new account</button>
            </a>
            <p class="declaring-name">
                <span class="at-symbol">@ </span>Kathmandu Furniture House
            </p>
        </form>
    </section>

    <!--  -->
</section>

<!--  -->
</body>

</html>