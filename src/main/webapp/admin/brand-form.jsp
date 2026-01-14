<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isEdit" value="${not empty brand}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${isEdit ? 'Cập nhật nhãn hàng' : 'Thêm nhãn hàng'} - Admin</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Admin CSS -->
    <link href="${ctx}/admin/admin.css" rel="stylesheet">

    <style>
        .logo-preview {
            max-width: 200px;
            max-height: 150px;
            margin-top: 10px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 10px;
            display: none;
        }
        .form-section {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
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
                <li class="breadcrumb-item">
                    <a href="${ctx}/admin/brands?action=list">Nhãn hàng</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                </li>
            </ol>
        </nav>

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="mb-0">
                <i class="bi bi-${isEdit ? 'pencil' : 'plus-lg'} me-2"></i>
                ${isEdit ? 'Cập nhật nhãn hàng' : 'Thêm nhãn hàng mới'}
            </h5>
            <a href="${ctx}/admin/brands?action=list" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Quay lại
            </a>
        </div>

        <!-- Error alert -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Form -->
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <form method="POST" action="${ctx}/admin/brands"
                      class="needs-validation form-section"
                      novalidate>
                    <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${brand.id}">
                    </c:if>

                    <!-- Tên nhãn hàng -->
                    <div class="mb-4">
                        <label for="name" class="form-label fw-semibold">
                            Tên nhãn hàng <span class="text-danger">*</span>
                        </label>
                        <input type="text"
                               class="form-control form-control-lg"
                               id="name"
                               name="name"
                               value="${brand.name}"
                               placeholder="Ví dụ: Nike, Adidas..."
                               required>
                        <div class="invalid-feedback">Vui lòng nhập tên nhãn hàng</div>
                    </div>

                    <!-- Logo URL -->
                    <div class="mb-4">
                        <label for="logoUrl" class="form-label fw-semibold">URL Logo</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-image"></i></span>
                            <input type="text"
                                   class="form-control"
                                   id="logoUrl"
                                   name="logoUrl"
                                   value="${brand.logoUrl}"
                                   placeholder="https://example.com/logo.png"
                                   onchange="previewLogo(this.value)">
                        </div>
                        <small class="form-text text-muted">Hình ảnh logo</small>
                        <img id="logoPreview"
                             src="${brand.logoUrl}"
                             class="logo-preview img-fluid"
                             style="${not empty brand.logoUrl ? 'display:block;' : ''}"
                             alt="Preview">
                    </div>

                    <!-- Trạng thái -->
                    <div class="mb-4">
                        <div class="form-check form-switch">
                            <input class="form-check-input"
                                   type="checkbox"
                                   id="active"
                                   name="active"
                                   ${isEdit ? (brand.active ? 'checked' : '') : 'checked'}>
                            <label class="form-check-label fw-semibold" for="active">
                                <i class="bi bi-eye text-success"></i> Hiển thị trên website
                            </label>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="d-flex gap-2 justify-content-end mt-4">
                        <a href="${ctx}/admin/brands?action=list" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-x-lg me-1"></i>Hủy
                        </a>
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="bi bi-${isEdit ? 'check2' : 'plus-lg'} me-1"></i>
                            ${isEdit ? 'Cập nhật' : 'Tạo mới'}
                        </button>
                    </div>
                </form>

                <!-- Preview Card -->
                <c:if test="${isEdit}">
                    <div class="mt-4">
                        <h6 class="mb-3"><i class="bi bi-eye me-2"></i>Xem trước</h6>
                        <div class="card text-center">
                            <div class="card-body">
                                <c:if test="${not empty brand.logoUrl}">
                                    <img src="${brand.logoUrl}" alt="${brand.name}"
                                         style="max-width:150px; max-height:100px; object-fit:contain;"
                                         onerror="this.style.display='none'">
                                </c:if>
                                <h5 class="mt-3 mb-0">${brand.name}</h5>
                                <small class="text-muted">${brand.slug}</small>
                            </div>
                        </div>
                    </div>
                </c:if>

            </div>
        </div>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
// Form validation
(function () {
    'use strict'
    const forms = document.querySelectorAll('.needs-validation')
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault()
                event.stopPropagation()
            }
            form.classList.add('was-validated')
        }, false)
    })
})();

// Logo preview
function previewLogo(url) {
    const img = document.getElementById('logoPreview');
    if (url && url.trim() !== '') {
        img.src = url;
        img.style.display = 'block';
    } else {
        img.style.display = 'none';
    }
}

// Auto-dismiss alerts
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => new bootstrap.Alert(alert).close(), 5000);
    });
});
</script>

</body>
</html>
