<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside id="sidebar" class="sidebar border-end bg-white">
    <div class="sidebar-inner">
        <ul class="s-nav">
            <li><a class="s-item" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="bi bi-speedometer2 me-2"></i>Dashboard
            </a></li>
        </ul>
        <div class="s-title">QUẢN LÝ</div>
        <ul class="s-nav">
            <li class="has-children">
                <a class="s-item s-parent" href="#" onclick="return false;">
                    <span><i class="bi bi-box-seam me-2"></i>Sản phẩm</span>
                    <i class="bi bi-chevron-down ms-auto small chev"></i>
                </a>
                <ul class="s-subnav">
                    <li><a class="s-subitem" href="${pageContext.request.contextPath}/admin/products">
                        <i class="bi bi-list-ul me-2"></i>Quản lý sản phẩm
                    </a></li>
                    <li><a class="s-subitem active" href="${pageContext.request.contextPath}/admin/categories">
                        <i class="bi bi-tags me-2"></i>Danh mục sản phẩm
                    </a></li>
                </ul>
            </li>
        </ul>
    </div>
</aside>