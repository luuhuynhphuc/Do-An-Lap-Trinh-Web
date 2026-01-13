package com.japansport.controller;

import com.japansport.dao.PolicyDao;
import com.japansport.model.Policy;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManagePolicyUserServlet", urlPatterns = {"/policies", "/policy"})
@MultipartConfig
public class ManagePolicyUserServlet extends HttpServlet {

    private final PolicyDao policyDao = new PolicyDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();

        if ("/policies".equals(servletPath)) {
            showPolicyList(request, response);
        } else if ("/policy".equals(servletPath)) {
            showPolicyDetail(request, response);
        }
    }

    /**
     * DS policy
     */
    private void showPolicyList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Policy> policies = policyDao.getAllActive();
        request.setAttribute("policies", policies);
        request.getRequestDispatcher("/policies.jsp").forward(request, response);
    }

    /**
     * Policy lay theo slug
     */
    private void showPolicyDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String slug = request.getParameter("slug");

        if (slug == null || slug.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/policies");
            return;
        }

        Policy policy = policyDao.getBySlug(slug);

        if (policy == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy chính sách");
            return;
        }

        request.setAttribute("policy", policy);
        request.getRequestDispatcher("/policy_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}