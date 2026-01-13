package com.japansport.controller;

import com.japansport.dao.NewsDao;
import com.japansport.dao.NewsCategoryDao;
import com.japansport.model.News;
import com.japansport.model.NewsCategory;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "NewsController", urlPatterns = {"/news", "/news/*"})
public class NewsController extends HttpServlet {

    private NewsDao newsDao;
    private NewsCategoryDao categoryDao;

    @Override
    public void init() {
        newsDao = new NewsDao();
        categoryDao = new NewsCategoryDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // hien thi ds cac tin tuc
            showNewsList(request, response);
        } else {
            // Hien thi tin tuc theo slug
            String slug = pathInfo.substring(1);
            showNewsDetail(request, response, slug);
        }
    }

    private void showNewsList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categorySlug = request.getParameter("category");
        String keyword = request.getParameter("keyword");

        List<News> newsList;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Tìm kiếm theo keyword
            newsList = newsDao.searchByTitle(keyword);
        } else if (categorySlug != null && !categorySlug.isEmpty()) {
            // Lọc theo category (cần implement thêm method trong NewsDao)
            NewsCategory category = categoryDao.getBySlug(categorySlug);
            if (category != null) {
                newsList = newsDao.getAll(); // TODO: implement getByCategory
                request.setAttribute("currentCategory", category);
            } else {
                newsList = newsDao.getAllPublished();
            }
        } else {
            // lay tat ca tin tuc da xuat ban
            newsList = newsDao.getAllPublished();
        }

        // Load categories cho news
        for (News news : newsList) {
            List<NewsCategory> cats = categoryDao.getCategoriesByNewsId(news.getId());
            news.setCategories(cats);
        }

        // Hot news cho slidebar
        List<News> featuredNews = newsDao.getFeaturedNews(5);

        // categories cho menu
        List<NewsCategory> allCategories = categoryDao.getAllActive();

        request.setAttribute("newsList", newsList);
        request.setAttribute("featuredNews", featuredNews);
        request.setAttribute("categories", allCategories);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/news-list.jsp").forward(request, response);
    }

    private void showNewsDetail(HttpServletRequest request, HttpServletResponse response, String slug)
            throws ServletException, IOException {

        News news = newsDao.getBySlug(slug);

        if (news == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tin tức");
            return;
        }

        // Tăng view count
        newsDao.incrementViewCount(news.getId());
        news.setViewCount(news.getViewCount() + 1);

        // Load categories của tin này
        List<NewsCategory> categories = categoryDao.getCategoriesByNewsId(news.getId());
        news.setCategories(categories);

        // Tin liên quan (cùng category - TODO: implement method)
        List<News> relatedNews = newsDao.getFeaturedNews(4);

        // Tin nổi bật cho sidebar
        List<News> featuredNews = newsDao.getFeaturedNews(5);

        request.setAttribute("news", news);
        request.setAttribute("relatedNews", relatedNews);
        request.setAttribute("featuredNews", featuredNews);

        request.getRequestDispatcher("/news-detail.jsp").forward(request, response);
    }
}