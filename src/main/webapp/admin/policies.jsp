<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Chính sách - Japan Sport Admin</title>

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
                <li class="breadcrumb-item active" aria-current="page">Chính sách</li>
            </ol>
        </nav>

        <!-- Header + Search + Add Button -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="mb-0">Quản lý Chính sách</h4>
            <div class="d-flex gap-2">
                <input id="searchInput" class="form-control" placeholder="Tìm tiêu đề..." style="max-width:260px">
                <button id="btnAddPolicy" class="btn btn-primary">
                    <i class="bi bi-plus-lg me-1"></i>Thêm chính sách
                </button>
            </div>
        </div>

        <!-- Policies Table -->
        <div class="card shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="tblPolicies">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 60px;">ID</th>
                            <th>Tiêu đề</th>
                            <th style="width: 150px;">Slug</th>
                            <th style="width: 120px;">Loại</th>
                            <th style="width: 80px;">Thứ tự</th>
                            <th style="width: 100px;">Trạng thái</th>
                            <th style="width: 140px;" class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Data sẽ load từ policies.js -->
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

<!-- MODAL ADD/EDIT POLICY -->
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

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/admin/policies.js"></script>

</body>
</html>
