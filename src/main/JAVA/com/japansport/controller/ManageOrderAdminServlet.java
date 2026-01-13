package com.japansport.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.japansport.dao.OrderDao;
import com.japansport.model.Order;
import com.japansport.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ManageOrderAdminServlet", urlPatterns = {"/admin/orders"})
@MultipartConfig
public class ManageOrderAdminServlet extends HttpServlet {

    private OrderDao orderDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.orderDao = new OrderDao();

        // Gson custom LocalDateTime adapter
        this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new com.google.gson.JsonSerializer<LocalDateTime>() {
                    @Override
                    public com.google.gson.JsonElement serialize(LocalDateTime src, java.lang.reflect.Type typeOfSrc,
                                                                 com.google.gson.JsonSerializationContext context) {
                        return new com.google.gson.JsonPrimitive(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
                    }
                })
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");

        // foward trang orders
        if (action == null || action.isEmpty()) {
            request.setAttribute("pageTitle", "Quản lý đơn hàng");
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "list":
                handleListOrders(request, response);
                break;
            case "detail":
                handleGetDetail(request, response);
                break;
            case "search":
                handleSearch(request, response);
                break;
            default:
                sendJsonError(response, "Action không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            sendJsonError(response, "Thiếu tham số action");
            return;
        }

        switch (action) {
            case "updateStatus":
                handleUpdateStatus(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            default:
                sendJsonError(response, "Action không hợp lệ");
        }
    }
    /**
     * lay ds tat ca order
     */
    private void handleListOrders(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            List<Order> orders = orderDao.getAll();
            sendJsonSuccess(response, orders);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi lấy danh sách đơn hàng: " + e.getMessage());
        }
    }

    /**
     * lay chi tiet 1 don hang
     */
    private void handleGetDetail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                sendJsonError(response, "Thiếu ID đơn hàng");
                return;
            }

            int orderId = Integer.parseInt(idStr);
            Order order = orderDao.getById(orderId);

            if (order == null) {
                sendJsonError(response, "Không tìm thấy đơn hàng");
                return;
            }

            sendJsonSuccess(response, order);

        } catch (NumberFormatException e) {
            sendJsonError(response, "ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi lấy chi tiết đơn hàng: " + e.getMessage());
        }
    }

    /**
     * tim kiem order
     */
    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String keyword = request.getParameter("keyword");
            if (keyword == null || keyword.trim().isEmpty()) {
                handleListOrders(request, response);
                return;
            }

            List<Order> orders = orderDao.search(keyword.trim());
            sendJsonSuccess(response, orders);

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi tìm kiếm: " + e.getMessage());
        }
    }

    /**
     * cap nhat order status
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");

            if (idStr == null || status == null) {
                sendJsonError(response, "Thiếu tham số");
                return;
            }

            int orderId = Integer.parseInt(idStr);

            // Validate status
            if (!isValidStatus(status)) {
                sendJsonError(response, "Trạng thái không hợp lệ");
                return;
            }

            boolean success = orderDao.updateStatus(orderId, status);

            if (success) {
                sendJsonSuccess(response, "Cập nhật trạng thái thành công");
            } else {
                sendJsonError(response, "Cập nhật thất bại");
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi cập nhật: " + e.getMessage());
        }
    }

    /**
     * cap nhat thong tin order
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                sendJsonError(response, "Thiếu ID đơn hàng");
                return;
            }

            int orderId = Integer.parseInt(idStr);
            Order order = orderDao.getById(orderId);

            if (order == null) {
                sendJsonError(response, "Không tìm thấy đơn hàng");
                return;
            }

            // cap nhat cac field roi gui len
            String status = request.getParameter("status");
            if (status != null && isValidStatus(status)) {
                order.setStatus(status);
            }

            String note = request.getParameter("note");
            if (note != null) {
                order.setNote(note);
            }

            String trackingCode = request.getParameter("trackingCode");
            if (trackingCode != null) {
                order.setTrackingCode(trackingCode);
            }

            String paymentStatus = request.getParameter("paymentStatus");
            if (paymentStatus != null) {
                order.setPaymentStatus(paymentStatus);
            }

            boolean success = orderDao.update(order);

            if (success) {
                sendJsonSuccess(response, "Cập nhật đơn hàng thành công");
            } else {
                sendJsonError(response, "Cập nhật thất bại");
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi cập nhật: " + e.getMessage());
        }
    }

    /**
     * Xoa order
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                sendJsonError(response, "Thiếu ID đơn hàng");
                return;
            }

            int orderId = Integer.parseInt(idStr);
            boolean success = orderDao.delete(orderId);

            if (success) {
                sendJsonSuccess(response, "Xóa đơn hàng thành công");
            } else {
                sendJsonError(response, "Xóa thất bại");
            }

        } catch (NumberFormatException e) {
            sendJsonError(response, "ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi xóa: " + e.getMessage());
        }
    }
    /**
     * Validate status
     */
    private boolean isValidStatus(String status) {
        return status != null && (
                status.equals("processing") ||
                        status.equals("confirmed") ||
                        status.equals("shipping") ||
                        status.equals("done") ||
                        status.equals("canceled")
        );
    }

    /**
     * Response thanh cong
     */
    private void sendJsonSuccess(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", data);

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }

    /**
     * Gửi JSON response thành công (chỉ message)
     */
    private void sendJsonSuccess(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", message);

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }

    /**
     * Response khi gap Error
     */
    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", message);

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
}