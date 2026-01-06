<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sản phẩm - Japan Sport Admin</title>

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
                        <span><i class="bi bi-box-seam me-2"></i>Sản phẩm</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav">
                        <li><a class="s-subitem active" href="${pageContext.request.contextPath}/admin/products">
                            <i class="bi bi-list-ul me-2"></i>Quản lý sản phẩm</a>
                        </li>
                        <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/categories">
                            <i class="bi bi-tags me-2"></i>Danh mục sản phẩm</a>
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
                <li class="breadcrumb-item active">Sản phẩm</li>
            </ol>
        </nav>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="mb-0">Quản lý Sản phẩm</h4>
            <div class="d-flex gap-2">
                <input id="searchInput" class="form-control" placeholder="Tìm tên sản phẩm..." style="max-width:260px">
                <button id="btnAddProduct" class="btn btn-primary">
                    <i class="bi bi-plus-lg me-1"></i>Thêm sản phẩm
                </button>
            </div>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table class="table align-middle table-hover mb-0" id="tblProducts">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Danh mục</th>
                            <th>Thương hiệu</th>
                            <th>Giá</th>
                            <th>Giá cũ</th>
                            <th>Giới tính</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- MODAL ADD/EDIT -->
<div class="modal fade" id="modalProduct" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="formProduct">
            <div class="modal-header">
                <h5 id="modalTitle">Thêm sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="productId">
                <input type="hidden" name="action" id="formAction" value="add">

                <div class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                        <input type="text" name="name" id="productName" class="form-control" required>
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
                        <label class="form-label">Giá (VNĐ) <span class="text-danger">*</span></label>
                        <input type="number" name="price" id="productPrice" class="form-control" step="1000" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Giá cũ (VNĐ)</label>
                        <input type="number" name="old_price" id="productOldPrice" class="form-control" step="1000">
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
                        <label class="form-label">Ảnh URL</label>
                        <input type="url" name="image_url" id="productImage" class="form-control">
                    </div>

                    <div class="col-md-12">
                        <div id="imagePreview" class="mt-2" style="display:none;">
                            <img id="previewImg" src="" alt="Preview" style="max-width:200px;max-height:200px;border-radius:8px;">
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/admin/products.js"></script>

</body>
</html>