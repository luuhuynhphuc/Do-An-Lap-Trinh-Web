<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.japansport.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng - Admin</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/2.0.8/css/dataTables.bootstrap5.min.css">

    <!-- Admin CSS -->
    <link href="${pageContext.request.contextPath}/admin/admin.css" rel="stylesheet">
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                </li>
                <li class="breadcrumb-item active">Đơn hàng</li>
            </ol>
        </nav>

        <!-- Header -->
        <div class="d-flex flex-wrap gap-2 align-items-center mb-3">
            <h5 class="mb-0 me-auto">Quản lý Đơn hàng</h5>

            <div class="d-flex gap-2">
                <button id="btnCsv" class="btn btn-outline-secondary">
                    <i class="bi bi-file-earmark-spreadsheet me-1"></i>Xuất CSV
                </button>
                <button id="btnPrint" class="btn btn-outline-secondary">
                    <i class="bi bi-printer me-1"></i>In
                </button>
            </div>
        </div>

        <!-- Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="tblOrders">
                        <thead class="table-light">
                        <tr>
                            <th>Mã đơn</th>
                            <th>Khách hàng</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th class="text-center">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody id="ordersTableBody">
                        <tr>
                            <td colspan="8" class="text-center py-4">
                                <div class="spinner-border text-primary"></div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </main>
</div>

<!-- OFFCANVAS: Chi tiết đơn -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="offOrder">
    <div class="offcanvas-header">
        <h5 class="offcanvas-title">Chi tiết đơn hàng</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
    </div>
    <div class="offcanvas-body">
        <div id="orderDetail" class="text-center text-muted py-5">
            <i class="bi bi-receipt fs-1"></i>
            <p class="mt-2">Chọn “Xem” để hiển thị chi tiết</p>
        </div>
    </div>
</div>

<!-- MODAL: Sửa trạng thái -->
<div class="modal fade" id="modalEditStatus" tabindex="-1">
    <div class="modal-dialog">
        <form class="modal-content" id="formEditStatus">
            <div class="modal-header">
                <h5 class="modal-title">Cập nhật trạng thái đơn hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <input type="hidden" id="editOrderId">

                <div class="mb-3">
                    <label class="form-label">Mã đơn</label>
                    <input type="text" id="editOrderCode" class="form-control" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <select id="editStatus" class="form-select" required>
                        <option value="processing">Chờ xác nhận</option>
                        <option value="confirmed">Đã xác nhận</option>
                        <option value="shipping">Đang giao</option>
                        <option value="done">Hoàn tất</option>
                        <option value="canceled">Đã hủy</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Ghi chú</label>
                    <textarea id="editNote" class="form-control" rows="3"></textarea>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu</button>
            </div>
        </form>
    </div>
</div>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/2.0.8/js/dataTables.min.js"></script>
<script src="https://cdn.datatables.net/2.0.8/js/dataTables.bootstrap5.min.js"></script>

<!-- Orders Script -->
<script src="${pageContext.request.contextPath}/admin/orders.js"></script>

</body>
</html>