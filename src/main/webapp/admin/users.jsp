<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Users - Japan Sport Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/admin/admin.css" rel="stylesheet">
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
                <span class="fw-semibold">JAPAN SPORT</span>
            </a>
        </div>

        <ul class="cui-icons list-unstyled d-flex align-items-center mb-0 ms-auto">
            <li class="dropdown">
                <a class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
                   href="#" data-bs-toggle="dropdown">
                    <span class="avatar-wrap position-relative">
                        <img src="${pageContext.request.contextPath}/images/admin1.png"
                             class="rounded-circle" width="32" height="32" alt="">
                        <span class="online"></span>
                    </span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a>
                    </li>
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
                <li><a class="s-item" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
                </li>
            </ul>
            <div class="s-title">QUẢN LÝ</div>
            <ul class="s-nav">
                <li class="has-children force-open">
                    <a class="s-item s-parent" href="#" onclick="return false;">
                        <span><i class="bi bi-people me-2"></i>Users</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav">
                        <li><a class="s-subitem active" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-list-ul me-2"></i>Danh sách Users</a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="flex-grow-1 p-3">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
                <li class="breadcrumb-item active">Users</li>
            </ol>
        </nav>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="mb-0">Quản lý Users</h4>
            <div class="d-flex gap-2">
                <input id="searchInput" class="form-control" placeholder="Tìm email/tên..." style="max-width:260px">
            </div>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table class="table align-middle table-hover mb-0" id="tblUsers">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Email</th>
                            <th>Tên</th>
                            <th>Role</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/admin/users.js"></script>

</body>
</html>