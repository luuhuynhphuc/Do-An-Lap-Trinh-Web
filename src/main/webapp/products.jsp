<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="com.japansport.model.Product" %>
<%@ page import="com.japansport.model.Category" %>
<%@ page import="com.japansport.model.Brand" %>
<%
    List<Product> list = (List<Product>) request.getAttribute("listProduct");
    if (list == null) {
        response.sendRedirect(request.getContextPath() + "/list-product");
        return;
    }
    List<Category> categoryList = (List<Category>) request.getAttribute("categoryList");
    String selectedCategoryId = (String) request.getAttribute("selectedCategoryId");
    String selectedSort = (String) request.getAttribute("selectedSort");

    List<Brand> brandList = (List<Brand>) request.getAttribute("brandList");

    String[] selectedBrandIdsArr = (String[]) request.getAttribute("selectedBrandIds");
    Set<String> selectedBrandIdSet = new HashSet<>();
    if (selectedBrandIdsArr != null) {
        selectedBrandIdSet.addAll(Arrays.asList(selectedBrandIdsArr));
    }

    // Phân trang
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    Integer totalProductsObj = (Integer) request.getAttribute("totalProducts");

    int currentPage = (currentPageObj != null) ? currentPageObj : 1;
    int totalPages = (totalPagesObj != null) ? totalPagesObj : 0;
    int totalProducts = (totalProductsObj != null) ? totalProductsObj : list.size();

    // Từ khoá search
    String keywordAttr = (String) request.getAttribute("keyword");

    // Các khoảng giá đang được chọn (từ controller gửi xuống)
    String[] selectedPricesArr = (String[]) request.getAttribute("selectedPrices");
    Set<String> selectedPriceSet = new HashSet<>();
    if (selectedPricesArr != null) {
        selectedPriceSet.addAll(Arrays.asList(selectedPricesArr));
    }

    String ctx = request.getContextPath();
%>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Japan Sport - Tất cả sản phẩm</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css"
          rel="stylesheet"/>
    <!-- App CSS -->
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>

<!-- ===== Banner  ===== -->
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

<!-- ===== Breadcrumb + Title ===== -->
<div class="bg-light py-3 border-bottom">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0 justify-content-center">
                <li class="breadcrumb-item"><a href="index.jsp">Trang chủ</a></li>
                <li class="breadcrumb-item active text-danger" aria-current="page">Tất cả sản phẩm</li>
            </ol>
        </nav>
    </div>
</div>

<div class="container my-4">
    <h2 class="text-center text-danger fw-bold mb-4">Tất cả sản phẩm</h2>

    <div class="row">
        <!-- ===== Sidebar ===== -->
        <aside class="col-lg-3 mb-4">
            <div class="widget-box mb-4">
                <div class="widget-title">DANH MỤC SẢN PHẨM</div>
                <ul class="category-list list-unstyled mb-0">

                    <!-- Tất cả -->
                    <li>
                        <a href="<%= ctx %>/list-product"
                           class="<% if (selectedCategoryId == null) { %>fw-bold text-danger<% } %>">
                            Tất cả sản phẩm
                        </a>
                        <i class="bi bi-chevron-right"></i>
                    </li>

                    <%
                        if (categoryList != null) {
                            for (Category c : categoryList) {
                                boolean active = (selectedCategoryId != null) &&
                                        selectedCategoryId.equals(String.valueOf(c.getId()));
                    %>
                    <li>
                        <a href="<%= ctx %>/list-product?categoryId=<%= c.getId() %>"
                           class="<% if (active) { %>fw-bold text-danger<% } %>">
                            <%= c.getName() %>
                        </a>
                        <i class="bi bi-chevron-right"></i>
                    </li>
                    <% }
                    }
                    %>
                </ul>
            </div>

            <!-- FORM LỌC (THƯƠNG HIỆU + MỨC GIÁ + LOẠI SẢN PHẨM) -->
            <form method="get" action="<%= ctx %>/list-product">

                <!-- giữ lại category, sort, keyword hiện tại -->
                <% if (selectedCategoryId != null && !selectedCategoryId.isEmpty()) { %>
                <input type="hidden" name="categoryId" value="<%= selectedCategoryId %>">
                <% } %>
                <% if (selectedSort != null && !selectedSort.isEmpty()) { %>
                <input type="hidden" name="sort" value="<%= selectedSort %>">
                <% } %>
                <% if (keywordAttr != null && !keywordAttr.isEmpty()) { %>
                <input type="hidden" name="keyword" value="<%= keywordAttr %>">
                <% } %>

                <!-- THƯƠNG HIỆU  -->
                <div class="widget-box mb-4">
                    <div class="widget-title">THƯƠNG HIỆU</div>
                    <div class="brand-list">
                        <% if (brandList != null) {
                            for (Brand b : brandList) { %>
                        <label class="form-check">
                            <input class="form-check-input"
                                   type="checkbox"
                                   name="brandId"
                                   value="<%= b.getId() %>"
                                <%= selectedBrandIdSet.contains(String.valueOf(b.getId())) ? "checked" : "" %>>
                            <span class="form-check-label"><%= b.getName() %></span>
                        </label>
                        <% }
                        } else { %>
                        <p class="text-muted mb-0">Chưa có thương hiệu nào.</p>
                        <% } %>
                    </div>
                </div>

                <!-- MỨC GIÁ -->
                <div class="widget-box mb-4">
                    <div class="widget-title">MỨC GIÁ</div>
                    <div class="brand-list">
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="0-500"
                                <%= selectedPriceSet.contains("0-500") ? "checked" : "" %>>
                            <span class="form-check-label">Giá dưới 500.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="500-1000"
                                <%= selectedPriceSet.contains("500-1000") ? "checked" : "" %>>
                            <span class="form-check-label">500.000đ - 1.000.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="1000-1500"
                                <%= selectedPriceSet.contains("1000-1500") ? "checked" : "" %>>
                            <span class="form-check-label">1.000.000đ - 1.500.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="1500-2000"
                                <%= selectedPriceSet.contains("1500-2000") ? "checked" : "" %>>
                            <span class="form-check-label">1.500.000đ - 2.000.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="2000-2500"
                                <%= selectedPriceSet.contains("2000-2500") ? "checked" : "" %>>
                            <span class="form-check-label">2.000.000đ - 2.500.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="2500-3000"
                                <%= selectedPriceSet.contains("2500-3000") ? "checked" : "" %>>
                            <span class="form-check-label">2.500.000đ - 3.000.000đ</span>
                        </label>
                        <label class="form-check">
                            <input class="form-check-input" type="checkbox" name="price" value="3000+"
                                <%= selectedPriceSet.contains("3000+") ? "checked" : "" %>>
                            <span class="form-check-label">Giá trên 3.000.000đ</span>
                        </label>
                    </div>
                </div>

                <!-- LOẠI SẢN PHẨM (UI, chưa có cột type trong DB) -->
                <div class="widget-box">
                    <div class="widget-title">LOẠI SẢN PHẨM</div>
                    <div class="brand-list">
                        <!-- giữ nguyên các checkbox loại sản phẩm hiện có -->
                    </div>
                </div>

                <button type="submit" class="btn btn-danger w-100 mt-3">
                    Lọc sản phẩm
                </button>
            </form>

        </aside>

        <!-- ===== Product list ===== -->
        <section class="col-lg-9">
            <!-- sort line -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="mb-0">TẤT CẢ SẢN PHẨM</h4>

                <form method="get" action="<%= ctx %>/list-product" class="d-flex align-items-center gap-2">
                    <%-- Giữ lại categoryId nếu đang lọc theo danh mục --%>
                    <% if (selectedCategoryId != null) { %>
                    <input type="hidden" name="categoryId" value="<%= selectedCategoryId %>">
                    <% } %>

                    <label for="sortSelect" class="me-1 fw-semibold" style="white-space: nowrap;">Sắp xếp:</label>
                    <select id="sortSelect" name="sort" class="form-select form-select-sm"
                            onchange="this.form.submit()">
                        <option value=""
                                <% if (selectedSort == null || selectedSort.isEmpty()) { %>selected<% } %>>
                            Mặc định
                        </option>
                        <option value="newest"
                                <% if ("newest".equals(selectedSort)) { %>selected<% } %>>
                            Mới nhất
                        </option>
                        <option value="price_asc"
                                <% if ("price_asc".equals(selectedSort)) { %>selected<% } %>>
                            Giá tăng dần
                        </option>
                        <option value="price_desc"
                                <% if ("price_desc".equals(selectedSort)) { %>selected<% } %>>
                            Giá giảm dần
                        </option>
                    </select>
                </form>
            </div>

            <% if (keywordAttr != null && !keywordAttr.isEmpty()) { %>
            <p class="text-muted mb-3">
                Kết quả tìm kiếm cho:
                <strong><%= keywordAttr %>
                </strong>
            </p>
            <% } %>

            <div class="row g-4">
                    <% for (Product p : list) { %>
                <!-- card sản phẩm -->
                    <% } %>


                <%-- ==== BẮT ĐẦU GRID DANH SÁCH ==== --%>
                <div class="row g-4">
                    <% if (list.isEmpty()) { %>
                    <div class="col-12">
                        <div class="alert alert-warning mb-0">Chưa có sản phẩm nào.</div>
                    </div>
                    <% } else { %>
                    <% for (Product p : list) { %>
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="product-card h-100 d-flex flex-column">

                            <%-- RIBBON (giữ nguyên nếu bạn có) --%>
                            <span class="ribbon">SALE</span>

                            <%-- ẢNH: GIỮ CLASS product-thumb, chỉ thêm khung tỉ lệ để đồng đều --%>
                            <a class="product-thumb ratio ratio-1x1 mb-0"
                               href="<%= ctx %>/product?id=<%= p.getId() %>">
                                <img src="<%= p.getImage_url() %>" alt="<%= p.getName() %>" class="img-cover">
                                
                            </a>

                            <div class="p-3 d-flex flex-column flex-fill">
                                <%-- TÊN: giữ class product-title, clamp 2 dòng để không vỡ hàng --%>
                                <h6 class="product-title line-clamp-2 mb-2">
                                    <a href="<%= ctx %>/product?id=<%= p.getId() %>"
                                       class="text-dark text-decoration-none">
                                        <%= p.getName() %>
                                    </a>

                                </h6>
                                <%-- GIÁ --%>
                                <div class="product-footer mt-auto d-flex justify-content-between align-items-end gap-2">
                                    <div class="product-price text-danger">
                                        <div class="price-now">
                                            <%= String.format("%,.0f", p.getPrice()) %>đ
                                        </div>
                                        <% if (p.getOld_price() > 0) { %>
                                        <div class="old-price">
                                            <del>
                                                <%= String.format("%,.0f", p.getOld_price()) %>đ
                                            </del>
                                        </div>
                                        <% } %>
                                    </div>

                                    <a class="btn btn-danger btn-sm px-3" href="<%= ctx %>/product?id=<%= p.getId() %>">Chi
                                        tiết</a>
                                </div>

                            </div>
                        </div>
                    </div>
                    <% } %>
                    <% } %>
                </div>
                <%-- ==== HẾT GRID ==== --%>

                <!-- Pagination -->
                    <%
                // Xây query string giữ lại category, sort, keyword
                StringBuilder baseQuery = new StringBuilder();
                if (selectedCategoryId != null && !selectedCategoryId.isEmpty()) {
                    baseQuery.append("&categoryId=").append(selectedCategoryId);
                }
                if (selectedSort != null && !selectedSort.isEmpty()) {
                    baseQuery.append("&sort=").append(selectedSort);
                }
                if (keywordAttr != null && !keywordAttr.isEmpty()) {
                    baseQuery.append("&keyword=").append(keywordAttr);
                }
            %>
                    <% if (totalPages > 1) { %>
                <nav class="mt-4" aria-label="Pagination">
                    <ul class="pagination justify-content-center">

                        <!-- Previous -->
                        <li class="page-item <%= (currentPage <= 1) ? "disabled" : "" %>">
                            <a class="page-link"
                               href="<%= ctx %>/list-product?page=<%= currentPage - 1 %><%= baseQuery.toString() %>"
                               aria-label="Previous">
                                &laquo;
                            </a>
                        </li>

                        <!-- Các số trang -->
                        <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                            <a class="page-link"
                               href="<%= ctx %>/list-product?page=<%= i %><%= baseQuery.toString() %>">
                                <%= i %>
                            </a>
                        </li>
                        <% } %>

                        <!-- Next -->
                        <li class="page-item <%= (currentPage >= totalPages) ? "disabled" : "" %>">
                            <a class="page-link"
                               href="<%= ctx %>/list-product?page=<%= currentPage + 1 %><%= baseQuery.toString() %>"
                               aria-label="Next">
                                &raquo;
                            </a>
                        </li>
                    </ul>
                </nav>
                    <% } %>
        </section>
    </div>
</div>
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

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<script>
    /* =========================================================================
       CART CORE (LocalStorage: 'cartItems')
       ========================================================================= */
    const STORAGE_KEY = 'cartItems';
    const getCart = () => JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
    const saveCart = (items) => localStorage.setItem(STORAGE_KEY, JSON.stringify(items));

    document.querySelectorAll('.add-to-cart').forEach(btn => {
        btn.addEventListener('click', () => {
            const item = {
                id: btn.dataset.id,
                title: btn.dataset.title,
                price: Number(btn.dataset.price || 0),
                image: btn.dataset.image || '',
                qty: 1
            };

            const cart = getCart();
            const found = cart.find(p => p.id === item.id);
            if (found) found.qty += 1; else cart.push(item);
            saveCart(cart);

            // chuyển đến giỏ hàng
            window.location.href = 'cart.html';
        });
    });

    function updateCartCount() {
        const items = JSON.parse(localStorage.getItem('cartItems') || '[]');
        const total = items.reduce((sum, it) => sum + (it.qty || 1), 0);
        const badge = document.getElementById('cartCount');
        if (badge) {
            badge.textContent = total;
            badge.style.display = total > 0 ? 'inline-block' : 'none';
        }
    }

    // chạy khi load
    document.addEventListener('DOMContentLoaded', updateCartCount);

    // Tooltips (giống index)
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(el => new bootstrap.Tooltip(el));


</script>
</body>
</html>