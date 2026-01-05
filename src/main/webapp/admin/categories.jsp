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
                <input id="categorySearch" class="form-control" placeholder="Tìm tên/slug..." style="max-width:260px">
                <button id="btnAddCategory" class="btn btn-primary">
                    <i class="bi bi-plus-lg me-1"></i>Thêm danh mục
                </button>
            </div>
        </div>

        <!-- Alert messages -->
        <div id="alertContainer"></div>

        <!-- Table -->
        <div class="card">
            <div class="table-responsive">
                <table class="table align-middle table-hover mb-0" id="tblCategories">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 80px">ID</th>
                            <th>Tên</th>
                            <th>Slug</th>
                            <th>Danh mục cha</th>
                            <th style="width: 100px">Thứ tự</th>
                            <th style="width: 100px">Nổi bật</th>
                            <th style="width: 100px">Trạng thái</th>
                            <th style="width: 120px" class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody id="categoryTableBody">
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
                        <label for="categoryImage" class="form-label">Ảnh (URL)</label>
                        <input type="url" class="form-control" id="categoryImage" name="image_url"
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
                <button type="submit" class="btn btn-primary" id="btnSaveCategory">
                    <i class="bi bi-check-lg me-1"></i>Lưu
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Category Management Script -->
<script>
const API_URL = '${pageContext.request.contextPath}/admin/categories';
let categoryModal;
let editingCategoryId = null;
let allCategories = [];

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    categoryModal = new bootstrap.Modal(document.getElementById('modalCategory'));

    // Load categories
    loadCategories();

    // Event listeners
    document.getElementById('btnAddCategory').addEventListener('click', () => openModal());
    document.getElementById('formCategory').addEventListener('submit', handleSubmit);
    document.getElementById('categorySearch').addEventListener('input', handleSearch);

    // Auto-generate slug from name
    document.getElementById('categoryName').addEventListener('input', function() {
        const slugInput = document.getElementById('categorySlug');
        if (!slugInput.dataset.manualEdit) {
            slugInput.value = generateSlug(this.value);
        }
    });

    document.getElementById('categorySlug').addEventListener('input', function() {
        this.dataset.manualEdit = this.value ? 'true' : '';
    });
});

// Load categories from server
async function loadCategories() {
    try {
        const response = await fetch(API_URL + '?action=getAll');
        if (!response.ok) throw new Error('Network response was not ok');

        allCategories = await response.json();
        renderCategories(allCategories);
        loadParentOptions();

    } catch (error) {
        console.error('Error loading categories:', error);
        showAlert('Lỗi khi tải danh sách danh mục', 'danger');
        document.getElementById('categoryTableBody').innerHTML =
            '<tr><td colspan="8" class="text-center text-danger">Lỗi khi tải dữ liệu</td></tr>';
    }
}

// Render categories table
function renderCategories(categories) {
    const tbody = document.getElementById('categoryTableBody');

    if (categories.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">Chưa có danh mục nào</td></tr>';
        return;
    }

    tbody.innerHTML = categories.map(cat => {
        const parentName = cat.parent_id ?
            (allCategories.find(c => c.id === cat.parent_id)?.name || 'N/A') :
            '<span class="text-muted">-</span>';

        const featuredBadge = cat.is_featured === 1 ?
            '<span class="badge bg-warning text-dark">Nổi bật</span>' :
            '<span class="badge bg-secondary">Thường</span>';

        const activeBadge = cat.active === 1 ?
            '<span class="badge bg-success">Hiển thị</span>' :
            '<span class="badge bg-secondary">Ẩn</span>';

        return `
            <tr>
                <td>${cat.id}</td>
                <td>${cat.name}</td>
                <td><code>${cat.slug}</code></td>
                <td>${parentName}</td>
                <td class="text-center">${cat.display_order}</td>
                <td>${featuredBadge}</td>
                <td>${activeBadge}</td>
                <td class="text-end">
                    <button class="btn btn-sm btn-outline-secondary me-1" onclick="openModal(${cat.id})">
                        <i class="bi bi-pencil"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-danger" onclick="deleteCategory(${cat.id})">
                        <i class="bi bi-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

// Load parent category options
function loadParentOptions() {
    const select = document.getElementById('categoryParent');
    const currentValue = select.value;

    const parentCategories = allCategories.filter(cat => cat.parent_id === null || cat.parent_id === 0);

    select.innerHTML = '<option value="">-- Không có (Danh mục gốc) --</option>' +
        parentCategories.map(cat => `<option value="${cat.id}">${cat.name}</option>`).join('');

    if (currentValue) {
        select.value = currentValue;
    }
}

// Open modal (add or edit)
async function openModal(categoryId = null) {
    editingCategoryId = categoryId;
    const form = document.getElementById('formCategory');
    form.reset();
    delete document.getElementById('categorySlug').dataset.manualEdit;

    if (categoryId) {
        // Edit mode
        document.getElementById('modalTitle').textContent = 'Sửa danh mục';

        try {
            const response = await fetch(API_URL + '?action=getById&id=' + categoryId);
            if (!response.ok) throw new Error('Failed to load category');

            const category = await response.json();

            document.getElementById('categoryId').value = category.id;
            document.getElementById('categoryName').value = category.name;
            document.getElementById('categorySlug').value = category.slug;
            document.getElementById('categoryOrder').value = category.display_order;
            document.getElementById('categoryParent').value = category.parent_id || '';
            document.getElementById('categoryFeatured').value = category.is_featured;
            document.getElementById('categoryActive').value = category.active;
            document.getElementById('categoryImage').value = category.image_url || '';
            document.getElementById('categoryLink').value = category.link || '';

        } catch (error) {
            console.error('Error loading category:', error);
            showAlert('Lỗi khi tải thông tin danh mục', 'danger');
            return;
        }
    } else {
        // Add mode
        document.getElementById('modalTitle').textContent = 'Thêm danh mục';
        document.getElementById('categoryActive').value = '1';
        document.getElementById('categoryFeatured').value = '0';
    }

    categoryModal.show();
}

// Handle form submit
async function handleSubmit(e) {
    e.preventDefault();

    const formData = new FormData(e.target);
    const action = editingCategoryId ? 'update' : 'create';

    if (editingCategoryId) {
        formData.append('id', editingCategoryId);
    }

    formData.append('action', action);

    try {
        const response = await fetch(API_URL, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        if (result.success) {
            showAlert(result.message, 'success');
            categoryModal.hide();
            loadCategories();
        } else {
            showAlert(result.message, 'danger');
        }

    } catch (error) {
        console.error('Error saving category:', error);
        showAlert('Lỗi khi lưu danh mục', 'danger');
    }
}

// Delete category
async function deleteCategory(id) {
    if (!confirm('Bạn có chắc chắn muốn xóa danh mục này?')) return;

    try {
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('id', id);

        const response = await fetch(API_URL, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        if (result.success) {
            showAlert(result.message, 'success');
            loadCategories();
        } else {
            showAlert(result.message, 'danger');
        }

    } catch (error) {
        console.error('Error deleting category:', error);
        showAlert('Lỗi khi xóa danh mục', 'danger');
    }
}

// Search categories
function handleSearch(e) {
    const query = e.target.value.toLowerCase();

    const filtered = allCategories.filter(cat =>
        cat.name.toLowerCase().includes(query) ||
        cat.slug.toLowerCase().includes(query) ||
        cat.id.toString().includes(query)
    );

    renderCategories(filtered);
}

// Generate slug from text
function generateSlug(text) {
    return text
        .toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .replace(/đ/g, 'd')
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/(^-|-$)/g, '');
}

// Show alert message
function showAlert(message, type = 'info') {
    const container = document.getElementById('alertContainer');
    const alert = document.createElement('div');
    alert.className = `alert alert-${type} alert-dismissible fade show`;
    alert.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    container.appendChild(alert);

    setTimeout(() => alert.remove(), 5000);
}
</script>

</body>
</html>