package com.japansport.controller;

import com.japansport.dao.ProductDao;
import com.japansport.dao.BrandDao;
import com.japansport.dao.ProductImageDao;
import com.japansport.model.Product;
import com.japansport.model.Brand;
import com.japansport.model.ProductImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailController", value = "/product")
public class ProductDetailController extends HttpServlet {

    private final ProductDao productDao = new ProductDao();
    private final BrandDao brandDao = new BrandDao();
    private final ProductImageDao productImageDao = new ProductImageDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy id từ URL: /product?id=5
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            // Không có id → quay về danh sách sản phẩm
            response.sendRedirect(request.getContextPath() + "/list-product");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            // id không phải số
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ");
            return;
        }

        // Lấy sản phẩm từ DB
        Product p = productDao.getById(id);
        if (p == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm");
            return;
        }

        // Gắn Brand cho sản phẩm nếu có brandId
        if (p.getBrand() == null && p.getBrandId() != null) {
            Brand brand = brandDao.getById(p.getBrandId());
            p.setBrand(brand);
        }

        // Lấy danh sách ảnh gallery của sản phẩm
        List<ProductImage> images = productImageDao.getByProductId(id);

        // Đưa dữ liệu xuống JSP
        request.setAttribute("product", p);
        request.setAttribute("images", images);

        request.getRequestDispatcher("product_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
