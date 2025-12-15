<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Thanh toán</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"
          rel="stylesheet"/>
    <link rel="stylesheet" href="assets/css/style.css"/>

</head>
<body>
<div class="container-narrow">
    <!-- Header -->
    <div class="d-flex align-items-center justify-content-between mb-3">
        <a href="index.jsp" class="d-flex align-items-center gap-2 text-decoration-none">
            <img src="assets/images/logo.webp" alt="Japan Sport" class="logo"/>
        </a>
        <a href="cart.jsp" class="text-decoration-none small"><i class="bi bi-chevron-left"></i> Quay về giỏ hàng</a>
    </div>

    <div class="row g-4">
        <!-- LEFT: Shipping / Payment form -->
        <div class="col-lg-7">
            <div class="panel">
                <div class="panel-body">
                    <h5 class="mb-3">Thông tin nhận hàng</h5>
                    <form id="checkoutForm" novalidate>
                        <div class="row g-3">
                            <div class="col-12">
                                <input  class="form-control" type="email" id="email" placeholder="Email" required>
                                <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>

                            </div>

                            <div class="col-12">
                                <input class="form-control" type="text" id="fullname" placeholder="Họ và tên" required>
                                <div class="invalid-feedback">Vui lòng nhập họ và tên.</div>
                            </div>
                            <div class="col-12">
                                <input class="form-control" type="tel" id="phone" placeholder="Số điện thoại" required>
                                <div class="invalid-feedback">Vui lòng nhập số điện thoại.</div>
                            </div>
                            <div class="col-12">
                                <input class="form-control" type="text" id="address" placeholder="Địa chỉ" required>
                                <div class="invalid-feedback">Vui lòng nhập địa chỉ.</div>
                            </div>
                            <div class="col-md-4">
                                <select class="form-select" id="province" required>
                                    <option value="">Tỉnh/Thành</option>
                                    <option>Hà Nội</option>
                                    <option>TP. Hồ Chí Minh</option>
                                    <option>Đà Nẵng</option>
                                    <option>Khác</option>
                                </select>
                                <div class="invalid-feedback">Chọn Tỉnh/Thành.</div>
                            </div>
                            <div class="col-md-4">
                                <input class="form-control" id="district" placeholder="Quận/Huyện" required>
                                <div class="invalid-feedback">Nhập Quận/Huyện.</div>
                            </div>
                            <div class="col-md-4">
                                <input class="form-control" id="ward" placeholder="Phường/Xã" required>
                                <div class="invalid-feedback">Nhập Phường/Xã.</div>
                            </div>
                        </div>

                        <div class="mt-4">
                            <h5 class="mb-2">Thanh toán</h5>
                            <div class="form-check border rounded p-3 mb-2">
                                <input class="form-check-input" type="radio" name="pay" id="payBank" value="bank"
                                       checked>
                                <label class="form-check-label" for="payBank">
                                    Chuyển khoản / Nộp tiền mặt vào tài khoản
                                </label>
                            </div>
                            <div class="form-check border rounded p-3">
                                <input class="form-check-input" type="radio" name="pay" id="payCOD" value="cod">
                                <label class="form-check-label" for="payCOD">
                                    Ship COD - Thanh toán tiền mặt khi nhận hàng
                                </label>
                            </div>
                        </div>

                        <div class="mt-4">
                            <textarea class="form-control" id="note" rows="3"
                                      placeholder="Ghi chú (tuỳ chọn)"></textarea>
                        </div>

                        <div class="mt-4 d-grid">
                            <button class="btn btn-primary" type="submit">ĐẶT HÀNG</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- RIGHT: Order summary -->
        <div class="col-lg-5">
            <div class="panel">
                <div class="panel-body">
                    <h5 class="mb-3">Đơn hàng (<span id="itemCount">0</span> sản phẩm)</h5>
                    <div id="orderItems" class="vstack gap-3"></div>

                    <div class="divider"></div>

                    <div class="input-group mb-2">
                        <input type="text" id="coupon" class="form-control"
                               placeholder="Nhập mã giảm giá (ví dụ: SALE5)">
                        <button id="applyCoupon" class="btn btn-outline-secondary">Áp dụng</button>
                    </div>
                    <div id="couponMsg" class="small-muted mb-2"></div>

                    <div class="sum-line"><span>Tạm tính</span><strong id="subtotal">0₫</strong></div>
                    <div class="sum-line"><span>Phí vận chuyển</span><span id="shipping">0₫</span></div>
                    <div class="sum-line"><span>Giảm giá</span><span id="discount">0₫</span></div>
                    <div class="divider"></div>
                    <div class="sum-line fs-5"><span><strong>Tổng cộng</strong></span><strong id="grand">0₫</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const STORAGE_KEY = 'cartItems';
    const ORDER_KEY = 'lastOrder';
    const fmt = n => (n || 0).toLocaleString('vi-VN') + '₫';

    let state = {items: [], subtotal: 0, shipping: 0, discount: 0};

    function loadCart() {
        const items = JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
        state.items = items.map(it => ({...it, qty: it.qty || 1}));
        state.subtotal = state.items.reduce((s, it) => s + it.price * it.qty, 0);
        state.shipping = state.subtotal > 0 ? 0 : 0; // tuỳ chính sách vận chuyển
        calcTotal();
        renderOrder();
    }

    function calcTotal() {
        state.total = Math.max(0, state.subtotal + state.shipping - state.discount);
    }

    function renderOrder() {
        const wrap = document.getElementById('orderItems');
        const count = document.getElementById('itemCount');
        wrap.innerHTML = '';
        let totalQty = 0;
        for (const it of state.items) {
            totalQty += it.qty;
            const row = document.createElement('div');
            row.className = 'd-flex align-items-center justify-content-between';
            row.innerHTML = `
          <div class="d-flex align-items-center gap-2 position-relative">
            <img class="item-thumb" src="${it.image}" alt="${it.title}">
            <span class="qty-badge">${it.qty}</span>
            <div class="ms-1" style="max-width:280px">
              <div class="fw-semibold small">${it.title}</div>
            </div>
          </div>
          <div class="fw-semibold">${fmt(it.price * it.qty)}</div>
        `;
            wrap.appendChild(row);
        }
        count.textContent = totalQty;
        document.getElementById('subtotal').textContent = fmt(state.subtotal);
        document.getElementById('shipping').textContent = fmt(state.shipping);
        document.getElementById('discount').textContent = '-' + fmt(state.discount);
        document.getElementById('grand').textContent = fmt(state.total);
    }

    // Apply coupon (demo): SALE5 = giảm 5% / FREESHIP = miễn phí ship
    document.getElementById('applyCoupon').addEventListener('click', () => {
        const code = (document.getElementById('coupon').value || '').trim().toUpperCase();
        let msg = '';
        state.discount = 0;
        if (code === 'SALE5') {
            state.discount = Math.round(state.subtotal * 0.05);
            msg = 'Đã áp dụng mã SALE5 (-5%).';
        } else if (code === 'FREESHIP') {
            state.shipping = 0;
            msg = 'Đã áp dụng mã FREESHIP (miễn phí vận chuyển).';
        } else if (code) {
            msg = 'Mã không hợp lệ.';
        }
        calcTotal();
        renderOrder();
        document.getElementById('couponMsg').textContent = msg;
    });

    // Validate + submit
    document.getElementById('checkoutForm').addEventListener('submit', (e) => {
        e.preventDefault();
        const form = e.target;
        if (!form.checkValidity()) {
            form.classList.add('was-validated');
            return;
        }
        if (state.items.length === 0) {
            alert('Giỏ hàng trống.');
            location.href = 'cart.html';
            return;
        }

        const order = {
            id: 'ORD' + Date.now(),
            items: state.items,
            subtotal: state.subtotal,
            shipping: state.shipping,
            discount: state.discount,
            total: state.total,
            payMethod: document.querySelector('input[name="pay"]:checked')?.value || 'bank',
            customer: {
                email: document.getElementById('email').value.trim(),
                name: document.getElementById('fullname').value.trim(),
                phone: document.getElementById('phone').value.trim(),
                address: document.getElementById('address').value.trim(),
                province: document.getElementById('province').value,
                district: document.getElementById('district').value.trim(),
                ward: document.getElementById('ward').value.trim(),
                note: document.getElementById('note').value.trim(),
            },
            createdAt: new Date().toISOString()
        };

        // Lưu tạm, xoá giỏ, điều hướng
        localStorage.setItem(ORDER_KEY, JSON.stringify(order));
        localStorage.setItem(STORAGE_KEY, '[]');
        alert('Đặt hàng thành công! Mã đơn: ' + order.id);
        location.href = 'index.html';
    });

    // Init
    loadCart();
</script>
</body>
</html>
