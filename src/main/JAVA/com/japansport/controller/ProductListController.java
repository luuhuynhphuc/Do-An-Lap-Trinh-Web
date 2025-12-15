package com.japansport.controller;

import com.japansport.dao.ProductDao;
import com.japansport.dao.CategoryDao;
import com.japansport.dao.BrandDao;
import com.japansport.model.Product;
import com.japansport.model.Category;
import com.japansport.model.Brand;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductListController", value = "/list-product")
public class ProductListController extends HttpServlet {

    private final ProductDao productDao = new ProductDao();
    private final CategoryDao categoryDao = new CategoryDao();
    private final BrandDao brandDao = new BrandDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String keywordParam    = req.getParameter("keyword");
        String categoryIdParam = req.getParameter("categoryId");
        String sortParam       = req.getParameter("sort");
        String pageParam       = req.getParameter("page");

        String[] priceParams   = req.getParameterValues("price");    // checkbox mức giá
        String[] brandIdParams = req.getParameterValues("brandId");  // checkbox thương hiệu (id)

        final int PAGE_SIZE = 8;

        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignore) {
                page = 1;
            }
        }

        List<Product> allProducts;

        // 1. Nếu có keyword -> ưu tiên TÌM KIẾM
        if (keywordParam != null && !keywordParam.trim().isEmpty()) {
            String keyword = keywordParam.trim();
            allProducts = productDao.searchByName(keyword);
            req.setAttribute("keyword", keyword);
        } else {
            // 2. Không có keyword -> lọc theo CATEGORY + SORT
            Integer categoryId = null;
            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdParam);
                } catch (NumberFormatException ignore) {
                    categoryId = null;
                }
            }

            if (categoryId != null) {
                allProducts = productDao.getByCategorySorted(categoryId, sortParam);
                req.setAttribute("selectedCategoryId", categoryIdParam);
            } else {
                allProducts = productDao.getAllSorted(sortParam);
            }
        }

        // 3. LỌC THEO THƯƠNG HIỆU (brand_id)
        if (brandIdParams != null && brandIdParams.length > 0
                && allProducts != null && !allProducts.isEmpty()) {

            List<Integer> brandIdFilter = new ArrayList<>();
            for (String s : brandIdParams) {
                try {
                    brandIdFilter.add(Integer.parseInt(s));
                } catch (NumberFormatException ignore) {}
            }

            if (!brandIdFilter.isEmpty()) {
                List<Product> filteredByBrand = new ArrayList<>();
                for (Product p : allProducts) {
                    Integer bId = p.getBrandId();
                    if (bId != null && brandIdFilter.contains(bId)) {
                        filteredByBrand.add(p);
                    }
                }
                allProducts = filteredByBrand;
            }
        }

        // 4. LỌC THEO MỨC GIÁ
        if (priceParams != null && priceParams.length > 0
                && allProducts != null && !allProducts.isEmpty()) {

            List<Product> filteredByPrice = new ArrayList<>();

            for (Product p : allProducts) {
                double price = p.getPrice();

                boolean matchAnyRange = false;
                for (String range : priceParams) {
                    if (isPriceInRange(price, range)) {
                        matchAnyRange = true;
                        break;
                    }
                }

                if (matchAnyRange) {
                    filteredByPrice.add(p);
                }
            }

            allProducts = filteredByPrice;
        }

        // 5. PHÂN TRANG trên list đã lọc
        int totalProducts = (allProducts != null) ? allProducts.size() : 0;
        int totalPages;
        List<Product> productsPage;

        if (totalProducts == 0) {
            totalPages = 0;
            page = 1;
            productsPage = allProducts; // list rỗng
        } else {
            totalPages = (int) Math.ceil(totalProducts * 1.0 / PAGE_SIZE);
            if (page > totalPages) page = totalPages;

            int fromIndex = (page - 1) * PAGE_SIZE;
            int toIndex = Math.min(fromIndex + PAGE_SIZE, totalProducts);

            productsPage = allProducts.subList(fromIndex, toIndex);
        }

        // 6. Lấy danh mục & thương hiệu cho sidebar
        List<Category> categories = categoryDao.getAllActive();
        List<Brand> brands = brandDao.getAllActive();

        req.setAttribute("categoryList", categories);
        req.setAttribute("brandList", brands);

        // 7. Gửi dữ liệu cho JSP
        req.setAttribute("selectedSort", sortParam);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalProducts", totalProducts);

        req.setAttribute("selectedPrices", priceParams);    // giữ checkbox giá
        req.setAttribute("selectedBrandIds", brandIdParams);// giữ checkbox brand

        req.setAttribute("listProduct", productsPage);

        req.getRequestDispatcher("products.jsp").forward(req, resp);
    }

    // Kiểm tra giá (đồng) có nằm trong khoảng người dùng chọn không
    private boolean isPriceInRange(double price, String range) {
        switch (range) {
            case "0-500":
                return price < 500_000;
            case "500-1000":
                return price >= 500_000 && price < 1_000_000;
            case "1000-1500":
                return price >= 1_000_000 && price < 1_500_000;
            case "1500-2000":
                return price >= 1_500_000 && price < 2_000_000;
            case "2000-2500":
                return price >= 2_000_000 && price < 2_500_000;
            case "2500-3000":
                return price >= 2_500_000 && price < 3_000_000;
            case "3000+":
                return price >= 3_000_000;
            default:
                return true;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
