<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Users - Japan Sport Admin</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Admin CSS -->
    <link href="${ctx}/admin/admin.css" rel="stylesheet">
</head>
<body>

<!-- TOPBAR -->
<jsp:include page="topbar.jsp"/>

<div class="d-flex min-vh-100">
    <!-- SIDEBAR -->
    <jsp:include page="sidebar.jsp"/>

    <!-- MAIN CONTENT -->
    <main class="flex-grow-1 p-3">

        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${ctx}/admin/dashboard">Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">Users</li>
            </ol>
        </nav>

        <!-- Header + Search -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="mb-0">Quản lý Users</h4>
            <div class="d-flex gap-2">
                <input id="searchInput" class="form-control" placeholder="Tìm email/tên..." style="max-width:260px">
            </div>
        </div>

        <!-- Users Table -->
        <div class="card shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="tblUsers">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 60px;">ID</th>
                            <th>Email</th>
                            <th>Tên</th>
                            <th style="width: 120px;">Role</th>
                            <th style="width: 100px;">Trạng thái</th>
                            <th style="width: 150px;">Ngày tạo</th>
                            <th style="width: 140px;" class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Data sẽ load từ users.js -->
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/admin/users.js"></script>

</body>
</html>
