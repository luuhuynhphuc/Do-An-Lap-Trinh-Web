<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Chính sách - Japan Sport Admin</title>

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
                <li><a class="s-item active" href="${pageContext.request.contextPath}/admin/policies">
                    <i class="bi bi-shield-check me-2"></i>Chính sách</a>
                </li>
            </ul>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="flex-grow-1 p-3">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
                <li class="breadcrumb-item active">Chính sách</li>
            </ol>
        </nav>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="mb-0">Quản lý Chính sách</h4>
            <div class="d-flex gap-2">
                <input id="searchInput" class="form-control" placeholder="Tìm tiêu đề..." style="max-width:260px">
                <button id="btnAddPolicy" class="btn btn-primary">
                    <i class="bi bi-plus-lg me-1"></i>Thêm chính sách
                </button>
            </div>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table class="table align-middle table-hover mb-0" id="tblPolicies">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Tiêu đề</th>
                            <th>Slug</th>
                            <th>Loại</th>
                            <th>Thứ tự</th>
                            <th>Trạng thái</th>
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
<div class="modal fade" id="modalPolicy" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <form class="modal-content" id="formPolicy">
            <div class="modal-header">
                <h5 id="modalTitle">Thêm chính sách</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="policyId">
                <input type="hidden" name="action" id="formAction" value="add">

                <div class="row g-3">
                    <div class="col-md-8">
                        <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                        <input type="text" name="title" id="policyTitle" class="form-control" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Slug</label>
                        <input type="text" name="slug" id="policySlug" class="form-control">
                        <small class="text-muted">Để trống để tự động tạo</small>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Loại chính sách</label>
                        <select name="policy_type" id="policyType" class="form-select">
                            <option value="shipping">Vận chuyển</option>
                            <option value="return">Đổi trả</option>
                            <option value="payment">Thanh toán</option>
                            <option value="privacy">Bảo mật</option>
                            <option value="warranty">Bảo hành</option>
                            <option value="other">Khác</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Thứ tự hiển thị</label>
                        <input type="number" name="display_order" id="policyOrder" class="form-control" value="0">
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="active" id="policyActive" class="form-select">
                            <option value="1">Hiển thị</option>
                            <option value="0">Ẩn</option>
                        </select>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label">Nội dung <span class="text-danger">*</span></label>
                        <textarea name="content" id="policyContent" class="form-control" rows="15" required></textarea>
                        <small class="text-muted">Hỗ trợ HTML</small>
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
<script src="${pageContext.request.contextPath}/admin/policies.js"></script>

</body>
</html>