<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tin tức - GIÀY NHẬT CHÍNH HÃNG</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/style.css">

    <style>
        .news-card {
            transition: transform 0.3s, box-shadow 0.3s;
            border: none;
            height: 100%;
        }
        .news-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        .news-thumbnail {
            height: 200px;
            object-fit: cover;
            background: #f0f0f0;
        }
        .news-category {
            display: inline-block;
            padding: 4px 10px;
            background: #0066cc;
            color: white;
            font-size: 0.75rem;
            border-radius: 3px;
            text-decoration: none;
            margin-right: 5px;
        }
        .news-category:hover {
            background: #0052a3;
            color: white;
        }
        .news-meta {
            color: #6c757d;
            font-size: 0.875rem;
        }
        .featured-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255, 193, 7, 0.9);
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        .sidebar-news-item {
            border-bottom: 1px solid #dee2e6;
            padding: 12px 0;
        }
        .sidebar-news-item:last-child {
            border-bottom: none;
        }
        .sidebar-news-thumb {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            background: #f0f0f0;
        }
    </style>
</head>
<body>

<!-- HEADER -->
<header class="bg-white shadow-sm mb-4">
    <div class="container">
        <nav class="navbar navbar-expand-lg navbar-light">
            <a class="navbar-brand" href="${ctx}/home">
                <img src="${ctx}/assets/images/logo.webp" alt="Japan Sport" height="50">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/home">
                            <i class="bi bi-house-door"></i> Trang chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${ctx}/news">
                            <i class="bi bi-newspaper"></i> Tin tức
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/list-product">
                            <i class="bi bi-box-seam"></i> Sản phẩm
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
    </div>
</header>

<!-- BREADCRUMB -->
<section class="bg-light py-3">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${ctx}/home">Trang chủ</a></li>
                <li class="breadcrumb-item active">Tin tức</li>
            </ol>
        </nav>
    </div>
</section>

<!-- MAIN CONTENT -->
<section class="py-5">
    <div class="container">
        <div class="row">
            <!-- Left Column - News List -->
            <div class="col-lg-8">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold">
                        <i class="bi bi-newspaper me-2"></i>
                        <c:choose>
                            <c:when test="${not empty currentCategory}">
                                ${currentCategory.name}
                            </c:when>
                            <c:when test="${not empty keyword}">
                                Kết quả tìm kiếm: "${keyword}"
                            </c:when>
                            <c:otherwise>
                                Tin tức mới nhất
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <c:if test="${not empty newsList}">
                        <span class="text-muted">${fn:length(newsList)} bài viết</span>
                    </c:if>
                </div>

                <!-- News Grid -->
                <div class="row g-4">
                    <c:forEach var="news" items="${newsList}">
                        <div class="col-md-6">
                            <div class="card news-card shadow-sm">
                                <div class="position-relative">
                                    <a href="${ctx}/news/${news.slug}">
                                        <img src="${news.thumbnailUrl}"
                                             class="card-img-top news-thumbnail"
                                             alt="${news.title}"
                                             onerror="handleImageError(this)">
                                    </a>
                                    <c:if test="${news.featured}">
                                        <span class="featured-badge">
                                            <i class="bi bi-star-fill"></i> Nổi bật
                                        </span>
                                    </c:if>
                                </div>
                                <div class="card-body">
                                    <!-- Categories -->
                                    <div class="mb-2">
                                        <c:forEach var="cat" items="${news.categories}">
                                            <a href="${ctx}/news?category=${cat.slug}" class="news-category">
                                                ${cat.name}
                                            </a>
                                        </c:forEach>
                                    </div>

                                    <!-- Title -->
                                    <h5 class="card-title">
                                        <a href="${ctx}/news/${news.slug}"
                                           class="text-dark text-decoration-none fw-bold">
                                            ${news.title}
                                        </a>
                                    </h5>

                                    <!-- Summary -->
                                    <p class="card-text text-muted">
                                        ${fn:substring(news.summary, 0, 120)}...
                                    </p>

                                    <!-- Meta -->
                                    <div class="d-flex justify-content-between align-items-center news-meta">
                                        <small>
                                            <i class="bi bi-person"></i> ${news.author}
                                        </small>
                                        <small>
                                            <i class="bi bi-eye"></i> ${news.viewCount}
                                        </small>
                                        <small>
                                            <i class="bi bi-calendar"></i>
                                            ${fn:substring(news.createdAt, 0, 10)}
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty newsList}">
                        <div class="col-12 text-center py-5">
                            <i class="bi bi-inbox fs-1 text-muted d-block mb-3"></i>
                            <p class="text-muted fs-5">Không tìm thấy tin tức nào</p>
                            <a href="${ctx}/news" class="btn btn-primary">
                                <i class="bi bi-arrow-left me-2"></i>Quay lại tất cả tin tức
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Right Sidebar -->
            <div class="col-lg-4">
                <!-- Search Box -->
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="card-title mb-3">
                            <i class="bi bi-search me-2"></i>Tìm kiếm
                        </h5>
                        <form method="get" action="${ctx}/news">
                            <div class="input-group">
                                <input type="text"
                                       class="form-control"
                                       name="keyword"
                                       placeholder="Tìm tin tức..."
                                       value="${keyword}">
                                <button class="btn btn-primary" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Categories -->
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="card-title mb-3">
                            <i class="bi bi-folder me-2"></i>Danh mục
                        </h5>
                        <div class="list-group list-group-flush">
                            <a href="${ctx}/news"
                               class="list-group-item list-group-item-action ${empty param.category ? 'active' : ''}">
                                <i class="bi bi-grid me-2"></i>Tất cả
                            </a>
                            <c:forEach var="cat" items="${categories}">
                                <a href="${ctx}/news?category=${cat.slug}"
                                   class="list-group-item list-group-item-action ${param.category == cat.slug ? 'active' : ''}">
                                    <i class="bi bi-tag me-2"></i>${cat.name}
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Featured News -->
                <c:if test="${not empty featuredNews}">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title mb-3">
                                <i class="bi bi-star me-2"></i>Tin nổi bật
                            </h5>
                            <c:forEach var="featured" items="${featuredNews}">
                                <div class="sidebar-news-item">
                                    <div class="d-flex gap-3">
                                        <img src="${featured.thumbnailUrl}"
                                             class="sidebar-news-thumb"
                                             alt="${featured.title}"
                                             onerror="handleImageError(this)">
                                        <div class="flex-grow-1">
                                            <a href="${ctx}/news/${featured.slug}"
                                               class="text-dark text-decoration-none fw-semibold d-block mb-1"
                                               style="font-size: 0.9rem;">
                                                ${fn:substring(featured.title, 0, 60)}...
                                            </a>
                                            <small class="text-muted">
                                                <i class="bi bi-calendar"></i>
                                                ${fn:substring(featured.createdAt, 0, 10)}
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="bg-dark text-white mt-5 py-4">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h5 class="text-uppercase mb-3">Japan Sport</h5>
                <p class="text-muted">Chuyên cung cấp giày thể thao chính hãng từ Nhật Bản</p>
            </div>
            <div class="col-md-6 text-md-end">
                <h6 class="mb-3">Liên kết nhanh</h6>
                <ul class="list-unstyled">
                    <li><a href="${ctx}/home" class="text-white text-decoration-none">Trang chủ</a></li>
                    <li><a href="${ctx}/news" class="text-white text-decoration-none">Tin tức</a></li>
                    <li><a href="${ctx}/list-product" class="text-white text-decoration-none">Sản phẩm</a></li>
                </ul>
            </div>
        </div>
        <hr class="border-secondary my-4">
        <div class="text-center text-muted">
            <p class="mb-0">© 2025 Japan Sport. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Xử lý lỗi hình ảnh an toàn - Tránh vòng lặp vô hạn
function handleImageError(img) {
    // Kiểm tra đã xử lý rồi không
    if (img.dataset.errorHandled === 'true') {
        return;
    }

    // Đánh dấu đã xử lý
    img.dataset.errorHandled = 'true';

    // Dùng SVG placeholder (không phụ thuộc URL bên ngoài)
    img.src = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="400" height="300"%3E%3Crect fill="%23f0f0f0" width="400" height="300"/%3E%3Ctext x="50%25" y="50%25" font-size="16" fill="%23999" text-anchor="middle" dominant-baseline="middle"%3ENo Image%3C/text%3E%3C/svg%3E';
}
</script>

</body>
</html>