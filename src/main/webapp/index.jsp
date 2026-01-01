<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%
    String ctx = request.getContextPath();
    if (request.getAttribute("productList") == null &&
            request.getAttribute("bestSellerProducts") == null) {
        response.sendRedirect(ctx + "/home");
        return;
    }
%>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>GIÀY NHẬT CHÍNH HÃNG - Trang chủ</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <!-- App CSS -->
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
<%----%>
<!-- PROMO TOP BANNER (động) -->
<c:if test="${not empty topBanners}">
    <div class="topbar section hidden-xs hidden-sm">
        <c:forEach var="b" items="${topBanners}">
            <a class="section block a-center"
               href="${empty b.link ? '#' : b.link}">
                <img src="${b.image_url}" alt="${b.title}"
                     style="width:100%;height:auto;display:flex;">
            </a>
        </c:forEach>
    </div>
</c:if>

<!-- HEADER -->
<header class="bg-white py-3">
    <div class="container">
        <div class="row g-3 align-items-center">
            <!-- logo -->
            <div class="col-lg-3 col-md-4">
                <div class="d-flex align-items-center">
                    <a href="index.jsp">
                        <img src="assets/images/logo.webp" alt="JapanSport" class="logo-header me-2">
                    </a>
                </div>
            </div>

            <!-- search -->
            <div class="col-lg-5 col-md-4">
                <form class="search-container" method="get" action="<%= ctx %>/list-product">
                    <input class="form-control search-input"
                           type="search"
                           name="keyword"
                           placeholder="Tìm kiếm…"
                           value="${param.keyword}"
                           aria-label="Ô tìm kiếm">
                    <button class="search-btn" type="submit" aria-label="Tìm">
                        <i class="bi bi-search"></i>
                    </button>
                </form>
            </div>

            <!-- hotline + icons -->
            <div class="col-lg-4 col-md-4">
                <div class="d-flex justify-content-end align-items-center gap-2">
                    <a href="tel:0984843218" class="btn btn-outline-danger rounded-pill px-3 d-none d-lg-inline">
                        Tư vấn bán hàng <strong class="ms-2">0984843218</strong>
                    </a>
                    <button class="btn header-icon-btn" title="Gọi"><i class="bi bi-telephone"></i></button>
                    <!--login icon-->
                    <button class="btn header-icon-btn" data-bs-toggle="tooltip" title="Tài khoản"
                            aria-label="Tài khoản">
                        <a href="login.jsp"><i class="bi bi-person"></i></a>
                    </button>
                    <!--cart icon-->
                    <a href="cart.jsp" data-bs-toggle="tooltip" title="Giỏ hàng"
                       class="position-relative header-icon-btn d-flex align-items-center justify-content-center">
                        <i class="bi bi-bag fs-5"></i>
                        <span id="cartCount"
                              class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">0
                        </span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</header>


<!-- NAVBAR (ĐỘNG theo DB: categories, brands) -->
<nav class="navbar navbar-expand-lg navbar-custom navbar-dark">
    <div class="container">
        <button class="navbar-toggler border-0" type="button"
                data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Mở menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav w-100 justify-content-around">

                <li class="nav-item"><a class="nav-link" href="${ctx}/home">TRANG CHỦ</a></li>
                <li class="nav-item"><a class="nav-link" href="${ctx}/list-product?gender=men">GIÀY NAM</a></li>
                <li class="nav-item"><a class="nav-link" href="${ctx}/list-product?gender=women">GIÀY NỮ</a></li>

                <!-- THỂ LOẠI -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="categoryDropdown"
                       role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        THỂ LOẠI
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="categoryDropdown">
                        <c:if test="${empty categoryList}">
                            <li><span class="dropdown-item text-muted">Chưa có thể loại</span></li>
                        </c:if>
                        <c:forEach var="cate" items="${categoryList}">
                            <li><a class="dropdown-item" href="${ctx}/list-product?categoryId=${cate.id}">${cate.name}</a></li>
                        </c:forEach>
                    </ul>
                </li>

                <!-- THƯƠNG HIỆU -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="brandDropdown"
                       role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        THƯƠNG HIỆU
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="brandDropdown">
                        <c:if test="${empty brandList}">
                            <li><span class="dropdown-item text-muted">Chưa có thương hiệu</span></li>
                        </c:if>
                        <c:forEach var="brand" items="${brandList}">
                            <li><a class="dropdown-item" href="${ctx}/list-product?brandId=${brand.id}">${brand.name}</a></li>
                        </c:forEach>
                    </ul>
                </li>

                <li class="nav-item"><a class="nav-link" href="${ctx}/list-product?sale=1">KHUYẾN MÃI</a></li>
                <li class="nav-item"><a class="nav-link" href="${ctx}/contact">LIÊN HỆ</a></li>

            </ul>
        </div>
    </div>
</nav>


<!-- HERO SLIDER -->
<section class="hero-wrap">
    <div id="hero" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner hero-inner">
            <div class="carousel-item active">
                <img src="assets/images/index/hero_silder1.webp" class="d-block w-100" alt="Hero 1">
            </div>
            <div class="carousel-item">
                <img src="assets/images/index/hero_silder2.webp" class="d-block w-100" alt="Hero 2">
            </div>
            <div class="carousel-item">
                <img src="assets/images/index/hero_silder3.webp" class="d-block w-100" alt="Hero 3">
            </div>
        </div>
        <button class="carousel-control-prev hero-ctrl" type="button" data-bs-target="#hero" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next hero-ctrl" type="button" data-bs-target="#hero" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>
</section>

<!-- DANH MỤC NỔI BẬT 2x3 -->

<section class="container py-5">
    <div class="row g-4">
        <c:if test="${not empty featuredCategories}">
            <c:forEach var="cat" items="${featuredCategories}">
                <div class="col-md-4">
                    <a href="${empty cat.link ? '#' : cat.link}" class="cat-card">
                        <img src="${cat.image_url}" alt="${cat.name}">
                        <span class="cat-label">${cat.name}</span>
                    </a>
                </div>
            </c:forEach>
        </c:if>
    </div>
</section>



<!-- ============ SẢN PHẨM MỚI NHẤT (ĐỘNG) ============ -->
<div class="container py-5">
    <h3 class="text-center fw-bold mb-4 text-uppercase">SẢN PHẨM MỚI NHẤT</h3>

    <div id="newProductsCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">

            <c:if test="${not empty productList}">
                <c:forEach var="p" items="${productList}" varStatus="st">

                    <!-- Mở 1 slide mới khi index % 4 == 0 -->
                    <c:if test="${st.index % 4 == 0}">
                        <div class="carousel-item ${st.index == 0 ? 'active' : ''}">
                        <div class="row g-4 justify-content-center">
                    </c:if>
                    <!-- CARD SẢN PHẨM -->
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="product-card h-100">
                            <a href="product?id=${p.id}">
                                <img src="${p.image_url}" class="card-img-top" alt="${p.name}">
                            </a>
                            <div class="p-3">
                                <div class="product-title">${p.name}</div>
                                <div class="text-danger fw-bold">${p.price}đ</div>
                            </div>
                        </div>
                    </div>

                    <!-- Đóng slide khi đủ 4 sp hoặc hết list -->
                    <c:if test="${st.index % 4 == 3 || st.last}">
                        </div> <!-- .row -->
                        </div> <!-- .carousel-item -->
                    </c:if>

                </c:forEach>
            </c:if>

        </div>

        <!-- Nút điều hướng -->
        <button class="carousel-control-prev prod-ctrl" type="button"
                data-bs-target="#newProductsCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next prod-ctrl" type="button"
                data-bs-target="#newProductsCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>
</div>


<!-- SẢN PHẨM BÁN CHẠY  -->

<div class="container py-5">
    <h3 class="text-center fw-bold mb-4 text-uppercase">SẢN PHẨM BÁN CHẠY</h3>

    <div id="bestSellerCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">

            <c:if test="${not empty bestSellerProducts}">
                <c:forEach var="p" items="${bestSellerProducts}" varStatus="st">

                    <c:if test="${st.index % 4 == 0}">
                        <div class="carousel-item ${st.index == 0 ? 'active' : ''}">
                        <div class="row g-4 justify-content-center">
                    </c:if>

                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="product-card h-100">
                            <a href="product?id=${p.id}">
                                <img src="${p.image_url}" class="card-img-top" alt="${p.name}">
                            </a>
                            <div class="p-3">
                                <div class="product-title">${p.name}</div>
                                <div class="text-danger fw-bold">${p.price}đ</div>
                            </div>
                        </div>
                    </div>

                    <c:if test="${st.index % 4 == 3 || st.last}">
                        </div> <!-- .row -->
                        </div> <!-- .carousel-item -->
                    </c:if>

                </c:forEach>
            </c:if>
        </div>

        <!-- Nút điều hướng -->
        <button class="carousel-control-prev prod-ctrl" type="button"
                data-bs-target="#bestSellerCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next prod-ctrl" type="button"
                data-bs-target="#bestSellerCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>
</div>


<!-- MEN FEATURE: Banner nhỏ + nội dung -->
<section class="container py-4 men-feature">
    <!-- Banner nhỏ bên trái -->
    <div class="row align-items-center men-feature-row d-flex justify-content-between gap-5">
        <!-- Banner -->
        <div class="col-lg-5">
            <c:if test="${not empty menBanner}">
                <img src="${menBanner.image_url}"
                     class="img-fluid rounded-2 shadow-sm w-100"
                     alt="${menBanner.title}">
            </c:if>
        </div>
    <!-- Text -->
        <div class="col-lg-6">
            <h3 class="fw-bold section-title mb-3">GIÀY NAM NĂNG ĐỘNG</h3>
            <p class="home-desc">
                Sneaker đã trở thành một biểu tượng của xã hội, là một sản phẩm của thời đại với những thiết kế cổ điển
                và những điều
                để đời đem đến những trông màu phổ biến của giày Sneaker Japan Shoes. Không lỗi thời với thời gian, mang
                dấu ấn cá tính
                khác biệt và tạo mọi sự lôi cuốn dành cho giày Sneaker. Tự tạo cuộc đời, tự tạo phong cách, đó là Japan
                Shoes.
            </p>
            <a href="products.jsp" class="fw-semibold text-decoration-none">XEM TẤT CẢ <i
                    class="bi bi-chevron-right"></i></a>
        </div>
    </div>


    <!-- Slider sản phẩm NAM -->
    <div id="menProducts" class="carousel slide mt-4" data-bs-ride="carousel">
        <div class="carousel-inner">
            <c:if test="${not empty menProducts}">
                <c:forEach var="p" items="${menProducts}" varStatus="st">

                    <!-- Mở một slide mới mỗi khi index % 4 == 0 -->
                    <c:if test="${st.index % 4 == 0}">
                        <div class="carousel-item ${st.index == 0 ? 'active' : ''}">
                        <div class="row g-3">
                    </c:if>

                    <!-- CARD SẢN PHẨM -->
                    <div class="col-6 col-md-4 col-lg-3 col-20">
                        <div class="product-card h-100">
                            <div class="ribbon">SALE</div>
                            <a href="product?id=${p.id}">
                                <img src="${p.image_url}" class="card-img-top" alt="${p.name}">
                            </a>
                            <div class="p-3">
                                <div class="product-title">${p.name}</div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-danger fw-bold">
                                            ${p.price}đ
                                    </div>
                                    <a href="product?id=${p.id}" class="btn btn-sm btn-outline-danger">Chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Đóng slide khi đủ 4 sp hoặc hết list -->
                    <c:if test="${st.index % 4 == 3 || st.last}">
                        </div><!-- row -->
                        </div><!-- carousel-item -->
                    </c:if>

                </c:forEach>
            </c:if>
        </div>

        <!-- điều hướng giữ nguyên -->
        <button class="carousel-control-prev prod-ctrl" type="button" data-bs-target="#menProducts"
                data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next prod-ctrl" type="button" data-bs-target="#menProducts"
                data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>
</section>

<!-- WOMEN FEATURE -->
<section class="container py-5 women-feature">
    <div class="row align-items-center d-flex justify-content-between gap-5">

        <!-- Text bên trái -->
        <div class="col-lg-6 order-lg-1 order-2">
            <h3 class="fw-bold section-title mb-3">GIÀY NỮ THANH LỊCH</h3>
            <p class="home-desc">
                Ra đời từ thế kỉ XX, tự tiện dụng cho đến biểu tượng của phong cách casual.
                Giày lười Japan Shoes là một trong những đại diện của sự chững chạc trong thời trang,
                là xu hướng của thế giới thời trang tối giản. Đồng hành cùng Japan Shoes
                là đồng hành với chuẩn mực của chính bạn.
            </p>
            <a href="products.jsp" class="text-decoration-none fw-semibold d-inline-flex align-items-center gap-1">
                XEM TẤT CẢ <i class="bi bi-chevron-right"></i>
            </a>
        </div>

        <!-- Banner bên phải -->
        <div class="col-lg-5 order-lg-2 order-1">
            <c:if test="${not empty womenRightBanner}">
                <img src="${womenRightBanner.image_url}"
                     alt="${womenRightBanner.title}"
                     class="img-fluid rounded-2 shadow-sm w-100">
            </c:if>
        </div>
    </div>

    <!-- Slider sản phẩm Nữ -->
    <div id="womenProducts" class="carousel slide mt-4" data-bs-ride="carousel">
        <div class="carousel-inner">
            <c:if test="${not empty womenProducts}">
                <c:forEach var="p" items="${womenProducts}" varStatus="st">

                    <c:if test="${st.index % 4 == 0}">
                        <div class="carousel-item ${st.index == 0 ? 'active' : ''}">
                        <div class="row g-3">
                    </c:if>

                    <div class="col-6 col-md-4 col-lg-3 col-20">
                        <div class="product-card h-100">
                            <div class="ribbon">SALE</div>
                            <a href="product?id=${p.id}">
                                <img src="${p.image_url}" class="card-img-top" alt="${p.name}">
                            </a>
                            <div class="p-3">
                                <div class="product-title">${p.name}</div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-danger fw-bold">
                                            ${p.price}đ
                                    </div>
                                    <a href="product?id=${p.id}" class="btn btn-sm btn-outline-danger">Chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:if test="${st.index % 4 == 3 || st.last}">
                        </div><!-- row -->
                        </div><!-- carousel-item -->
                    </c:if>

                </c:forEach>
            </c:if>
        </div>

        <!-- Điều hướng giữ nguyên -->
        <button class="carousel-control-prev prod-ctrl" type="button" data-bs-target="#womenProducts"
                data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next prod-ctrl" type="button" data-bs-target="#womenProducts"
                data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>

</section>

<!-- BANNER QUẢNG CÁO dưới Giày Nữ -->
<section class="container py-4">
    <div class="row">
        <div class="col-12">
            <c:if test="${not empty womenBottomBanner}">
                <a href="${empty womenBottomBanner.link ? '#' : womenBottomBanner.link}">
                    <img src="${womenBottomBanner.image_url}"
                         alt="${womenBottomBanner.title}"
                         class="img-fluid vw-100 h-70 rounded-2 shadow-sm">
                </a>
            </c:if>
        </div>
    </div>
</section>



<!-- Features -->
<section class="bg-light py-4">
    <div class="container">
        <div class="row g-3">
            <div class="col-lg-3 col-6">  <!--srv1-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 pt-2 ">
                            <img src="assets/images/footer/srv_1.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">VẬN CHUYỂN SIÊU TỐC</h6>
                            <small class="text-muted">Vận chuyển nội thành HN trong 2 tiếng!</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6">  <!--srv2-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_2.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">ĐỔI HÀNG</h6>
                            <small class="text-muted">Đổi hàng trong 7 ngày miễn phí!</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6"> <!--srv3-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_3.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">TIẾT KIỆM THỜI GIAN</h6>
                            <small class="text-muted">Mua sắm dễ hơn khi online</small></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-6"> <!--srv4-->
                <div class="d-flex align-items-center">
                    <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                        <div class="col-3 p-0 ">
                            <img src="assets/images/footer/srv_4.png" alt="Service Item"
                                 class="img-fluid rounded ">
                        </div>
                        <div><h6 class="fw-bold mb-1">ĐỊA CHỈ CỬA HÀNG</h6>
                            <small class="text-muted">Lotus 4, Vinhome Gardenia, Hàm Nghi, Từ Liêm, HN</small></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>


<!-- FOOTER -->
<footer class="bg-dark text-light py-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-3 col-md-6">
                <h5 class="text-uppercase mb-3">THÔNG TIN</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="index.jsp" class="text-light text-decoration-none">Trang chủ</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">ADIDAS</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">NIKE</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">HÀNG KHÁC</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">ĐỒNG HỒ - PHỤ KIỆN ĐIỆN TỬ</a>
                    </li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Phụ kiện, Quần áo</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">TPCN Nhật</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h5 class="text-uppercase mb-3">DANH MỤC SẢN PHẨM</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Giày nam</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Giày nữ</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Adidas Fashion Sneaker - Giày
                        thời trang</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Giày chạy - giày đi bộ</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Giày Đen Trắng</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Giày Bóng rổ</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Giày Tennis</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h5 class="text-uppercase mb-3">CHÍNH SÁCH</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="news.html" class="text-light text-decoration-none">THÔNG TIN ĐIỆN TỬ</a>
                    </li>
                    <li class="mb-2"><a href="shipping_policy.html" class="text-light text-decoration-none">Chính sách
                        vận chuyển</a></li>
                    <li class="mb-2"><a href="return_policy.html" class="text-light text-decoration-none">Chính sách đổi
                        trả</a></li>
                    <li class="mb-2"><a href="ordering_instructions.html" class="text-light text-decoration-none">Hướng
                        dẫn đặt hàng</a></li>
                    <li class="mb-2"><a href="payment_in4.html" class="text-light text-decoration-none">Thông tin thanh
                        toán</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Thông tin về JAPANBABY</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Chính sách vận chuyển</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h5 class="text-uppercase mb-3">FACEBOOK</h5>
                <div class="bg-secondary rounded p-3 mb-3"
                     style="height:120px;display:flex;align-items:center;justify-content:center;">
                    <i class="bi bi-facebook fs-1 text-primary"></i>
                </div>
                <div>
                    <h6 class="fw-bold">Hộ kinh doanh JAPANBABY</h6>
                    <p class="small mb-1">MST: 0108569593</p>
                    <p class="small">Đơn vị: UBND Quận Nam Từ Liêm cấp ngày 17/07/2018 (Sửa đổi ngày 05/11/2023)</p>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Back to top -->
<button class="btn btn-danger position-fixed bottom-0 end-0 m-4 rounded-circle"
        style="width:50px;height:50px;z-index:1000;"
        onclick="window.scrollTo({top:0,behavior:'smooth'})"
        title="Lên đầu trang" aria-label="Lên đầu trang">
    <i class="bi bi-arrow-up"></i>
</button>

<!-- Bootstrap JS (bundle đã gồm Popper) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<!-- App JS nhỏ -->
<script>
    // Tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(el => new bootstrap.Tooltip(el));

    // Hiệu ứng focus search
    document.addEventListener('DOMContentLoaded', function () {
        const searchInput = document.querySelector('.search-input');
        if (searchInput) {
            searchInput.addEventListener('focus', function () {
                this.parentElement.style.transform = 'scale(1.02)';
                this.parentElement.style.transition = 'transform 0.2s ease';
            });
            searchInput.addEventListener('blur', function () {
                this.parentElement.style.transform = 'scale(1)';
            });
        }
    });


    /* =========================================================================
       CART CORE (LocalStorage: 'cartItems')
       ========================================================================= */
    const STORAGE_KEY = 'cartItems';
    const getCart = () => JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
    const saveCart = (items) => localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
    const fmtVND = n => (n || 0).toLocaleString('vi-VN') + '₫';

    function addToCart(item) {
        const cart = getCart();
        const found = cart.find(p => p.id === item.id);
        if (found) found.qty = (found.qty || 1) + (item.qty || 1);
        else cart.push({...item, qty: item.qty || 1});
        saveCart(cart);
        updateCartCount();
    }

    function updateCartCount() {
        const total = getCart().reduce((s, it) => s + (it.qty || 1), 0);
        const badge = qs('#cartCount');
        if (badge) {
            badge.textContent = total;
            badge.style.display = total > 0 ? 'inline-block' : 'none';
        }
    }

    /* ===== Helpers (thêm vào) ===== */
    const qs = (sel, root = document) => root.querySelector(sel);
    const qsa = (sel, root = document) => Array.from(root.querySelectorAll(sel));
    /* ===== Gọi cập nhật khi trang load (thêm vào) ===== */
    document.addEventListener('DOMContentLoaded', () => {
        updateCartCount();  // đọc số lượng từ localStorage và hiển thị lên badge
    });

</script>

</body>
</html>
