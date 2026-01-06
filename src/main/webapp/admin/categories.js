const API_URL = '/demo/admin/categories';

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

async function fetchCategories() {
    try {
        const response = await fetch(`${API_URL}?action=list`);
        if (!response.ok) {
            console.error('Response status:', response.status);
            throw new Error('Network response was not ok');
        }
        const data = await response.json();
        console.log('Fetched categories:', data);
        return data;
    } catch (error) {
        console.error('Error fetching categories:', error);
        showToast('Lỗi khi tải danh sách danh mục', 'danger');
        return [];
    }
}

async function fetchCategoryById(id) {
    try {
        const response = await fetch(`${API_URL}?action=getById&id=${id}`);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error('Error fetching category:', error);
        showToast('Lỗi khi tải thông tin danh mục', 'danger');
        return null;
    }
}

async function fetchParentCategories() {
    try {
        const response = await fetch(`${API_URL}?action=getParents`);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error('Error fetching parent categories:', error);
        return [];
    }
}

async function saveCategory(formData) {
    try {
        // Log để debug
        console.log('Saving category with action:', formData.get('action'));
        console.log('Category ID:', formData.get('id'));
        console.log('Category name:', formData.get('name'));

        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        // Kiểm tra response status
        console.log('Response status:', response.status);

        const result = await response.json();
        console.log('Server response:', result);

        if (result.success) {
            showToast(result.message, 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi lưu danh mục', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error saving category:', error);
        showToast('Lỗi kết nối server: ' + error.message, 'danger');
        return false;
    }
}

async function deleteCategory(id) {
    try {
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('id', id);

        console.log('Deleting category:', id);

        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        console.log('Delete response status:', response.status);

        const result = await response.json();
        console.log('Delete result:', result);

        if (result.success) {
            showToast(result.message, 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi xóa danh mục', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error deleting category:', error);
        showToast('Lỗi kết nối server: ' + error.message, 'danger');
        return false;
    }
}

let allCategories = [];
let categoryModal = null;
let editingCategoryId = null;

async function renderCategories() {
    const tbody = document.querySelector('#tblCategories tbody');
    if (!tbody) {
        console.error('Table body not found');
        return;
    }

    allCategories = await fetchCategories();
    const searchQuery = document.getElementById('searchInput')?.value.toLowerCase() || '';

    const filtered = allCategories.filter(cat => {
        const searchText = (cat.name + (cat.slug || '')).toLowerCase();
        return searchText.includes(searchQuery);
    });

    tbody.innerHTML = '';

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center py-4">Không có dữ liệu</td></tr>';
        return;
    }

    filtered.forEach(cat => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${cat.id}</td>
            <td>${cat.name}</td>
            <td><code>${cat.slug || ''}</code></td>
            <td>
                ${cat.image_url
                    ? `<img src="${cat.image_url}" alt="" class="thumb" style="width:50px;height:50px;object-fit:cover;border-radius:8px;">`
                    : '<span class="text-muted">-</span>'}
            </td>
            <td>${cat.display_order ?? 0}</td>
            <td>
                ${cat.is_featured === 1
                    ? '<span class="badge bg-warning">Nổi bật</span>'
                    : '<span class="badge bg-secondary">-</span>'}
            </td>
            <td>
                ${cat.active === 1
                    ? '<span class="badge bg-success">Hiển thị</span>'
                    : '<span class="badge bg-secondary">Ẩn</span>'}
            </td>
            <td class="text-end">
                <button class="btn btn-sm btn-outline-secondary me-1" onclick="openEditModal(${cat.id})">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger" onclick="handleDelete(${cat.id})">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

async function loadParentOptions() {
    const select = document.getElementById('categoryParent');
    if (!select) return;

    const parents = await fetchParentCategories();

    select.innerHTML = '<option value="">-- Không có (Danh mục gốc) --</option>';
    parents.forEach(cat => {
        const option = document.createElement('option');
        option.value = cat.id;
        option.textContent = cat.name;
        select.appendChild(option);
    });
}

async function openAddModal() {
    editingCategoryId = null;
    document.getElementById('modalTitle').textContent = 'Thêm danh mục';
    document.getElementById('formAction').value = 'create';
    document.getElementById('formCategory').reset();
    document.getElementById('categoryId').value = '';

    await loadParentOptions();
    categoryModal.show();
}

async function openEditModal(id) {
    const category = await fetchCategoryById(id);
    if (!category) return;

    editingCategoryId = id;
    document.getElementById('modalTitle').textContent = 'Sửa danh mục';
    document.getElementById('formAction').value = 'update';
    document.getElementById('categoryId').value = category.id;
    document.getElementById('categoryName').value = category.name;
    document.getElementById('categorySlug').value = category.slug || '';
    document.getElementById('categoryImage').value = category.image_url || '';
    document.getElementById('categoryLink').value = category.link || '';
    document.getElementById('categoryOrder').value = category.display_order ?? 0;
    document.getElementById('categoryFeatured').value = category.is_featured ?? 0;
    document.getElementById('categoryActive').value = category.active ?? 1;

    await loadParentOptions();
    document.getElementById('categoryParent').value = category.parent_id || '';

    categoryModal.show();
}

async function handleDelete(id) {
    if (!confirm('Bạn có chắc muốn xóa danh mục này?')) return;

    const success = await deleteCategory(id);
    if (success) {
        await renderCategories();
    }
}

// FORM SUBMIT
document.getElementById('formCategory')?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const formData = new FormData(e.target);

    // Validate
    if (!formData.get('name') || formData.get('name').trim() === '') {
        showToast('Vui lòng nhập tên danh mục', 'warning');
        return;
    }

    // Auto-generate slug if empty
    if (!formData.get('slug') || formData.get('slug').trim() === '') {
        const name = formData.get('name');
        formData.set('slug', slugify(name));
    }

    const success = await saveCategory(formData);

    if (success) {
        categoryModal.hide();
        await renderCategories();
    }
});

// Auto-generate slug from name
document.getElementById('categoryName')?.addEventListener('input', (e) => {
    const slugInput = document.getElementById('categorySlug');
    if (!slugInput.dataset.manualEdit) {
        slugInput.value = slugify(e.target.value);
    }
});

document.getElementById('categorySlug')?.addEventListener('input', (e) => {
    e.target.dataset.manualEdit = 'true';
});

// EVENT LISTENERS
document.getElementById('btnAddCategory')?.addEventListener('click', openAddModal);
document.getElementById('searchInput')?.addEventListener('input', renderCategories);

// Sidebar toggle for mobile
document.getElementById('btnToggleSidebar')?.addEventListener('click', () => {
    document.getElementById('sidebar')?.classList.toggle('show');
});

// INIT
document.addEventListener('DOMContentLoaded', async () => {
    console.log('Page loaded, initializing...');

    // Initialize modal
    const modalEl = document.getElementById('modalCategory');
    if (modalEl) {
        categoryModal = new bootstrap.Modal(modalEl);
        console.log('Modal initialized');
    } else {
        console.error('Modal element not found');
    }

    // Initial render
    await renderCategories();
});

// Make functions global for inline onclick
window.openEditModal = openEditModal;
window.handleDelete = handleDelete;