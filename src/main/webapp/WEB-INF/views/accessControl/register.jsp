<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title" value="Welcome Kathmandu Furniture House — Login" />
    <jsp:param name="pageFolder" value="accessControl"/>
    <jsp:param name="cssFile" value="register" />
</jsp:include>

<body>
<!-- Logo Section -->
<jsp:include page="/WEB-INF/templates/accessControl/header.jsp" />

<div class="main">

    <div class="content">
        <form action="${pageContext.request.contextPath}/register" method="post">
            <!-- Back -->
            <div class="back-arrow">&#8249;</div>

            <!-- Heading -->
            <h1 class="form-title">Get started on funiture Membership</h1>
            <p class="form-subtitle">
                Create an account to connect with friends, family and communities of
                people who share your interests.
            </p>
            <c:if test="${not empty error}">
                <p class="error"><c:out value="${error}" /></p>
            </c:if>
            <!-- Name -->
            <div class="field-group">

                <label class="field-label">Name</label>
                <div class="input-row">
                    <input type="text" name="firstName" placeholder="First Name"
                           value="<c:out value='${param.firstName}' default='' />" required/>
                    <input type="text" name="firstName" placeholder="Last Name"
                           value="<c:out value='${param.lastName}' default='' />" required/>
                </div>
            </div>

            <!-- Birthday -->
            <div class="field-group">
                <label class="field-label">Birthday</label>

                <div class="select-row">

                    <!-- Year -->
                    <select name="birthYear">
                        <option value="" disabled selected>Year</option>
                        <c:forEach var="y" items="${years}">
                            <option value="${y}">${y}</option>
                        </c:forEach>
                    </select>

                    <!-- Month -->
                    <select name="birthMonth">
                        <option value="" disabled selected>Month</option>
                        <c:forEach var="m" items="${months}">
                            <option value="${m}">${m}</option>
                        </c:forEach>
                    </select>

                    <!-- Day -->
                    <select name="birthDay">
                        <option value="" disabled selected>Day</option>
                        <c:forEach var="d" items="${days}">
                            <option value="${d}">${d}</option>
                        </c:forEach>
                    </select>

                </div>
            </div>

            <!-- Gender -->
            <div class="field-group">
                <label class="field-label">Gender</label>
                <select class="gender-select" name="gender" style="width: 100%" required>
                    <option value="" disabled selected>Select your gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Non-binary">Non-binary</option>
                    <option value="Prefer not to say">Prefer not to say</option>
                </select>
            </div>

            <!-- Mobile / Email -->
            <div class="field-group">
                <label class="field-label">Mobile number or email</label>
                <input type="text" name = "contact" placeholder="Mobile number or email"
                       value="<c:out value='${param.email}' default='' />" requried/>
                <p class="helper-text">
                    You may receive notifications from us.
                    <a href="#">Learn why we ask for your contact information</a>
                </p>
            </div>

            <!-- Password -->
            <div class="field-group">
                <label class="field-label">Password</label>
                <input type="password" name = "password" placeholder="Password" requried/>
            </div>

            <!-- confirm password -->
            <div class="field-group">
                <label class="field-label">Confirm Password</label>
                <input type="password" name = "cpassword" placeholder="Confirm Password" requried/>
            </div>

            <!-- Legal -->
            <p class="legal-text">
                People who use our service may have uploaded your contact information
                to Furniture.
                <a href="#">Learn more</a>
            </p>

            <p class="legal-text">
                By tapping Submit, you agree to create an account and to Furniture
                <a href="#">Terms</a>, <a href="#">Privacy Policy</a> and
                <a href="#">Cookies Policy</a>
            </p>

            <p class="legal-text">
                The <a href="#">Privacy Policy</a> describes the ways we can use the
                information we collect when you create an account. For example, we use
                this information to provide, personalize and improve our products,
                including ads.
            </p>

            <!-- Buttons -->
            <button class="btn-primary">Create new account</button>
            <a href="${pageContext.request.contextPath}/login.jsp">
                <button class="btn-secondary" type = "submit" >I already have a account</button>
            </a>
        </form>
    </div>
</div>

