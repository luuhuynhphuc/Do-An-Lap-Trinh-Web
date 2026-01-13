<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${news.title} - GIÀY NHẬT CHÍNH HÃNG</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/style.css">

    <style>
        .news-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
        }
        .news-category-badge {
            display: inline-block;
            padding: 6px 14px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            margin-right: 8px;
            font-size: 0.875rem;
        }
        .news-meta-info {
            display: flex;
            gap: 20px;
            margin-top: 1.5rem;
            font-size: 0.95rem;
        }
        .news-meta-info span {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .news-thumbnail-main {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 8px;
            margin: 2rem 0;
            background: #f0f0f0;
        }
        .news-content {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #2d3748;
        }
        .news-content img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            margin: 1.5rem 0;
        }
        .news-content h2,
        .news-content h3 {
            margin-top: 2rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }
        .news-content p {
            margin-bottom: 1.2rem;
        }
        .share-buttons {
            display: flex;
            gap: 10px;
            margin: 2rem 0;
            flex-wrap: wrap;
        }
        .share-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: transform 0.2s;
        }
        .share-btn:hover {
            transform: translateY(-2px);
            color: white;
        }
        .share-btn.facebook { background: #1877f2; }
        .share-btn.twitter { background: #1da1f2; }
        .share-btn.linkedin { background: #0a66c2; }
        .related-news-card {
            transition: transform 0.3s;
        }
        .related-news-card:hover {
            transform: translateY(-5px);
        }
        .related-news-thumb {
            height: 180px;
            object-fit: cover;
            background: #f0f0f0;
        }
        .sidebar-widget {
            position: sticky;
            top: 20px;
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
<header class="bg-white shadow-sm">
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

<!-- NEWS HEADER -->
<section class="news-header">
    <div class="container">
        <!-- Categories -->
        <div class="mb-3">
            <c:forEach var="cat" items="${news.categories}">
                <span class="news-category-badge">${cat.name}</span>
            </c:forEach>
        </div>

        <!-- Title -->
        <h1 class="display-5 fw-bold mb-3">${news.title}</h1>

        <!-- Summary -->
        <p class="lead mb-0">${news.summary}</p>

        <!-- Meta Info -->
        <div class="news-meta-info">
            <span>
                <i class="bi bi-person-circle"></i>
                <strong>${news.author}</strong>
            </span>
            <span>
                <i class="bi bi-calendar3"></i>
                ${fn:substring(news.createdAt, 0, 10)}
            </span>
            <span>
                <i class="bi bi-eye"></i>
                ${news.viewCount} lượt xem
            </span>
        </div>
    </div>
</section>

<!-- BREADCRUMB -->
<section class="bg-light py-3">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${ctx}/home">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${ctx}/news">Tin tức</a></li>
                <li class="breadcrumb-item active">${fn:substring(news.title, 0, 50)}...</li>
            </ol>
        </nav>
    </div>
</section>

<!-- MAIN CONTENT -->
<section class="py-5">
    <div class="container">
        <div class="row">
            <!-- Main Content -->
            <div class="col-lg-8">
                <!-- Thumbnail -->
                <c:if test="${not empty news.thumbnailUrl}">
                    <img src="${news.thumbnailUrl}"
                         class="news-thumbnail-main"
                         alt="${news.title}"
                         onerror="handleImageError(this)">
                </c:if>

                <!-- Content -->
                <article class="news-content">
                    ${news.content}
                </article>

                <!-- Share Buttons -->
                <div class="share-buttons">
                    <strong class="w-100 mb-2 d-block">Chia sẻ bài viết:</strong>
                    <a href="https://www.facebook.com/sharer/sharer.php?u=${pageContext.request.requestURL}"
                       target="_blank"
                       class="share-btn facebook">
                        <i class="bi bi-facebook"></i> Facebook
                    </a>
                    <a href="https://twitter.com/intent/tweet?url=${pageContext.request.requestURL}&text=${news.title}"
                       target="_blank"
                       class="share-btn twitter">
                        <i class="bi bi-twitter"></i> Twitter
                    </a>
                    <a href="https://www.linkedin.com/sharing/share-offsite/?url=${pageContext.request.requestURL}"
                       target="_blank"
                       class="share-btn linkedin">
                        <i class="bi bi-linkedin"></i> LinkedIn
                    </a>
                </div>

                <hr class="my-5">

                <!-- Related News -->
                <c:if test="${not empty relatedNews}">
                    <h3 class="fw-bold mb-4">
                        <i class="bi bi-grid-3x3-gap me-2"></i>Tin liên quan
                    </h3>
                    <div class="row g-4">
                        <c:forEach var="related" items="${relatedNews}">
                            <div class="col-md-6">
                                <div class="card related-news-card shadow-sm h-100">
                                    <a href="${ctx}/news/${related.slug}">
                                        <img src="${related.thumbnailUrl}"
                                             class="card-img-top related-news-thumb"
                                             alt="${related.title}"
                                             onerror="handleImageError(this)">
                                    </a>
                                    <div class="card-body">
                                        <h5 class="card-title">
                                            <a href="${ctx}/news/${related.slug}"
                                               class="text-dark text-decoration-none">
                                                ${related.title}
                                            </a>
                                        </h5>
                                        <p class="card-text text-muted small">
                                            ${fn:substring(related.summary, 0, 100)}...
                                        </p>
                                        <div class="text-muted small">
                                            <i class="bi bi-calendar"></i>
                                            ${fn:substring(related.createdAt, 0, 10)}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <div class="sidebar-widget">
                    <!-- Featured News -->
                    <c:if test="${not empty featuredNews}">
                        <div class="card shadow-sm mb-4">
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

                    <!-- Back to List -->
                    <div class="card shadow-sm">
                        <div class="card-body text-center">
                            <a href="${ctx}/news" class="btn btn-outline-primary btn-lg w-100">
                                <i class="bi bi-arrow-left me-2"></i>Quay lại danh sách
                            </a>
                        </div>
                    </div>
                </div>
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