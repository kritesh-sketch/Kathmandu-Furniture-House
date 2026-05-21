<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Bad Request &mdash; Kathmandu Furniture</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600&family=Playfair+Display:ital,wght@0,600;1,600&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      background: #f4f5f7;
      font-family: "Montserrat", sans-serif;
      color: #111827;
      padding: 24px;
    }

    .error-card {
      background: #fff;
      border-radius: 16px;
      padding: 60px 48px 52px;
      max-width: 520px;
      width: 100%;
      text-align: center;
      box-shadow: 0 4px 24px rgba(0,0,0,.07);
    }

    .error-code {
      font-family: "Playfair Display", serif;
      font-size: 110px;
      line-height: 1;
      font-weight: 600;
      color: #111827;
      letter-spacing: -4px;
      margin-bottom: 8px;
    }

    .error-code span {
      color: #c9922a;
    }

    .divider {
      width: 48px;
      height: 3px;
      background: #c9922a;
      border-radius: 2px;
      margin: 20px auto 24px;
    }

    .error-title {
      font-family: "Playfair Display", serif;
      font-size: 26px;
      font-weight: 600;
      margin-bottom: 12px;
    }

    .error-desc {
      font-size: 14px;
      color: #6b7280;
      line-height: 1.7;
      margin-bottom: 36px;
    }

    .home-btn {
      display: inline-block;
      background: #111827;
      color: #fff;
      text-decoration: none;
      font-size: 13px;
      font-weight: 600;
      letter-spacing: .5px;
      padding: 13px 32px;
      border-radius: 8px;
      transition: background .2s;
    }

    .home-btn:hover { background: #1f2937; }

    .brand {
      margin-top: 40px;
      font-size: 12px;
      color: #adb3c0;
      letter-spacing: .5px;
    }
  </style>
</head>
<body>
  <div class="error-card">
    <div class="error-code">4<span>0</span>0</div>
    <div class="divider"></div>
    <h1 class="error-title">Bad Request</h1>
    <p class="error-desc">
      The request could not be understood by the server.<br/>
      Please check your input and try again.
    </p>
    <a href="${pageContext.request.contextPath}/user/home" class="home-btn">Back to Home</a>
  </div>
  <p class="brand">Kathmandu Furniture House</p>
</body>
</html>
