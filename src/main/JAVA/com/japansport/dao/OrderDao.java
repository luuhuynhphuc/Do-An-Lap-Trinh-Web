package com.japansport.dao;

import com.japansport.model.Order;
import com.japansport.model.OrderItem;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderDao extends DAO {

    public OrderDao() {
        super();
    }

    private Order mapRowToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();

        order.setId(rs.getInt("id"));
        order.setOrderCode(rs.getString("order_code"));
        order.setUserId(rs.getInt("user_id"));

        // Thong tin KH
        order.setCustomerName(rs.getString("customer_name"));
        order.setCustomerPhone(rs.getString("customer_phone"));
        order.setCustomerEmail(rs.getString("customer_email"));
        order.setShippingAddress(rs.getString("shipping_address"));

        // Thong tin order
        order.setShippingMethod(rs.getString("shipping_method"));
        order.setTrackingCode(rs.getString("tracking_code"));
        order.setVoucherCode(rs.getString("voucher_code"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));

        // cac gia tri
        order.setSubtotal(rs.getDouble("subtotal"));
        order.setDiscount(rs.getDouble("discount"));
        order.setShippingFee(rs.getDouble("shipping_fee"));
        order.setTotal(rs.getDouble("total"));

        // Trang thai
        order.setStatus(rs.getString("status"));
        order.setNote(rs.getString("note"));

        // thoi gian tao don
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            order.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            order.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        // thong tin user
        try {
            order.setUserName(rs.getString("user_name"));
        } catch (SQLException ignored) {
            // Cột user_name không tồn tại trong query này
        }

        return order;
    }

    /**
     * Them order moi
     *
     */
    public int insert(Order order) {
        String sql = "INSERT INTO orders (order_code, user_id, customer_name, customer_phone, " +
                "customer_email, shipping_address, shipping_method, tracking_code, " +
                "voucher_code, payment_method, payment_status, subtotal, discount, " +
                "shipping_fee, total, status, note, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, order.getOrderCode());
            ps.setInt(2, order.getUserId());
            ps.setString(3, order.getCustomerName());
            ps.setString(4, order.getCustomerPhone());
            ps.setString(5, order.getCustomerEmail());
            ps.setString(6, order.getShippingAddress());
            ps.setString(7, order.getShippingMethod());
            ps.setString(8, order.getTrackingCode());
            ps.setString(9, order.getVoucherCode());
            ps.setString(10, order.getPaymentMethod());
            ps.setString(11, order.getPaymentStatus());
            ps.setDouble(12, order.getSubtotal());
            ps.setDouble(13, order.getDiscount());
            ps.setDouble(14, order.getShippingFee());
            ps.setDouble(15, order.getTotal());
            ps.setString(16, order.getStatus());
            ps.setString(17, order.getNote());
            ps.setTimestamp(18, Timestamp.valueOf(order.getCreatedAt()));
            ps.setTimestamp(19, Timestamp.valueOf(order.getUpdatedAt()));

            int affected = ps.executeUpdate();

            if (affected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Them sp vao don
     */
    public boolean insertOrderItem(OrderItem item) {
        String sql = "INSERT INTO order_items (order_id, product_id, product_name, " +
                "product_image, quantity, price, size, color) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getProductId());
            ps.setString(3, item.getProductName());
            ps.setString(4, item.getProductImage());
            ps.setInt(5, item.getQuantity());
            ps.setDouble(6, item.getPrice());
            ps.setString(7, item.getSize());
            ps.setString(8, item.getColor());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * lay tat ca don hang (get moi nhat)
     */
    public List<Order> getAll() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.name AS user_name " +
                "FROM orders o " +
                "LEFT JOIN users u ON o.user_id = u.id " +
                "ORDER BY o.created_at DESC";

        try {
            Statement st = getStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                Order order = mapRowToOrder(rs);
                list.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * lay order theo ID
     */
    public Order getById(int id) {
        String sql = "SELECT o.*, u.name AS user_name " +
                "FROM orders o " +
                "LEFT JOIN users u ON o.user_id = u.id " +
                "WHERE o.id = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Order order = mapRowToOrder(rs);
                // Load items
                order.setItems(getOrderItems(id));
                return order;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * get order theo orderID
     */
    public Order getByOrderCode(String orderCode) {
        String sql = "SELECT o.*, u.name AS user_name " +
                "FROM orders o " +
                "LEFT JOIN users u ON o.user_id = u.id " +
                "WHERE o.order_code = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, orderCode);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Order order = mapRowToOrder(rs);
                order.setItems(getOrderItems(order.getId()));
                return order;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * lay danh sach tung item cua 1 don hang
     */
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();

        // JOIN với bảng products để đảm bảo luôn có tên sản phẩm
        String sql = "SELECT oi.*, " +
                "       COALESCE(oi.product_name, p.name) AS product_name, " +
                "       COALESCE(oi.product_image, p.image_url) AS product_image " +
                "FROM order_items oi " +
                "LEFT JOIN products p ON oi.product_id = p.id " +
                "WHERE oi.order_id = ? " +
                "ORDER BY oi.id";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setProductImage(rs.getString("product_image"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));

                // Optional fields
                try {
                    item.setSize(rs.getString("size"));
                    item.setColor(rs.getString("color"));
                } catch (SQLException ignored) {
                    // Columns might not exist
                }

                items.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * tim kiem order(name, phone, email, order code)
     */
    public List<Order> search(String keyword) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.name AS user_name " +
                "FROM orders o " +
                "LEFT JOIN users u ON o.user_id = u.id " +
                "WHERE o.order_code LIKE ? " +
                "   OR o.customer_name LIKE ? " +
                "   OR o.customer_phone LIKE ? " +
                "   OR o.customer_email LIKE ? " +
                "ORDER BY o.created_at DESC";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = mapRowToOrder(rs);
                list.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /**
     * update thong tin order
     */
    public boolean update(Order order) {
        String sql = "UPDATE orders SET " +
                "customer_name=?, customer_phone=?, customer_email=?, " +
                "shipping_address=?, shipping_method=?, tracking_code=?, " +
                "voucher_code=?, payment_method=?, payment_status=?, " +
                "subtotal=?, discount=?, shipping_fee=?, total=?, " +
                "status=?, note=?, updated_at=? " +
                "WHERE id=?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, order.getCustomerName());
            ps.setString(2, order.getCustomerPhone());
            ps.setString(3, order.getCustomerEmail());
            ps.setString(4, order.getShippingAddress());
            ps.setString(5, order.getShippingMethod());
            ps.setString(6, order.getTrackingCode());
            ps.setString(7, order.getVoucherCode());
            ps.setString(8, order.getPaymentMethod());
            ps.setString(9, order.getPaymentStatus());
            ps.setDouble(10, order.getSubtotal());
            ps.setDouble(11, order.getDiscount());
            ps.setDouble(12, order.getShippingFee());
            ps.setDouble(13, order.getTotal());
            ps.setString(14, order.getStatus());
            ps.setString(15, order.getNote());
            ps.setTimestamp(16, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(17, order.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * cap nhat order status
     */
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status=?, updated_at=? WHERE id=?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, orderId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * xoa order (bao gom item)
     */
    public boolean delete(int id) {
        Connection conn = null;
        try {
            conn = DBConnect.getInstance().getConnect();
            conn.setAutoCommit(false);

            // 1. xoa item truoc
            String sqlItems = "DELETE FROM order_items WHERE order_id=?";
            try (PreparedStatement ps = conn.prepareStatement(sqlItems)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            // 2. xoa order
            String sqlOrder = "DELETE FROM orders WHERE id=?";
            try (PreparedStatement ps = conn.prepareStatement(sqlOrder)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu lỗi
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * dem tong so order
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) AS total FROM orders";
        try {
            Statement st = getStatement();
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * dem order theo status
     */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) AS total FROM orders WHERE status=?";
        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}