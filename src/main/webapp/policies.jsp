<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chính sách - Japan Sport</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
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
        <div class="col-12">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                    <li class="breadcrumb-item active">Chính sách</li>
                </ol>
            </nav>

            <h2 class="mb-4">Chính sách của Japan Sport</h2>

            <c:if test="${empty policies}">
                <div class="alert alert-info">
                    Hiện chưa có chính sách nào được công bố.
                </div>
            </c:if>

            <div class="row g-4">
                <c:forEach items="${policies}" var="policy">
                    <div class="col-md-6">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <i class="bi bi-shield-check text-primary me-2"></i>
                                    ${policy.title}
                                </h5>
                                <p class="card-text text-muted">
                                    <c:choose>
                                        <c:when test="${policy.policyType == 'shipping'}">
                                            Thông tin về vận chuyển và giao hàng
                                        </c:when>
                                        <c:when test="${policy.policyType == 'return'}">
                                            Điều kiện và quy trình đổi trả hàng
                                        </c:when>
                                        <c:when test="${policy.policyType == 'payment'}">
                                            Hình thức thanh toán và bảo mật
                                        </c:when>
                                        <c:when test="${policy.policyType == 'privacy'}">
                                            Cam kết bảo mật thông tin khách hàng
                                        </c:when>
                                        <c:otherwise>
                                            Thông tin chính sách
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <a href="${pageContext.request.contextPath}/policy?slug=${policy.slug}"
                                   class="btn btn-outline-primary">
                                    Xem chi tiết <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
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
</body>
</html>