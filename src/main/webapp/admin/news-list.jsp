<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    com.japansport.model.User currentUser = (com.japansport.model.User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi" data-bs-theme="light">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Quản lý Tin tức • Japan Sport Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/admin/admin.css" rel="stylesheet">

    <style>
        .news-thumbnail {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            background: #f0f0f0;
        }
        .category-tag {
            font-size: 0.7rem;
            padding: 2px 6px;
            background: #e7f1ff;
            color: #0066cc;
            border-radius: 3px;
            margin-right: 4px;
        }
        .featured-star {
            color: #ffc107;
        }
    </style>
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
                <img src="https://coreui.io/images/brand/coreui-signet-white.svg" alt="" height="24" class="me-2">
                <span class="fw-semibold">JAPAN SPORT</span>
                <span class="badge bg-white text-primary ms-2">ADMIN</span>
            </a>
        </div>

        <form class="cui-search ms-lg-5 me-3 flex-grow-1 d-none d-md-block" role="search">
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-search"></i></span>
                <input id="globalSearch" class="form-control" placeholder="Tìm tin tức...">
            </div>
        </form>

        <ul class="cui-icons list-unstyled d-flex align-items-center mb-0 ms-auto">
            <li class="cui-icon">
                <a class="text-white position-relative" href="#"><i class="bi bi-bell fs-5"></i></a>
            </li>
            <li class="cui-sep" role="separator"></li>
            <li class="dropdown">
                <a class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" href="#"
                   data-bs-toggle="dropdown">
                    <span class="avatar-wrap position-relative">
                        <img src="${pageContext.request.contextPath}/admin/images/admin1.png"
                             class="rounded-circle" width="32" height="32" alt=""
                             onerror="this.src='https://ui-avatars.com/api/?name=<%= currentUser.getName() %>&background=5b57ea&color=fff'">
                        <span class="online"></span>
                    </span>
                    <span class="ms-2 d-none d-md-inline"><%= currentUser.getName() %></span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><h6 class="dropdown-header">Xin chào, <%= currentUser.getName() %>!</h6></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                    </a></li>
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
                    <i class="bi bi-speedometer2 me-2"></i>Dashboard
                </a></li>
            </ul>
            <div class="s-title">QUẢN LÝ</div>
            <ul class="s-nav">
                <li class="has-children">
                    <a class="s-item s-parent" href="#" onclick="return false;">
                        <span><i class="bi bi-box-seam me-2"></i>Sản phẩm</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav">
                        <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/products">
                            <i class="bi bi-list-ul me-2"></i>Quản lý sản phẩm
                        </a></li>
                        <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/categories">
                            <i class="bi bi-tags me-2"></i>Danh mục sản phẩm
                        </a></li>
                        <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/brand">
                            <i class="bi bi-badge-tm me-2"></i>Quản lý nhãn hàng
                        </a></li>
                    </ul>
                </li>
                <li class="has-children active">
                    <a class="s-item s-parent active" href="#" onclick="return false;">
                        <span><i class="bi bi-newspaper me-2"></i>Tin tức</span>
                        <i class="bi bi-chevron-down ms-auto small chev"></i>
                    </a>
                    <ul class="s-subnav" style="display: block;">
                        <li><a class="s-subitem active" href="${pageContext.request.contextPath}/admin/news">
                            <i class="bi bi-list-ul me-2"></i>Quản lý tin tức
                        </a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="flex-grow-1 p-3">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
                <li class="breadcrumb-item active">Quản lý Tin tức</li>
            </ol>
        </nav>

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="mb-0"><i class="bi bi-newspaper me-2"></i>Quản lý Tin tức</h2>
            <a href="${pageContext.request.contextPath}/admin/news?action=add" class="btn btn-primary">
                <i class="bi bi-plus-lg me-1"></i>Thêm tin mới
            </a>
        </div>

        <!-- Alerts -->
        <c:if test="${param.success == 'create'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>Thêm tin tức thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'update'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>Cập nhật tin tức thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'delete'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>Xóa tin tức thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">Ảnh</th>
                                <th>Tiêu đề</th>
                                <th style="width: 150px;">Danh mục</th>
                                <th style="width: 100px;">Tác giả</th>
                                <th style="width: 100px;">Trạng thái</th>
                                <th style="width: 80px;">Lượt xem</th>
                                <th style="width: 120px;">Ngày tạo</th>
                                <th style="width: 140px;" class="text-center">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="news" items="${newsList}">
                                <tr>
                                    <td>
                                        <img src="${news.thumbnailUrl}"
                                             alt="${news.title}"
                                             class="news-thumbnail"
                                             onerror="handleImageError(this)">
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <c:if test="${news.featured}">
                                                <i class="bi bi-star-fill featured-star"></i>
                                            </c:if>
                                            <div>
                                                <div class="fw-semibold">${news.title}</div>
                                                <small class="text-muted">${news.slug}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:forEach var="cat" items="${news.categories}">
                                            <span class="category-tag">${cat.name}</span>
                                        </c:forEach>
                                    </td>
                                    <td>${news.author}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${news.status == 'published'}">
                                                <span class="badge bg-success">Published</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Draft</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <i class="bi bi-eye text-muted"></i> ${news.viewCount}
                                    </td>
                                    <td>
                                        <small>${news.createdAt}</small>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/admin/news?action=edit&id=${news.id}"
                                               class="btn btn-outline-primary" title="Sửa">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/news/${news.slug}"
                                               class="btn btn-outline-info" target="_blank" title="Xem">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <button onclick="confirmDelete(${news.id}, '${news.title}')"
                                                    class="btn btn-outline-danger" title="Xóa">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty newsList}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                        <p>Chưa có tin tức nào</p>
                                        <a href="${pageContext.request.contextPath}/admin/news?action=add" class="btn btn-sm btn-primary">
                                            <i class="bi bi-plus-lg me-1"></i>Thêm tin đầu tiên
                                        </a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
const $ = (s) => document.querySelector(s);
$("#btnToggleSidebar")?.addEventListener("click", () => $("#sidebar")?.classList.add("show"));

// Search
$("#globalSearch")?.addEventListener("input", (e) => {
    const q = e.target.value.toLowerCase();
    document.querySelectorAll("tbody tr").forEach(tr => {
        tr.style.display = tr.textContent.toLowerCase().includes(q) ? "" : "none";
    });
});

// Xử lý lỗi hình ảnh an toàn - Tránh vòng lặp vô hạn
function handleImageError(img) {
    // Kiểm tra đã xử lý rồi không
    if (img.dataset.errorHandled === 'true') {
        return;
    }

    // Đánh dấu đã xử lý
    img.dataset.errorHandled = 'true';

    // Dùng SVG placeholder (không phụ thuộc URL bên ngoài)
    img.src = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="80" height="60"%3E%3Crect fill="%23f0f0f0" width="80" height="60"/%3E%3Ctext x="50%25" y="50%25" font-size="10" fill="%23999" text-anchor="middle" dominant-baseline="middle"%3ENo Image%3C/text%3E%3C/svg%3E';
}

function confirmDelete(id, title) {
    if (confirm('Bạn có chắc chắn muốn xóa tin tức "' + title + '"?')) {
        window.location.href = '${pageContext.request.contextPath}/admin/news?action=delete&id=' + id;
    }
}

// Auto-dismiss alerts after 5 seconds
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Clear URL params after showing alert to prevent reload loop
    if (window.location.search.includes('success') || window.location.search.includes('error')) {
        setTimeout(function() {
            const url = new URL(window.location);
            url.searchParams.delete('success');
            url.searchParams.delete('error');
            window.history.replaceState({}, document.title, url.pathname + url.search);
        }, 100);
    }
});
</script>

</body>
</html>