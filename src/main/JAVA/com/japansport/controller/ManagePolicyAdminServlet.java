package com.japansport.controller;

import com.japansport.dao.PolicyDao;
import com.japansport.model.Policy;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "ManagePolicyAdminServlet", urlPatterns = {"/admin/policies"})
@MultipartConfig
public class ManagePolicyAdminServlet extends HttpServlet {

    private final PolicyDao policyDao = new PolicyDao();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            request.getRequestDispatcher("/admin/policies.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "list":
                listPolicies(request, response);
                break;
            case "get":
                getPolicy(request, response);
                break;
            default:
                sendErrorResponse(response, "Invalid action: " + action);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            sendErrorResponse(response, "Missing action parameter");
            return;
        }

        switch (action) {
            case "add":
                addPolicy(request, response);
                break;
            case "update":
                updatePolicy(request, response);
                break;
            case "delete":
                deletePolicy(request, response);
                break;
            default:
                sendErrorResponse(response, "Invalid action: " + action);
        }
    }

    private void listPolicies(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Policy> policies = policyDao.getAll();
        sendJsonResponse(response, policies);
    }

    private void getPolicy(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Policy policy = policyDao.getById(id);

            if (policy != null) {
                sendJsonResponse(response, policy);
            } else {
                sendErrorResponse(response, "Policy not found");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid policy ID");
        }
    }

    private void addPolicy(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Policy policy = new Policy();
            policy.setTitle(request.getParameter("title"));
            policy.setSlug(request.getParameter("slug"));
            policy.setContent(request.getParameter("content"));
            policy.setPolicyType(request.getParameter("policy_type"));

            String orderStr = request.getParameter("display_order");
            policy.setDisplayOrder(orderStr != null ? Integer.parseInt(orderStr) : 0);

            String activeStr = request.getParameter("active");
            policy.setActive(activeStr != null && activeStr.equals("1") ? 1 : 0);

            int newId = policyDao.insert(policy);

            if (newId > 0) {
                policy.setId(newId);
                sendSuccessResponse(response, "Thêm chính sách thành công", policy);
            } else {
                sendErrorResponse(response, "Failed to add policy");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error: " + e.getMessage());
        }
    }

    private void updatePolicy(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Policy policy = policyDao.getById(id);

            if (policy == null) {
                sendErrorResponse(response, "Policy not found");
                return;
            }

            policy.setTitle(request.getParameter("title"));
            policy.setSlug(request.getParameter("slug"));
            policy.setContent(request.getParameter("content"));
            policy.setPolicyType(request.getParameter("policy_type"));

            String orderStr = request.getParameter("display_order");
            policy.setDisplayOrder(orderStr != null ? Integer.parseInt(orderStr) : 0);

            String activeStr = request.getParameter("active");
            policy.setActive(activeStr != null && activeStr.equals("1") ? 1 : 0);

            boolean success = policyDao.update(policy);

            if (success) {
                sendSuccessResponse(response, "Cập nhật chính sách thành công", policy);
            } else {
                sendErrorResponse(response, "Failed to update policy");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error: " + e.getMessage());
        }
    }

    private void deletePolicy(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = policyDao.delete(id);

            if (success) {
                sendSuccessResponse(response, "Xóa chính sách thành công", null);
            } else {
                sendErrorResponse(response, "Failed to delete policy");
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid policy ID");
        }
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    private void sendSuccessResponse(HttpServletResponse response, String message, Object data)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String json = String.format(
                "{\"success\": true, \"message\": \"%s\", \"data\": %s}",
                message,
                data != null ? gson.toJson(data) : "null"
        );

        out.print(json);
        out.flush();
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        PrintWriter out = response.getWriter();

        String json = String.format("{\"success\": false, \"message\": \"%s\"}", message);
        out.print(json);
        out.flush();
    }
}