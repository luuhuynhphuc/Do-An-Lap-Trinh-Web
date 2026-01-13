<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${pageTitle} - Admin Panel</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        .brand-logo {
            width: 60px;
            height: 60px;
            object-fit: contain;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 5px;
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
    </style>
</head>
<body class="bg-light">

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <jsp:include page="/admin/sidebar.jsp" />

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <i class="bi bi-tags me-2"></i>Quản lý Nhãn hàng
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${ctx}/admin/brands?action=add" class="btn btn-sm btn-primary">
                        <i class="bi bi-plus-lg me-1"></i>Thêm nhãn hàng mới
                    </a>
                </div>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${param.success == 'create'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle me-2"></i>Thêm nhãn hàng thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.success == 'update'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle me-2"></i>Cập nhật nhãn hàng thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.success == 'delete'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle me-2"></i>Xóa nhãn hàng thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'delete'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i>Không thể xóa nhãn hàng. Có thể đang có sản phẩm liên kết.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Brand Table -->
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 60px;">ID</th>
                                    <th style="width: 80px;">Logo</th>
                                    <th>Tên nhãn hàng</th>
                                    <th style="width: 200px;">Slug</th>
                                    <th style="width: 100px;" class="text-center">Trạng thái</th>
                                    <th style="width: 140px;" class="text-center">Hành động</th>
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
                                                         alt="${brand.name}"
                                                         class="brand-logo"
                                                         onerror="this.src='${ctx}/assets/images/no-logo.png'">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="brand-logo d-flex align-items-center justify-content-center bg-light text-muted">
                                                        <i class="bi bi-image fs-5"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="fw-semibold">${brand.name}</div>
                                        </td>
                                        <td>
                                            <code class="text-muted">${brand.slug}</code>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${brand.active}">
                                                    <span class="badge bg-success status-badge">
                                                        <i class="bi bi-check-circle me-1"></i>Hoạt động
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary status-badge">
                                                        <i class="bi bi-x-circle me-1"></i>Ẩn
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm">
                                                <a href="${ctx}/admin/brands?action=edit&id=${brand.id}"
                                                   class="btn btn-outline-primary"
                                                   title="Sửa">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <button onclick="confirmDelete(${brand.id}, '${brand.name}')"
                                                        class="btn btn-outline-danger"
                                                        title="Xóa">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty brandList}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                            <p>Chưa có nhãn hàng nào</p>
                                            <a href="${ctx}/admin/brands?action=add" class="btn btn-sm btn-primary">
                                                <i class="bi bi-plus-lg me-1"></i>Thêm nhãn hàng đầu tiên
                                            </a>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
function confirmDelete(id, name) {
    if (confirm('Bạn có chắc chắn muốn xóa nhãn hàng "' + name + '"?\n\nLưu ý: Nếu có sản phẩm đang sử dụng nhãn hàng này, thao tác sẽ thất bại.')) {
        window.location.href = '${ctx}/admin/brands?action=delete&id=' + id;
    }
}

// Auto-dismiss alerts after 5 seconds
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Clear URL params after showing alert to prevent reload loop
    if (window.location.search.includes('success') || window.location.search.includes('error')) {
        setTimeout(function() {
            const url = new URL(window.location);
            url.searchParams.delete('success');
            url.searchParams.delete('error');
            window.history.replaceState({}, document.title, url.pathname + url.search);
        }, 100);
    }
});
</script>

</body>
</html>