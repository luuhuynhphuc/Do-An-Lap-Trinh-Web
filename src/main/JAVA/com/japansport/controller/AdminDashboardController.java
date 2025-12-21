package com.japansport.controller;

import com.japansport.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;


@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin admin từ session (đã được filter kiểm tra)
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Set attribute cho JSP
        request.setAttribute("adminName", currentUser.getName());
        request.setAttribute("pageTitle", "Dashboard");

        // TODO: Lấy thống kê từ database
        // int totalProducts = productDao.countAll();
        // int totalOrders = orderDao.countAll();
        // request.setAttribute("totalProducts", totalProducts);
        // request.setAttribute("totalOrders", totalOrders);

        // Forward đến trang admin dashboard
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}