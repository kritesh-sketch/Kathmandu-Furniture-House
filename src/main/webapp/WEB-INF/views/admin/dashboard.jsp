<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
  <head>
    <jsp:include page="../../templates/admin/head-common.jsp"/>
    <title>Kathmandu Furniture — Admin Dashboard</title>
  </head>

  <body>
    <div class="admin-layout">
      <jsp:include page="../../templates/admin/sidebar.jsp">
        <jsp:param name="activePage" value="dashboard"/>
      </jsp:include>

      <main class="main-content">
        <header class="topbar">
          <div class="header-titles" style="display: flex; align-items: center; gap: 12px">
            <button class="hamburger-btn" id="hamburgerBtn">
              <i class="fa-solid fa-bars"></i>
            </button>
            <div>
              <h2>Dashboard</h2>
              <p>Welcome back, Admin. <span class="wave">👋</span></p>
            </div>
          </div>
        </header>

        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light">
                <i class="fa-solid fa-bag-shopping"></i> 
              </div>
              <c:choose>
                <c:when test="${ordersTrend >= 0}">
                  <span class="trend positive">+<fmt:formatNumber value="${ordersTrend}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                </c:when>
                <c:otherwise>
                  <span class="trend negative"><fmt:formatNumber value="${ordersTrend}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="stat-value" id="totalRevenue">
              <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$"/>
            </div>
            <div class="stat-label">Total Revenue</div>
          </div>
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light">
                <i class="fa-solid fa-bag-shopping"></i>
              </div>
              <c:choose>
                <c:when test="${ordersTrend >= 0}">
                  <span class="trend positive">+<fmt:formatNumber value="${ordersTrend}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                </c:when>
                <c:otherwise>
                  <span class="trend negative"><fmt:formatNumber value="${ordersTrend}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="stat-value" id="totalOrders"><fmt:formatNumber value="${totalOrders}" type="number"/></div>
            <div class="stat-label">Total Orders</div>
          </div>
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light"><i class="fa-solid fa-cube"></i></div>
              <c:choose>
                <c:when test="${productsTrend >= 0}">
                  <span class="trend positive">+<fmt:formatNumber value="${productsTrend}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                </c:when>
                <c:otherwise>
                  <span class="trend negative"><fmt:formatNumber value="${productsTrend}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="stat-value" id="activeProducts"><fmt:formatNumber value="${activeProducts}" type="number"/></div>
            <div class="stat-label">Active Products</div>
          </div>
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light">
                <i class="fa-regular fa-user"></i>
              </div>
              <c:choose>
                <c:when test="${customersTrend >= 0}">
                  <span class="trend positive">+<fmt:formatNumber value="${customersTrend}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                </c:when>
                <c:otherwise>
                  <span class="trend negative"><fmt:formatNumber value="${customersTrend}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="stat-value" id="totalCustomers"><fmt:formatNumber value="${totalCustomers}" type="number"/></div>
            <div class="stat-label">Customers</div>
          </div>
        </div>

        <div class="content-grid">
          <div class="recent-orders panel">
            <div class="panel-header">
              <h3>Recent Orders</h3>
              <c:if test="${not empty recentOrders}">
                <a href="#" class="view-all">View All &rarr;</a>
              </c:if>
            </div>
            <c:choose>
              <c:when test="${not empty recentOrders}">
                <table class="orders-table">
                  <thead>
                    <tr>
                      <th>ORDER</th>
                      <th>CUSTOMER</th>
                      <th>PRODUCT</th>
                      <th>AMOUNT</th>
                      <th>STATUS</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="order" items="${recentOrders}">
                      <tr>
                        <td><strong>#NR-${order.id}</strong></td>
                        <td>
                          <div class="customer-info">
                            <div class="avatar-sm"><c:out value="${fn:substring(order.customerName, 0, 2)}" /></div>
                            <span><c:out value="${order.customerName}" /></span>
                          </div>
                        </td>
                        <td><c:out value="${order.productName}" /></td>
                        <td><fmt:formatNumber value="${order.amount}" type="currency" currencySymbol="$"/></td>
                        <td>
                          <c:set var="statusClass" value="cancelled" />
                          <c:choose>
                            <c:when test="${order.status == 'Delivered'}"><c:set var="statusClass" value="delivered"/></c:when>
                            <c:when test="${order.status == 'Processing'}"><c:set var="statusClass" value="processing"/></c:when>
                            <c:when test="${order.status == 'Shipped'}"><c:set var="statusClass" value="shipped"/></c:when>
                            <c:when test="${order.status == 'Pending'}"><c:set var="statusClass" value="pending"/></c:when>
                          </c:choose>
                          <span class="status-badge ${statusClass}">
                            <span class="dot"></span> <c:out value="${order.status}" />
                          </span>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:when>
              <c:otherwise>
                <div class="empty-state">
                  <i class="fa-regular fa-clock"></i>
                  No recent orders available.
                </div>
              </c:otherwise>
            </c:choose>
          </div>

        </div>
      </main>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
  </body>
</html>
