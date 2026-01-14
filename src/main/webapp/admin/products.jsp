<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sản phẩm - Admin</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Admin CSS -->
    <link href="${pageContext.request.contextPath}/admin/admin.css" rel="stylesheet">
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
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                </li>
                <li class="breadcrumb-item active">Sản phẩm</li>
            </ol>
        </nav>

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Quản lý Sản phẩm</h5>
            <div class="d-flex gap-2">
                <input id="searchInput" class="form-control"
                       placeholder="Tìm tên sản phẩm..." style="max-width:260px">
                <button id="btnAddProduct" class="btn btn-primary">
                    <i class="bi bi-plus-lg me-1"></i>Thêm sản phẩm
                </button>
            </div>
        </div>

        <!-- Table -->
        <div class="card">
            <div class="table-responsive">
                <table class="table align-middle table-hover mb-0" id="tblProducts">
                    <thead class="table-light">
                    <tr>
                        <th style="width:60px">ID</th>
                        <th style="width:90px">Ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Danh mục</th>
                        <th>Thương hiệu</th>
                        <th>Giá</th>
                        <th>Giá cũ</th>
                        <th>Giới tính</th>
                        <th class="text-end" style="width:120px">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                        <!-- Load bằng products.js -->
                        <tr>
                            <td colspan="9" class="text-center py-4">
                                <div class="spinner-border text-primary"></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

<!-- MODAL ADD / EDIT PRODUCT -->
<div class="modal fade" id="modalProduct" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="formProduct">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Thêm sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <input type="hidden" name="id" id="productId">
                <input type="hidden" name="action" id="formAction" value="add">

                <div class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">
                            Tên sản phẩm <span class="text-danger">*</span>
                        </label>
                        <input type="text" name="name" id="productName"
                               class="form-control" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Danh mục</label>
                        <select name="category_id" id="productCategory" class="form-select">
                            <option value="">-- Chọn danh mục --</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Thương hiệu</label>
                        <select name="brand_id" id="productBrand" class="form-select">
                            <option value="">-- Chọn thương hiệu --</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">
                            Giá (VNĐ) <span class="text-danger">*</span>
                        </label>
                        <input type="number" name="price" id="productPrice"
                               class="form-control" step="1000" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Giá cũ (VNĐ)</label>
                        <input type="number" name="old_price" id="productOldPrice"
                               class="form-control" step="1000">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Giới tính</label>
                        <select name="gender" id="productGender" class="form-select">
                            <option value="">-- Chọn --</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                            <option value="Unisex">Unisex</option>
                        </select>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label">Ảnh</label>
                        <input type="text" name="image_url" id="productImage"
                               class="form-control">
                    </div>

                    <div class="col-md-12">
                        <div id="imagePreview" class="mt-2" style="display:none;">
                            <img id="previewImg" src=""
                                 style="max-width:200px;border-radius:8px">
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button"
                        class="btn btn-outline-secondary"
                        data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-lg me-1"></i>Lưu
                </button>
            </div>
        </form>
    </div>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/admin/products.js"></script>

</body>
</html>
