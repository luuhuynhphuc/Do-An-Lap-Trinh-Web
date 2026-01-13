package com.japansport.controller;

import com.japansport.dao.PolicyDao;
import com.japansport.dao.ProductDao;
import com.japansport.model.Policy;
import com.japansport.model.Product;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import com.japansport.dao.BannerDao;
import com.japansport.model.Banner;
import com.japansport.model.Category;
import com.japansport.dao.CategoryDao;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", value = "/home")
public class HomeController extends HttpServlet {

    private ProductDao productDao;
    private BannerDao bannerDao;
    private CategoryDao categoryDao;


    @Override
    public void init() {
        productDao = new ProductDao();
        bannerDao = new BannerDao();
        categoryDao = new CategoryDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            // Lấy toàn bộ sản phẩm từ DB
            List<Product> productList = productDao.getAll();

            // Lấy banner theo từng vị trí
            List<Banner> topBanners = bannerDao.getBannersByPosition("HOME_TOP");
            Banner menBanner = bannerDao.getOneBannerByPosition("HOME_MEN");
            Banner womenRightBanner = bannerDao.getOneBannerByPosition("HOME_WOMEN_RIGHT");
            Banner womenBottomBanner = bannerDao.getOneBannerByPosition("HOME_WOMEN_BOTTOM");


            // Lấy sản phẩm nam
            List<Product> menProducts = productDao.getByGender("M", 8);

            // Lấy sản phẩm nữ
            List<Product> womenProducts = productDao.getByGender("F", 8);

            // Lấy 6 danh mục nổi bật
            /*List<Category> featuredCategories = categoryDao.getFeaturedCategories(6);*/
            List<Category> featuredCategories = categoryDao.getFeaturedCategories(6);

            // Debug xem có dữ liệu không
            System.out.println("HomeController - productList size = " + productList.size());

/* SET ATTRIBUTE (gắn giá trị) */
            // Gắn cho 2 section
            request.setAttribute("productList", productList);        // Sản phẩm mới nhất
            request.setAttribute("bestSellerProducts", productList); // Sản phẩm bán chạy


            // Gắn attribute cho banner
            request.setAttribute("topBanners", topBanners);
            request.setAttribute("menBanner", menBanner);
            request.setAttribute("womenRightBanner", womenRightBanner);
            request.setAttribute("womenBottomBanner", womenBottomBanner);


            // Gắn thêm cho slider Nam/Nữ
            request.setAttribute("menProducts", menProducts);
            request.setAttribute("womenProducts", womenProducts);

            request.setAttribute("featuredCategories", featuredCategories);

            //Load policies cho footer
            PolicyDao policyDao = new PolicyDao();
            List<Policy> policies = policyDao.getAll();
            request.setAttribute("policies", policies);

            // Trả về index.jsp
            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi truy xuất dữ liệu sản phẩm");
        }
    }
}
