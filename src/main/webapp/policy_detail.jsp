<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${policy.title} - Japan Sport</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">

    <style>
        .policy-content {
            line-height: 1.8;
        }
        .policy-content h3 {
            margin-top: 2rem;
            margin-bottom: 1rem;
            color: #2c3e50;
        }
        .policy-content p {
            margin-bottom: 1rem;
        }
        .policy-content ul, .policy-content ol {
            margin-bottom: 1rem;
            padding-left: 2rem;
        }
        .policy-content li {
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>

<!-- Header -->
<header class="bg-white shadow-sm mb-4">
    <div class="container">
        <nav class="navbar navbar-expand-lg navbar-light">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <strong>Japan Sport</strong>
            </a>
        </nav>
    </div>
</header>

<main class="container my-5">
    <div class="row">
        <div class="col-lg-8 mx-auto">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/policies">Chính sách</a></li>
                    <li class="breadcrumb-item active">${policy.title}</li>
                </ol>
            </nav>

            <div class="card shadow-sm">
                <div class="card-body p-4 p-md-5">
                    <h1 class="mb-4">
                        <i class="bi bi-shield-check text-primary me-2"></i>
                        ${policy.title}
                    </h1>

                    <div class="policy-content">
                        ${policy.content}
                    </div>

                    <hr class="my-4">

                    <div class="d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/policies" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-2"></i>Quay lại
                        </a>

                        <div class="text-muted small">
                            <i class="bi bi-clock me-1"></i>
                            Cập nhật lần cuối: <span id="lastUpdate">Đang tải...</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contact Support -->
            <div class="card mt-4 bg-light">
                <div class="card-body text-center">
                    <h5 class="mb-3">Cần hỗ trợ thêm?</h5>
                    <p class="text-muted mb-3">
                        Nếu bạn có thắc mắc về chính sách này, vui lòng liên hệ với chúng tôi
                    </p>
                    <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary">
                        <i class="bi bi-headset me-2"></i>Liên hệ hỗ trợ
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-dark text-white mt-5 py-4">
    <div class="container text-center">
        <p class="mb-0">© 2025 Japan Sport</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Format last update date (optional)
    document.addEventListener('DOMContentLoaded', () => {
        const updateEl = document.getElementById('lastUpdate');
        if (updateEl) {
            const now = new Date();
            updateEl.textContent = now.toLocaleDateString('vi-VN');
        }
    });
</script>
</body>
</html>