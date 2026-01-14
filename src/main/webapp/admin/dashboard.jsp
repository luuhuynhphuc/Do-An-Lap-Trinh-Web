<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    com.japansport.model.User currentUser = (com.japansport.model.User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi" data-bs-theme="light">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Dashboard • Japan Sport Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>

    <link href="${pageContext.request.contextPath}/admin/admin.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/admin/dashboard.css" rel="stylesheet">
</head>
<body>

<!-- TOPBAR -->
<header class="cui-topbar">
    <div class="cui-topbar__inner container-fluid">
        <div class="d-flex align-items-center gap-3">
            <button class="btn btn-link text-white d-lg-none p-0" id="btnToggleSidebar">
                <i class="bi bi-list fs-3"></i>
            </button>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center text-white text-decoration-none">
                <img src="https://coreui.io/images/brand/coreui-signet-white.svg" alt="" height="24" class="me-2">
                <span class="fw-semibold">JAPAN SPORT</span>
                <span class="badge bg-white text-primary ms-2">ADMIN</span>
            </a>
        </div>

        <form class="cui-search ms-lg-5 me-3 flex-grow-1 d-none d-md-block" role="search">
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-search"></i></span>
                <input id="globalSearch" class="form-control" placeholder="Search...">
            </div>
        </form>

        <ul class="cui-icons list-unstyled d-flex align-items-center mb-0 ms-auto">
            <li class="cui-icon">
                <a class="text-white position-relative" href="#"><i class="bi bi-bell fs-5"></i></a>
            </li>

            <li class="cui-sep" role="separator"></li>

            <li class="dropdown">
                <a class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" href="#"
                   data-bs-toggle="dropdown">
                    <span class="avatar-wrap position-relative">
                        <img src="${pageContext.request.contextPath}/admin/images/admin1.png"
                             class="rounded-circle" width="32" height="32" alt=""
                             onerror="this.src='https://ui-avatars.com/api/?name=<%= currentUser.getName() %>&background=5b57ea&color=fff'">
                        <span class="online"></span>
                    </span>
                    <span class="ms-2 d-none d-md-inline"><%= currentUser.getName() %></span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><h6 class="dropdown-header">Xin chào, <%= currentUser.getName() %>!</h6></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile">
                        <i class="bi bi-person me-2"></i>Hồ sơ
                    </a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/settings">
                        <i class="bi bi-gear me-2"></i>Cài đặt
                    </a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                    </a></li>
                </ul>
            </li>
        </ul>
    </div>
</header>

<div class="d-flex min-vh-100">
    <!-- SIDEBAR -->
    <aside id="sidebar" class="sidebar border-end bg-white">
        <div class="sidebar-inner">
            <ul class="s-nav">
                <li><a class="s-item active" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-speedometer2 me-2"></i>Dashboard
                </a></li>
            </ul>
            <div class="s-title">QUẢN LÝ</div>
            <ul class="s-nav">
                <li class="has-children">
                    <a class="s-item s-parent" href="#" onclick="return false;">
                        <span><i class="bi bi-box-seam me-2"></i>Sản phẩm</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav">
                        <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/products">
                            <i class="bi bi-list-ul me-2"></i>Quản lý sản phẩm
                        </a></li>
                        <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/categories">
                            <i class="bi bi-tags me-2"></i>Danh mục sản phẩm
                        </a></li>
                        <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/brands">
                            <i class="bi bi-badge-tm me-2"></i>Quản lý nhãn hàng
                        </a></li>
                    </ul>
                </li>
                <li class="has-children">
                    <a class="s-item s-parent" href="#" onclick="return false;">
                        <span><i class="bi bi-people me-2"></i>Users</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav">
                        <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-list-ul me-2"></i>Danh sách Users
                        </a></li>
                    </ul>
                </li>
                <li class="has-children">
                    <a class="s-item s-parent" href="#" onclick="return false;">
                        <span><i class="bi bi-receipt me-2"></i>Đơn hàng</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav">
                        <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="bi bi-list-ul me-2"></i>Quản lý đơn hàng
                        </a></li>
                    </ul>
                </li>
                <li class="has-children">
                    <a class="s-item s-parent" href="#" onclick="return false;">
                        <span><i class="bi bi-newspaper me-2"></i>Tin tức</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav">
                        <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/news">
                            <i class="bi bi-list-ul me-2"></i>Quản lý tin tức
                        </a></li>
                    </ul>
                </li>
                <li><a class="s-item" href="${pageContext.request.contextPath}/admin/policies">
                    <i class="bi bi-shield-check me-2"></i>Chính sách
                </a></li>
            </ul>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="flex-grow-1 p-3">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
                <li class="breadcrumb-item active">Dashboard</li>
            </ol>
        </nav>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Dashboard Content -->
        <section id="dash" class="panel show">
            <!-- Stats Cards -->
            <div class="row g-3">
                <div class="col-sm-6 col-xl-3">
                    <div class="card stat">
                        <div class="card-body">
                            <div class="text-secondary">Doanh thu</div>
                            <div class="display-6 fw-bold" id="statRevenue">${monthlyRevenue}</div>
                            <small class="text-success">
                                <i class="bi bi-check-circle-fill me-1"></i>
                                Đơn đã hoàn thành
                            </small>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="card stat">
                        <div class="card-body">
                            <div class="text-secondary">Khách hàng</div>
                            <div class="display-6 fw-bold" id="statCustomers">${totalCustomers}</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="card stat">
                        <div class="card-body">
                            <div class="text-secondary">Đơn hàng</div>
                            <div class="display-6 fw-bold" id="statOrders">${totalOrders}</div>
                            <small class="text-success">
                                <i class="bi bi-check-circle-fill me-1"></i>
                                Đã hoàn thành
                            </small>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="card stat">
                        <div class="card-body">
                            <div class="text-secondary">Sản phẩm</div>
                            <div class="display-6 fw-bold" id="statProducts">${totalProducts}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts -->
            <div class="row g-3 mt-1">
                <div class="col-12 col-lg-6">
                    <div class="card h-100">
                        <div class="card-header fw-semibold">
                            Doanh thu (triệu đồng)
                            <span class="badge bg-success ms-2">Đơn hoàn thành</span>
                        </div>
                        <div class="card-body">
                            <canvas id="chartSale" height="140"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-lg-6">
                    <div class="card h-100">
                        <div class="card-header fw-semibold">Lượt truy cập</div>
                        <div class="card-body">
                            <canvas id="chartTraffic" height="140"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Welcome Message -->
            <div class="row g-3 mt-3">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body text-center py-5">
                            <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                            <h3 class="mt-3">Chào mừng <%= currentUser.getName() %>!</h3>
                            <p class="text-secondary">Bạn đã đăng nhập thành công vào Admin Panel</p>
                            <p class="text-secondary">
                                Email: <span class="badge bg-primary"><%= currentUser.getEmail() %></span>
                                Role: <span class="badge bg-danger"><%= currentUser.getRole() %></span>
                            </p>
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-primary me-2">
                                    <i class="bi bi-box-seam me-1"></i>Quản lý sản phẩm
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-primary">
                                    <i class="bi bi-tags me-1"></i>Quản lý danh mục
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Dashboard Data -->
<script>
    // Pass data from JSP to JavaScript
    window.dashboardData = {
        revenueLabels: ${revenueLabels},
        revenueValues: ${revenueValues},
        trafficData: ${trafficData},
        totalProducts: ${totalProducts},
        totalOrders: ${totalOrders},
        totalCustomers: ${totalCustomers},
        monthlyRevenue: '${monthlyRevenue}'
    };
</script>

<!-- Dashboard JavaScript -->
<script src="${pageContext.request.contextPath}/admin/dashboard.js"></script>

</body>
</html>