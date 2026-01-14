<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Danh mục - Admin</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Custom Admin CSS -->
    <link href="${pageContext.request.contextPath}/admin/admin.css" rel="stylesheet">
</head>
<body>

<!-- Include header/topbar -->
<jsp:include page="topbar.jsp" />

<div class="d-flex min-vh-100">
    <!-- Include sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Main Content -->
    <main class="flex-grow-1 p-3">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
                <li class="breadcrumb-item active">Danh mục sản phẩm</li>
            </ol>
        </nav>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Quản lý Danh mục</h5>
            <div class="d-flex gap-2">
                <input id="searchInput" class="form-control" placeholder="Tìm tên/slug..." style="max-width:260px">
                <button id="btnAddCategory" class="btn btn-primary">
                    <i class="bi bi-plus-lg me-1"></i>Thêm danh mục
                </button>
            </div>
        </div>

        <!-- Table -->
        <div class="card">
            <div class="table-responsive">
                <table class="table align-middle table-hover mb-0" id="tblCategories">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 80px">ID</th>
                            <th>Tên</th>
                            <th>Slug</th>
                            <th>Ảnh</th>
                            <th style="width: 100px">Thứ tự</th>
                            <th style="width: 100px">Nổi bật</th>
                            <th style="width: 100px">Trạng thái</th>
                            <th style="width: 120px" class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Data will be loaded via JavaScript -->
                        <tr>
                            <td colspan="8" class="text-center py-4">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Đang tải...</span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- Modal Form -->
<div class="modal fade" id="modalCategory" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="formCategory">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Thêm danh mục</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="categoryId" name="id">
                <input type="hidden" id="formAction" name="action" value="create">

                <div class="row g-3">
                    <div class="col-md-8">
                        <label for="categoryName" class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="categoryName" name="name" required>
                    </div>

                    <div class="col-md-4">
                        <label for="categoryOrder" class="form-label">Thứ tự</label>
                        <input type="number" class="form-control" id="categoryOrder" name="display_order" value="0" min="0">
                    </div>

                    <div class="col-md-12">
                        <label for="categorySlug" class="form-label">Slug (SEO)</label>
                        <input type="text" class="form-control" id="categorySlug" name="slug"
                               placeholder="Tự động tạo từ tên...">
                        <small class="text-muted">Để trống để tự động tạo từ tên danh mục</small>
                    </div>

                    <div class="col-md-6">
                        <label for="categoryParent" class="form-label">Danh mục cha</label>
                        <select class="form-select" id="categoryParent" name="parent_id">
                            <option value="">-- Không có (Danh mục gốc) --</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="categoryFeatured" class="form-label">Nổi bật</label>
                        <select class="form-select" id="categoryFeatured" name="is_featured">
                            <option value="0">Không</option>
                            <option value="1">Có</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="categoryActive" class="form-label">Trạng thái</label>
                        <select class="form-select" id="categoryActive" name="active">
                            <option value="1">Hiển thị</option>
                            <option value="0">Ẩn</option>
                        </select>
                    </div>

                    <div class="col-md-12">
                        <label for="categoryImage" class="form-label">Ảnh</label>
                        <input type="text" class="form-control" id="categoryImage" name="image_url"
                               placeholder="https://example.com/image.jpg">
                    </div>

                    <div class="col-md-12">
                        <label for="categoryLink" class="form-label">Link liên kết</label>
                        <input type="text" class="form-control" id="categoryLink" name="link"
                               placeholder="/categories/...">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-lg me-1"></i>Lưu
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Category Management Script - QUAN TRỌNG: Phải để cuối cùng -->
<script src="${pageContext.request.contextPath}/admin/categories.js"></script>

</body>
</html>