package com.japansport.filter;

import com.japansport.dao.BrandDao;
import com.japansport.dao.CategoryDao;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;

/**
 * Bơm dữ liệu menu (categoryList, brandList) cho mọi trang.
 * Có cache + TTL để giảm query.
 */
@WebFilter(urlPatterns = "/*")
public class MenuFilter implements Filter {

    private CategoryDao categoryDao;
    private BrandDao brandDao;

    private static final String APP_CATEGORIES = "APP_MENU_CATEGORIES";
    private static final String APP_BRANDS     = "APP_MENU_BRANDS";
    private static final String APP_LAST_LOAD  = "APP_MENU_LAST_LOAD";

    // refresh menu mỗi 5 phút
    private static final long TTL_MS = 5 * 60 * 1000L;

    @Override
    public void init(FilterConfig filterConfig) {
        categoryDao = new CategoryDao();
        brandDao = new BrandDao();
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        ServletContext app = request.getServletContext();

        long now = System.currentTimeMillis();
        Long lastLoad = (Long) app.getAttribute(APP_LAST_LOAD);

        boolean needReload = (lastLoad == null) || (now - lastLoad > TTL_MS)
                || app.getAttribute(APP_CATEGORIES) == null
                || app.getAttribute(APP_BRANDS) == null;

        if (needReload) {
            try {
                app.setAttribute(APP_CATEGORIES, categoryDao.getAllActive());
                app.setAttribute(APP_BRANDS, brandDao.getAllActive());
                app.setAttribute(APP_LAST_LOAD, now);
            } catch (Exception e) {
                e.printStackTrace(); // DB lỗi thì vẫn cho request chạy tiếp
            }
        }

        request.setAttribute("categoryList", app.getAttribute(APP_CATEGORIES));
        request.setAttribute("brandList", app.getAttribute(APP_BRANDS));

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {}
}
