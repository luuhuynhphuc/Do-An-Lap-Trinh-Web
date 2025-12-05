<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Kính Ray-Ban Chính hãng - Wayfarer Classic - Japan Sport</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet"/>
    <!-- App CSS -->
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>

<!-- ===== Banner ===== -->
<div class="topbar section hidden-xs hidden-sm">
    <a class="section block a-center" href="#">
        <img src="assets/images/banner.webp" alt="Siêu bão khuyến mãi cuối năm"
             style="width:100%;height:auto;display:flex;">
    </a>
</div>

<!-- ===== Header ===== -->
<header class="bg-white shadow-sm py-3">
    <div class="container">
        <div class="row align-items-center g-3">
            <div class="col-lg-3 col-md-4">
                <div class="d-flex align-items-center">
                    <a href="index.jsp">
                        <img src="assets/images/logo.webp" alt="JapanSport" class="logo-header me-2">
                    </a>
                </div>
            </div>
            <div class="col-lg-5 col-md-4">
                <div class="search-container">
                    <input class="form-control search-input" type="search" placeholder="Tìm kiếm…"
                           aria-label="Ô tìm kiếm">
                    <button class="search-btn" aria-label="Tìm kiếm"><i class="bi bi-search"></i></button>
                </div>
            </div>
            <div class="col-lg-4 col-md-4">
                <div class="d-flex justify-content-end align-items-center gap-2">
                    <a href="tel:0984843218" class="btn btn-outline-danger rounded-pill px-3 d-none d-lg-inline">
                        Tư vấn bán hàng <strong class="ms-2">0984843218</strong>
                    </a>
                    <button class="btn header-icon-btn" title="Gọi"><i class="bi bi-telephone"></i></button>
                    <button class="btn header-icon-btn" data-bs-toggle="tooltip" title="Tài khoản"
                            aria-label="Tài khoản">
                        <a href="login.html"><i class="bi bi-person"></i></a>
                    </button>
                    <a href="cart.html"
                       class="position-relative header-icon-btn d-flex align-items-center justify-content-center">
                        <i class="bi bi-bag fs-5"></i>
                        <span id="cartCount"
                              class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">0</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- ===== Navbar ===== -->
<nav class="navbar navbar-expand-lg navbar-custom navbar-dark">
    <div class="container">
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Mở menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav w-100 justify-content-around">
                <!-- Trang chủ -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="index.jsp">TRANG CHỦ</a>
                    <ul class="dropdown-menu">
                        <li class="dropdown-submenu">
                            <a class="dropdown-item dropdown-toggle" href="sanpham.html">SẢN PHẨM</a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Giày nam</a></li>
                                <li><a class="dropdown-item" href="#">Giày nữ</a></li>
                                <li><a class="dropdown-item" href="#">Giày trẻ em</a></li>
                                <li><a class="dropdown-item" href="#">Giày thể thao</a></li>
                            </ul>
                        </li>
                    </ul>
                    <!-- ADIDAS -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">ADIDAS</a>
                    <ul class="dropdown-menu">
                        <li class="dropdown-submenu">
                            <a class="dropdown-item dropdown-toggle" href="#">Ultraboost</a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Ultraboost 22</a></li>
                                <li><a class="dropdown-item" href="#">Ultraboost 21</a></li>
                                <li><a class="dropdown-item" href="#">Ultraboost 4.0</a></li>
                                <li><a class="dropdown-item" href="#">Ultraboost 20</a></li>
                                <li><a class="dropdown-item" href="#">Ultraboost Light</a></li>
                            </ul>
                        </li>
                        <li><a class="dropdown-item" href="#">ADIDAS 4D</a></li>
                        <li><a class="dropdown-item" href="#">ALPHABOUNCE</a></li>
                        <li><a class="dropdown-item" href="#">EQ RUN</a></li>
                        <li><a class="dropdown-item" href="#">STAN SMITH</a></li>
                        <li><a class="dropdown-item" href="#">FALCONRUN</a></li>
                        <li><a class="dropdown-item" href="#">GALAXY | GLX</a></li>
                        <li><a class="dropdown-item" href="#">SUPER NOVA</a></li>
                    </ul>
                </li>

                <!-- NIKE -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">NIKE</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">GIÀY NIKE NAM</a></li>
                        <li><a class="dropdown-item" href="#">GIÀY NIKE NỮ</a></li>
                        <li><a class="dropdown-item" href="#">Jordan</a></li>
                        <li><a class="dropdown-item" href="#">Air Force 1</a></li>
                        <li class="dropdown-submenu">
                            <a class="dropdown-item dropdown-toggle" href="#">Air Zoom Pegasus</a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Pegasus 38</a></li>
                                <li><a class="dropdown-item" href="#">Pegasus 39</a></li>
                                <li><a class="dropdown-item" href="#">Pegasus 40</a></li>
                                <li><a class="dropdown-item" href="#">Pegasus Turbo</a></li>
                                <li><a class="dropdown-item" href="#">Pegasus 41</a></li>
                            </ul>
                        </li>
                    </ul>
                </li>

                <!-- Hàng khác -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">HÀNG KHÁC</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">Lacoste</a></li>
                        <li><a class="dropdown-item" href="#">Puma</a></li>
                        <li><a class="dropdown-item" href="#">Reebok</a></li>
                        <li><a class="dropdown-item" href="#">Mizuno</a></li>
                        <li><a class="dropdown-item" href="#">Asics</a></li>
                    </ul>
                </li>

                <!-- Đồng hồ - Phụ kiện điện tử -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">ĐỒNG HỒ - PHỤ KIỆN ĐIỆN
                        TỬ</a>
                    <ul class="dropdown-menu mega-menu p-3">
                        <li>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <h6 class="dropdown-header text-uppercase fw-bold">Đồng hồ chính hãng</h6>
                                    <ul class="list-unstyled mb-0">
                                        <li><a class="dropdown-item" href="#">CASIO</a></li>
                                        <li><a class="dropdown-item" href="#">CITIZEN</a></li>
                                        <li><a class="dropdown-item" href="#">ORIENT</a></li>
                                        <li><a class="dropdown-item" href="#">FOSSIL</a></li>
                                        <li><a class="dropdown-item" href="#">Calvin Klein</a></li>
                                        <li><a class="dropdown-item" href="#">MICHAEL KORS</a></li>
                                        <li><a class="dropdown-item" href="#">SEIKO</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="dropdown-header text-uppercase fw-bold">Tai nghe - Phụ kiện điện tử</h6>
                                    <ul class="list-unstyled mb-0">
                                        <li><a class="dropdown-item" href="#">JBL</a></li>
                                        <li><a class="dropdown-item" href="#">SONY</a></li>
                                        <li><a class="dropdown-item" href="#">Audio-Technica</a></li>
                                        <li><a class="dropdown-item" href="#">SENNHEISER</a></li>
                                        <li><a class="dropdown-item" href="#">Apple AirPods</a></li>
                                        <li><a class="dropdown-item" href="#">Sạc dự phòng</a></li>
                                        <li><a class="dropdown-item" href="#">Cáp sạc</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="dropdown-header text-uppercase fw-bold">Máy tính bảng Nhật</h6>
                                    <ul class="list-unstyled mb-0">
                                        <li><a class="dropdown-item" href="#">iPad</a></li>
                                        <li><a class="dropdown-item" href="#">Samsung Tab</a></li>
                                        <li><a class="dropdown-item" href="#">Microsoft Surface</a></li>
                                        <li><a class="dropdown-item" href="#">Lenovo Tab</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="dropdown-header text-uppercase fw-bold">Đồ gia dụng</h6>
                                    <ul class="list-unstyled mb-0">
                                        <li><a class="dropdown-item" href="#">Máy lọc nước</a></li>
                                        <li><a class="dropdown-item" href="#">Máy sấy tóc</a></li>
                                        <li><a class="dropdown-item" href="#">Máy đánh răng</a></li>
                                        <li><a class="dropdown-item" href="#">Máy massage</a></li>
                                        <li><a class="dropdown-item" href="#">Bàn ủi</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="dropdown-header text-uppercase fw-bold">Máy tính xách tay</h6>
                                    <ul class="list-unstyled mb-0">
                                        <li><a class="dropdown-item" href="#">Apple MacBook</a></li>
                                        <li><a class="dropdown-item" href="#">Dell</a></li>
                                        <li><a class="dropdown-item" href="#">HP</a></li>
                                        <li><a class="dropdown-item" href="#">Lenovo</a></li>
                                        <li><a class="dropdown-item" href="#">Toshiba</a></li>
                                        <li><a class="dropdown-item" href="#">Fujitsu</a></li>
                                        <li><a class="dropdown-item" href="#">NEC</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="dropdown-header text-uppercase fw-bold">Hàng cũ/Đã qua sử dụng</h6>
                                    <ul class="list-unstyled mb-0">
                                        <li><a class="dropdown-item" href="#">Laptop Used</a></li>
                                        <li><a class="dropdown-item" href="#">Tai nghe Used</a></li>
                                        <li><a class="dropdown-item" href="#">Bàn phím - Chuột Used</a></li>
                                        <li><a class="dropdown-item" href="#">Loa Used</a></li>
                                        <li><a class="dropdown-item" href="#">Đồng hồ Used</a></li>
                                    </ul>
                                </div>
                            </div>
                        </li>
                    </ul>
                </li>

                <!-- Phụ kiện, quần áo -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">PHỤ KIỆN, QUẦN ÁO</a>
                    <ul class="dropdown-menu">
                        <li class="dropdown-submenu">
                            <a class="dropdown-item dropdown-toggle" href="#">Áo</a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Áo Polo</a></li>
                                <li><a class="dropdown-item" href="#">Áo Phông</a></li>
                                <li><a class="dropdown-item" href="#">Áo Khoác</a></li>
                            </ul>
                        </li>
                        <li class="dropdown-submenu">
                            <a class="dropdown-item dropdown-toggle" href="#">Quần thể thao</a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Quần Short</a></li>
                                <li><a class="dropdown-item" href="#">Quần Dài</a></li>
                            </ul>
                        </li>
                        <li class="dropdown-submenu">
                            <a class="dropdown-item dropdown-toggle" href="#">Phụ kiện</a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Balo</a></li>
                                <li><a class="dropdown-item" href="#">Tất</a></li>
                                <li><a class="dropdown-item" href="#">Túi đeo chéo</a></li>
                                <li><a class="dropdown-item" href="#">Mũ thể thao</a></li>
                            </ul>
                        </li>
                        <li class="dropdown-submenu">
                            <a class="dropdown-item dropdown-toggle" href="#">Kính mắt</a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">RAY-BAN</a></li>
                            </ul>
                        </li>
                        <li class="dropdown-submenu">
                            <a class="dropdown-item dropdown-toggle" href="#">Nước hoa</a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Nước hoa có sẵn</a></li>
                                <li><a class="dropdown-item" href="#">Nước hoa ADIDAS</a></li>
                            </ul>
                        </li>
                    </ul>
                </li>

                <!-- TPCN Nhật -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">TPCN NHẬT</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">ORIHIRO</a></li>
                        <li><a class="dropdown-item" href="#">DHC</a></li>
                        <li><a class="dropdown-item" href="#">Mỹ Phẩm Nhật</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
    <div class="container">
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- giữ lại menu giống product1 -->
            <ul class="navbar-nav w-100 justify-content-around">
                <li class="nav-item"><a class="nav-link" href="index.jsp">TRANG CHỦ</a></li>
                <li class="nav-item"><a class="nav-link" href="sanpham.html">SẢN PHẨM</a></li>
                <li class="nav-item"><a class="nav-link" href="#">ADIDAS</a></li>
                <li class="nav-item"><a class="nav-link" href="#">NIKE</a></li>
                <li class="nav-item"><a class="nav-link" href="#">HÀNG KHÁC</a></li>
                <li class="nav-item"><a class="nav-link" href="#">ĐỒNG HỒ - PHỤ KIỆN ĐIỆN TỬ</a></li>
                <li class="nav-item"><a class="nav-link" href="#">PHỤ KIỆN, QUẦN ÁO</a></li>
                <li class="nav-item"><a class="nav-link" href="#">TPCN NHẬT</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- ===== Breadcrumb ===== -->
<div class="bg-light py-2">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0 justify-content-center">
                <li class="breadcrumb-item"><a href="index.jsp">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="#">Áo</a></li>
                <li class="breadcrumb-item active text-danger" aria-current="page">
                    Áo phông dài tay Adidas Chính Hãng - Ultimate365 Textured Quarter-Zip Top - Màu Trắng | JapanSport
                    IU4698
                </li>
            </ol>
        </nav>
    </div>
</div>

<!-- ===== Product Detail Content ===== -->
<div class="container my-4">
    <div class="row">
        <h1 class="text-danger fw-bold mb-3 d-flex justify-content-center">Áo</h1>

        <!-- LEFT: Gallery + Zoom Preview -->
        <div class="col-xl-5 col-lg-5">
            <div class="product-zoom-wrap">
                <div class="product-gallery">
                    <div class="main-image mb-3">
                        <img id="mainImage" src="assets/images/product2/product2_1.webp" alt="Ray-Ban Wayfarer"
                             class="img-fluid w-100 border rounded">
                        <div id="zoomPreview" class="zoom-preview" aria-hidden="true"></div>
                        <div id="zoomLens" class="zoom-lens"></div>
                    </div>

                    <!-- Thumbnails -->
                    <div class="d-flex align-items-center gap-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="prevThumb()" aria-label="Previous">
                            <i class="bi bi-chevron-left"></i>
                        </button>

                        <div class="thumbnails-wrapper flex-grow-1 overflow-hidden">
                            <div class="thumbnails d-flex gap-2">
                                <img src="assets/images/product2/product2_1.webp" alt="View 1" class="thumbnail active"
                                     onclick="changeImage(this)">
                                <img src="assets/images/product2/product2_2.webp" alt="View 2" class="thumbnail"
                                     onclick="changeImage(this)">
                                <img src="assets/images/product2/product2_3.jpg" alt="View 3" class="thumbnail"
                                     onclick="changeImage(this)">
                                <img src="assets/images/product2/product2_4.jpg" alt="View 4" class="thumbnail"
                                     onclick="changeImage(this)">
                            </div>
                        </div>

                        <button class="btn btn-sm btn-outline-secondary" onclick="nextThumb()" aria-label="Next">
                            <i class="bi bi-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- RIGHT: Info -->
        <div class="col-xl-7 col-lg-7">
            <div class="row g-3 align-items-start">
                <div class="col-xl-8 col-lg-8 order-2 order-lg-1" data-info-col>
                    <div class="product-info">
                        <h2 class="h4 mb-3">Áo phông dài tay Adidas Chính Hãng - Ultimate365 Textured Quarter-Zip Top -
                            Màu Trắng | JapanSport IU4698</h2>
                        <div class="mb-3">
                            <span class="text-muted">Thương hiệu: </span>
                            <a href="#" class="text-primary text-decoration-none">Adidads</a>
                            <span class="text-muted ms-3">| Kho: </span>
                            <span class="text-primary">Còn hàng</span>
                        </div>

                        <div class="mb-3">
                            <div class="stars text-warning">
                                <i class="bi bi-star"></i>
                                <i class="bi bi-star"></i>
                                <i class="bi bi-star"></i>
                                <i class="bi bi-star"></i>
                                <i class="bi bi-star"></i>
                            </div>
                            <a href="assets/images/product1/product1_7.webp"
                               class="text-primary text-decoration-none small ms-2">
                                <i class="bi bi-info-circle"></i> Hướng dẫn chọn size
                            </a>
                        </div>

                        <div class="price-section mb-4">
                            <h3 class="text-danger fw-bold fs-2 mb-2">980.000₫</h3>
                            <div class="alert alert-danger">
                                <span>Hàng xách tay Nhật, Fullbox, Cam kết 100% chính hãng, Phát hiện hàng giả xin đền 10 lần tiền.</span>
                            </div>
                            <p class="text-black fw-bold mb-2">Ship COD toàn quốc | Miễn phí đổi size, đổi màu trong 1
                                tuần !!!</p>
                            <p class="text-primary fw-bold">Địa chỉ: Lotus 4, Vinhome Gardenia, Hàm Nghi, Từ Liêm,
                                HN</p>
                            <p class="text-primary fw-bold">SĐT liên hệ: 0984843218 0977179889</p>
                        </div>

                        <div class="action-buttons mb-100 d-flex justify-content-between">
                            <button id="btnBuyNowProduct"
                                    class="btn btn-danger btn-lg me-4 mb-5"
                                    data-id="rb-wayfarer-002"
                                    data-title="Áo phông dài tay Adidas Chính Hãng - Ultimate365 Textured Quarter-Zip Top - Màu Trắng | JapanSport IU4698"
                                    data-price="980000"
                                    data-image="assets/images/product2/product2_1.webp">
                                MUA NGAY
                                <small class="d-block">Giao Hàng Thanh Toán COD</small>
                            </button>

                            <button id="btnAddToCart"
                                    class="btn btn-lg mb-5 btn-danger add-to-cart"
                                    data-id="rb-wayfarer-002"
                                    data-title="Áo phông dài tay Adidas Chính Hãng - Ultimate365 Textured Quarter-Zip Top - Màu Trắng | JapanSport IU4698"
                                    data-price="980000"
                                    data-image="assets/images/product2/product2_1.webp"
                                    data-url="product2.html">
                                Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Sidebar -->
                <div class="col-xl-4 col-lg-4 order-1 order-lg-2">
                    <aside class="features-sidebar sidebar-sticky">
                        <div class="feature-item d-flex align-items-start mb-3 p-3 bg-light rounded">
                            <div class="col-3 pt-2"><img src="assets/images/footer/srv_1.png" class="img-fluid rounded"
                                                         alt=""></div>
                            <div><h6 class="fw-bold mb-1">VẬN CHUYỂN SIÊU TỐC</h6><small class="text-muted">Vận chuyển
                                nội thành HN trong 2 tiếng!</small></div>
                        </div>
                        <div class="feature-item d-flex align-items-start mb-3 p-3 bg-light rounded">
                            <div class="col-3 pt-2"><img src="assets/images/footer/srv_2.png" class="img-fluid rounded"
                                                         alt=""></div>
                            <div><h6 class="fw-bold mb-1">Đổi hàng</h6><small class="text-muted">Đổi hàng trong 7 ngày
                                miễn phí!</small></div>
                        </div>
                        <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded">
                            <div class="col-3 pt-2"><img src="assets/images/footer/srv_3.png" class="img-fluid rounded"
                                                         alt=""></div>
                            <div><h6 class="fw-bold mb-1">Tiết kiệm thời gian</h6><small class="text-muted">Mua sắm dễ
                                hơn khi online</small></div>
                        </div>

                        <div class="feature-item d-flex align-items-start mb-4 p-3 bg-light rounded"> <!--Srv4-->
                            <div class=" col-3 pt-2">
                                <img src="assets/images/footer/srv_4.png" alt="Service item"
                                     class="img-fluid rounded   ">
                            </div>
                            <div><h6 class="fw-bold mb-1">ĐỊA CHỈ CỬA HÀNG</h6>
                                <small class="text-muted">Lotus 4, Vinhome Gardenia, Hàm Nghi, Từ Liêm, HN</small></div>
                        </div>

                        <div class="hot-collection mt-4">
                            <h6 class="text-danger fw-bold mb-3">BỘ SƯU TẬP HOT</h6>
                            <div class="hot-item mb-3">
                                <div class="row g-2 align-items-center">
                                    <div class="col-4"><img src="assets/images/login/login2.webp"
                                                            class="img-fluid rounded" alt=""></div>
                                    <div class="col-8">
                                        <h6 class="small mb-1">Giày Adidas Trẻ em - Chính Hãng</h6>
                                        <div class="text-danger fw-bold small">600.000₫</div>
                                        <div class="text-muted small">
                                            <del>1.300.000₫</del>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </aside>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Modal xác nhận thêm giỏ -->
<div id="addedModal" class="modal fade" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-0">
                <div class="d-flex align-items-center text-success fw-semibold">
                    <i class="bi bi-check-circle-fill me-2"></i> Sản phẩm vừa được thêm vào giỏ hàng
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>

            <div class="modal-body pt-0">
                <div class="row g-3">
                    <div class="col-md-7 d-flex align-items-center">
                        <img id="mImg" src="" alt="" style="width:90px;height:90px;object-fit:cover;border-radius:10px;border:1px solid #eee" class="me-3">
                        <div>
                            <div id="mTitle" class="fw-semibold"></div>
                            <div id="mPrice" class="text-danger fw-bold mt-1"></div>
                        </div>
                    </div>

                    <div class="col-md-5">
                        <div class="p-3 bg-light rounded">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Tổng tiền:</span>
                                <strong id="mTotal" class="text-danger"></strong>
                            </div>
                            <button id="mProceed" class="btn btn-danger w-100">
                                TIẾN HÀNH ĐẶT HÀNG
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer border-0 pt-0">
                <a href="cart.html" class="btn btn-outline-secondary">Xem giỏ hàng</a>
                <button class="btn btn-link text-muted" data-bs-dismiss="modal">Tiếp tục mua hàng</button>
            </div>
        </div>
    </div>
</div>

<!-- Tabs (giữ giống trang 1, đổi text một chút) -->
<div class="container">
    <div class="row gx-4 mt-4 pt-1">
        <div class="col-xxl-9 col-xl-9 col-lg-12">
            <div class="product-tabs card border-0 shadow-sm">
                <ul class="nav nav-tabs px-3 pt-3" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-desc" type="button">Mô
                            tả sản phẩm
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-custom" type="button">Tab tùy
                            chỉnh
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-review" type="button">Đánh
                            giá
                        </button>
                    </li>
                </ul>
                <div class="tab-content p-4">
                    <div class="tab-pane fade show active" id="tab-desc">
                        <h4 class="fw-bold mb-3">Ray-Ban Wayfarer Classic RB2140 50mm</h4>
                        <p>Thiết kế Wayfarer biểu tượng với gọng nhựa chắc chắn, kính đen cổ điển phù hợp nhiều phong
                            cách. Hàng chính hãng JapanSport, bảo hành uy tín.</p>
                        <h5 class="fw-bold mt-4 mb-3">Thông tin chi tiết</h5>
                        <ul class="list-unstyled ps-3 mb-0">
                            <li class="mb-2">• Chất liệu gọng: Nhựa cao cấp</li>
                            <li class="mb-2">• Màu gọng: Đen</li>
                            <li class="mb-2">• Kiểu dáng: Wayfarer</li>
                            <li class="mb-2">• Màu tròng: Khói</li>
                            <li class="mb-2">• Bề rộng tròng: 50mm</li>
                        </ul>
                    </div>
                    <div class="tab-pane fade" id="tab-custom">Nội dung tùy chỉnh (bảo hành, phụ kiện kèm theo…).</div>
                    <div class="tab-pane fade" id="tab-review">
                        <p class="mb-2">Chưa có đánh giá. Hãy là người đầu tiên!</p>
                        <button id="openReviewBtn" class="btn btn-danger">Viết đánh giá</button>
                        <!-- Modal custom giống product1 -->
                        <div id="reviewModal" class="review-modal" aria-hidden="true" role="dialog" aria-modal="true">
                            <div class="review-overlay" data-close></div>
                            <div class="review-card" role="document" aria-labelledby="reviewTitle">
                                <button class="review-close" type="button" aria-label="Đóng" title="Đóng" data-close>
                                    &times;
                                </button>
                                <h5 id="reviewTitle" class="mb-3 text-center fw-bold">Đánh giá sản phẩm</h5>
                                <div class="review-stars text-center mb-3" aria-label="Chọn số sao">
                                    <i class="star bi bi-star-fill" data-value="1"></i>
                                    <i class="star bi bi-star-fill" data-value="2"></i>
                                    <i class="star bi bi-star-fill" data-value="3"></i>
                                    <i class="star bi bi-star-fill" data-value="4"></i>
                                    <i class="star bi bi-star-fill" data-value="5"></i>
                                </div>
                                <form id="reviewForm" class="review-form">
                                    <input type="hidden" name="rating" id="ratingValue" value="5"/>
                                    <div class="mb-2"><input type="text" class="form-control"
                                                             placeholder="Nhập tên của bạn" required></div>
                                    <div class="mb-2"><input type="email" class="form-control"
                                                             placeholder="nguyenvan@gmail.com" required></div>
                                    <div class="mb-2"><input type="text" class="form-control" placeholder="Tiêu đề">
                                    </div>
                                    <div class="mb-3"><textarea class="form-control" rows="4"
                                                                placeholder="Nội dung"></textarea></div>
                                    <div class="text-center">
                                        <button type="submit" class="btn btn-danger px-4">Gửi</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <!-- /Modal -->
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xxl-3 col-xl-3 d-none d-xl-block"></div>
    </div>
</div>

<!-- FOOTER -->
<footer class="bg-dark text-light py-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-3 col-md-6">
                <h5 class="text-uppercase mb-3">THÔNG TIN</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Trang chủ</a></li>
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
                    <li class="mb-2"><a href="news.html" class="text-light text-decoration-none">THÔNG TIN ĐIỆN TỬ</a></li>
                    <li class="mb-2"><a href="shipping_policy.html" class="text-light text-decoration-none">Chính sách vận chuyển</a></li>
                    <li class="mb-2"><a href="return_policy.html" class="text-light text-decoration-none">Chính sách đổi trả</a></li>
                    <li class="mb-2"><a href="ordering_instructions.html" class="text-light text-decoration-none">Hướng dẫn đặt hàng</a></li>
                    <li class="mb-2"><a href="payment_in4.html" class="text-light text-decoration-none">Thông tin thanh toán</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Thông tin về JAPANBABY</a></li>
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
        onclick="window.scrollTo({top:0,behavior:'smooth'})" title="Lên đầu trang" aria-label="Lên đầu trang">
    <i class="bi bi-arrow-up"></i>
</button>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<script>
    /* ===== TIỆN ÍCH DOM ===== */
    const qs = (sel, root = document) => root.querySelector(sel);
    const qsa = (sel, root = document) => Array.from(root.querySelectorAll(sel));

    /* ===== Cart core ===== */
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
        if (!badge) return;
        badge.textContent = total;
        badge.style.display = total > 0 ? 'inline-block' : 'none';
    }

    /* =========================================================================
        GALLERY + THUMBNAILS (4 ảnh hiển thị, trượt từng ảnh)
          2 nút prev/next gọi prevThumb() / nextThumb()
        ========================================================================= */
    (function () {
        const gallery = qs('.product-gallery');
        if (!gallery) return;
        const mainImg = qs('#mainImage', gallery);
        const mainBox = qs('.main-image', gallery);
        const viewport = qs('.thumbnails-wrapper', gallery);
        const rail = qs('.thumbnails', gallery);
        const thumbs = () => qsa('.thumbnail', rail);

        let cursor = 0;
        const VISIBLE = 4;
        const SAFETY = 4;
        const MIN = 56, MAX = 112;
        let GAP = 8;
        let size = 80;

        function readGap() {
            const cs = getComputedStyle(rail);
            const g = parseFloat(cs.gap || cs.columnGap || '8');
            return isNaN(g) ? 8 : g;
        }

        const clamp = (v, a, b) => Math.min(b, Math.max(a, v));
        const maxCursor = () => Math.max(0, thumbs().length - VISIBLE);

        function compute() {
            GAP = readGap();
            const totalW = Math.floor(mainBox.clientWidth);
            viewport.style.width = totalW + 'px';
            size = Math.floor((totalW - SAFETY - (VISIBLE - 1) * GAP) / VISIBLE);
            size = clamp(size, MIN, MAX);
            thumbs().forEach(t => {
                t.style.width = size + 'px';
                t.style.height = size + 'px';
            });
            cursor = clamp(cursor, 0, maxCursor());
            apply();
        }

        function apply() {
            const step = size + GAP;
            const dx = Math.round(cursor * step);
            rail.style.transform = `translateX(${-dx}px)`;
        }

        window.nextThumb = function () {
            if (cursor < maxCursor()) {
                cursor += 1;
                apply();
            }
        };
        window.prevThumb = function () {
            if (cursor > 0) {
                cursor -= 1;
                apply();
            }
        };

        window.changeImage = function (thumbnail) {
            if (!thumbnail) return;
            mainImg.src = thumbnail.src;
            thumbs().forEach(t => t.classList.remove('active'));
            thumbnail.classList.add('active');
            if (qs('#zoomPreview').style.display === 'block') {
                qs('#zoomPreview').style.backgroundImage = `url(${mainImg.src})`;
                syncPreviewBox();
            }
        };

        window.addEventListener('resize', compute);
        document.addEventListener('DOMContentLoaded', compute);
    })();

    /* ===== Zoom Preview ===== */
    const infoCol = document.querySelector('[data-info-col]');
    const img = document.getElementById('mainImage');
    const lens = document.getElementById('zoomLens');
    const preview = document.getElementById('zoomPreview');
    const SCALE = 2.2;
    const LENS_W = 140, LENS_H = 140;

    function syncPreviewBox() {
        preview.style.width = img.clientWidth + 'px';
        preview.style.height = img.clientHeight + 'px';
    }

    function showZoom() {
        if (window.innerWidth < 1200) return;
        syncPreviewBox();
        preview.style.display = 'block';
        lens.style.display = 'block';
        preview.style.backgroundImage = `url(${img.src})`;
        preview.style.backgroundSize = (SCALE * 100) + '% auto';
        if (infoCol) infoCol.style.pointerEvents = 'none';
    }

    function hideZoom() {
        preview.style.display = 'none';
        lens.style.display = 'none';
        if (infoCol) infoCol.style.pointerEvents = '';
    }

    function moveLens(e) {
        const r = img.getBoundingClientRect();
        let x = e.clientX - r.left - LENS_W / 2;
        let y = e.clientY - r.top - LENS_H / 2;
        x = Math.max(0, Math.min(x, r.width - LENS_W));
        y = Math.max(0, Math.min(y, r.height - LENS_H));
        lens.style.left = x + 'px';
        lens.style.top = y + 'px';
        const maxX = r.width - LENS_W, maxY = r.height - LENS_H;
        const px = (x / maxX) * 100, py = (y / maxY) * 100;
        preview.style.backgroundPosition = `${px}% ${py}%`;
    }

    img.addEventListener('mouseenter', showZoom);
    img.addEventListener('mouseleave', hideZoom);
    img.addEventListener('mousemove', moveLens);
    document.querySelectorAll('.thumbnail').forEach(t => {
        t.addEventListener('click', () => {
            if (preview.style.display === 'block') {
                setTimeout(() => {
                    syncPreviewBox();
                    preview.style.backgroundImage = `url(${img.src})`;
                }, 0);
            }
        });
    });
    window.addEventListener('resize', () => {
        if (preview.style.display === 'block') syncPreviewBox();
    });

    /* ===== Review Modal (custom) ===== */
    (function () {
        const openBtn = qs('#openReviewBtn');
        const modal = qs('#reviewModal');
        if (!modal) return;
        const overlay = qs('.review-overlay', modal);
        const closers = qsa('[data-close]', modal);
        const stars = qsa('.review-stars .star', modal);
        const ratingEl = qs('#ratingValue', modal);
        let lastFocus;

        function paint(v) {
            stars.forEach(st => {
                const val = +st.dataset.value;
                st.classList.toggle('active', val <= v);
            });
        }

        function open() {
            lastFocus = document.activeElement;
            modal.classList.add('show');
            modal.setAttribute('aria-hidden', 'false');
            document.body.style.overflow = 'hidden';
        }

        function close() {
            modal.classList.remove('show');
            modal.setAttribute('aria-hidden', 'true');
            document.body.style.overflow = '';
            lastFocus?.focus?.();
        }

        openBtn?.addEventListener('click', open);
        overlay?.addEventListener('click', close);
        closers.forEach(b => b.addEventListener('click', close));
        document.addEventListener('keydown', e => {
            if (e.key === 'Escape' && modal.classList.contains('show')) close();
        });
        paint(+ratingEl?.value || 5);
        stars.forEach(st => st.addEventListener('click', () => {
            const v = +st.dataset.value;
            if (ratingEl) ratingEl.value = v;
            paint(v);
        }));
        qs('#reviewForm')?.addEventListener('submit', e => {
            e.preventDefault();
            close();
            alert('Cảm ơn bạn đã gửi đánh giá!');
        });
    })();

    /* ===== Buttons (Add to cart + Buy now với modal) ===== */
    (function(){
        // Cập nhật badge khi vào trang
        document.addEventListener('DOMContentLoaded', updateCartCount);

        // Thêm vào giỏ
        const addBtn = qs('#btnAddToCart');
        if(addBtn){
            addBtn.addEventListener('click', () => {
                const item = {
                    id:    addBtn.dataset.id,
                    title: addBtn.dataset.title,
                    price: Number(addBtn.dataset.price || 0),
                    image: addBtn.dataset.image || '',
                    qty:   1
                };
                addToCart(item);
                alert('Đã thêm sản phẩm vào giỏ!');
            });
        }


        // Mua ngay (thêm vào giỏ + bật modal)
        const buyBtn = qs('#btnBuyNowProduct');
        const addedModalEl = qs('#addedModal');
        if (buyBtn && addedModalEl) {
            buyBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();

                // Tắt zoom nếu đang mở
                try { hideZoom(); } catch(err) {}

                const item = {
                    id:    buyBtn.dataset.id,
                    title: buyBtn.dataset.title,
                    price: Number(buyBtn.dataset.price || 0),
                    image: buyBtn.dataset.image || '',
                    qty:   1
                };
                addToCart(item);
                fillAndShowAddedModal(item);
            });

            function fillAndShowAddedModal(item){
                qs('#mImg').src = item.image || '';
                qs('#mImg').alt = item.title || '';
                qs('#mTitle').textContent = item.title || '';
                qs('#mPrice').textContent = fmtVND(item.price || 0);
                qs('#mTotal').textContent = fmtVND((item.price||0) * (item.qty||1));

                const bsModal = new bootstrap.Modal(addedModalEl, { backdrop: 'static' });
                bsModal.show();
            }
        }
        // Khi bấm "TIẾN HÀNH ĐẶT HÀNG" → sang payment.html
        const proceedBtn = qs('#mProceed');
        if (proceedBtn) {
            proceedBtn.addEventListener('click', () => {
                window.location.href = 'payment.html';
            });
        }

    })();
</script>
</body>
</html>
