<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
  <head>
    <jsp:include page="../../templates/admin/head-common.jsp"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/analytics.css" />
    <title>Kathmandu Furniture — Analytics</title>
  </head>

  <body>
    <div class="admin-layout">
      <jsp:include page="../../templates/admin/sidebar.jsp">
        <jsp:param name="activePage" value="analytics"/>
      </jsp:include>

      <main class="main-content">
        <header class="topbar">
          <div class="header-titles" style="display:flex;align-items:center;gap:12px">
            <button class="hamburger-btn" id="hamburgerBtn">
              <i class="fa-solid fa-bars"></i>
            </button>
            <div>
              <h2>Analytics</h2>
              <p>Store performance overview and insights.</p>
            </div>
          </div>
        </header>

        <!-- Stat cards -->
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light"><i class="fa-regular fa-comment-dots"></i></div>
            </div>
            <div class="stat-value"><fmt:formatNumber value="${totalFeedback}" type="number"/></div>
            <div class="stat-label">Total Feedback</div>
          </div>
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light"><i class="fa-regular fa-clock"></i></div>
            </div>
            <div class="stat-value"><fmt:formatNumber value="${pendingFeedback}" type="number"/></div>
            <div class="stat-label">Pending Feedback</div>
          </div>
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light"><i class="fa-solid fa-rotate-left"></i></div>
            </div>
            <div class="stat-value"><fmt:formatNumber value="${totalReturnOrders}" type="number"/></div>
            <div class="stat-label">Return Orders</div>
          </div>
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light"><i class="fa-solid fa-star"></i></div>
            </div>
            <div class="stat-value">
              <fmt:formatNumber value="${avgProductRating}" type="number" minFractionDigits="1" maxFractionDigits="1"/>
            </div>
            <div class="stat-label">Avg. Product Rating</div>
          </div>
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light"><i class="fa-solid fa-cart-shopping"></i></div>
            </div>
            <div class="stat-value"><fmt:formatNumber value="${ordersToday}" type="number"/></div>
            <div class="stat-label">Orders Today</div>
          </div>
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light"><i class="fa-solid fa-calendar-week"></i></div>
            </div>
            <div class="stat-value"><fmt:formatNumber value="${ordersThisWeek}" type="number"/></div>
            <div class="stat-label">Orders This Week</div>
          </div>
          <div class="stat-card">
            <div class="stat-header">
              <div class="icon-box light"><i class="fa-solid fa-user-clock"></i></div>
            </div>
            <div class="stat-value"><fmt:formatNumber value="${newUsersThisWeek}" type="number"/></div>
            <div class="stat-label">New Users This Week</div>
          </div>
        </div>

        <!-- Charts -->
        <div class="charts-grid">
          <div class="chart-panel panel">
            <div class="panel-header">
              <h3><i class="fa-solid fa-chart-line"></i> Monthly Revenue (Last 6 Months)</h3>
            </div>
            <div class="chart-wrap">
              <canvas id="revenueChart"></canvas>
            </div>
          </div>

          <div class="chart-panel panel">
            <div class="panel-header">
              <h3><i class="fa-solid fa-chart-pie"></i> Orders by Status</h3>
            </div>
            <div class="chart-wrap chart-wrap--sm">
              <canvas id="statusChart"></canvas>
            </div>
          </div>

          <div class="chart-panel panel">
            <div class="panel-header">
              <h3><i class="fa-solid fa-trophy"></i> Top 5 Products by Orders</h3>
            </div>
            <div class="chart-wrap">
              <canvas id="topProductsChart"></canvas>
            </div>
          </div>

          <div class="chart-panel panel">
            <div class="panel-header">
              <h3><i class="fa-solid fa-user-plus"></i> New Registrations (Last 6 Months)</h3>
            </div>
            <div class="chart-wrap">
              <canvas id="usersChart"></canvas>
            </div>
          </div>

          <div class="chart-panel panel">
            <div class="panel-header">
              <h3><i class="fa-solid fa-tags"></i> Products by Category</h3>
            </div>
            <div class="chart-wrap chart-wrap--sm">
              <canvas id="categoryChart"></canvas>
            </div>
          </div>

          <div class="chart-panel panel">
            <div class="panel-header">
              <h3><i class="fa-solid fa-boxes-stacked"></i> Availability vs Orders</h3>
            </div>
            <div class="chart-wrap">
              <canvas id="availabilityChart"></canvas>
            </div>
          </div>

          <div class="chart-panel panel" style="grid-column: 1 / -1;">
            <div class="panel-header">
              <h3><i class="fa-solid fa-chart-bar"></i> Daily Orders — Last 7 Days</h3>
            </div>
            <div class="chart-wrap">
              <canvas id="dailyOrdersChart"></canvas>
            </div>
          </div>
        </div>
      </main>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/admin/admin-base.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script>
      const revenueData       = ${not empty monthlyRevenueJson      ? monthlyRevenueJson      : '[]'};
      const statusData        = ${not empty ordersByStatusJson      ? ordersByStatusJson      : '[]'};
      const topProductData    = ${not empty topProductsJson         ? topProductsJson         : '[]'};
      const usersData         = ${not empty monthlyNewUsersJson     ? monthlyNewUsersJson     : '[]'};
      const categoryData      = ${not empty categoryBreakdownJson   ? categoryBreakdownJson   : '[]'};
      const availabilityData  = ${not empty availabilityBreakdownJson ? availabilityBreakdownJson : '[]'};

      Chart.defaults.font.family = "'Inter', sans-serif";
      Chart.defaults.color = '#6b7280';

      const labels = arr => arr.map(d => d.label);
      const values = arr => arr.map(d => d.value);

      // Monthly Revenue — Line
      new Chart(document.getElementById('revenueChart'), {
        type: 'line',
        data: {
          labels: labels(revenueData),
          datasets: [{
            label: 'Revenue (Rs.)',
            data: values(revenueData),
            borderColor: '#111827',
            backgroundColor: 'rgba(17,24,39,0.07)',
            fill: true,
            tension: 0.4,
            pointBackgroundColor: '#111827',
            pointRadius: 4,
            borderWidth: 2
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: {
            y: {
              beginAtZero: true,
              ticks: { callback: v => 'Rs. ' + v.toLocaleString() }
            }
          }
        }
      });

      // Orders by Status — Doughnut
      const statusColors = {
        'Pending':    '#d97706',
        'Confirmed':  '#2563eb',
        'Processing': '#7c3aed',
        'Shipped':    '#0d9488',
        'Delivered':  '#059669',
        'Cancelled':  '#6b7280'
      };
      new Chart(document.getElementById('statusChart'), {
        type: 'doughnut',
        data: {
          labels: labels(statusData),
          datasets: [{
            data: values(statusData),
            backgroundColor: labels(statusData).map(l => statusColors[l] || '#adb3c0'),
            borderWidth: 2,
            borderColor: '#fff'
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          cutout: '60%',
          plugins: {
            legend: {
              position: 'bottom',
              labels: { padding: 14, boxWidth: 12, font: { size: 12 } }
            }
          }
        }
      });

      // Top Products — Horizontal Bar
      new Chart(document.getElementById('topProductsChart'), {
        type: 'bar',
        data: {
          labels: labels(topProductData),
          datasets: [{
            label: 'Orders',
            data: values(topProductData),
            backgroundColor: 'rgba(17,24,39,0.78)',
            borderRadius: 6,
            borderSkipped: false
          }]
        },
        options: {
          indexAxis: 'y',
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: {
            x: { beginAtZero: true, ticks: { precision: 0 } }
          }
        }
      });

      // New Users — Bar
      new Chart(document.getElementById('usersChart'), {
        type: 'bar',
        data: {
          labels: labels(usersData),
          datasets: [{
            label: 'New Users',
            data: values(usersData),
            backgroundColor: 'rgba(124,58,237,0.75)',
            borderRadius: 6,
            borderSkipped: false
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: {
            y: { beginAtZero: true, ticks: { precision: 0 } }
          }
        }
      });

      // Category Breakdown — Pie
      const catColors = [
        '#111827','#374151','#6b7280','#9ca3af','#d1d5db','#e5e7eb'
      ];
      new Chart(document.getElementById('categoryChart'), {
        type: 'pie',
        data: {
          labels: categoryData.map(d => d.label),
          datasets: [{
            data: categoryData.map(d => d.value),
            backgroundColor: categoryData.map((_, i) => catColors[i % catColors.length]),
            borderWidth: 2,
            borderColor: '#fff'
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'bottom',
              labels: { padding: 12, boxWidth: 12, font: { size: 12 } }
            },
            tooltip: {
              callbacks: {
                label: ctx => ' ' + ctx.label + ': ' + ctx.parsed + ' products'
              }
            }
          }
        }
      });

      // Availability vs Orders — Grouped Bar
      const availColors = {
        'In Stock':     '#059669',
        'Out of Stock': '#dc2626',
        'Coming Soon':  '#d97706'
      };
      new Chart(document.getElementById('availabilityChart'), {
        type: 'bar',
        data: {
          labels: availabilityData.map(d => d.label),
          datasets: [
            {
              label: 'Products',
              data: availabilityData.map(d => d.products),
              backgroundColor: availabilityData.map(d => availColors[d.label] || '#6b7280'),
              borderRadius: 6,
              borderSkipped: false
            },
            {
              label: 'Orders Received',
              data: availabilityData.map(d => d.orders),
              backgroundColor: availabilityData.map(d => (availColors[d.label] || '#6b7280') + '55'),
              borderRadius: 6,
              borderSkipped: false,
              borderWidth: 1,
              borderColor: availabilityData.map(d => availColors[d.label] || '#6b7280')
            }
          ]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'bottom',
              labels: { padding: 14, boxWidth: 12, font: { size: 12 } }
            }
          },
          scales: {
            y: { beginAtZero: true, ticks: { precision: 0 } }
          }
        }
      });

      // Daily Orders — Bar (week-10 workshop pattern)
      const dailyOrdersData = ${not empty dailyOrdersJson ? dailyOrdersJson : '[]'};
      new Chart(document.getElementById('dailyOrdersChart'), {
        type: 'bar',
        data: {
          labels: labels(dailyOrdersData),
          datasets: [{
            label: 'Orders',
            data: values(dailyOrdersData),
            backgroundColor: 'rgba(17,24,39,0.75)',
            borderRadius: 6,
            borderSkipped: false
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: {
            y: { beginAtZero: true, ticks: { precision: 0 } }
          }
        }
      });
    </script>
  </body>
</html>
