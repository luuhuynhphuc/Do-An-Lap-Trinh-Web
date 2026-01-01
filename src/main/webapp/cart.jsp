<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.japansport.model.Cart" %>
<%@ page import="com.japansport.model.CartItem" %>
<%
    String ctx = request.getContextPath();

    Cart cart = (Cart) request.getAttribute("cart");
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");

    // Fallback để không vỡ nếu controller chưa set "cart"
    if (cart == null) {
        if (cartItems == null) cartItems = Collections.emptyList();
        cart = new Cart(0, 0, "ACTIVE", true, cartItems);
    } else {
        cartItems = cart.getItems();
    }

    double subtotal = cart.getSubtotal();
    int totalQty = cart.getTotalQty();

    String cartError = (String) session.getAttribute("cartError");
    session.removeAttribute("cartError");
%>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Japan Sport - Header với Bootstrap</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet"/>

    <!-- App CSS -->
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
<!-- Banner quảng cáo -->
<div class="topbar section hidden-xs hidden-sm">
    <a class="section block a-center" href="#">
        <img src="assets/images/banner.webp" alt="Siêu bão khuyến mãi cuối năm"
             style="width:100%;height:auto;display:flex;">
    </a>
</div>

<!-- Header -->
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
                    <a href="<%=ctx%>/cart" data-bs-toggle="tooltip" title="Giỏ hàng"
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
                    <a class="nav-link dropdown-toggle" href="<%=ctx%>/home">TRANG CHỦ</a>
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

<!-- Main Content -->
<main class="bg-light py-5">
    <div class="cart-container">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h1 class="cart-title">Giỏ hàng của bạn</h1>
            <a href="sanpham.html" class="continue-link btn btn-outline-dark">Tiếp tục mua hàng</a>
        </div>

        <!-- Cart Table -->
        <% if (cartError != null) { %>
        <div class="alert alert-danger"><%=cartError%></div>
        <% } %>

        <% if (cartItems.isEmpty()) { %>
        <div class="alert alert-info">Giỏ hàng đang trống.</div>
        <% } else { %>
        <div class="table-responsive bg-white rounded shadow-sm p-3">
            <table class="table align-middle mb-0">
                <thead>
                <tr>
                    <th style="width:120px">Sản phẩm</th>
                    <th>Tên</th>
                    <th style="width:140px">Giá</th>
                    <th style="width:260px">Số lượng</th>
                    <th style="width:140px">Thành tiền</th>
                    <th style="width:70px"></th>
                </tr>
                </thead>
                <tbody>
                <% for (CartItem it : cartItems) { %>
                <tr>
                    <td>
                        <img src="<%=it.getImageUrl()%>" style="width:90px;height:90px;object-fit:cover;border-radius:10px;">
                    </td>
                    <td>
                        <div class="fw-semibold"><%=it.getProductName()%></div>
                        <% if (it.getVariantId() != null) { %>
                        <div class="text-muted small">Màu: <%=it.getColor()%> | Size: <%=it.getSize()%></div>
                        <% } %>
                    </td>
                    <td><%=String.format("%,.0f", it.getUnitPrice())%>₫</td>
                    <td>
                        <form class="d-flex gap-2" method="post" action="<%=ctx%>/cart">
                            <input type="hidden" name="action" value="update"/>
                            <input type="hidden" name="cartItemId" value="<%=it.getCartItemId()%>"/>
                            <input type="number" class="form-control" style="max-width:110px"
                                   name="qty" min="1" value="<%=it.getQuantity()%>"/>
                            <button class="btn btn-outline-secondary" type="submit">Cập nhật</button>
                        </form>
                    </td>
                    <td><%=String.format("%,.0f", it.getSubtotal())%>₫</td>
                    <td>
                        <form method="post" action="<%=ctx%>/cart">
                            <input type="hidden" name="action" value="remove"/>
                            <input type="hidden" name="cartItemId" value="<%=it.getCartItemId()%>"/>
                            <button class="btn btn-outline-danger btn-sm" type="submit">X</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>



        <div class="row mt-4 g-4">
            <div class="col-lg-7">
                <form method="post" action="<%=ctx%>/cart" class="d-inline">
                    <input type="hidden" name="action" value="clear"/>
                    <button class="btn btn-outline-secondary" type="submit">
                        <i class="bi bi-trash3 me-1"></i> Xoá toàn bộ giỏ
                    </button>
                </form>

            </div>
            <div class="col-lg-5">
                <div class="totals-box">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span>Tạm tính</span>
                        <strong id="subtotal"><%=String.format("%,.0f", subtotal)%>₫</strong>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span>Phí vận chuyển</span>
                        <span id="shipping">0₫</span>
                    </div>
                    <div class="line my-3"></div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="fs-5">Thành tiền</span>
                        <strong class="fs-5" id="grandTotal"><%=String.format("%,.0f", subtotal)%>₫</strong>
                    </div>
                    <div class="mt-3 d-grid gap-2">
                        <button class="btn btn-danger checkout-btn" id="btnBuyNow">MUA NGAY - GIAO HÀNG THANH TOÁN
                        </button>
                        <a class="btn btn-primary checkout-btn" href="<%=request.getContextPath()%>/checkout">MUA NGAY</a>
                        <button class="btn btn-info checkout-btn text-white" id="btnInstallment">TRẢ GÓP QUA THẺ
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<!-- Features Service -->
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

<!-- Footer -->
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
                    <li class="mb-2"><a href="news.html" class="text-light text-decoration-none">THÔNG TIN ĐIỆN TỬ</a>
                    </li>
                    <li class="mb-2"><a href="news.html" class="text-light text-decoration-none">THÔNG TIN ĐIỆN TỬ</a></li>
                    <li class="mb-2"><a href="shipping_policy.html" class="text-light text-decoration-none">Chính sách vận chuyển</a></li>
                    <li class="mb-2"><a href="return_policy.html" class="text-light text-decoration-none">Chính sách đổi trả</a></li>
                    <li class="mb-2"><a href="ordering_instructions.html" class="text-light text-decoration-none">Hướng dẫn đặt hàng</a></li>
                    <li class="mb-2"><a href="payment_in4.html" class="text-light text-decoration-none">Thông tin thanh toán</a></li>
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


</body>
</html>
