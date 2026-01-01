<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.japansport.model.Cart" %>
<%@ page import="com.japansport.model.CartItem" %>
<%@ page import="com.japansport.model.User" %>
<%
    String ctx = request.getContextPath();

    Cart cart = (Cart) request.getAttribute("cart");
    List<CartItem> items = (List<CartItem>) request.getAttribute("cartItems");

    // Fallback để không vỡ nếu controller chưa set "cart"
    if (cart == null) {
        if (items == null) items = Collections.emptyList();
        cart = new Cart(0, 0, "ACTIVE", true, items);
    } else {
        items = cart.getItems();
    }

    User u = (User) session.getAttribute("currentUser");

    double subtotal = cart.getSubtotal();
    int totalQty = cart.getTotalQty();

    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Thanh toán</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="assets/css/style.css"/>
</head>
<body>
<div class="container-narrow">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <a href="<%=ctx%>/home" class="d-flex align-items-center gap-2 text-decoration-none">
            <img src="assets/images/logo.webp" alt="Japan Sport" class="logo"/>
        </a>
        <a href="<%=ctx%>/cart" class="text-decoration-none small">
            <i class="bi bi-chevron-left"></i> Quay về giỏ hàng
        </a>
    </div>

    <% if (errorMessage != null) { %>
    <div class="alert alert-danger"><%=errorMessage%></div>
    <% } %>

    <div class="row g-4">
        <div class="col-lg-7">
            <div class="panel">
                <div class="panel-body">
                    <h5 class="mb-3">Thông tin nhận hàng</h5>

                    <form id="checkoutForm" method="post" action="<%=ctx%>/checkout" novalidate>
                        <div class="row g-3">
                            <div class="col-12">
                                <input class="form-control" type="email" name="email"
                                       value="<%= (u!=null?u.getEmail():"") %>" placeholder="Email" required>
                                <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
                            </div>

                            <div class="col-12">
                                <input class="form-control" type="text" name="fullName"
                                       value="<%= (u!=null?u.getName():"") %>" placeholder="Họ và tên" required>
                                <div class="invalid-feedback">Vui lòng nhập họ và tên.</div>
                            </div>

                            <div class="col-12">
                                <input class="form-control" type="tel" name="phone" placeholder="Số điện thoại" required>
                                <div class="invalid-feedback">Vui lòng nhập số điện thoại.</div>
                            </div>

                            <div class="col-12">
                                <input class="form-control" type="text" name="addressLine" placeholder="Địa chỉ" required>
                                <div class="invalid-feedback">Vui lòng nhập địa chỉ.</div>
                            </div>

                            <div class="col-md-4">
                                <select class="form-select" name="city" required>
                                    <option value="">Tỉnh/Thành</option>
                                    <option>Hà Nội</option>
                                    <option>TP. Hồ Chí Minh</option>
                                    <option>Đà Nẵng</option>
                                    <option>Khác</option>
                                </select>
                                <div class="invalid-feedback">Chọn Tỉnh/Thành.</div>
                            </div>

                            <div class="col-md-4">
                                <input class="form-control" name="district" placeholder="Quận/Huyện" required>
                                <div class="invalid-feedback">Nhập Quận/Huyện.</div>
                            </div>

                            <div class="col-md-4">
                                <input class="form-control" name="ward" placeholder="Phường/Xã" required>
                                <div class="invalid-feedback">Nhập Phường/Xã.</div>
                            </div>
                        </div>

                        <div class="mt-4">
                            <h5 class="mb-2">Thanh toán</h5>
                            <div class="form-check border rounded p-3 mb-2">
                                <input class="form-check-input" type="radio" name="payMethod" id="payBank" value="bank" checked>
                                <label class="form-check-label" for="payBank">
                                    Chuyển khoản / Nộp tiền mặt vào tài khoản
                                </label>
                            </div>
                            <div class="form-check border rounded p-3">
                                <input class="form-check-input" type="radio" name="payMethod" id="payCOD" value="cod">
                                <label class="form-check-label" for="payCOD">
                                    Ship COD - Thanh toán tiền mặt khi nhận hàng
                                </label>
                            </div>
                        </div>

                        <div class="mt-4">
                            <textarea class="form-control" name="note" rows="3" placeholder="Ghi chú (tuỳ chọn)"></textarea>
                        </div>

                        <div class="mt-4 d-grid">
                            <button class="btn btn-primary" type="submit">ĐẶT HÀNG</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="panel">
                <div class="panel-body">
                    <h5 class="mb-3">Đơn hàng (<span><%=totalQty%></span> sản phẩm)</h5>

                    <div class="vstack gap-3">
                        <% for (CartItem it : items) { %>
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center gap-2 position-relative">
                                <img class="item-thumb" src="<%=it.getImageUrl()%>" alt="<%=it.getProductName()%>">
                                <span class="qty-badge"><%=it.getQuantity()%></span>
                                <div class="ms-1" style="max-width:280px">
                                    <div class="fw-semibold small"><%=it.getProductName()%></div>
                                    <% if (it.getVariantId() != null) { %>
                                    <div class="small text-muted">Màu: <%=it.getColor()%> | Size: <%=it.getSize()%></div>
                                    <% } %>
                                </div>
                            </div>
                            <div class="fw-semibold"><%=String.format("%,.0f", it.getSubtotal())%>₫</div>
                        </div>
                        <% } %>
                    </div>

                    <div class="divider"></div>

                    <div class="sum-line"><span>Tạm tính</span><strong><%=String.format("%,.0f", subtotal)%>₫</strong></div>
                    <div class="sum-line"><span>Phí vận chuyển</span><span>0₫</span></div>
                    <div class="sum-line"><span>Giảm giá</span><span>0₫</span></div>
                    <div class="divider"></div>
                    <div class="sum-line fs-5">
                        <span><strong>Tổng cộng</strong></span>
                        <strong><%=String.format("%,.0f", subtotal)%>₫</strong>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // validate bootstrap
    document.getElementById('checkoutForm').addEventListener('submit', (e) => {
        const form = e.target;
        if (!form.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
            form.classList.add('was-validated');
        }
    });
</script>
</body>
</html>
