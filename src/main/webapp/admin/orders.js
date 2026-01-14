const API_URL = '/demo/admin/orders';

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
function showToast(msg, type = 'success') {
    const el = document.createElement('div');
    el.className = `alert alert-${type} position-fixed top-0 end-0 m-3`;
    el.style.zIndex = '9999';
    el.textContent = msg;
    document.body.appendChild(el);
    setTimeout(() => el.remove(), 3000);
}

// DataTable instance
let dt = null;
let orderOffcanvas = null;
let statusModal = null;

// Fetch orders from API
async function fetchOrders() {
    try {
        const response = await fetch(`${API_URL}?action=list`);
        if (!response.ok) {
            console.error('Response status:', response.status);
            throw new Error('Network response was not ok');
        }
        const json = await response.json();
        console.log('Fetched orders:', json);

        if (!json.success) {
            showToast(json.message || 'Lỗi khi tải dữ liệu', 'danger');
            return [];
        }

        return json.data || [];
    } catch (error) {
        console.error('Error fetching orders:', error);
        showToast('Lỗi khi tải danh sách đơn hàng', 'danger');
        return [];
    }
}

// Fetch order detail
async function fetchOrderDetail(id) {
    try {
        const response = await fetch(`${API_URL}?action=detail&id=${id}`);
        if (!response.ok) throw new Error('Network response was not ok');
        const json = await response.json();

        if (!json.success) {
            showToast(json.message || 'Lỗi khi tải chi tiết', 'danger');
            return null;
        }

        return json.data;
    } catch (error) {
        console.error('Error fetching order detail:', error);
        showToast('Lỗi khi tải chi tiết đơn hàng', 'danger');
        return null;
    }
}

// Update order status
async function updateOrderStatus(id, status, note) {
    try {
        const formData = new FormData();
        formData.append('action', 'updateStatus');
        formData.append('id', id);
        formData.append('status', status);
        if (note) formData.append('note', note);

        console.log('Updating order status:', { id, status, note });

        const response = await fetch(API_URL, {
            method: 'POST',
            body: formData
        });

        console.log('Update response status:', response.status);

        const result = await response.json();
        console.log('Update result:', result);

        if (result.success) {
            showToast(result.message || 'Cập nhật trạng thái thành công', 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi cập nhật trạng thái', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error updating status:', error);
        showToast('Lỗi kết nối server: ' + error.message, 'danger');
        return false;
    }
}

// Delete order
async function deleteOrderById(id) {
    try {
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('id', id);

        console.log('Deleting order:', id);

        const response = await fetch(API_URL, {
            method: 'POST',
            body: formData
        });

        console.log('Delete response status:', response.status);

        const result = await response.json();
        console.log('Delete result:', result);

        if (result.success) {
            showToast(result.message || 'Xóa đơn hàng thành công', 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi xóa đơn hàng', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error deleting order:', error);
        showToast('Lỗi kết nối server: ' + error.message, 'danger');
        return false;
    }
}

// Render orders to table
async function renderOrders() {
    const tbody = document.getElementById('ordersTableBody');
    if (!tbody) {
        console.error('Table body not found');
        return;
    }

    // Destroy DataTable first to avoid conflicts
    if (dt) {
        dt.destroy();
        dt = null;
    }

    const orders = await fetchOrders();

    tbody.innerHTML = '';

    if (orders.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center py-4">Không có đơn hàng nào</td></tr>';
        return;
    }

    orders.forEach(order => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><strong>${order.orderCode || '—'}</strong></td>
            <td>${order.customerName || '—'}</td>
            <td>${order.customerPhone || '—'}</td>
            <td>${order.customerEmail || '—'}</td>
            <td>${fmtDate(order.createdAt)}</td>
            <td><strong>${fmt(order.total)}</strong></td>
            <td>${statusBadge(order.status)}</td>
            <td class="text-center">
                <button class="btn btn-sm btn-outline-primary me-1" onclick="viewOrder(${order.id})" title="Xem chi tiết">
                    <i class="bi bi-eye"></i>
                </button>
                <button class="btn btn-sm btn-outline-secondary me-1" onclick="editOrder(${order.id}, '${(order.orderCode || '').replace(/'/g, "\\'")}', '${order.status || ''}')" title="Sửa">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger" onclick="deleteOrder(${order.id}, '${(order.orderCode || '').replace(/'/g, "\\'")}'))" title="Xóa">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });

    // Initialize new DataTable with fresh data
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
        },
        // Force redraw
        destroy: true
    });

    console.log('Orders table rendered with', orders.length, 'items');
}

// View order detail
async function viewOrder(id) {
    const order = await fetchOrderDetail(id);
    if (!order) return;

    showOrderDetail(order);
}

// Show order detail in offcanvas
function showOrderDetail(order) {
    const items = order.items || [];

    const itemsHtml = items.map(item =>
        `<tr>
            <td>${item.productName || '—'}</td>
            <td class="text-center">${item.quantity}</td>
            <td class="text-end">${fmt(item.price)}</td>
            <td class="text-end">${fmt(item.quantity * item.price)}</td>
        </tr>`
    ).join('');

    const noteHtml = order.note
        ? `<div class="mt-2"><span class="text-secondary">Ghi chú:</span> ${order.note}</div>`
        : '';

    const html = `
        <div class="row g-2">
            <div class="col-md-6">
                <div class="mb-1"><span class="text-secondary">Mã đơn:</span> <strong>${order.orderCode || '—'}</strong></div>
                <div class="mb-1"><span class="text-secondary">Khách hàng:</span> ${order.customerName || '—'}</div>
                <div class="mb-1"><span class="text-secondary">SĐT:</span> ${order.customerPhone || '—'}</div>
                <div class="mb-1"><span class="text-secondary">Email:</span> ${order.customerEmail || '—'}</div>
                <div class="mb-1"><span class="text-secondary">Địa chỉ:</span> ${order.shippingAddress || '—'}</div>
            </div>
            <div class="col-md-6">
                <div class="mb-1"><span class="text-secondary">Ngày đặt:</span> ${fmtDate(order.createdAt)}</div>
                <div class="mb-1"><span class="text-secondary">Loại ship:</span> ${order.shippingMethod || '—'}</div>
                <div class="mb-1"><span class="text-secondary">Mã vận đơn:</span> ${order.trackingCode || '—'}</div>
                <div class="mb-1"><span class="text-secondary">Thanh toán:</span> ${order.paymentMethod || '—'}</div>
                <div class="mb-1"><span class="text-secondary">Trạng thái:</span> ${statusBadge(order.status)}</div>
            </div>
        </div>
        ${noteHtml}
        <hr class="my-3">
        <div class="fw-semibold mb-2">Sản phẩm</div>
        <table class="table table-sm">
            <thead>
                <tr>
                    <th>Tên sản phẩm</th>
                    <th class="text-center">SL</th>
                    <th class="text-end">Đơn giá</th>
                    <th class="text-end">Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                ${itemsHtml || '<tr><td colspan="4" class="text-center text-secondary">Không có sản phẩm</td></tr>'}
            </tbody>
            <tfoot>
                <tr><th colspan="3" class="text-end">Tạm tính</th><th class="text-end">${fmt(order.subtotal)}</th></tr>
                <tr><th colspan="3" class="text-end">Giảm</th><th class="text-end">-${fmt(order.discount)}</th></tr>
                <tr><th colspan="3" class="text-end">Phí ship</th><th class="text-end">${fmt(order.shippingFee)}</th></tr>
                <tr><th colspan="3" class="text-end">Tổng thanh toán</th><th class="text-end"><strong>${fmt(order.total)}</strong></th></tr>
            </tfoot>
        </table>
    `;

    document.getElementById('orderDetail').innerHTML = html;
    orderOffcanvas.show();
}

// Edit order status
function editOrder(id, code, status) {
    document.getElementById('editOrderId').value = id;
    document.getElementById('editOrderCode').value = code;
    document.getElementById('editStatus').value = status;
    document.getElementById('editNote').value = '';

    statusModal.show();
}

// Delete order
async function deleteOrder(id, code) {
    if (!confirm(`Xóa đơn hàng ${code}?\n\nLưu ý: Không thể hoàn tác!`)) return;

    const success = await deleteOrderById(id);
    if (success) {
        console.log('Delete successful, reloading orders...');
        // Force reload immediately
        await renderOrders();
    }
}

// Export CSV
function exportCSV() {
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
}

// FORM SUBMIT - Update status
document.getElementById('formEditStatus')?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const id = document.getElementById('editOrderId').value;
    const status = document.getElementById('editStatus').value;
    const note = document.getElementById('editNote').value;

    const success = await updateOrderStatus(id, status, note);

    if (success) {
        statusModal.hide();
        console.log('Status update successful, reloading orders...');
        // Force reload immediately after closing modal
        setTimeout(async () => {
            await renderOrders();
        }, 300); // Small delay to let modal close animation finish
    }
});

// EVENT LISTENERS
document.getElementById('btnCsv')?.addEventListener('click', exportCSV);
document.getElementById('btnPrint')?.addEventListener('click', () => window.print());

// Sidebar toggle for mobile
document.getElementById('btnToggleSidebar')?.addEventListener('click', () => {
    document.getElementById('sidebar')?.classList.toggle('show');
});

// INIT
document.addEventListener('DOMContentLoaded', async () => {
    console.log('Page loaded, initializing orders...');

    // Initialize offcanvas
    const offcanvasEl = document.getElementById('offOrder');
    if (offcanvasEl) {
        orderOffcanvas = new bootstrap.Offcanvas(offcanvasEl);
        console.log('Offcanvas initialized');
    }

    // Initialize modal
    const modalEl = document.getElementById('modalEditStatus');
    if (modalEl) {
        statusModal = new bootstrap.Modal(modalEl);
        console.log('Status modal initialized');
    }

    // Initial render
    await renderOrders();
});

// Make functions global for inline onclick
window.viewOrder = viewOrder;
window.editOrder = editOrder;
window.deleteOrder = deleteOrder;