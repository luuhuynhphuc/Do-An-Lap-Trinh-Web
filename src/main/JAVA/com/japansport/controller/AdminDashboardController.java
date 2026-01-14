package com.japansport.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.japansport.dao.ProductDao;
import com.japansport.dao.OrderDao;
import com.japansport.dao.UserDao;
import com.japansport.dao.DBConnect;
import com.japansport.model.Order;
import com.japansport.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    private ProductDao productDao;
    private OrderDao orderDao;
    private UserDao userDao;
    private Gson gson;

    @Override
    public void init() {
        productDao = new ProductDao();
        orderDao = new OrderDao();
        userDao = new UserDao();

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

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if ("getRevenue".equals(action)) {
            handleGetRevenueAjax(request, response);
            return;
        }

        if ("debug".equals(action)) {
            handleDebug(request, response);
            return;
        }

        try {
            loadDashboardData(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải dữ liệu dashboard: " + e.getMessage());

            request.setAttribute("totalProducts", 0);
            request.setAttribute("totalOrders", 0);
            request.setAttribute("totalCustomers", 0);
            request.setAttribute("monthlyRevenue", "0 đ");
            request.setAttribute("revenueLabels", "['Jan','Feb','Mar','Apr','May','Jun']");
            request.setAttribute("revenueValues", "[0,0,0,0,0,0]");
            request.setAttribute("trafficData", "[0,0,0,0,0,0,0,0,0,0,0,0]");
        }
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private void handleGetRevenueAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            double monthlyRevenue = calculateMonthlyRevenue();
            int totalOrders = countCompletedOrders(); // CHANGED: Chỉ đếm đơn đã hoàn thành

            String[] revenueChartData = getRevenueChartData();
            List<String> labels = new ArrayList<>(Arrays.asList(revenueChartData[0].split(",")));
            List<Double> values = parseDoubleArray(revenueChartData[1]);

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("success", true);
            result.put("monthlyRevenue", monthlyRevenue);
            result.put("totalOrders", totalOrders);
            result.put("revenueLabels", labels);
            result.put("revenueValues", values);
            result.put("timestamp", System.currentTimeMillis());

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(result));
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Lỗi khi tính toán doanh thu: " + e.getMessage());
        }
    }

    private void handleDebug(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        out.println("=== DATABASE DEBUG INFO ===");
        out.println();

        try (Connection conn = DBConnect.getInstance().getConnect()) {

            out.println("1. ALL ORDERS:");
            String allOrdersSql = "SELECT id, order_code, status, total, created_at, updated_at " +
                    "FROM orders ORDER BY created_at DESC";

            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(allOrdersSql)) {
                while (rs.next()) {
                    out.printf("   #%d %s | Status: %s | Total: %.2f | Created: %s | Updated: %s%n",
                            rs.getInt("id"),
                            rs.getString("order_code"),
                            rs.getString("status"),
                            rs.getDouble("total"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("updated_at"));
                }
            }

            out.println();
            out.println("2. COMPLETED ORDERS BY MONTH/YEAR:");
            String byMonthSql = "SELECT " +
                    "YEAR(created_at) as year, " +
                    "MONTH(created_at) as month, " +
                    "COUNT(*) as count, " +
                    "COALESCE(SUM(total), 0) as revenue " +
                    "FROM orders " +
                    "WHERE status IN ('done', 'hoàn tất') " +
                    "GROUP BY YEAR(created_at), MONTH(created_at) " +
                    "ORDER BY year DESC, month DESC";

            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(byMonthSql)) {
                while (rs.next()) {
                    out.printf("   %d-%02d: %d orders, %.2f VND%n",
                            rs.getInt("year"),
                            rs.getInt("month"),
                            rs.getInt("count"),
                            rs.getDouble("revenue"));
                }
            }

            out.println();
            out.println("=== END DEBUG ===");

        } catch (SQLException e) {
            out.println("ERROR: " + e.getMessage());
            e.printStackTrace(out);
        }
    }

    private void loadDashboardData(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int totalProducts = productDao.countAll();
        int totalOrders = countCompletedOrders(); // CHANGED: Chỉ đếm đơn đã hoàn thành
        int totalCustomers = countCustomers();
        double monthlyRevenue = calculateMonthlyRevenue();

        String[] revenueChartData = getRevenueChartData();
        String revenueLabels = revenueChartData[0];
        String revenueValues = revenueChartData[1];

        String trafficData = "[72, 78, 80, 29, 26, 10, 48, 81, 55, 21, 14, 96]";

        DecimalFormat formatter = new DecimalFormat("#,###");
        String formattedRevenue = formatter.format(monthlyRevenue) + " đ";

        request.setAttribute("adminName", ((User) request.getSession().getAttribute("currentUser")).getName());
        request.setAttribute("pageTitle", "Dashboard");
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("monthlyRevenue", formattedRevenue);
        request.setAttribute("revenueLabels", revenueLabels);
        request.setAttribute("revenueValues", revenueValues);
        request.setAttribute("trafficData", trafficData);

        System.out.println("[DASHBOARD] Products: " + totalProducts + ", Completed Orders: " + totalOrders);
        System.out.println("[DASHBOARD] Monthly Revenue: " + formattedRevenue);
        System.out.println("[DASHBOARD] Chart Labels: " + revenueLabels);
        System.out.println("[DASHBOARD] Chart Values: " + revenueValues);
    }

    /**
     * ĐẾM TỔNG SỐ ĐơN HÀNG ĐÃ HOÀN THÀNH
     */
    private int countCompletedOrders() {
        String sql = "SELECT COUNT(*) as count FROM orders WHERE status IN ('done', 'hoàn tất')";

        try (Connection conn = DBConnect.getInstance().getConnect();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                int count = rs.getInt("count");
                System.out.println("[DEBUG] Total completed orders: " + count);
                return count;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("[ERROR] countCompletedOrders: " + e.getMessage());
        }
        return 0;
    }

    private int countCustomers() {
        try {
            List<User> allUsers = userDao.getAll();
            int count = 0;
            for (User user : allUsers) {
                if (user.getRole() == null || !user.getRole().equalsIgnoreCase("admin")) {
                    count++;
                }
            }
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * TÍNH DOANH THU THÁNG NÀY - CHỈ ĐƠN ĐÃ HOÀN THÀNH
     */
    private double calculateMonthlyRevenue() {
        String sql = "SELECT COALESCE(SUM(total), 0) AS revenue " +
                "FROM orders " +
                "WHERE status IN ('done', 'hoàn tất') " +
                "AND MONTH(created_at) = MONTH(CURRENT_DATE()) " +
                "AND YEAR(created_at) = (SELECT MAX(YEAR(created_at)) FROM orders WHERE status IN ('done', 'hoàn tất'))";

        System.out.println("[DEBUG] calculateMonthlyRevenue SQL: " + sql);

        try (Connection conn = DBConnect.getInstance().getConnect();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                double revenue = rs.getDouble("revenue");
                System.out.println("[DEBUG] Monthly revenue calculated: " + revenue);

                if (revenue == 0) {
                    return calculateRevenueFromLatestMonth();
                }
                return revenue;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("[ERROR] calculateMonthlyRevenue: " + e.getMessage());
        }
        return 0.0;
    }

    /**
     * DOANH THU THÁNG TỪ ĐƠN HÀNG MỚI NHẤT - CHỈ ĐƠN ĐÃ HOÀN THÀNH
     */
    private double calculateRevenueFromLatestMonth() {
        String sql = "SELECT COALESCE(SUM(total), 0) AS revenue " +
                "FROM orders " +
                "WHERE status IN ('done', 'hoàn tất') " +
                "AND MONTH(created_at) = (SELECT MONTH(MAX(created_at)) FROM orders WHERE status IN ('done', 'hoàn tất')) " +
                "AND YEAR(created_at) = (SELECT YEAR(MAX(created_at)) FROM orders WHERE status IN ('done', 'hoàn tất'))";

        System.out.println("[DEBUG] calculateRevenueFromLatestMonth SQL: " + sql);

        try (Connection conn = DBConnect.getInstance().getConnect();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                double revenue = rs.getDouble("revenue");
                System.out.println("[DEBUG] Revenue from latest month: " + revenue);
                return revenue;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * LẤY DỮ LIỆU DOANH THU 6 THÁNG GẦN NHẤT - CHỈ ĐƠN ĐÃ HOÀN THÀNH
     */
    private String[] getRevenueChartData() {
        List<String> labels = new ArrayList<>();
        List<Double> values = new ArrayList<>();

        String sql = "SELECT " +
                "DATE_FORMAT(created_at, '%b') AS month_label, " +
                "YEAR(created_at) as year, " +
                "MONTH(created_at) as month_num, " +
                "COALESCE(SUM(total), 0) AS revenue " +
                "FROM orders " +
                "WHERE status IN ('done', 'hoàn tất') " +
                "GROUP BY YEAR(created_at), MONTH(created_at) " +
                "ORDER BY YEAR(created_at) DESC, MONTH(created_at) DESC " +
                "LIMIT 6";

        System.out.println("[DEBUG] getRevenueChartData SQL: " + sql);

        Map<String, Double> monthlyData = new LinkedHashMap<>();

        try (Connection conn = DBConnect.getInstance().getConnect();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                String monthLabel = rs.getString("month_label");
                int year = rs.getInt("year");
                int monthNum = rs.getInt("month_num");
                double revenue = rs.getDouble("revenue");

                double revenueInMillion = revenue / 1000000.0;

                String key = monthLabel + " " + year;
                monthlyData.put(key, revenueInMillion);
                System.out.println("[DEBUG] Found completed order data: " + key + " = " + revenueInMillion + " triệu");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("[ERROR] getRevenueChartData: " + e.getMessage());
        }

        if (!monthlyData.isEmpty()) {
            List<String> sortedMonths = new ArrayList<>(monthlyData.keySet());
            Collections.reverse(sortedMonths);

            for (String monthKey : sortedMonths) {
                labels.add(monthKey);
                values.add(monthlyData.get(monthKey));
            }
        }

        if (labels.isEmpty()) {
            System.out.println("[DEBUG] No monthly data for completed orders, checking all completed orders...");
            labels.addAll(Arrays.asList("Jan 2025", "Feb 2025", "Mar 2025", "Apr 2025", "May 2025", "Jun 2025"));

            String completedOrdersSql = "SELECT total, created_at FROM orders WHERE status IN ('done', 'hoàn tất')";
            try (Connection conn = DBConnect.getInstance().getConnect();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(completedOrdersSql)) {

                double totalRevenue = 0;
                int orderCount = 0;
                while (rs.next()) {
                    orderCount++;
                    totalRevenue += rs.getDouble("total");
                }

                System.out.println("[DEBUG] Found " + orderCount + " completed orders, total: " + totalRevenue);

                if (orderCount > 0) {
                    double avgPerMonth = totalRevenue / 6 / 1000000.0;
                    for (int i = 0; i < 6; i++) {
                        values.add(Math.round(avgPerMonth * 10.0) / 10.0);
                    }
                } else {
                    values.addAll(Arrays.asList(0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
                }

            } catch (SQLException e) {
                e.printStackTrace();
                values.addAll(Arrays.asList(0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
            }
        }

        String labelsStr = "['" + String.join("','", labels) + "']";
        String valuesStr = values.toString();

        System.out.println("[DEBUG] Final chart labels: " + labelsStr);
        System.out.println("[DEBUG] Final chart values: " + valuesStr);

        return new String[]{labelsStr, valuesStr};
    }

    private List<Double> parseDoubleArray(String arrayStr) {
        List<Double> result = new ArrayList<>();
        String cleaned = arrayStr.replace("[", "").replace("]", "").trim();
        if (cleaned.isEmpty()) {
            return result;
        }
        for (String val : cleaned.split(",")) {
            try {
                result.add(Double.parseDouble(val.trim()));
            } catch (NumberFormatException e) {
                result.add(0.0);
            }
        }
        return result;
    }

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}