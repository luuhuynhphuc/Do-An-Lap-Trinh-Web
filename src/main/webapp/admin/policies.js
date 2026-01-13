const API_URL = '/demo/admin/policies';

function slugify(str) {
    if (!str) return '';
    return str.toString().toLowerCase().trim()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .replace(/đ/g, 'd')
        .replace(/[^a-z0-9\s-]/g, '')
        .replace(/\s+/g, '-')
        .replace(/-+/g, '-')
        .replace(/^-+|-+$/g, '');
}

function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `alert alert-${type} position-fixed top-0 end-0 m-3`;
    toast.style.zIndex = '9999';
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.remove();
    }, 3000);
}

async function fetchPolicies() {
    try {
        const response = await fetch(`${API_URL}?action=list`);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error('Error fetching policies:', error);
        showToast('Lỗi khi tải danh sách chính sách', 'danger');
        return [];
    }
}

async function addPolicy(formData) {
    try {
        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        if (result.success) {
            showToast(result.message, 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi thêm chính sách', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error adding policy:', error);
        showToast('Lỗi khi thêm chính sách', 'danger');
        return false;
    }
}

async function updatePolicy(formData) {
    try {
        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        if (result.success) {
            showToast(result.message, 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi cập nhật chính sách', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error updating policy:', error);
        showToast('Lỗi khi cập nhật chính sách', 'danger');
        return false;
    }
}

async function deletePolicy(id) {
    try {
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('id', id);

        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        if (result.success) {
            showToast(result.message, 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi xóa chính sách', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error deleting policy:', error);
        showToast('Lỗi khi xóa chính sách', 'danger');
        return false;
    }
}

let allPolicies = [];
let policyModal = null;
let editingPolicyId = null;

const POLICY_TYPE_LABELS = {
    'shipping': 'Vận chuyển',
    'return': 'Đổi trả',
    'payment': 'Thanh toán',
    'privacy': 'Bảo mật',
    'warranty': 'Bảo hành',
    'other': 'Khác'
};

async function renderPolicies() {
    const tbody = document.querySelector('#tblPolicies tbody');
    if (!tbody) return;

    allPolicies = await fetchPolicies();
    const searchQuery = document.getElementById('searchInput')?.value.toLowerCase() || '';

    const filtered = allPolicies.filter(policy => {
        const searchText = (policy.title + policy.slug).toLowerCase();
        return searchText.includes(searchQuery);
    });

    tbody.innerHTML = '';

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center py-4">Không có dữ liệu</td></tr>';
        return;
    }

    filtered.forEach(policy => {
        const tr = document.createElement('tr');

        const typeLabel = POLICY_TYPE_LABELS[policy.policyType] || policy.policyType;

        tr.innerHTML = `
            <td>${policy.id}</td>
            <td>${policy.title}</td>
            <td><code>${policy.slug}</code></td>
            <td><span class="badge bg-info">${typeLabel}</span></td>
            <td>${policy.displayOrder}</td>
            <td>
                ${policy.active === 1
                    ? '<span class="badge bg-success">Hiển thị</span>'
                    : '<span class="badge bg-secondary">Ẩn</span>'}
            </td>
            <td class="text-end">
                <button class="btn btn-sm btn-outline-secondary me-1" onclick="openEditModal(${policy.id})">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger" onclick="handleDelete(${policy.id})">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function openAddModal() {
    editingPolicyId = null;
    document.getElementById('modalTitle').textContent = 'Thêm chính sách';
    document.getElementById('formAction').value = 'add';
    document.getElementById('formPolicy').reset();
    document.getElementById('policyId').value = '';
    policyModal.show();
}

function openEditModal(id) {
    const policy = allPolicies.find(p => p.id === id);
    if (!policy) return;

    editingPolicyId = id;
    document.getElementById('modalTitle').textContent = 'Sửa chính sách';
    document.getElementById('formAction').value = 'update';
    document.getElementById('policyId').value = policy.id;
    document.getElementById('policyTitle').value = policy.title;
    document.getElementById('policySlug').value = policy.slug;
    document.getElementById('policyContent').value = policy.content;
    document.getElementById('policyType').value = policy.policyType || 'other';
    document.getElementById('policyOrder').value = policy.displayOrder || 0;
    document.getElementById('policyActive').value = policy.active || 1;

    policyModal.show();
}

async function handleDelete(id) {
    if (!confirm('Bạn có chắc muốn xóa chính sách này?')) return;

    const success = await deletePolicy(id);
    if (success) {
        await renderPolicies();
    }
}


document.getElementById('formPolicy')?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const formData = new FormData(e.target);

    // Auto-generate slug if empty
    if (!formData.get('slug')) {
        const title = formData.get('title');
        formData.set('slug', slugify(title));
    }

    let success = false;

    if (formData.get('action') === 'add') {
        success = await addPolicy(formData);
    } else {
        success = await updatePolicy(formData);
    }

    if (success) {
        policyModal.hide();
        await renderPolicies();
    }
});

// Auto-generate slug from title
document.getElementById('policyTitle')?.addEventListener('input', (e) => {
    const slugInput = document.getElementById('policySlug');
    if (!slugInput.dataset.manualEdit) {
        slugInput.value = slugify(e.target.value);
    }
});

document.getElementById('policySlug')?.addEventListener('input', (e) => {
    e.target.dataset.manualEdit = 'true';
});


document.getElementById('btnAddPolicy')?.addEventListener('click', openAddModal);
document.getElementById('searchInput')?.addEventListener('input', renderPolicies);


document.getElementById('btnToggleSidebar')?.addEventListener('click', () => {
    document.getElementById('sidebar')?.classList.toggle('show');
});


document.addEventListener('DOMContentLoaded', async () => {
    const modalEl = document.getElementById('modalPolicy');
    if (modalEl) {
        policyModal = new bootstrap.Modal(modalEl);
    }

    await renderPolicies();
});

// Make functions global for inline onclick
window.openEditModal = openEditModal;
window.handleDelete = handleDelete;