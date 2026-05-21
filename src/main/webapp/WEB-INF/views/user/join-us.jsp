<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="Join Us — Kathmandu Furniture" />
    <jsp:param name="pageFolder" value="user" />
    <jsp:param name="currentCssFile" value="auth" />
    <jsp:param name="headerCssFile" value="header" />
    <jsp:param name="footerCssFile" value="footer" />
</jsp:include>

<body>

<jsp:include page="/WEB-INF/templates/user/header.jsp" />

<div class="auth-page">
    <div class="auth-card" style="max-width:520px;">

        <a href="${pageContext.request.contextPath}/user/home" class="auth-logo">
            <img src="${pageContext.request.contextPath}/static/images/kathmanduFurnitureLogo.png" alt="Kathmandu Furniture" />
        </a>

        <h1 class="auth-title">Create Your Account</h1>
        <p class="auth-subtitle">Join us to explore premium furniture. Your account will be activated after admin approval.</p>

        <c:if test="${not empty error}">
            <div class="auth-alert error"><c:out value="${error}"/></div>
        </c:if>

        <form class="auth-form" method="post" action="${pageContext.request.contextPath}/user/join-us">

            <div class="auth-row">
                <div class="auth-field">
                    <label class="auth-label" for="firstName">First Name <span style="color:#e53935">*</span></label>
                    <input class="auth-input" type="text" id="firstName" name="firstName"
                           placeholder="First name" value="<c:out value='${v_firstName}'/>" required />
                </div>
                <div class="auth-field">
                    <label class="auth-label" for="lastName">Last Name <span style="color:#e53935">*</span></label>
                    <input class="auth-input" type="text" id="lastName" name="lastName"
                           placeholder="Last name" value="<c:out value='${v_lastName}'/>" required />
                </div>
            </div>

            <div class="auth-field">
                <label class="auth-label" for="email">Email Address <span style="color:#e53935">*</span></label>
                <input class="auth-input" type="email" id="email" name="email"
                       placeholder="you@example.com" value="<c:out value='${v_email}'/>" required />
            </div>

            <div class="auth-field">
                <label class="auth-label" for="phone">Phone Number <span style="color:#e53935">*</span></label>
                <input class="auth-input" type="tel" id="phone" name="phone"
                       placeholder="e.g. 9800000000" value="<c:out value='${v_phone}'/>" required />
            </div>

            <div class="auth-row">
                <div class="auth-field">
                    <label class="auth-label" for="dob">Date of Birth</label>
                    <input class="auth-input" type="date" id="dob" name="dob"
                           value="<c:out value='${v_dob}'/>" />
                </div>
                <div class="auth-field">
                    <label class="auth-label">Gender</label>
                    <div class="gender-group">
                        <label class="gender-option">
                            <input type="radio" name="gender" value="Male"
                                   ${v_gender == 'Male' ? 'checked' : ''} /> Male
                        </label>
                        <label class="gender-option">
                            <input type="radio" name="gender" value="Female"
                                   ${v_gender == 'Female' ? 'checked' : ''} /> Female
                        </label>
                        <label class="gender-option">
                            <input type="radio" name="gender" value="Other"
                                   ${v_gender == 'Other' ? 'checked' : ''} /> Other
                        </label>
                    </div>
                </div>
            </div>

            <div class="auth-field">
                <label class="auth-label" for="password">Password <span style="color:#e53935">*</span></label>
                <div class="pw-wrap">
                    <input class="auth-input" type="password" id="password" name="password"
                           placeholder="Create a password" required />
                    <button type="button" class="pw-eye" onclick="togglePw('password', this)" aria-label="Show password">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
                <small style="color:#888;font-size:12px;">Min 8 characters, uppercase, number &amp; special character (@$!%*?&amp;#)</small>
            </div>

            <div class="auth-field">
                <label class="auth-label" for="confirmPassword">Confirm Password <span style="color:#e53935">*</span></label>
                <div class="pw-wrap">
                    <input class="auth-input" type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Repeat your password" required />
                    <button type="button" class="pw-eye" onclick="togglePw('confirmPassword', this)" aria-label="Show password">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
            </div>

            <button type="submit" class="auth-btn">Create Account</button>
        </form>

        <div class="auth-footer">
            Already have an account?
            <a href="${pageContext.request.contextPath}/user/login">Sign In</a>
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

