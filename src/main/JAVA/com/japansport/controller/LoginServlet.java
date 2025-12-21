package com.japansport.controller;
import com.japansport.dao.UserDao;
import com.japansport.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() {
        userDao = new UserDao();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user;
        try {
            user = userDao.login(email, password);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(3600);

            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            return;
        }

        request.setAttribute("errorMessage", "Email hoặc mật khẩu không đúng");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

}
