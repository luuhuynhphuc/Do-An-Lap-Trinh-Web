package com.japansport.controller;

import com.japansport.dao.BrandDao;
import com.japansport.model.Brand;
import com.japansport.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageBrandAdminServlet", urlPatterns = {"/admin/brands"})
@MultipartConfig
public class ManageBrandAdminServlet extends HttpServlet {

    private BrandDao brandDao;

    @Override
    public void init() {
        brandDao = new BrandDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                showBrandList(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBrand(request, response);
                break;
            default:
                showBrandList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createBrand(request, response);
        } else if ("update".equals(action)) {
            updateBrand(request, response);
        }
    }

    private void showBrandList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Brand> brandList = brandDao.getAll();
        request.setAttribute("brandList", brandList);
        request.setAttribute("pageTitle", "Quản lý Nhãn hàng");
        request.getRequestDispatcher("/admin/brand-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "Thêm Nhãn hàng mới");
        request.getRequestDispatcher("/admin/brand-form.jsp").forward(request, response);
    }

    private void createBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String logoUrl = request.getParameter("logoUrl");
        boolean active = "on".equals(request.getParameter("active"));

        // Tạo slug tự động
        String slug = Brand.generateSlug(name);

        Brand brand = new Brand();
        brand.setName(name);
        brand.setSlug(slug);
        brand.setLogoUrl(logoUrl);
        brand.setActive(active);

        int brandId = brandDao.insert(brand);

        if (brandId > 0) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&success=create");
        } else {
            request.setAttribute("error", "Không thể thêm nhãn hàng");
            showAddForm(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Brand brand = brandDao.getById(id);

        if (brand == null) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?error=notfound");
            return;
        }

        request.setAttribute("brand", brand);
        request.setAttribute("pageTitle", "Sửa Nhãn hàng");
        request.getRequestDispatcher("/admin/brand-form.jsp").forward(request, response);
    }

    private void updateBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String logoUrl = request.getParameter("logoUrl");
        boolean active = "on".equals(request.getParameter("active"));

        Brand brand = brandDao.getById(id);
        if (brand == null) {
            response.sendRedirect(request.getContextPath() + "/admin/brand?error=notfound");
            return;
        }

        brand.setName(name);
        brand.setSlug(Brand.generateSlug(name));
        brand.setLogoUrl(logoUrl);
        brand.setActive(active);

        boolean updated = brandDao.update(brand);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&success=update");
        } else {
            request.setAttribute("error", "Không thể cập nhật nhãn hàng");
            showEditForm(request, response);
        }
    }
    private void deleteBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        boolean deleted = brandDao.delete(id);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&success=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/brands?action=list&error=delete");
        }
    }
}