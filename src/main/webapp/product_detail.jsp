<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.japansport.model.Product" %>
<%@ page import="com.japansport.model.Brand" %>
<%@ page import="com.japansport.model.ProductVariant" %>
<%@ page import="com.japansport.dao.ProductVariantDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="com.japansport.model.ProductSpec" %>
<%@ page import="com.japansport.model.ProductImage" %>


<%!
    private static String escapeJs(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    // Escape HTML (để description dạng text không phá layout)
    private static String escapeHtml(String s) {
        if (s == null) return "";
        String out = s;
        out = out.replace("&", "&amp;");
        out = out.replace("<", "&lt;");
        out = out.replace(">", "&gt;");
        out = out.replace("\"", "&quot;");
        out = out.replace("'", "&#39;");
        return out;
    }

    /**
     * Render mô tả sản phẩm:
     * - Nếu description có vẻ là HTML (có <...>) thì render thẳng
     * - Nếu là text thường thì escape + xuống dòng thành <br/>
     */
    private static String renderProductDesc(String s) {
        if (s == null) return "";
        String t = s.trim();
        if (t.isEmpty()) return "";

        boolean looksLikeHtml = t.contains("<") && t.contains(">"); // không dùng regex/backslash để tránh lỗi JSP
        if (looksLikeHtml) return t;

        return escapeHtml(t)
                .replace("\r\n", "<br/>")
                .replace("\n", "<br/>")
                .replace("\r", "<br/>");
    }
%>

<%
    Product p = (Product) request.getAttribute("product");
    if (p == null) {
        response.sendRedirect(request.getContextPath() + "/list-product");
        return;
    }
    String ctx = request.getContextPath();

    // ===== VARIANTS (color/size) + STOCK =====
    // Ưu tiên dữ liệu được set từ Servlet: request.setAttribute("variants", List<ProductVariant>)
    List<ProductVariant> variants = null;
    try {
        Object vObj = request.getAttribute("variants");
        if (vObj instanceof List) {
            variants = (List<ProductVariant>) vObj;
        }
    } catch (Exception ignore) {
    }

    if (variants == null) {
        // Fallback: tự query DB (tạm thời cho bạn test nhanh). Prodev: nên query ở Servlet rồi forward.
        try {
            ProductVariantDAO variantDAO = new ProductVariantDAO();
            variants = variantDAO.findByProductId(p.getId());
        } catch (Exception e) {
            variants = Collections.emptyList();
        }
    }
    if (variants == null) variants = Collections.emptyList();

    int totalStock = 0;
    for (ProductVariant v : variants) {
        totalStock += Math.max(0, v.getStockQty());
    }
    List<ProductSpec> specs = (List<ProductSpec>) request.getAttribute("specs");
    List<ProductImage> allImages = null;
    try {
        Object imgObj = request.getAttribute("images");
        if (imgObj instanceof List) allImages = (List<ProductImage>) imgObj;
    } catch (Exception ignore) {
    }
    if (allImages == null) allImages = Collections.emptyList();

// Ảnh main ban đầu (để trang không trống)
// (Cách 1: DB lưu link http/https nên src dùng thẳng)
    ProductImage initMain = null;
    for (ProductImage im : allImages) {
        if (im != null && im.isMainImage()) {
            initMain = im;
            break;
        }
    }
    if (initMain == null && !allImages.isEmpty()) initMain = allImages.get(0);

    String initMainUrl = (initMain != null && initMain.getImageUrl() != null && !initMain.getImageUrl().isBlank())
            ? initMain.getImageUrl()
            : p.getImage_url();

    String initMainAlt = (initMain != null && initMain.getAlt() != null && !initMain.getAlt().isBlank())
            ? initMain.getAlt()
            : p.getName();

%>


<!DOCTYPE html>
<html lang="vi" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title><%= p.getName() %> - Japan Sport</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet"/>
    <!-- App CSS -->
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>

<!-- ===== Banner giống index ===== -->
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

            <!-- Contact / Actions -->
            <div class="col-lg-4 col-md-4">
                <div class="d-flex justify-content-end align-items-center gap-2">
                    <a href="tel:0984843218" class="btn btn-outline-danger rounded-pill px-3 d-none d-lg-inline">
                        Tư vấn bán hàng <strong class="ms-2">0984843218</strong>
                    </a>
                    <button class="btn header-icon-btn" title="Gọi"><i class="bi bi-telephone"></i></button>
                    <button class="btn header-icon-btn" data-bs-toggle="tooltip" title="Tài khoản"
                            aria-label="Tài khoản">
                        <a href="<%=ctx%>/login.jsp"><i class="bi bi-person"></i></a>
                    </button>
                    <a href="<%=ctx%>/cart"
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
                            <a class="dropdown-item dropdown-toggle" href="products.jsp">SẢN PHẨM</a>
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

<!-- ===== Breadcrumb ===== -->

<div class="bg-light py-2">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0 justify-content-center">
                <!-- Trang chủ -->
                <li class="breadcrumb-item">
                    <a href="<%= ctx %>/">Trang chủ</a>
                </li>

                <!-- Trang danh sách sản phẩm -->
                <li class="breadcrumb-item">
                    <a href="<%= ctx %>/list-product">Sản phẩm</a>
                </li>

                <!-- Thương hiệu (nếu có) -->
                <li class="breadcrumb-item">
                    <a href="#">
                        <%= (p.getBrand() != null) ? p.getBrand().getName() : "" %>
                    </a>
                </li>

                <!-- Sản phẩm hiện tại -->
                <li class="breadcrumb-item active text-danger" aria-current="page">
                    <%= p.getName() %>
                </li>
            </ol>
        </nav>
    </div>
</div>


<!-- ===== Product Detail Content ===== -->
<div class="container my-4">
    <div class="row">
        <h1 class="text-danger fw-bold mb-3 d-flex justify-content-center">
            <%= (p.getBrand() != null) ? p.getBrand().getName() : "" %>
        </h1>
        <!-- LEFT: Gallery + Zoom Preview -->
        <div class="col-xl-5 col-lg-5">
            <div class="product-zoom-wrap">
                <!-- Ảnh chính -->
                <div class="product-gallery">
                    <div class="main-image mb-3">
                        <img id="mainImage" src="<%= initMainUrl %>" alt="<%= initMainAlt %>"
                             class="img-fluid w-100 border rounded">
                        <div id="zoomPreview" class="zoom-preview" aria-hidden="true"></div>
                        <div id="zoomLens" class="zoom-lens"></div>
                    </div>

                    <div class="d-flex align-items-center gap-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="prevThumb()" aria-label="Previous">
                            <i class="bi bi-chevron-left"></i>
                        </button>

                        <div class="thumbnails-wrapper flex-grow-1 overflow-hidden">
                            <div class="thumbnails d-flex flex-nowrap gap-2">
                                <%
                                    int maxThumb = 6;
                                    int count = 0;

                                    if (allImages != null && !allImages.isEmpty()) {
                                        for (ProductImage im : allImages) {
                                            if (im == null || im.getImageUrl() == null || im.getImageUrl().isBlank())
                                                continue;
                                            String u = im.getImageUrl();
                                            String a = (im.getAlt() != null && !im.getAlt().isBlank()) ? im.getAlt() : p.getName();
                                %>
                                <img src="<%= u %>" alt="<%= a %>"
                                     class="thumbnail <%= (count==0 ? "active" : "") %>"
                                     onclick="changeImage(this)">
                                <%
                                            count++;
                                            if (count >= maxThumb) break;
                                        }
                                    }

                                    if (count == 0) {
                                %>
                                <img src="<%= p.getImage_url() %>" alt="<%= p.getName() %>"
                                     class="thumbnail active" onclick="changeImage(this)">
                                <%
                                    }
                                %>
                            </div>
                        </div>

                        <button class="btn btn-sm btn-outline-secondary" onclick="nextThumb()" aria-label="Next">
                            <i class="bi bi-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- RIGHT: Info rộng hơn + Sidebar -->
        <div class="col-xl-7 col-lg-7">
            <div class="row g-3 align-items-start">
                <!-- Product Info: 8/12 -->
                <div class="col-xl-8 col-lg-8 order-2 order-lg-1" data-info-col>
                    <div class="product-info">
                        <h2 class="h4 mb-3"><%= p.getName() %>
                        </h2>
                        <div class="mb-3">
                            <span class="text-muted">Thương hiệu: </span>
                            <a href="#" class="text-primary text-decoration-none">
                                <%= (p.getBrand() != null) ? p.getBrand().getName() : "" %>
                            </a>
                            <span class="text-muted ms-3">| Kho: </span>
                            <span class="text-primary" id="stockText">
                                <%= (totalStock > 0) ? "Còn hàng" : "Hết hàng" %>
                            </span>
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
                            <h3 class="text-danger fw-bold fs-2 mb-2">
                                <%= String.format("%,.0f", p.getPrice()) %>đ
                                <% if (p.getOld_price() > 0) { %>
                                <span class="text-muted text-decoration-line-through fs-5 ms-2">
                                    <%= String.format("%,.0f", p.getOld_price()) %>đ
                                    </span>
                                <% } %>
                            </h3>
                            <div class="alert alert-danger">
                                <span>Hàng xách tay Nhật, Fullbox, Cam kết 100% chính hãng, Phát hiện hàng giả xin đền
                                    10 lần tiền.</span>
                            </div>
                            <p class="text-black fw-bold mb-2">Ship COD toàn quốc | Miễn phí đổi size, đổi màu trong 1
                                tuần !!!</p>
                            <p class="text-primary fw-bold">Địa chỉ: Lotus 4, Vinhome Gardenia, Hàm Nghi, Từ Liêm,
                                HN</p>
                            <p class="text-primary fw-bold">SĐT liên hệ: 0984843218 0977179889</p>
                        </div>


                        <!-- ===== CHỌN MÀU / SIZE + SỐ LƯỢNG (DYNAMIC) ===== -->
                        <div class="product-variant-box mb-4">
                            <div class="fw-bold">KÍCH THƯỚC :</div>
                            <div id="sizeOptions" class="size-selector"></div>

                            <div class="fw-bold mt-3">MÀU SẮC :</div>
                            <div id="colorOptions" class="color-selector"></div>

                            <div class="fw-bold mt-3">SỐ LƯỢNG :</div>
                            <div class="quantity-selector">
                                <div id="variantStockHint" class="variant-stock-hint"></div>
                                <button class="qty-btn" type="button" id="qtyMinus">-</button>
                                <input type="number" class="qty-input" id="qtyInput" name="qty" value="1" min="1">
                                <button class="qty-btn" type="button" id="qtyPlus">+</button>
                            </div>
                            <!-- Hidden: variant info để add-to-cart -->
                            <input type="hidden" id="variantIdHidden" name="variantId" value="">
                            <%----%>
                            <form id="addToCartForm" method="post" action="<%=ctx%>/cart" style="display:none;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="<%=p.getId()%>">
                                <input type="hidden" name="variantId" id="formVariantId" value="">
                                <input type="hidden" name="qty" id="formQty" value="1">
                                <input type="hidden" name="buyNow" id="formBuyNow" value="0">
                            </form>
                            <input type="hidden" id="variantColorHidden" value="">
                            <input type="hidden" id="variantSizeHidden" value="">
                            <div class="small text-danger mt-2" id="variantError" style="display:none;"></div>
                        </div>
                        <!-- ===== /CHỌN MÀU / SIZE ===== -->
                        <%--có cần phải tạo trang riêng không--%>
                        <div class="action-buttons mb-100 d-flex justify-content-between">
                            <button type="button"
                                    id="btnBuyNowProduct"
                                    class="btn btn-danger btn-lg me-4 mb-5">
                                MUA NGAY
                                <small class="d-block">Giao Hàng Thanh Toán COD</small>
                            </button>

                            <button type="button"
                                    id="btnAddToCart"
                                    class="btn btn-lg mb-5 btn-danger add-to-cart">
                                Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Sidebar: 4/12 -->
                <div class="col-xl-4 col-lg-4 order-1 order-lg-2">
                    <aside class="features-sidebar sidebar-sticky">
                        <div class="feature-item d-flex align-items-start mb-3 p-3 bg-light rounded"> <!--Srv1-->
                            <div class="col-3 pt-2">
                                <img src="assets/images/footer/srv_1.png" alt="Service item" class="img-fluid rounded">
                            </div>
                            <div><h6 class="fw-bold mb-1">VẬN CHUYỂN SIÊU TỐC</h6>
                                <small class="text-muted">Vận chuyển nội thành HN trong 2 tiếng!</small></div>
                        </div>

                        <div class="feature-item d-flex align-items-start mb-3 p-3 bg-light rounded"> <!--Srv2-->
                            <div class="col-3 pt-2">
                                <img src="assets/images/footer/srv_2.png" alt="Service item" class="img-fluid rounded">
                            </div>
                            <div><h6 class="fw-bold mb-1">Đổi hàng</h6>
                                <small class="text-muted">Đổi hàng trong 7 ngày miễn phí!</small></div>
                        </div>

                        <div class="feature-item d-flex align-items-start mb-3 p-3 bg-light rounded"> <!--svr3-->
                            <div class=" col-3 pt-2">
                                <img src="assets/images/footer/srv_3.png" alt="Service item"
                                     class="img-fluid rounded   ">
                            </div>
                            <div><h6 class="fw-bold mb-1">Tiết kiệm thời gian</h6>
                                <small class="text-muted">Mua sắm dễ hơn khi online</small></div>
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
<%-- --%>

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
                        <img id="mImg" src="" alt=""
                             style="width:90px;height:90px;object-fit:cover;border-radius:10px;border:1px solid #eee"
                             class="me-3">
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
                            <!-- <small class="text-muted d-block text-center mt-2">Sẽ tự chuyển sang thanh toán sau 2 giây…</small>-->
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

<!-- ===== PRODUCT TABS ===== -->
<div class="container">
    <div class="row gx-4 mt-4 pt-1">
        <!-- Chiều rộng: bằng tổng Ảnh chính + Product Info, chừa ra phần sidebar -->
        <div class="col-xxl-9 col-xl-9 col-lg-12">
            <div class="product-tabs card border-0 shadow-sm">
                <ul class="nav nav-tabs px-3 pt-3" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-desc" type="button"
                                role="tab">
                            Mô tả sản phẩm
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-custom" type="button"
                                role="tab">
                            Tab tùy chỉnh
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-review" type="button"
                                role="tab">
                            Đánh giá
                        </button>
                    </li>
                </ul>

                <div class="tab-content p-4">
                    <!-- MÔ TẢ -->
                    <div class="tab-pane fade show active" id="tab-desc" role="tabpanel">
                        <h4 class="fw-bold mb-3"><%= p.getName() %>
                        </h4>

                        <%
                            // Mô tả từ DB (products.description)
                            String desc = (p.getDescription() == null) ? "" : p.getDescription().trim();

                            // Nếu mô tả không phải HTML thì xuống dòng cho đẹp
                            // (Nếu sau này bạn lưu mô tả dạng HTML từ admin thì nó vẫn hiển thị được bình thường)
                            boolean looksLikeHtml = desc.contains("<") && desc.contains(">");

                            if (!looksLikeHtml) {
                                // Escape HTML cơ bản để tránh lỗi hiển thị khi mô tả có ký tự đặc biệt
                                desc = desc.replace("&", "&amp;")
                                        .replace("<", "&lt;")
                                        .replace(">", "&gt;")
                                        .replace("\"", "&quot;")
                                        .replace("'", "&#39;");

                                // Convert newline -> <br>
                                desc = desc.replace("\r\n", "<br>")
                                        .replace("\n", "<br>")
                                        .replace("\r", "<br>");
                            }
                        %>

                        <div class="mb-0">
                            <%= desc.isEmpty() ? "Đang cập nhật mô tả sản phẩm." : desc %>
                        </div>
                        <%
                            if (specs != null && !specs.isEmpty()) {
                        %>
                        <hr class="my-4"/>
                        <h5 class="fw-bold mb-3">Chi tiết sản phẩm</h5>
                        <ul class="mb-0">
                            <%
                                for (ProductSpec s : specs) {
                                    String k = s.getSpecKey() == null ? "" : escapeHtml(s.getSpecKey());
                                    String v = s.getSpecValue() == null ? "" : escapeHtml(s.getSpecValue());
                            %>
                            <li><strong><%= k %>
                            </strong>: <%= v %>
                            </li>
                            <%
                                }
                            %>
                        </ul>
                        <%
                            }
                        %>
                    </div>


                    <!-- TÙY CHỈNH -->
                    <div class="tab-pane fade" id="tab-custom" role="tabpanel">
                        <p class="mb-0">Nội dung tùy chỉnh (bảo hành, phụ kiện kèm theo, hướng dẫn sử dụng…) – bạn thay
                            theo nhu cầu.</p>
                    </div>

                    <!-- ĐÁNH GIÁ -->
                    <div class="tab-pane fade" id="tab-review" role="tabpanel">
                        <%
                            // Check login (an toàn – không phụ thuộc class User cụ thể)
                            Object u = session.getAttribute("user");
                            if (u == null) u = session.getAttribute("account");
                            if (u == null) u = session.getAttribute("acc");
                            boolean loggedIn = (u != null);
                        %>

                        <div id="reviewSection" class="review-wrap my-4"
                             data-product-id="<%= p.getId() %>"
                             data-api="<%= request.getContextPath() %>/api/reviews"
                             data-submit-api="<%= request.getContextPath() %>/api/reviews/add"
                             data-logged-in="<%= (session.getAttribute("user") != null) ? "1" : "0" %>">
                            <!-- 1) Tổng quan đánh giá -->
                            <div class="row g-4 align-items-stretch">
                                <div class="col-lg-4">
                                    <div class="border rounded-3 p-3 h-100 bg-light">
                                        <div class="d-flex align-items-end gap-2">
                                            <div class="display-6 fw-bold mb-0" id="rvAvg">0.0</div>
                                            <div class="text-muted mb-2">/5</div>
                                        </div>

                                        <div class="text-warning fs-5 mt-1" id="rvAvgStars"></div>
                                        <div class="text-muted small mt-1" id="rvCountText">0 đánh giá</div>
                                    </div>
                                </div>

                                <div class="col-lg-8">
                                    <div class="border rounded-3 p-3 h-100">
                                        <div class="vstack gap-2">
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="text-nowrap" style="width:48px;">5<i
                                                        class="bi bi-star-fill text-warning ms-1"></i></div>
                                                <div class="progress flex-grow-1" style="height:10px;">
                                                    <div class="progress-bar bg-warning" id="rvBar5"
                                                         style="width:0%"></div>
                                                </div>
                                                <div class="text-end" style="width:42px;" id="rvCnt5">0</div>
                                            </div>

                                            <div class="d-flex align-items-center gap-2">
                                                <div class="text-nowrap" style="width:48px;">4<i
                                                        class="bi bi-star-fill text-warning ms-1"></i></div>
                                                <div class="progress flex-grow-1" style="height:10px;">
                                                    <div class="progress-bar bg-warning" id="rvBar4"
                                                         style="width:0%"></div>
                                                </div>
                                                <div class="text-end" style="width:42px;" id="rvCnt4">0</div>
                                            </div>

                                            <div class="d-flex align-items-center gap-2">
                                                <div class="text-nowrap" style="width:48px;">3<i
                                                        class="bi bi-star-fill text-warning ms-1"></i></div>
                                                <div class="progress flex-grow-1" style="height:10px;">
                                                    <div class="progress-bar bg-warning" id="rvBar3"
                                                         style="width:0%"></div>
                                                </div>
                                                <div class="text-end" style="width:42px;" id="rvCnt3">0</div>
                                            </div>

                                            <div class="d-flex align-items-center gap-2">
                                                <div class="text-nowrap" style="width:48px;">2<i
                                                        class="bi bi-star-fill text-warning ms-1"></i></div>
                                                <div class="progress flex-grow-1" style="height:10px;">
                                                    <div class="progress-bar bg-warning" id="rvBar2"
                                                         style="width:0%"></div>
                                                </div>
                                                <div class="text-end" style="width:42px;" id="rvCnt2">0</div>
                                            </div>

                                            <div class="d-flex align-items-center gap-2">
                                                <div class="text-nowrap" style="width:48px;">1<i
                                                        class="bi bi-star-fill text-warning ms-1"></i></div>
                                                <div class="progress flex-grow-1" style="height:10px;">
                                                    <div class="progress-bar bg-warning" id="rvBar1"
                                                         style="width:0%"></div>
                                                </div>
                                                <div class="text-end" style="width:42px;" id="rvCnt1">0</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 2) Filters + sort -->
                            <div class="d-flex flex-wrap align-items-center gap-2 mt-4">
                                <div class="btn-group" role="group" id="rvFilters">
                                    <button type="button" class="btn btn-outline-secondary active" data-rating="0">Tất
                                        cả
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary" data-rating="5">5<i
                                            class="bi bi-star-fill text-warning ms-1"></i></button>
                                    <button type="button" class="btn btn-outline-secondary" data-rating="4">4<i
                                            class="bi bi-star-fill text-warning ms-1"></i></button>
                                    <button type="button" class="btn btn-outline-secondary" data-rating="3">3<i
                                            class="bi bi-star-fill text-warning ms-1"></i></button>
                                    <button type="button" class="btn btn-outline-secondary" data-rating="2">2<i
                                            class="bi bi-star-fill text-warning ms-1"></i></button>
                                    <button type="button" class="btn btn-outline-secondary" data-rating="1">1<i
                                            class="bi bi-star-fill text-warning ms-1"></i></button>
                                </div>

                                <select class="form-select w-auto ms-lg-auto" id="rvSort">
                                    <option value="newest" selected>Mới nhất</option>
                                    <option value="highest">Cao nhất</option>
                                    <option value="lowest">Thấp nhất</option>
                                </select>
                            </div>

                            <!-- 3) Review list -->
                            <div class="mt-3" id="rvList">
                                <div class="text-muted">Đang tải đánh giá...</div>
                            </div>

                            <nav class="mt-3">
                                <ul class="pagination pagination-sm mb-0" id="rvPager"></ul>
                            </nav>

                            <!-- 4) Write review -->
                            <hr class="my-4"/>
                            <div id="rvWriteBox">
                                <div id="rvWriteNotice" class="mb-2"></div>

                                <form id="rvForm" class="border rounded-3 p-3 d-none">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>"/>
                                    <input type="hidden" name="rating" id="rvRatingInput" value="5"/>

                                    <div class="d-flex align-items-center gap-2 mb-2">
                                        <div class="fw-bold">Đánh giá của bạn:</div>
                                        <div class="text-warning fs-5" id="rvPickStars" style="cursor:pointer;">
                                            <i class="bi bi-star-fill" data-value="1"></i>
                                            <i class="bi bi-star-fill" data-value="2"></i>
                                            <i class="bi bi-star-fill" data-value="3"></i>
                                            <i class="bi bi-star-fill" data-value="4"></i>
                                            <i class="bi bi-star-fill" data-value="5"></i>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <textarea class="form-control" name="comment" rows="4"
                                                  placeholder="Tối thiểu 5 ký tự..." required></textarea>
                                    </div>

                                    <div class="d-flex align-items-center gap-2">
                                        <button type="submit" class="btn btn-danger">Gửi đánh giá</button>
                                        <div class="small text-muted">Demo front-end (sau này nối DB sẽ lưu thật).</div>
                                    </div>

                                    <div class="mt-2" id="rvFormMsg"></div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cột trống để giữ căn lề với sidebar -->
        <div class="col-xxl-3 col-xl-3 d-none d-xl-block"></div>
    </div>
</div>


<!-- ===== Service Features ===== -->
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

<!-- Contact floating buttons -->
<a href="tel:0984843218" class="btn btn-primary position-fixed bottom-0 start-0 m-4 rounded-circle"
   style="width:60px;height:60px;z-index:1000;display:flex;align-items:center;justify-content:center;"
   title="Gọi ngay" aria-label="Gọi ngay">
    <i class="bi bi-telephone fs-4"></i>
</a>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<script>
    // ===== VARIANTS DATA FROM SERVER =====
    // [{id, color, size, stock}]
    const VARIANTS = [
        <% for (int i = 0; i < variants.size(); i++) {
            ProductVariant v = variants.get(i);
            // Escape để nhúng an toàn vào chuỗi JavaScript
            String c = escapeJs(v.getColor());
            String s = escapeJs(v.getSize());
        %>
        {
            id: <%= v.getId() %>,
            color: "<%= c %>",
            size: "<%= s %>",
            stock: <%= v.getStockQty() %>
        }<%= (i < variants.size()-1) ? "," : "" %>
        <% } %>
    ];
</script>

<script>
    // ===== PRODUCT IMAGES FROM DB (URL http/https) =====
    const PRODUCT_IMAGES = [
        <% for (int i = 0; i < allImages.size(); i++) {
            ProductImage im = allImages.get(i);
            if (im == null) continue;
            String raw = im.getImageUrl();
            if (raw == null || raw.isBlank()) continue;

            String url = escapeJs(raw);
            String alt = escapeJs((im.getAlt() != null && !im.getAlt().isBlank()) ? im.getAlt() : p.getName());
            String color = escapeJs(im.getColor() != null ? im.getColor() : "");
        %>
        {
            url: "<%= url %>",
            alt: "<%= alt %>",
            color: "<%= color %>",
            isMain:<%= im.isMainImage() ? "true" : "false" %>,
            sort:<%= im.getSortOrder() %>
        }<%= (i < allImages.size()-1) ? "," : "" %>
        <% } %>
    ];

    function _normColor(s) {
        let x = String(s || '').trim().toLowerCase();
        if (!x) return '';

        // nếu DB lưu dạng mã màu
        if (x[0] === '#') {
            const h = x.slice(1);
            if (h === 'fff' || h === 'ffffff') return 'white';
            if (h === '000' || h === '000000') return 'black';
            return x;
        }

        // bỏ dấu tiếng Việt
        x = x.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
        x = x.replace(/\s+/g, ' ').trim();

        // map VN <-> EN
        const map = {
            'trang': 'white', 'white': 'white',
            'den': 'black', 'black': 'black',
            'xanh': 'blue', 'xanh duong': 'blue', 'blue': 'blue',
            'do': 'red', 'red': 'red',
            'xanh la': 'green', 'green': 'green',
            'xam': 'gray', 'grey': 'gray', 'gray': 'gray',
            'vang': 'yellow', 'yellow': 'yellow',
            'cam': 'orange', 'orange': 'orange',
            'hong': 'pink', 'pink': 'pink',
            'nau': 'brown', 'brown': 'brown'
        };

        return map[x] || x;
    }


    function _pickImagesByColor(colorName) {
        const target = _normColor(colorName);
        let list = [];

        if (target) list = PRODUCT_IMAGES.filter(x => _normColor(x.color) === target);
        if (!list.length) list = PRODUCT_IMAGES.filter(x => !_normColor(x.color)); // ảnh chung
        if (!list.length) list = PRODUCT_IMAGES.slice();

        list.sort((a, b) => {
            const ma = a.isMain ? 1 : 0, mb = b.isMain ? 1 : 0;
            if (ma !== mb) return mb - ma;
            return Number(a.sort || 0) - Number(b.sort || 0);
        });

        return list;
    }

    // ====== RENDER GALLERY (BỊ THIẾU NÊN CLICK MÀU KHÔNG ĐỔI ẢNH) ======
    window.setGalleryImages = function (list) {
        const images = Array.isArray(list) ? list : [];

        const main = document.getElementById('mainImage');
        const thumbs = document.querySelector('.thumbnails');
        const wrapper = document.querySelector('.thumbnails-wrapper');

        if (!main || !thumbs) return;

        // Update ảnh chính
        if (images.length > 0) {
            main.src = images[0].url;
            main.alt = images[0].alt || main.alt || '';
        }

        // Rebuild thumbnails
        thumbs.innerHTML = '';
        const maxThumb = 6;

        images.slice(0, maxThumb).forEach((im, idx) => {
            const img = document.createElement('img');
            img.src = im.url;
            img.alt = im.alt || '';
            img.className = 'thumbnail' + (idx === 0 ? ' active' : '');
            img.onclick = function () { window.changeImage(this); };
            thumbs.appendChild(img);
        });

        // reset scroll thumbnail
        if (wrapper) wrapper.scrollLeft = 0;
    };

    // các hàm đang được gọi bởi onclick trong HTML nhưng file hiện tại chưa định nghĩa
    window.changeImage = function (thumbEl) {
        const main = document.getElementById('mainImage');
        if (!main || !thumbEl) return;

        main.src = thumbEl.src;
        main.alt = thumbEl.alt || '';

        document.querySelectorAll('.thumbnail').forEach(t => t.classList.remove('active'));
        thumbEl.classList.add('active');
    };

    window.prevThumb = function () {
        const wrapper = document.querySelector('.thumbnails-wrapper');
        if (!wrapper) return;
        wrapper.scrollLeft -= 160;
    };

    window.nextThumb = function () {
        const wrapper = document.querySelector('.thumbnails-wrapper');
        if (!wrapper) return;
        wrapper.scrollLeft += 160;
    };

    window.__pendingGalleryColor = window.__pendingGalleryColor || '';
    window.updateGalleryByColor = function (colorName) {
        window.__pendingGalleryColor = colorName || '';
        const list = _pickImagesByColor(colorName);
        if (typeof window.setGalleryImages === 'function') {
            window.setGalleryImages(list);
        }
    };
</script>


<script>
    /* =========================
       VER PRO: Variant + Stock + Disable + Submit
       ========================= */

    // Helpers (chỉ 1 lần, không trùng tên)
    const qs = (sel, root = document) => root.querySelector(sel);
    const qsa = (sel, root = document) => Array.from(root.querySelectorAll(sel));

    // Đảm bảo có window.VARIANTS để các đoạn khác dùng thống nhất
    //  const VARIANTS = [...]
    try {
        if (typeof VARIANTS !== 'undefined') window.VARIANTS = VARIANTS;
    } catch (e) {
    }

    function updateCartCountFromServer() {
        fetch('<%=request.getContextPath()%>/cart?mode=count')
            .then(r => r.json())
            .then(data => {
                const badge = qs('#cartCount');
                if (!badge) return;
                const total = data.count || 0;
                badge.textContent = total;
                badge.style.display = total > 0 ? 'inline-block' : 'none';
            })
            .catch(() => {
            });
    }

    // map màu: nếu DB lưu #hex hoặc rgb(...) thì dùng luôn
    function colorToCss(name) {
        const n = String(name || '').trim();
        if (!n) return '#9e9e9e';

        if (/^#([0-9a-f]{3}|[0-9a-f]{6})$/i.test(n)) return n;
        if (/^rgb\(/i.test(n) || /^rgba\(/i.test(n)) return n;

        const k = n.toLowerCase();
        const map = {
            'black': '#000000', 'đen': '#000000',
            'white': '#ffffff', 'trắng': '#ffffff',
            'red': '#e53935', 'đỏ': '#e53935',
            'blue': '#1e88e5', 'xanh': '#1e88e5', 'xanh dương': '#1e88e5',
            'navy': '#0b1f46', 'xanh navy': '#0b1f46',
            'gray': '#9e9e9e', 'grey': '#9e9e9e', 'xám': '#9e9e9e',
            'beige': '#d7c4a3', 'kem': '#d7c4a3',
            'brown': '#6d4c41', 'nâu': '#6d4c41',
            'green': '#43a047', 'xanh lá': '#43a047',
            'yellow': '#fdd835', 'vàng': '#fdd835',
            'orange': '#fb8c00', 'cam': '#fb8c00',
            'pink': '#ec407a', 'hồng': '#ec407a'
        };
        return map[k] || '#9e9e9e';
    }

    function initVariantSelectorPro() {
        const VARS = Array.isArray(window.VARIANTS) ? window.VARIANTS : [];

        const sizeWrap  = qs('#sizeOptions');
        const colorWrap = qs('#colorOptions');

        const vidHidden = qs('#variantIdHidden');
        const errBox    = qs('#variantError');

        const colorHidden = qs('#variantColorHidden');
        const sizeHidden  = qs('#variantSizeHidden');

        const qtyInput = qs('#qtyInput');
        const btnMinus = qs('#qtyMinus');
        const btnPlus  = qs('#qtyPlus');

        const btnAdd = qs('#btnAddToCart');
        const btnBuy = qs('#btnBuyNowProduct');

        const hint = qs('#variantStockHint'); // dòng dưới số lượng

        if (!sizeWrap || !colorWrap || !qtyInput) return;

        const uniq = (arr) => Array.from(new Set((arr || []).map(x => String(x ?? '').trim()))).filter(Boolean);

        const sizesAll  = uniq(VARS.map(v => v.size))
            .sort((a,b)=> (Number(a)-Number(b)) || String(a).localeCompare(String(b),'vi'));
        const colorsAll = uniq(VARS.map(v => v.color));

        let selectedColor = '';
        let selectedSize  = '';

        const findVariant = (sz, cl) =>
            VARS.find(v => String(v.size).trim() === String(sz).trim()
                && String(v.color).trim() === String(cl).trim()) || null;

        const sumStockByColor = (cl) =>
            VARS.filter(v => String(v.color).trim() === String(cl).trim())
                .reduce((s,v)=> s + (Number(v.stock||0)||0), 0);

        const sumStockBySize = (sz) =>
            VARS.filter(v => String(v.size).trim() === String(sz).trim())
                .reduce((s,v)=> s + (Number(v.stock||0)||0), 0);

        // null = không có biến thể đó, 0 = có nhưng hết, >0 = còn
        const stockOf = (cl, sz) => {
            const v = findVariant(sz, cl);
            return v ? (Number(v.stock || 0) || 0) : null;
        };

        const pickFirstSizeForColor = (cl) =>
            sizesAll.find(sz => {
                const st = stockOf(cl, sz);
                return st != null && st > 0;
            }) || '';

        const pickFirstColorForSize = (sz) =>
            colorsAll.find(cl => {
                const st = stockOf(cl, sz);
                return st != null && st > 0;
            }) || '';

        function setButtonsEnabled(ok) {
            if (btnAdd) btnAdd.disabled = !ok;
            if (btnBuy) btnBuy.disabled = !ok;

            qtyInput.disabled = !ok;
            if (btnMinus) btnMinus.disabled = !ok;
            if (btnPlus)  btnPlus.disabled  = !ok;
        }

        function showError(msg) {
            if (!errBox) return;
            errBox.textContent = msg || '';
            errBox.style.display = msg ? 'block' : 'none';
        }

        function setHint(type, text) {
            if (!hint) return;
            hint.classList.remove('is-low','is-out');
            if (type) hint.classList.add(type);
            hint.textContent = text || '';
        }

        function clampQty(maxStock) {
            let q = parseInt(qtyInput.value || '1', 10);
            if (!Number.isFinite(q) || q < 1) q = 1;

            const max = Number(maxStock || 0);
            if (max > 0) q = Math.min(q, max);

            qtyInput.value = String(q);
            qtyInput.max = max > 0 ? String(max) : '1';
        }

        function renderSizes() {
            sizeWrap.innerHTML = '';

            sizesAll.forEach(sz => {
                let st, enabled, title;

                if (selectedColor) {
                    st = stockOf(selectedColor, sz);
                    enabled = (st != null && st > 0);
                    title = (st == null) ? 'Không có size này cho màu đã chọn' : (st <= 0 ? 'Hết hàng' : `Còn ${st}`);
                } else {
                    st = sumStockBySize(sz);
                    enabled = st > 0;
                    title = enabled ? `Còn ${st}` : 'Hết hàng';
                }

                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'size-option' + (String(sz) === String(selectedSize) ? ' active' : '') + (enabled ? '' : ' disabled');
                btn.textContent = String(sz);

                // badge
                const badge = document.createElement('span');
                badge.className = 'opt-stock';
                badge.textContent = String(st ?? 0);
                btn.appendChild(badge);

                btn.title = title;

                if (!enabled) btn.disabled = true;

                btn.addEventListener('click', () => {
                    if (btn.disabled) return;
                    selectedSize = sz;

                    // nếu đã chọn màu nhưng size này không còn (tránh edge-case) -> tự chọn màu còn hàng cho size
                    if (selectedColor) {
                        const x = stockOf(selectedColor, selectedSize);
                        if (x == null || x <= 0) selectedColor = pickFirstColorForSize(selectedSize);
                    } else {
                        // chưa chọn màu -> auto chọn màu còn hàng đầu tiên cho size
                        selectedColor = pickFirstColorForSize(selectedSize);
                    }

                    renderColors();
                    renderSizes();
                    syncState();
                });

                sizeWrap.appendChild(btn);
            });
        }

        function renderColors() {
            colorWrap.innerHTML = '';

            colorsAll.forEach(cl => {
                let st, enabled, title;

                if (selectedSize) {
                    st = stockOf(cl, selectedSize);
                    enabled = (st != null && st > 0);
                    title = (st == null) ? 'Không có màu này cho size đã chọn' : (st <= 0 ? 'Hết hàng' : `Còn ${st}`);
                } else {
                    st = sumStockByColor(cl);
                    enabled = st > 0;
                    title = enabled ? `Còn ${st}` : 'Hết hàng';
                }

                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'color-option' + (String(cl) === String(selectedColor) ? ' active' : '') + (enabled ? '' : ' disabled');
                btn.setAttribute('data-color-name', cl);
                btn.style.backgroundColor = colorToCss(cl);

                // trắng cho dễ nhìn
                const low = String(cl || '').trim().toLowerCase();
                if (low === 'white' || low === 'trắng') btn.style.boxShadow = 'inset 0 0 0 2px #ddd';

                // badge
                const badge = document.createElement('span');
                badge.className = 'opt-stock';
                badge.textContent = String(st ?? 0);
                btn.appendChild(badge);

                btn.title = title;

                if (!enabled) btn.disabled = true;

                btn.addEventListener('click', () => {
                    if (btn.disabled) return;

                    selectedColor = cl;

                    // đổi màu -> auto chọn size còn hàng đầu tiên của màu đó
                    const nextSize = pickFirstSizeForColor(selectedColor);
                    if (nextSize) selectedSize = nextSize;

                    renderColors();
                    renderSizes();
                    syncState();

                    // đổi màu -> đổi ảnh theo màu
                    if (typeof window.updateGalleryByColor === 'function') {
                        window.updateGalleryByColor(selectedColor);
                    }
                });

                colorWrap.appendChild(btn);
            });
        }

        function syncState() {
            if (colorHidden) colorHidden.value = selectedColor || '';
            if (sizeHidden)  sizeHidden.value  = selectedSize  || '';

            if (!selectedColor || !selectedSize) {
                if (vidHidden) vidHidden.value = '';
                setButtonsEnabled(false);
                clampQty(0);
                showError('');
                setHint('', 'Vui lòng chọn màu & size để xem tồn kho.');
                return;
            }

            const v = findVariant(selectedSize, selectedColor);
            if (!v) {
                if (vidHidden) vidHidden.value = '';
                setButtonsEnabled(false);
                clampQty(0);
                showError('Biến thể không tồn tại.');
                setHint('is-out', 'Phiên bản này không tồn tại.');
                return;
            }

            const stock = Number(v.stock || 0) || 0;
            if (vidHidden) vidHidden.value = String(v.id);

            if (stock <= 0) {
                setButtonsEnabled(false);
                clampQty(0);
                showError('Phiên bản bạn chọn đã hết hàng.');
                setHint('is-out', 'Phiên bản này đã hết hàng.');
                return;
            }

            setButtonsEnabled(true);
            clampQty(stock);
            showError('');

            if (stock <= 3) setHint('is-low', `Sắp hết: còn ${stock} đôi cho phiên bản này.`);
            else setHint('', `Còn ${stock} đôi cho phiên bản này.`);
        }

        // preselect: biến thể còn hàng đầu tiên
        const first = VARS.find(x => (Number(x.stock || 0) || 0) > 0) || VARS[0] || null;
        if (first) {
            selectedColor = first.color || '';
            selectedSize  = first.size  || '';
        }

        renderColors();
        renderSizes();
        syncState();

        // init gallery theo màu default
        if (selectedColor && typeof window.updateGalleryByColor === 'function') {
            window.updateGalleryByColor(selectedColor);
        }

        // qty +/- theo max đã clamp
        function changeQty(delta) {
            if (qtyInput.disabled) return;
            let q = parseInt(qtyInput.value || '1', 10);
            if (!Number.isFinite(q) || q < 1) q = 1;

            const max = parseInt(qtyInput.max || '9999', 10) || 9999;
            q = Math.max(1, Math.min(max, q + delta));
            qtyInput.value = String(q);
        }
        btnMinus?.addEventListener('click', () => changeQty(-1));
        btnPlus?.addEventListener('click', () => changeQty(+1));
    }


    function submitAddToCart(buyNow) {
        const variantId = String(qs('#variantIdHidden')?.value || '').trim();
        const qty = parseInt(qs('#qtyInput')?.value || '1', 10) || 1;

        const VARS = Array.isArray(window.VARIANTS) ? window.VARIANTS : [];
        if (VARS.length > 0 && !variantId) {
            const err = qs('#variantError');
            if (err) {
                err.textContent = 'Vui lòng chọn màu/size trước khi thêm vào giỏ.';
                err.style.display = 'block';
            }
            return;
        }

        qs('#formVariantId').value = variantId;
        qs('#formQty').value = String(Math.max(1, qty));
        qs('#formBuyNow').value = buyNow ? '1' : '0';
        qs('#addToCartForm').submit();
    }

    document.addEventListener('DOMContentLoaded', () => {
        updateCartCountFromServer();
        initVariantSelectorPro();

        qs('#btnAddToCart')?.addEventListener('click', (e) => {
            e.preventDefault();
            submitAddToCart(false);
        });

        qs('#btnBuyNowProduct')?.addEventListener('click', (e) => {
            e.preventDefault();
            submitAddToCart(true);
        });
    });
</script>

<script src="<%=request.getContextPath()%>/assets/js/review.js"></script>


</body>
</html>