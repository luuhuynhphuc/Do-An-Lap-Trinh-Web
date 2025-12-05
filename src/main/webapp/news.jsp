<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Tin tức - Japan Sport</title>

    <!-- Bootstrap -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet"/>
    <!-- App CSS (giống các trang khác của bạn) -->
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
            <!-- Logo -->
            <div class="col-lg-3 col-md-4">
                <div class="d-flex align-items-center">
                    <a href="index.jsp">
                        <img src="assets/images/logo.webp" alt="JapanSport" class="logo-header me-2">
                    </a>
                </div>
            </div>

            <!-- Search -->
            <div class="col-lg-5 col-md-4">
                <div class="search-container">
                    <input class="form-control search-input" type="search" placeholder="Tìm kiếm…"
                           aria-label="Ô tìm kiếm">
                    <button class="search-btn" aria-label="Tìm kiếm">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </div>

            <!-- hotline and icons -->
            <div class="col-lg-4 col-md-4">
                <div class="d-flex justify-content-end align-items-center gap-2">
                    <a href="tel:0984843218" class="btn btn-outline-danger rounded-pill px-3 d-none d-lg-inline">
                        Tư vấn bán hàng <strong class="ms-2">0984843218</strong>
                    </a>
                    <button class="btn header-icon-btn" title="Gọi"><i class="bi bi-telephone"></i></button>
                    <!--login-->
                    <button class="btn header-icon-btn" data-bs-toggle="modal" title="Tài khoản"
                            aria-label="Tài khoản">
                        <a href="login.html"><i class="bi bi-person"></i></a>
                    </button>
                    <!--cart icon-->
                    <a href="cart.html" data-bs-toggle="tooltip" title="Giỏ hàng"
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

<!-- Navbar -->
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
                                <li><a class="dropdown-item" href="https://giaynhatchinhhang.vn/giay-nam">Giày nam</a>
                                </li>
                                <li><a class="dropdown-item" href="#">Giày nữ</a></li>
                                <li><a class="dropdown-item" href="#">Giày trẻ em</a></li>
                                <li><a class="dropdown-item" href="#">Giày thể thao</a></li>
                            </ul>
                        </li>
                    </ul>
                </li>

                <!-- ADIDAS -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown"
                       aria-expanded="false">ADIDAS</a>
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
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown"
                       aria-expanded="false">NIKE</a>
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
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown" aria-expanded="false">HÀNG
                        KHÁC</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">Lacoste</a></li>
                        <li><a class="dropdown-item" href="#">Puma</a></li>
                        <li><a class="dropdown-item" href="#">Reebok</a></li>
                        <li><a class="dropdown-item" href="#">Mizuno</a></li>
                        <li><a class="dropdown-item" href="#">Asics</a></li>
                    </ul>
                </li>

                <!-- Đồng hồ - Phụ kiện điện tử (Mega menu) -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown" aria-expanded="false">ĐỒNG HỒ
                        - PHỤ KIỆN ĐIỆN TỬ</a>
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
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown" aria-expanded="false">PHỤ
                        KIỆN, QUẦN ÁO</a>
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
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown" aria-expanded="false">TPCN
                        NHẬT</a>
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

<!-- ===== Breadcrumb ===== -->
<div class="bg-light py-3 border-bottom">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0 justify-content-center">
                <li class="breadcrumb-item"><a href="index.jsp">Trang chủ</a></li>
                <li class="breadcrumb-item active text-danger" aria-current="page">Tin tức</li>
            </ol>
        </nav>
    </div>
</div>

<!-- ===== Title ===== -->
<div class="container my-3">
    <h2 class="text-center news-title-page">Tin tức</h2>
</div>

<!-- ===== Main ===== -->
<div class="container my-4 row-equal">
    <div class="row g-4">
        <!-- Sidebar -->
        <aside class="col-lg-3">
            <div class="widget-box mb-5">
                <div class="widget-title">DANH MỤC</div>
                <ul class="category-list list-unstyled mb-0">
                    <li><a href="#">Giày nam</a><i class="bi bi-chevron-down"></i></li>
                    <li><a href="#">Giày nữ</a><i class="bi bi-chevron-down"></i></li>
                    <li><a href="#">Adidas Fashion Sneaker - Giày thời trang</a><i class="bi bi-chevron-down"></i></li>
                    <li><a href="#">Giày chạy - giày đi bộ</a><i class="bi bi-chevron-down"></i></li>
                    <li><a href="#">Giày Dép Trẻ Em</a><i class="bi bi-chevron-down"></i></li>
                    <li><a href="#">Giày Bóng rổ</a><i class="bi bi-chevron-down"></i></li>
                    <li><a href="#">Giày Tennis</a><i class="bi bi-chevron-down"></i></li>
                    <li><a href="#">Giày đá bóng</a><i class="bi bi-chevron-down"></i></li>
                </ul>
            </div>

            <div class="widget-box">
                <div class="widget-title">SIÊU BÃO VỀ GIÁ</div>
                <article class="product-mini d-flex align-items-center gap-3 p-3">
                    <a class="flex-shrink-0" href="#">
                        <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600&auto=format&fit=crop"
                             alt="Giày Adidas Trẻ em" style="width:100px;height:auto;">
                    </a>
                    <div>
                        <h6 class="mb-1"><a href="#" class="text-decoration-none text-dark">Giày Adidas Trẻ em - Chính
                            Hãng</a></h6>
                        <div>
                            <span class="price-now">600.000₫</span>
                            <span class="price-old">1.300.000₫</span>
                        </div>
                    </div>
                </article>
            </div>
        </aside>

        <!-- Content -->
        <section class="col-lg-9 d-flex flex-column">
            <!-- Featured article -->
            <article class="news-feature mb-4">
                <a href="#" class="d-block">
                    <img src="assets/images/news/news1.webp"
                         alt="Asics Tennis">
                </a>
                <div class="flex-grow-0 mb-7">
                    <h5 class="fw-bold ">
                        <a href="#" class="text-decoration-none text-dark">
                            Hướng dẫn chọn giày chơi tennis, Pickleball phù hợp cho từng loại sân!
                        </a>
                    </h5>
                    <p class="mb-0 text-muted">Hướng dẫn về giày tennis – nên mang giày gì khi chơi trên sân cỏ, sân đất
                        nện và sân cứng Có ba...</p>
                </div>
            </article>

            <!-- Bottom cards (6 items) -->
            <div class="news-bottom">
                <div class="row g-4">

                    <!-- 1 -->
                    <div class="col-md-6">
                        <article class="d-flex gap-3 align-items-start">
                            <a class="news-card-thumb flex-shrink-0" style="width:160px" href="#">
                                <img src="assets/images/news/news2.webp" alt="YEEZY BOOST 350 V2" style="width:100%;height:auto;display:block;">
                            </a>
                            <div>
                                <h6 class="mb-1 fw-bold"><a href="#" class="text-decoration-none text-dark">YEEZY BOOST 350 V2</a></h6>
                                <p class="mb-0 text-muted">YEEZY BOOST 350 V2 có phần trên từ Primeknit được thiết kế lại. Sọc bên sườn dọn sau nhuộm...</p>
                            </div>
                        </article>
                    </div>

                    <!-- 2 -->
                    <div class="col-md-6">
                        <article class="d-flex gap-3 align-items-start">
                            <a class="news-card-thumb flex-shrink-0" style="width:160px" href="#">
                                <img src="assets/images/news/news3.webp" alt="Size Golf Adidas" style="width:100%;height:auto;display:block;">
                            </a>
                            <div>
                                <h6 class="mb-1 fw-bold">
                                    <a href="#" class="text-decoration-none text-dark">Hướng dẫn chọn size quần áo Golf Adidas - Chuẩn size châu á</a>
                                </h6>
                                <p class="mb-0 text-muted">Hướng dẫn chọn size Quần áo golf adidas</p>
                            </div>
                        </article>
                    </div>

                    <!-- 3 -->
                    <div class="col-md-6">
                        <article class="d-flex gap-3 align-items-start">
                            <a class="news-card-thumb flex-shrink-0" style="width:160px" href="#">
                                <img src="assets/images/news/news4.webp" alt="Những lưu ý khi mua Surface cũ" style="width:100%;height:auto;display:block;">
                            </a>
                            <div>
                                <h6 class="mb-1 fw-bold"><a href="#" class="text-decoration-none text-dark">Những lưu ý khi mua Surface đã qua sử dụng</a></h6>
                                <p class="mb-0 text-muted">Surface là dòng máy tính bảng kết hợp laptop của Microsoft, nổi bật với thiết kế sang trọng...</p>
                            </div>
                        </article>
                    </div>

                    <!-- 4 -->
                    <div class="col-md-6">
                        <article class="d-flex gap-3 align-items-start">
                            <a class="news-card-thumb flex-shrink-0" style="width:160px" href="#">
                                <img src="assets/images/news/news5.webp" alt="Máy quét mã vạch" style="width:100%;height:auto;display:block;">
                            </a>
                            <div>
                                <h6 class="mb-1 fw-bold"><a href="#" class="text-decoration-none text-dark">Phần mềm quét mã vạch có kiểm tra được hàng thật, hàng giả không?</a></h6>
                                <p class="mb-0 text-muted">Hiện nay xuất hiện rất nhiều sản phẩm nhái. Việc kiểm tra nguồn gốc xuất xứ bằng mã vạch...</p>
                            </div>
                        </article>
                    </div>

                    <!-- 5 -->
                    <div class="col-md-6">
                        <article class="d-flex gap-3 align-items-start">
                            <a class="news-card-thumb flex-shrink-0" style="width:160px" href="#">
                                <img src="assets/images/news/news6.webp" alt="Vệ sinh giày Adidas" style="width:100%;height:auto;display:block;">
                            </a>
                            <div>
                                <h6 class="mb-1 fw-bold"><a href="#" class="text-decoration-none text-dark">Cách vệ sinh, giặt giày Adidas đúng chuẩn từ hãng, sạch như mới</a></h6>
                                <p class="mb-0 text-muted">Giày Adidas nổi tiếng bền đẹp; vệ sinh đúng cách giúp kéo dài tuổi thọ và giữ form chuẩn...</p>
                            </div>
                        </article>
                    </div>

                    <!-- 6 -->
                    <div class="col-md-6">
                        <article class="d-flex gap-3 align-items-start">
                            <a class="news-card-thumb flex-shrink-0" style="width:160px" href="#">
                                <img src="assets/images/news/news7.webp" alt="True size là gì" style="width:100%;height:auto;display:block;">
                            </a>
                            <div>
                                <h6 class="mb-1 fw-bold"><a href="#" class="text-decoration-none text-dark">True Size là gì? Cách chọn size giày chuẩn</a></h6>
                                <p class="mb-0 text-muted">Một trong những điều khó nhất khi chọn sneaker là chọn đúng size. Dưới đây là mẹo đo chân và chọn size...</p>
                            </div>
                        </article>
                    </div>

                </div>

                <!-- Pagination -->
                <nav class="mt-4 d-flex justify-content-end">
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item active">
                            <a class="page-link bg-danger border-danger" href="#">1</a>
                        </li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item"><a class="page-link" href="#">4</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#" aria-label="Next"><i class="bi bi-chevron-right"></i></a>
                        </li>
                    </ul>
                </nav>
            </div>

        </section>
    </div>
</div>

<!-- ===== Footer (giữ nguyên cấu trúc như trang của bạn) ===== -->
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
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Giày Bóng rổ</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Giày Tennis</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h5 class="text-uppercase mb-3">CHÍNH SÁCH</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="news.html" class="text-light text-decoration-none">THÔNG TIN ĐIỆN TỬ</a></li>
                    <li class="mb-2"><a href="shipping_policy.html" class="text-light text-decoration-none">Chính sách vận chuyển</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Chính sách đổi trả</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Hướng dẫn đặt hàng</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Thông tin thanh toán</a></li>
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
    /* Tooltips */
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(el => new bootstrap.Tooltip(el));

     /*Hiệu ứng focus search*/
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
    const getCart  = () => JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
    const saveCart = (items) => localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
    const fmtVND   = n => (n||0).toLocaleString('vi-VN') + '₫';

    function addToCart(item){
        const cart = getCart();
        const found = cart.find(p => p.id === item.id);
        if (found) found.qty = (found.qty || 1) + (item.qty || 1);
        else cart.push({ ...item, qty: item.qty || 1 });
        saveCart(cart);
        updateCartCount();
    }

    function updateCartCount(){
        const total = getCart().reduce((s, it) => s + (it.qty || 1), 0);
        const badge = qs('#cartCount');
        if (badge){
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
