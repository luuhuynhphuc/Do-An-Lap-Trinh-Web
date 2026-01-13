package com.japansport.controller;

import com.japansport.dao.NewsDao;
import com.japansport.dao.NewsCategoryDao;
import com.japansport.model.News;
import com.japansport.model.NewsCategory;
import com.japansport.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageNewsAdminServlet", urlPatterns = {"/admin/news"})
@MultipartConfig
public class ManageNewsAdminServlet extends HttpServlet {

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

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                showNewsList(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteNews(request, response);
                break;
            default:
                showNewsList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createNews(request, response);
        } else if ("update".equals(action)) {
            updateNews(request, response);
        }
    }

    private void showNewsList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<News> newsList = newsDao.getAll();

        // Load categories cho news
        for (News news : newsList) {
            List<NewsCategory> cats = categoryDao.getCategoriesByNewsId(news.getId());
            news.setCategories(cats);
        }

        request.setAttribute("newsList", newsList);
        request.setAttribute("pageTitle", "Quản lý Tin tức");
        request.getRequestDispatcher("/admin/news-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<NewsCategory> categories = categoryDao.getAllActive();
        request.setAttribute("categories", categories);
        request.setAttribute("pageTitle", "Thêm Tin tức mới");
        request.getRequestDispatcher("/admin/news-form.jsp").forward(request, response);
    }

    private void createNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // form
        String title = request.getParameter("title");
        String summary = request.getParameter("summary");
        String content = request.getParameter("content");
        String thumbnailUrl = request.getParameter("thumbnailUrl");
        String status = request.getParameter("status");
        boolean featured = "on".equals(request.getParameter("featured"));

        // author from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        String author = currentUser != null ? currentUser.getName() : "Admin";

        // auto slug
        String slug = News.generateSlug(title);

        // object News
        News news = new News();
        news.setTitle(title);
        news.setSlug(slug);
        news.setSummary(summary);
        news.setContent(content);
        news.setThumbnailUrl(thumbnailUrl);
        news.setAuthor(author);
        news.setStatus(status);
        news.setFeatured(featured);

        int newsId = newsDao.insert(news);

        if (newsId > 0) {
            // save categories
            String[] categoryIds = request.getParameterValues("categoryIds");
            if (categoryIds != null) {
                for (String catId : categoryIds) {
                    categoryDao.addCategoryToNews(newsId, Integer.parseInt(catId));
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/news?action=list&success=create");
        } else {
            request.setAttribute("error", "Không thể thêm tin tức");
            showAddForm(request, response);
        }
    }

    // ============== EDIT ==============
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        News news = newsDao.getById(id);

        if (news == null) {
            response.sendRedirect(request.getContextPath() + "/admin/news?error=notfound");
            return;
        }

        // Load categories hien tai cua news
        List<NewsCategory> selectedCats = categoryDao.getCategoriesByNewsId(id);
        news.setCategories(selectedCats);

        // Load all categories
        List<NewsCategory> allCategories = categoryDao.getAllActive();

        request.setAttribute("news", news);
        request.setAttribute("categories", allCategories);
        request.setAttribute("pageTitle", "Sửa Tin tức");
        request.getRequestDispatcher("/admin/news-form.jsp").forward(request, response);
    }

    private void updateNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String summary = request.getParameter("summary");
        String content = request.getParameter("content");
        String thumbnailUrl = request.getParameter("thumbnailUrl");
        String status = request.getParameter("status");
        boolean featured = "on".equals(request.getParameter("featured"));

        News news = newsDao.getById(id);
        if (news == null) {
            response.sendRedirect(request.getContextPath() + "/admin/news?error=notfound");
            return;
        }

        // Update thong tin
        news.setTitle(title);
        news.setSlug(News.generateSlug(title));
        news.setSummary(summary);
        news.setContent(content);
        news.setThumbnailUrl(thumbnailUrl);
        news.setStatus(status);
        news.setFeatured(featured);

        boolean updated = newsDao.update(news);

        if (updated) {
            // update categories
            categoryDao.removeCategoriesFromNews(id);
            String[] categoryIds = request.getParameterValues("categoryIds");
            if (categoryIds != null) {
                for (String catId : categoryIds) {
                    categoryDao.addCategoryToNews(id, Integer.parseInt(catId));
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/news?action=list&success=update");
        } else {
            request.setAttribute("error", "Không thể cập nhật tin tức");
            showEditForm(request, response);
        }
    }

    private void deleteNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        boolean deleted = newsDao.delete(id);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/news?action=list&success=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/news?action=list&error=delete");
        }
    }
}