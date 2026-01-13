<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty news}" />
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
    <title>${isEdit ? 'Sửa' : 'Thêm'} Tin tức • Japan Sport Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/admin/admin.css" rel="stylesheet">
    <script src="https://cdn.tiny.cloud/1/zw2hjl1kfj3g58ccxket04y5v9rogcw2gompvsu89d6eaipg/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>

    <style>
        .preview-img {
            max-width: 300px;
            margin-top: 10px;
            border-radius: 8px;
            display: none;
        }
        .category-checkbox {
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            margin-bottom: 8px;
        }
    </style>
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
        <ul class="cui-icons list-unstyled d-flex align-items-center mb-0 ms-auto">
            <li class="dropdown">
                <a class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" href="#" data-bs-toggle="dropdown">
                    <span class="avatar-wrap position-relative">
                        <img src="${pageContext.request.contextPath}/admin/images/admin1.png"
                             class="rounded-circle" width="32" height="32" alt=""
                             onerror="this.src='https://ui-avatars.com/api/?name=<%= currentUser.getName() %>&background=5b57ea&color=fff'">
                    </span>
                    <span class="ms-2"><%= currentUser.getName() %></span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
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
                <li><a class="s-item" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-speedometer2 me-2"></i>Dashboard
                </a></li>
            </ul>
            <div class="s-title">QUẢN LÝ</div>
            <ul class="s-nav">
                <li class="has-children active">
                    <a class="s-item s-parent active" href="#" onclick="return false;">
                        <span><i class="bi bi-newspaper me-2"></i>Tin tức</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav" style="display: block;">
                        <li><a class="s-subitem active" href="${pageContext.request.contextPath}/admin/news">
                            <i class="bi bi-list-ul me-2"></i>Quản lý tin tức
                        </a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="flex-grow-1 p-3">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/news">Tin tức</a></li>
                <li class="breadcrumb-item active">${isEdit ? 'Sửa' : 'Thêm'} tin</li>
            </ol>
        </nav>

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="mb-0">
                <i class="bi bi-${isEdit ? 'pencil' : 'plus-lg'} me-2"></i>${isEdit ? 'Sửa' : 'Thêm'} Tin tức
            </h2>
            <a href="${pageContext.request.contextPath}/admin/news" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Quay lại
            </a>
        </div>

        <!-- Error -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Form -->
        <form method="POST" action="${pageContext.request.contextPath}/admin/news" class="needs-validation" novalidate>
            <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}">
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${news.id}">
            </c:if>

            <div class="row">
                <!-- Left Column -->
                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">Thông tin cơ bản</h5>
                        </div>
                        <div class="card-body">
                            <!-- Title -->
                            <div class="mb-3">
                                <label for="title" class="form-label fw-semibold">
                                    Tiêu đề <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control form-control-lg" id="title" name="title"
                                       value="${news.title}" placeholder="Nhập tiêu đề tin tức..." required>
                                <div class="invalid-feedback">Vui lòng nhập tiêu đề</div>
                            </div>

                            <!-- Summary -->
                            <div class="mb-3">
                                <label for="summary" class="form-label fw-semibold">
                                    Tóm tắt <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" id="summary" name="summary" rows="3"
                                          placeholder="Nhập tóm tắt ngắn gọn..." required>${news.summary}</textarea>
                                <div class="form-text">Tóm tắt sẽ hiển thị ở danh sách tin tức</div>
                                <div class="invalid-feedback">Vui lòng nhập tóm tắt</div>
                            </div>

                            <!-- Content -->
                            <div class="mb-3">
                                <label for="content" class="form-label fw-semibold">
                                    Nội dung <span class="text-danger">*</span>
                                </label>
                                <textarea id="content" name="content" required>${news.content}</textarea>
                                <div class="invalid-feedback">Vui lòng nhập nội dung</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="col-lg-4">
                    <!-- Publish -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h6 class="mb-0">Xuất bản</h6>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label for="status" class="form-label fw-semibold">Trạng thái</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="draft" ${news.status == 'draft' ? 'selected' : ''}>Draft (Nháp)</option>
                                    <option value="published" ${news.status == 'published' ? 'selected' : ''}>Published (Công khai)</option>
                                </select>
                            </div>

                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="featured" name="featured" ${news.featured ? 'checked' : ''}>
                                <label class="form-check-label" for="featured">
                                    <i class="bi bi-star text-warning"></i> Tin nổi bật
                                </label>
                            </div>

                            <hr class="my-3">

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-${isEdit ? 'check2' : 'plus-lg'} me-1"></i>
                                    ${isEdit ? 'Cập nhật' : 'Tạo mới'}
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/news" class="btn btn-outline-secondary">Hủy</a>
                            </div>
                        </div>
                    </div>

                    <!-- Thumbnail -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h6 class="mb-0">Ảnh đại diện</h6>
                        </div>
                        <div class="card-body">
                            <input type="text" class="form-control" id="thumbnailUrl" name="thumbnailUrl"
                                   value="${news.thumbnailUrl}" placeholder="URL ảnh đại diện" onchange="previewImage(this.value)">
                            <div class="form-text">Nhập URL ảnh thumbnail</div>
                            <img id="previewImg" src="${news.thumbnailUrl}" class="preview-img img-fluid"
                                 style="${not empty news.thumbnailUrl ? 'display: block;' : ''}" alt="Preview">
                        </div>
                    </div>

                    <!-- Categories -->
                    <div class="card">
                        <div class="card-header">
                            <h6 class="mb-0">Danh mục</h6>
                        </div>
                        <div class="card-body">
                            <c:forEach var="cat" items="${categories}">
                                <div class="form-check category-checkbox">
                                    <input class="form-check-input" type="checkbox" name="categoryIds" value="${cat.id}" id="cat${cat.id}"
                                           <c:forEach var="selected" items="${news.categories}">
                                               ${selected.id == cat.id ? 'checked' : ''}
                                           </c:forEach>>
                                    <label class="form-check-label" for="cat${cat.id}">${cat.name}</label>
                                </div>
                            </c:forEach>
                            <c:if test="${empty categories}">
                                <p class="text-muted small mb-0">Chưa có danh mục nào</p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
const $ = (s) => document.querySelector(s);
$("#btnToggleSidebar")?.addEventListener("click", () => $("#sidebar")?.classList.add("show"));

// Validation
(function () {
    document.querySelectorAll('.needs-validation').forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
})();

// Preview
function previewImage(url) {
    const img = $("#previewImg");
    if (url && url.trim() !== '') {
        img.src = url;
        img.style.display = 'block';
    } else {
        img.style.display = 'none';
    }
}

// TinyMCE - Initialize once
if (typeof tinymce !== 'undefined') {
    tinymce.init({
        selector: '#content',
        height: 500,
        menubar: false,
        plugins: ['advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview', 'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen', 'insertdatetime', 'media', 'table', 'help', 'wordcount'],
        toolbar: 'undo redo | blocks | bold italic forecolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat | link image | code | help',
        content_style: 'body { font-family: Arial, sans-serif; font-size: 14px; }',
        language: 'vi',
        setup: function(editor) {
            editor.on('init', function() {
                console.log('TinyMCE initialized');
            });
        }
    });
}

// Auto-dismiss alerts
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
});
</script>

</body>
</html>