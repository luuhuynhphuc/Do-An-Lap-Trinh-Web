const API_URL = '/demo/admin/products';

function fmt(n) {
    return (n ?? 0).toLocaleString('vi-VN') + 'đ';
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

async function fetchProducts() {
    try {
        const response = await fetch(`${API_URL}?action=list`);
        if (!response.ok) {
            console.error('Response status:', response.status);
            throw new Error('Network response was not ok');
        }
        const data = await response.json();
        console.log('Fetched products:', data);
        return data;
    } catch (error) {
        console.error('Error fetching products:', error);
        showToast('Lỗi khi tải danh sách sản phẩm', 'danger');
        return [];
    }
}

async function fetchCategories() {
    try {
        const response = await fetch(`${API_URL}?action=categories`);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error('Error fetching categories:', error);
        return [];
    }
}

async function fetchBrands() {
    try {
        const response = await fetch(`${API_URL}?action=brands`);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error('Error fetching brands:', error);
        return [];
    }
}

async function saveProduct(formData, isUpdate = false) {
    try {
        const action = formData.get('action');
        const id = formData.get('id');

        console.log('=== SAVING PRODUCT ===');
        console.log('Action:', action);
        console.log('ID:', id);
        console.log('Name:', formData.get('name'));
        console.log('Price:', formData.get('price'));

        // Debug: In ra tất cả các field trong FormData
        console.log('All form fields:');
        for (let [key, value] of formData.entries()) {
            console.log(`  ${key}: ${value}`);
        }

        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        console.log('Response status:', response.status);

        const result = await response.json();
        console.log('Server response:', result);

        if (result.success) {
            showToast(result.message || 'Lưu sản phẩm thành công', 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi lưu sản phẩm', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error saving product:', error);
        showToast('Lỗi kết nối server: ' + error.message, 'danger');
        return false;
    }
}

async function deleteProduct(id) {
    try {
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('id', id);

        console.log('Deleting product:', id);

        const response = await fetch(`${API_URL}`, {
            method: 'POST',
            body: formData
        });

        console.log('Delete response status:', response.status);

        const result = await response.json();
        console.log('Delete result:', result);

        if (result.success) {
            showToast(result.message || 'Xóa sản phẩm thành công', 'success');
            return true;
        } else {
            showToast(result.message || 'Lỗi khi xóa sản phẩm', 'danger');
            return false;
        }
    } catch (error) {
        console.error('Error deleting product:', error);
        showToast('Lỗi kết nối server: ' + error.message, 'danger');
        return false;
    }
}

let allProducts = [];
let allCategories = [];
let allBrands = [];
let productModal = null;
let editingProductId = null;

async function renderProducts() {
    const tbody = document.querySelector('#tblProducts tbody');
    if (!tbody) {
        console.error('Table body not found');
        return;
    }

    allProducts = await fetchProducts();
    const searchQuery = document.getElementById('searchInput')?.value.toLowerCase() || '';

    const filtered = allProducts.filter(prod => {
        const searchText = prod.name.toLowerCase();
        return searchText.includes(searchQuery);
    });

    tbody.innerHTML = '';

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" class="text-center py-4">Không có dữ liệu</td></tr>';
        return;
    }

    filtered.forEach(prod => {
        // Tìm tên category
        const category = allCategories.find(c => c.id === prod.categoryId);
        const categoryName = category ? category.name : '-';

        // Tìm tên brand
        const brandName = prod.brand ? prod.brand.name : '-';

        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${prod.id}</td>
            <td>
                ${prod.image_url
                    ? `<img src="${prod.image_url}" alt="" class="thumb" style="width:50px;height:50px;object-fit:cover;border-radius:8px;">`
                    : '<span class="text-muted">-</span>'}
            </td>
            <td>${prod.name}</td>
            <td>${categoryName}</td>
            <td>${brandName}</td>
            <td>${fmt(prod.price)}</td>
            <td>${prod.old_price > 0 ? fmt(prod.old_price) : '-'}</td>
            <td>${prod.gender || '-'}</td>
            <td class="text-end">
                <button class="btn btn-sm btn-outline-secondary me-1" onclick="openEditModal(${prod.id})">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger" onclick="handleDelete(${prod.id})">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

async function openAddModal() {
    editingProductId = null;
    document.getElementById('modalTitle').textContent = 'Thêm sản phẩm';

    // Reset form
    const form = document.getElementById('formProduct');
    form.reset();

    // Set action và clear ID
    document.getElementById('formAction').value = 'add';
    document.getElementById('productId').value = '';
    document.getElementById('imagePreview').style.display = 'none';

    // Load categories & brands vào dropdown
    await loadDropdowns();

    productModal.show();
}

async function openEditModal(id) {
    const product = allProducts.find(p => p.id === id);
    if (!product) {
        console.error('Product not found:', id);
        showToast('Không tìm thấy sản phẩm', 'danger');
        return;
    }

    editingProductId = id;
    document.getElementById('modalTitle').textContent = 'Sửa sản phẩm';

    // Set action TRƯỚC KHI set các giá trị khác
    document.getElementById('formAction').value = 'update';
    document.getElementById('productId').value = product.id;

    // Điền dữ liệu vào form
    document.getElementById('productName').value = product.name;
    document.getElementById('productPrice').value = product.price;
    document.getElementById('productOldPrice').value = product.old_price || '';
    document.getElementById('productGender').value = product.gender || '';
    document.getElementById('productImage').value = product.image_url || '';

    // Load categories & brands
    await loadDropdowns();

    // Set selected values
    document.getElementById('productCategory').value = product.categoryId || '';
    document.getElementById('productBrand').value = product.brandId || '';

    // Preview image
    if (product.image_url) {
        document.getElementById('previewImg').src = product.image_url;
        document.getElementById('imagePreview').style.display = 'block';
    } else {
        document.getElementById('imagePreview').style.display = 'none';
    }

    productModal.show();
}

async function handleDelete(id) {
    if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) return;

    const success = await deleteProduct(id);
    if (success) {
        await renderProducts();
    }
}

async function loadDropdowns() {
    // Load categories
    const catSelect = document.getElementById('productCategory');
    if (catSelect) {
        catSelect.innerHTML = '<option value="">-- Chọn danh mục --</option>';
        allCategories.forEach(cat => {
            const option = document.createElement('option');
            option.value = cat.id;
            option.textContent = cat.name;
            catSelect.appendChild(option);
        });
    }

    // Load brands
    const brandSelect = document.getElementById('productBrand');
    if (brandSelect) {
        brandSelect.innerHTML = '<option value="">-- Chọn thương hiệu --</option>';
        allBrands.forEach(brand => {
            const option = document.createElement('option');
            option.value = brand.id;
            option.textContent = brand.name;
            brandSelect.appendChild(option);
        });
    }
}

// FORM SUBMIT - ĐÂY LÀ PHẦN QUAN TRỌNG NHẤT
document.getElementById('formProduct')?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const form = e.target;
    const formData = new FormData(form);

    // Validate
    if (!formData.get('name') || formData.get('name').trim() === '') {
        showToast('Vui lòng nhập tên sản phẩm', 'warning');
        return;
    }

    if (!formData.get('price') || parseFloat(formData.get('price')) <= 0) {
        showToast('Vui lòng nhập giá hợp lệ', 'warning');
        return;
    }

    // KIỂM TRA ACTION - đây là phần quan trọng
    let action = formData.get('action');

    console.log('=== FORM SUBMIT ===');
    console.log('Action from form:', action);
    console.log('ID from form:', formData.get('id'));

    // Nếu không có action trong FormData, lấy từ hidden input
    if (!action) {
        action = document.getElementById('formAction').value;
        formData.append('action', action);
        console.log('Action was missing, added from hidden input:', action);
    }

    if (!action) {
        showToast('Lỗi: Không xác định được hành động', 'danger');
        console.error('No action found in form!');
        return;
    }

    const success = await saveProduct(formData);

    if (success) {
        productModal.hide();
        await renderProducts();
    }
});

// Image preview
document.getElementById('productImage')?.addEventListener('input', (e) => {
    const url = e.target.value;
    if (url) {
        document.getElementById('previewImg').src = url;
        document.getElementById('imagePreview').style.display = 'block';
    } else {
        document.getElementById('imagePreview').style.display = 'none';
    }
});

// EVENT LISTENERS
document.getElementById('btnAddProduct')?.addEventListener('click', openAddModal);
document.getElementById('searchInput')?.addEventListener('input', renderProducts);

// Sidebar toggle for mobile
document.getElementById('btnToggleSidebar')?.addEventListener('click', () => {
    document.getElementById('sidebar')?.classList.toggle('show');
});

// INIT
document.addEventListener('DOMContentLoaded', async () => {
    console.log('Page loaded, initializing...');

    // Initialize modal
    const modalEl = document.getElementById('modalProduct');
    if (modalEl) {
        productModal = new bootstrap.Modal(modalEl);
        console.log('Modal initialized');
    } else {
        console.error('Modal element not found');
    }

    // Load initial data
    allCategories = await fetchCategories();
    allBrands = await fetchBrands();
    console.log('Loaded categories:', allCategories.length);
    console.log('Loaded brands:', allBrands.length);

    // Initial render
    await renderProducts();
});

// Make functions global for inline onclick
window.openEditModal = openEditModal;
window.handleDelete = handleDelete;