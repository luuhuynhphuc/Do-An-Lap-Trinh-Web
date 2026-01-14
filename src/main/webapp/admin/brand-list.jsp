<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý Nhãn hàng - Admin</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Admin CSS -->
    <link href="${ctx}/admin/admin.css" rel="stylesheet">

    <!-- Page CSS -->
    <style>
        .brand-logo {
            width: 60px;
            height: 60px;
            object-fit: contain;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 6px;
            background: #f8f9fa;
        }
        .status-badge {
            font-size: .75rem;
            padding: .3rem .5rem;
        }
    </style>
</head>
<body>

<!-- TOPBAR -->
<jsp:include page="topbar.jsp"/>

<div class="d-flex min-vh-100">
    <!-- SIDEBAR -->
    <jsp:include page="sidebar.jsp"/>

    <!-- MAIN -->
    <main class="flex-grow-1 p-3">

        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="${ctx}/admin/dashboard">Dashboard</a>
                </li>
                <li class="breadcrumb-item active">Nhãn hàng</li>
            </ol>
        </nav>

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">
                <i class="bi bi-tags me-2"></i>Quản lý Nhãn hàng
            </h5>

            <a href="${ctx}/admin/brands?action=add"
               class="btn btn-primary">
                <i class="bi bi-plus-lg me-1"></i>Thêm nhãn hàng
            </a>
        </div>

        <!-- Alerts -->
        <c:if test="${param.success == 'create'}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle me-2"></i>Thêm nhãn hàng thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'update'}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle me-2"></i>Cập nhật nhãn hàng thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'delete'}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle me-2"></i>Xóa nhãn hàng thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.error == 'delete'}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle me-2"></i>
                Không thể xóa nhãn hàng vì đang có sản phẩm liên kết.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Table -->
        <div class="card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th style="width:60px">ID</th>
                            <th style="width:80px">Logo</th>
                            <th>Tên nhãn hàng</th>
                            <th>Slug</th>
                            <th class="text-center" style="width:120px">Trạng thái</th>
                            <th class="text-center" style="width:140px">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="brand" items="${brandList}">
                            <tr>
                                <td class="fw-semibold">#${brand.id}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty brand.logoUrl}">
                                            <img src="${brand.logoUrl}"
                                                 class="brand-logo"
                                                 onerror="handleImageError(this)">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="brand-logo d-flex align-items-center justify-content-center text-muted">
                                                <i class="bi bi-image"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="fw-semibold">${brand.name}</td>
                                <td><code class="text-muted">${brand.slug}</code></td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${brand.active}">
                                            <span class="badge bg-success status-badge">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary status-badge">Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group btn-group-sm">
                                        <a href="${ctx}/admin/brands?action=edit&id=${brand.id}"
                                           class="btn btn-outline-primary">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <button class="btn btn-outline-danger"
                                                onclick="confirmDelete(${brand.id}, '${brand.name}')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty brandList}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-1 mb-3 d-block"></i>
                                    Chưa có nhãn hàng nào
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
function handleImageError(img) {
    if (img.dataset.errorHandled) return;
    img.dataset.errorHandled = true;
    img.src = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="60" height="60"%3E%3Crect fill="%23f0f0f0" width="60" height="60"/%3E%3Ctext x="50%25" y="50%25" font-size="10" fill="%23999" text-anchor="middle" dominant-baseline="middle"%3ENo Image%3C/text%3E%3C/svg%3E';
}

function confirmDelete(id, name) {
    if (confirm('Bạn có chắc chắn muốn xóa nhãn hàng "' + name + '"?')) {
        window.location.href = '${ctx}/admin/brands?action=delete&id=' + id;
    }
}
</script>

</body>
</html>
