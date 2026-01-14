const $ = (selector) => document.querySelector(selector);
const $$ = (selector) => document.querySelectorAll(selector);

// Chart instances
let saleChart = null;
let trafficChart = null;

/**
 * Initialize Dashboard
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('Dashboard initializing...');

    // Setup event listeners
    setupSidebarToggle();
    setupGlobalSearch();

    // Render charts
    renderCharts();

    // Log loaded data
    logDashboardInfo();

    console.log('Dashboard loaded successfully!');
});

/**
 * Setup Sidebar Toggle for Mobile
 */
function setupSidebarToggle() {
    const toggleBtn = $("#btnToggleSidebar");
    const sidebar = $("#sidebar");

    if (!toggleBtn || !sidebar) return;

    // Toggle sidebar
    toggleBtn.addEventListener("click", () => {
        sidebar.classList.add("show");
    });

    // Close sidebar when clicking outside
    document.addEventListener("click", (e) => {
        if (window.innerWidth < 992 &&
            !sidebar.contains(e.target) &&
            e.target.id !== "btnToggleSidebar") {
            sidebar.classList.remove("show");
        }
    });
}

/**
 * Setup Global Search
 */
function setupGlobalSearch() {
    const searchInput = $("#globalSearch");
    if (!searchInput) return;

    searchInput.addEventListener("input", (e) => {
        const query = e.target.value.trim().toLowerCase();
        const panel = $(".panel.show");

        if (!panel) return;

        const rows = panel.querySelectorAll("tbody tr");
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(query) ? "" : "none";
        });
    });
}

/**
 * Render Charts
 */
function renderCharts() {
    const ctx1 = $("#chartSale");
    const ctx2 = $("#chartTraffic");

    if (!ctx1 || !ctx2) {
        console.error('Chart canvases not found');
        return;
    }

    if (typeof Chart === "undefined") {
        console.error('Chart.js not loaded');
        return;
    }

    // Destroy existing charts
    if (saleChart) saleChart.destroy();
    if (trafficChart) trafficChart.destroy();

    // Get data from window
    const data = window.dashboardData || {};
    const revenueLabels = data.revenueLabels || [];
    const revenueValues = data.revenueValues || [];
    const trafficData = data.trafficData || [];

    // Render Revenue Chart
    renderRevenueChart(ctx1, revenueLabels, revenueValues);

    // Render Traffic Chart
    renderTrafficChart(ctx2, trafficData);

    console.log('Charts rendered successfully');
}

/**
 * Render Revenue Chart (Line Chart)
 */
function renderRevenueChart(ctx, labels, values) {
    saleChart = new Chart(ctx, {
        type: "line",
        data: {
            labels: labels,
            datasets: [{
                label: "Doanh thu (triệu)",
                data: values,
                tension: 0.4,
                borderColor: "#5b57ea",
                backgroundColor: "rgba(91,87,234,.15)",
                fill: true,
                pointBackgroundColor: "#5b57ea",
                pointBorderColor: "#fff",
                pointHoverBackgroundColor: "#fff",
                pointHoverBorderColor: "#5b57ea"
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: true,
                    labels: {
                        font: {
                            family: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif"
                        }
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.dataset.label + ': ' +
                                   context.parsed.y.toFixed(1) + ' triệu đồng';
                        }
                    },
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    padding: 12,
                    cornerRadius: 6
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: "rgba(0,0,0,.05)"
                    },
                    ticks: {
                        callback: function(value) {
                            return value + 'tr';
                        },
                        font: {
                            size: 11
                        }
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        font: {
                            size: 11
                        }
                    }
                }
            },
            interaction: {
                intersect: false,
                mode: 'index'
            }
        }
    });
}

/**
 * Render Traffic Chart (Bar Chart)
 */
function renderTrafficChart(ctx, data) {
    trafficChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
            datasets: [{
                label: "Lượt truy cập",
                data: data,
                backgroundColor: "#5b57ea",
                borderRadius: 4,
                hoverBackgroundColor: "#4a47d9"
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    padding: 12,
                    cornerRadius: 6
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: "rgba(0,0,0,.05)"
                    },
                    ticks: {
                        font: {
                            size: 11
                        }
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        font: {
                            size: 11
                        }
                    }
                }
            }
        }
    });
}

/**
 * Log Dashboard Info to Console
 */
function logDashboardInfo() {
    const data = window.dashboardData;
    if (!data) {
        console.warn('No dashboard data available');
        return;
    }

    console.group('📊 Dashboard Data');
    console.log('Products:', data.totalProducts);
    console.log('Completed Orders:', data.totalOrders);
    console.log('Customers:', data.totalCustomers);
    console.log('Monthly Revenue:', data.monthlyRevenue);
    console.log('Revenue Labels:', data.revenueLabels);
    console.log('Revenue Values:', data.revenueValues);
    console.groupEnd();
}

/**
 * Refresh Dashboard Data (AJAX)
 * Optional: Call this periodically or on button click
 */
function refreshDashboardData() {
    const contextPath = window.location.pathname.substring(0,
        window.location.pathname.indexOf('/', 1));

    fetch(contextPath + '/admin/dashboard?action=getRevenue')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Update stats
                updateStats(data);

                // Update charts
                updateCharts(data);

                console.log('Dashboard data refreshed');
            } else {
                console.error('Failed to refresh data:', data.message);
            }
        })
        .catch(error => {
            console.error('Error refreshing dashboard:', error);
        });
}

/**
 * Update Stats Display
 */
function updateStats(data) {
    const revenueEl = $("#statRevenue");
    const ordersEl = $("#statOrders");

    if (revenueEl && data.monthlyRevenue) {
        const formatter = new Intl.NumberFormat('vi-VN');
        revenueEl.textContent = formatter.format(data.monthlyRevenue) + ' đ';
    }

    if (ordersEl && data.totalOrders) {
        ordersEl.textContent = data.totalOrders;
    }
}

/**
 * Update Charts with New Data
 */
function updateCharts(data) {
    if (saleChart && data.revenueLabels && data.revenueValues) {
        saleChart.data.labels = data.revenueLabels;
        saleChart.data.datasets[0].data = data.revenueValues;
        saleChart.update();
    }
}

/**
 * Format Number with Commas
 */
function formatNumber(num) {
    return new Intl.NumberFormat('vi-VN').format(num);
}

/**
 * Format Currency
 */
function formatCurrency(num) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(num);
}

// Export functions for external use
window.DashboardManager = {
    refresh: refreshDashboardData,
    formatNumber: formatNumber,
    formatCurrency: formatCurrency
};