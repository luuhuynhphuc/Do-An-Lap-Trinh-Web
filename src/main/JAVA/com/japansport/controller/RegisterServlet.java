package com.japansport.controller;

import com.japansport.dao.UserDao;
import com.japansport.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // 1) Kiểm tra rất cơ bản (đủ cho người mới)
        if (name == null || name.isBlank() ||
                email == null || email.isBlank() ||
                password == null || password.isBlank()) {

            req.setAttribute("errorMessage", "Vui lòng nhập đủ Họ tên, Email và Mật khẩu.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 2) Tạo User và gọi DAO.insert(...)
        User u = new User();
        u.setName(name);
        u.setEmail(email);
        u.setPassword(password);   // đơn giản: lưu plaintext (khi quen hãy dùng BCrypt)
        u.setActive(1);            // cho phép đăng nhập ngay

        try {
            UserDao dao = new UserDao();

            // (khuyến nghị) chặn email trùng – nếu chưa có UNIQUE(email)
            if (dao.existsByEmail(email)) {
                req.setAttribute("errorMessage", "Email đã tồn tại, vui lòng dùng email khác.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            int affected = dao.insert(u);   // dùng chính insert bạn đang có
            if (affected > 0) {
                // đăng ký xong → về trang đăng nhập
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
            } else {
                req.setAttribute("errorMessage", "Đăng ký thất bại, thử lại!");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        } catch (Exception e) {

            req.setAttribute("errorMessage", "Có lỗi kết nối hoặc email đã tồn tại.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
