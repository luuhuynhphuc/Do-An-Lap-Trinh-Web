<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.japansport.model.User" %>
<%
    // Kiểm tra quyền admin
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }

    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi" data-bs-theme="light">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Đơn hàng • Admin</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- DataTables v2 + Bootstrap 5 -->
    <link rel="stylesheet" href="https://cdn.datatables.net/2.0.8/css/dataTables.bootstrap5.min.css">
    <!-- App CSS -->
    <link href="<%= contextPath %>/admin/admin.css" rel="stylesheet">
</head>

<body>

<!-- TOPBAR -->
<header class="cui-topbar">
    <div class="cui-topbar__inner container-fluid">
        <div class="d-flex align-items-center gap-3">
            <button class="btn btn-link text-white d-lg-none p-0" id="btnToggleSidebar">
                <i class="bi bi-list fs-3"></i>
            </button>
            <a href="<%= contextPath %>/admin/dashboard" class="d-flex align-items-center text-white text-decoration-none">
                <img src="<%= contextPath %>/admin/images/logo.png" alt="Logo" height="24" class="me-2">
                <span class="fw-semibold">Japan Sport Admin</span>
            </a>
        </div>
        <form class="cui-search ms-lg-5 me-3 d-none d-md-block" role="search">
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-search"></i></span>
                <input id="globalSearch" class="form-control" placeholder="Search...">
            </div>
        </form>
        <ul class="cui-icons list-unstyled d-flex align-items-center mb-0 ms-auto">
            <li class="cui-icon"><a class="text-white position-relative" href="#"><i class="bi bi-bell fs-5"></i><span class="dot"></span></a></li>
            <li class="cui-sep" role="separator"></li>
            <li class="dropdown">
                <a class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" href="#" data-bs-toggle="dropdown">
                    <span class="avatar-wrap position-relative">
                        <img src="<%= contextPath %>/admin/images/admin1.png" class="rounded-circle" width="32" height="32" alt="">
                        <span class="online"></span>
                    </span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item text-danger" href="<%= contextPath %>/logout">
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
                <li><a class="s-item" href="<%= contextPath %>/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
            </ul>
            <div class="s-title">MANAGEMENT</div>
            <ul class="s-nav">
                <li class="has-children">
                    <a class="s-item s-parent" href="#" onclick="return false;">
                        <span><i class="bi bi-box-seam me-2"></i>Sản phẩm</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav">
                        <li><a class="s-subitem" href="<%= contextPath %>/admin/products"><i class="bi bi-list-ul me-2"></i>Quản lý sản phẩm</a></li>
                        <li><a class="s-subitem" href="<%= contextPath %>/admin/categories"><i class="bi bi-tags me-2"></i>Danh mục</a></li>
                        <li><a class="s-subitem" href="<%= contextPath %>/admin/brands"><i class="bi bi-badge-tm me-2"></i>Nhãn hàng</a></li>
                    </ul>
                </li>

                <!-- Orders -->
                <li class="has-children force-open">
                    <a class="s-item s-parent active" href="#" onclick="return false;">
                        <span><i class="bi bi-receipt me-2"></i>Đơn hàng</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav">
                        <li><a class="s-subitem active" href="<%= contextPath %>/admin/orders"><i class="bi bi-list-ul me-2"></i>Quản lý đơn hàng</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="flex-grow-1 p-3">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="<%= contextPath %>/admin/dashboard">Dashboard</a></li>
                <li class="breadcrumb-item active">Đơn hàng</li>
            </ol>
        </nav>

        <section>
            <div class="d-flex flex-wrap gap-2 align-items-center mb-2">
                <h3 class="mb-0 me-auto">Đơn hàng</h3>

                <div class="d-flex gap-2">
                    <button id="btnCsv" class="btn btn-outline-secondary">
                        <i class="bi bi-file-earmark-spreadsheet"></i> Xuất CSV
                    </button>
                    <button id="btnPrint" class="btn btn-outline-secondary">
                        <i class="bi bi-printer"></i> In
                    </button>
                    <button id="btnRefresh" class="btn btn-outline-primary">
                        <i class="bi bi-arrow-clockwise"></i> Làm mới
                    </button>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0" id="tblOrders" style="width:100%">
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
                                <!-- Data loaded by JavaScript -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>

<!-- OFFCANVAS: Chi tiết đơn -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="offOrder" aria-labelledby="offOrderLabel">
    <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="offOrderLabel">Chi tiết đơn hàng</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
    </div>
    <div class="offcanvas-body">
        <div id="orderDetail">
            <div class="text-center text-secondary py-5">
                <i class="bi bi-receipt fs-1"></i>
                <p class="mt-2">Chọn "Xem" để hiển thị chi tiết</p>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: Sửa trạng thái -->
<div class="modal fade" id="modalEditStatus" tabindex="-1" aria-hidden="true">
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
                    <label class="form-label">Trạng thái <span class="text-danger">*</span></label>
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
                    <textarea id="editNote" class="form-control" rows="3" placeholder="Ghi chú nội bộ..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>

<!-- Libs -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/2.0.8/js/dataTables.min.js"></script>
<script src="https://cdn.datatables.net/2.0.8/js/dataTables.bootstrap5.min.js"></script>

<script>
const API_URL = '<%= contextPath %>/admin/orders';

// Format tiền VNĐ
const fmt = (n) => (Number(n) || 0).toLocaleString('vi-VN') + 'đ';

// Format datetime
const fmtDate = (str) => {
    if (!str) return '—';
    const d = new Date(str);
    return d.toLocaleString('vi-VN', {
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit'
    });
};

// Status badge
const statusBadge = (status) => {
    const map = {
        'processing': '<span class="badge text-bg-warning">Chờ xác nhận</span>',
        'confirmed': '<span class="badge text-bg-info">Đã xác nhận</span>',
        'shipping': '<span class="badge text-bg-primary">Đang giao</span>',
        'done': '<span class="badge text-bg-success">Hoàn tất</span>',
        'canceled': '<span class="badge text-bg-secondary">Đã hủy</span>'
    };
    return map[status] || '<span class="badge text-bg-light">N/A</span>';
};

// Toast notification
const toast = (msg, type) => {
    type = type || 'success';
    const el = document.createElement('div');
    el.className = 'alert alert-' + type + ' position-fixed top-0 end-0 m-3';
    el.style.zIndex = '9999';
    el.textContent = msg;
    document.body.appendChild(el);
    setTimeout(() => el.remove(), 3000);
};

// DataTable instance
let dt = null;

// Load orders
async function loadOrders() {
    try {
        const res = await fetch(API_URL + '?action=list');
        const json = await res.json();

        if (!json.success) {
            toast(json.message || 'Lỗi khi tải dữ liệu', 'danger');
            return;
        }

        const orders = json.data || [];
        renderOrders(orders);

    } catch (err) {
        console.error('Error loading orders:', err);
        toast('Lỗi kết nối server', 'danger');
    }
}

// Render orders to table
function renderOrders(orders) {
    const tbody = document.getElementById('ordersTableBody');
    tbody.innerHTML = '';

    if (orders.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center py-4">Không có đơn hàng nào</td></tr>';
        return;
    }

    orders.forEach(order => {
        const tr = document.createElement('tr');
        tr.innerHTML =
            '<td><strong>' + (order.orderCode || '—') + '</strong></td>' +
            '<td>' + (order.customerName || '—') + '</td>' +
            '<td>' + (order.customerPhone || '—') + '</td>' +
            '<td>' + (order.customerEmail || '—') + '</td>' +
            '<td>' + fmtDate(order.createdAt) + '</td>' +
            '<td><strong>' + fmt(order.total) + '</strong></td>' +
            '<td>' + statusBadge(order.status) + '</td>' +
            '<td class="text-center">' +
                '<button class="btn btn-sm btn-outline-primary me-1" onclick="viewOrder(' + order.id + ')">' +
                    '<i class="bi bi-eye"></i>' +
                '</button>' +
                '<button class="btn btn-sm btn-outline-secondary me-1" onclick="editOrder(' + order.id + ', \'' + (order.orderCode || '') + '\', \'' + (order.status || '') + '\')">' +
                    '<i class="bi bi-pencil"></i>' +
                '</button>' +
                '<button class="btn btn-sm btn-outline-danger" onclick="deleteOrder(' + order.id + ', \'' + (order.orderCode || '') + '\')">' +
                    '<i class="bi bi-trash"></i>' +
                '</button>' +
            '</td>';
        tbody.appendChild(tr);
    });

    // Init/Update DataTable
    if (dt) {
        dt.destroy();
    }
    dt = new DataTable('#tblOrders', {
        pageLength: 10,
        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, 'Tất cả']],
        language: {
            search: 'Tìm kiếm:',
            lengthMenu: 'Hiển thị _MENU_ dòng',
            info: 'Hiển thị _START_—_END_ / _TOTAL_',
            infoEmpty: 'Không có dữ liệu',
            zeroRecords: 'Không có dữ liệu',
            paginate: { previous: 'Trước', next: 'Sau' }
        }
    });
}

// View order detail
async function viewOrder(id) {
    try {
        const res = await fetch(API_URL + '?action=detail&id=' + id);
        const json = await res.json();

        if (!json.success) {
            toast(json.message || 'Lỗi khi tải chi tiết', 'danger');
            return;
        }

        const order = json.data;
        showOrderDetail(order);

    } catch (err) {
        console.error('Error loading detail:', err);
        toast('Lỗi kết nối server', 'danger');
    }
}

// Show order detail in offcanvas
function showOrderDetail(order) {
    const items = order.items || [];

    const itemsHtml = items.map(item =>
        '<tr>' +
            '<td>' + (item.productName || '—') + '</td>' +
            '<td class="text-center">' + item.quantity + '</td>' +
            '<td class="text-end">' + fmt(item.price) + '</td>' +
            '<td class="text-end">' + fmt(item.quantity * item.price) + '</td>' +
        '</tr>'
    ).join('');

    // Tạo phần ghi chú nếu có
    const noteHtml = order.note
        ? '<div class="mt-2"><span class="text-secondary">Ghi chú:</span> ' + order.note + '</div>'
        : '';

    const html =
        '<div class="row g-2">' +
            '<div class="col-md-6">' +
                '<div class="mb-1"><span class="text-secondary">Mã đơn:</span> <strong>' + (order.orderCode || '—') + '</strong></div>' +
                '<div class="mb-1"><span class="text-secondary">Khách hàng:</span> ' + (order.customerName || '—') + '</div>' +
                '<div class="mb-1"><span class="text-secondary">SĐT:</span> ' + (order.customerPhone || '—') + '</div>' +
                '<div class="mb-1"><span class="text-secondary">Email:</span> ' + (order.customerEmail || '—') + '</div>' +
                '<div class="mb-1"><span class="text-secondary">Địa chỉ:</span> ' + (order.shippingAddress || '—') + '</div>' +
            '</div>' +
            '<div class="col-md-6">' +
                '<div class="mb-1"><span class="text-secondary">Ngày đặt:</span> ' + fmtDate(order.createdAt) + '</div>' +
                '<div class="mb-1"><span class="text-secondary">Loại ship:</span> ' + (order.shippingMethod || '—') + '</div>' +
                '<div class="mb-1"><span class="text-secondary">Mã vận đơn:</span> ' + (order.trackingCode || '—') + '</div>' +
                '<div class="mb-1"><span class="text-secondary">Thanh toán:</span> ' + (order.paymentMethod || '—') + '</div>' +
                '<div class="mb-1"><span class="text-secondary">Trạng thái:</span> ' + statusBadge(order.status) + '</div>' +
            '</div>' +
        '</div>' +
        noteHtml +
        '<hr class="my-3">' +
        '<div class="fw-semibold mb-2">Sản phẩm</div>' +
        '<table class="table table-sm">' +
            '<thead>' +
                '<tr>' +
                    '<th>Tên sản phẩm</th>' +
                    '<th class="text-center">SL</th>' +
                    '<th class="text-end">Đơn giá</th>' +
                    '<th class="text-end">Thành tiền</th>' +
                '</tr>' +
            '</thead>' +
            '<tbody>' +
                (itemsHtml || '<tr><td colspan="4" class="text-center text-secondary">Không có sản phẩm</td></tr>') +
            '</tbody>' +
            '<tfoot>' +
                '<tr><th colspan="3" class="text-end">Tạm tính</th><th class="text-end">' + fmt(order.subtotal) + '</th></tr>' +
                '<tr><th colspan="3" class="text-end">Giảm</th><th class="text-end">-' + fmt(order.discount) + '</th></tr>' +
                '<tr><th colspan="3" class="text-end">Phí ship</th><th class="text-end">' + fmt(order.shippingFee) + '</th></tr>' +
                '<tr><th colspan="3" class="text-end">Tổng thanh toán</th><th class="text-end"><strong>' + fmt(order.total) + '</strong></th></tr>' +
            '</tfoot>' +
        '</table>';

    document.getElementById('orderDetail').innerHTML = html;
    new bootstrap.Offcanvas('#offOrder').show();
}

// Edit order status
function editOrder(id, code, status) {
    document.getElementById('editOrderId').value = id;
    document.getElementById('editOrderCode').value = code;
    document.getElementById('editStatus').value = status;
    document.getElementById('editNote').value = '';

    new bootstrap.Modal('#modalEditStatus').show();
}

// Save status
document.getElementById('formEditStatus').addEventListener('submit', async (e) => {
    e.preventDefault();

    const id = document.getElementById('editOrderId').value;
    const status = document.getElementById('editStatus').value;
    const note = document.getElementById('editNote').value;

    try {
        const formData = new FormData();
        formData.append('action', 'updateStatus');
        formData.append('id', id);
        formData.append('status', status);
        if (note) formData.append('note', note);

        const res = await fetch(API_URL, { method: 'POST', body: formData });
        const json = await res.json();

        if (json.success) {
            toast('Cập nhật trạng thái thành công', 'success');
            bootstrap.Modal.getInstance('#modalEditStatus').hide();
            loadOrders(); // Reload table
        } else {
            toast(json.message || 'Lỗi khi cập nhật', 'danger');
        }

    } catch (err) {
        console.error('Error updating status:', err);
        toast('Lỗi kết nối server', 'danger');
    }
});

// Delete order
async function deleteOrder(id, code) {
    if (!confirm('Xóa đơn hàng ' + code + '?\n\nLưu ý: Không thể hoàn tác!')) return;

    try {
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('id', id);

        const res = await fetch(API_URL, { method: 'POST', body: formData });
        const json = await res.json();

        if (json.success) {
            toast('Xóa đơn hàng thành công', 'success');
            loadOrders();
        } else {
            toast(json.message || 'Lỗi khi xóa', 'danger');
        }

    } catch (err) {
        console.error('Error deleting:', err);
        toast('Lỗi kết nối server', 'danger');
    }
}

// Export CSV
document.getElementById('btnCsv').addEventListener('click', () => {
    const table = document.getElementById('tblOrders');
    const rows = [];
    const headers = ['Mã đơn', 'Khách hàng', 'SĐT', 'Email', 'Ngày đặt', 'Tổng tiền', 'Trạng thái'];
    rows.push(headers.join(','));

    Array.from(table.querySelectorAll('tbody tr')).forEach(tr => {
        const cells = Array.from(tr.cells).slice(0, 7);
        const row = cells.map(td => '"' + td.textContent.trim().replace(/"/g, '""') + '"');
        rows.push(row.join(','));
    });

    const blob = new Blob([rows.join('\n')], { type: 'text/csv;charset=utf-8;' });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = 'orders_' + Date.now() + '.csv';
    a.click();
});

// Print
document.getElementById('btnPrint').addEventListener('click', () => window.print());

// Refresh
document.getElementById('btnRefresh').addEventListener('click', loadOrders);

// Sidebar toggle
const btnToggle = document.getElementById('btnToggleSidebar');
if (btnToggle) {
    btnToggle.addEventListener('click', () => {
        document.getElementById('sidebar').classList.toggle('show');
    });
}

// Init
loadOrders();
</script>

</body>
</html>