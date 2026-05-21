<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title"          value="Sign In — Kathmandu Furniture" />
    <jsp:param name="pageFolder"     value="user" />
    <jsp:param name="currentCssFile" value="auth" />
    <jsp:param name="headerCssFile"  value="header" />
    <jsp:param name="footerCssFile"  value="footer" />
</jsp:include>

<body>

<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<div class="auth-page">
    <div class="auth-card">

        <a href="${pageContext.request.contextPath}/user/home" class="auth-logo">
            <img src="${pageContext.request.contextPath}/static/images/kathmanduFurnitureLogo.png"
                 alt="Kathmandu Furniture" />
        </a>

        <h1 class="auth-title">Sign In</h1>
        <p class="auth-subtitle">Welcome back! Enter your credentials to continue.</p>

        <%-- Success message after registration --%>
        <c:if test="${param.registered == 'true'}">
            <div class="auth-alert success">
                Account created! Your account is pending admin approval.
            </div>
        </c:if>

        <%-- Redirect messages --%>
        <c:if test="${param.msg == 'login'}">
            <div class="auth-alert info">Please sign in to continue.</div>
        </c:if>
        <c:if test="${param.msg == 'admin'}">
            <div class="auth-alert info">Admin access only. Please sign in with your admin credentials.</div>
        </c:if>

        <%-- Error message --%>
        <c:if test="${not empty error}">
            <div class="auth-alert error"><c:out value="${error}"/></div>
        </c:if>

        <form class="auth-form" method="post" action="${pageContext.request.contextPath}/login">

            <div class="auth-field">
                <label class="auth-label" for="contact">Email or Phone Number</label>
                <input class="auth-input" type="text" id="contact" name="contact"
                       placeholder="Email or mobile number"
                       value="<c:out value='${contactValue}'/>" required />
            </div>

            <div class="auth-field">
                <label class="auth-label" for="password">Password</label>
                <div class="pw-wrap">
                    <input class="auth-input" type="password" id="password" name="password"
                           placeholder="Enter your password" required />
                    <button type="button" class="pw-eye" onclick="togglePw('password', this)" aria-label="Show password">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
            </div>

            <button type="submit" class="auth-btn">Sign In</button>
        </form>

        <div class="auth-footer">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/user/join-us">Create one</a>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp" />

<script>
    function togglePw(fieldId, btn) {
        var input = document.getElementById(fieldId);
        input.type = input.type === 'password' ? 'text' : 'password';
    }
</script>

</body>
</html>
