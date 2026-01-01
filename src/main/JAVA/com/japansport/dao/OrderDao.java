package com.japansport.dao;

import com.japansport.model.CartItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao extends DAO {

    public int placeOrderFromCart(
            int userId,
            String fullName, String phone,
            String addressLine, String city, String district, String ward,
            String payMethod, String note
    ) throws SQLException {

        Connection conn = getConnection();
        boolean oldAuto = conn.getAutoCommit();
        conn.setAutoCommit(false);

        try {
            // 1) Lấy cart ACTIVE (hướng B)
            int cartId = getOrCreateActiveCartId(conn, userId);

            // 2) Lock items để checkout an toàn (tránh đổi qty khi đang đặt)
            List<CartItem> items = getCartItemsForUpdate(conn, cartId);
            if (items.isEmpty()) {
                throw new SQLException("Giỏ hàng trống.");
            }

            // 3) Lưu địa chỉ (set default)
            int addressId = insertAddressAsDefault(
                    conn, userId, fullName, phone, addressLine, city, district, ward
            );

            // 4) Tính tổng tiền
            double total = 0;
            for (CartItem it : items) total += it.getSubtotal();

            // 5) Tạo order
            int orderId = insertOrder(conn, userId, addressId, total, "PENDING");

            // 6) Tạo order_items
            insertOrderItems(conn, orderId, items);

            // 7) Trừ tồn kho variant (nếu có variant)
            for (CartItem it : items) {
                if (it.getVariantId() != null) {
                    String upd = "UPDATE product_variants " +
                            "SET stock_qty = stock_qty - ? " +
                            "WHERE id=? AND stock_qty >= ?";
                    try (PreparedStatement ps = conn.prepareStatement(upd)) {
                        ps.setInt(1, it.getQuantity());
                        ps.setInt(2, it.getVariantId());
                        ps.setInt(3, it.getQuantity());
                        int affected = ps.executeUpdate();
                        if (affected != 1) {
                            throw new SQLException("Không đủ tồn kho cho biến thể: " + it.getVariantId());
                        }
                    }
                }
            }

            // 8) Clear cart_items
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM cart_items WHERE cart_id=?")) {
                ps.setInt(1, cartId);
                ps.executeUpdate();
            }

            // 9) Chốt cart ACTIVE -> ORDERED (Hướng B)
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE carts " +
                            "SET status='ORDERED', is_active=0, active_key=NULL, updated_at=CURRENT_TIMESTAMP " +
                            "WHERE id=?"
            )) {
                ps.setInt(1, cartId);
                ps.executeUpdate();
            }

            conn.commit();
            return orderId;

        } catch (SQLException ex) {
            conn.rollback();
            throw ex;
        } finally {
            conn.setAutoCommit(oldAuto);
        }
    }

    /**
     * Hướng B:
     * - Tìm cart ACTIVE: carts.user_id = ? AND is_active = 1
     * - Nếu chưa có: tạo cart mới ACTIVE (active_key = user_id)
     * - Nếu bị trùng UNIQUE(active_key) do race-condition: query lại cart ACTIVE và trả về.
     */
    private int getOrCreateActiveCartId(Connection conn, int userId) throws SQLException {
        String find = "SELECT id FROM carts WHERE user_id=? AND is_active=1 ORDER BY updated_at DESC, id DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(find)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        }

        String ins = "INSERT INTO carts(user_id, status, is_active, active_key) VALUES(?, 'ACTIVE', 1, ?)";
        try (PreparedStatement ps = conn.prepareStatement(ins, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException ex) {
            // Nếu trùng UNIQUE(active_key) => đã có cart ACTIVE được tạo bởi request khác
            try (PreparedStatement ps2 = conn.prepareStatement(find)) {
                ps2.setInt(1, userId);
                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) return rs2.getInt("id");
                }
            }
            throw ex;
        }

        throw new SQLException("Cannot create active cart");
    }

    private List<CartItem> getCartItemsForUpdate(Connection conn, int cartId) throws SQLException {
        String sql =
                "SELECT ci.id AS cart_item_id, ci.product_id, ci.variant_id, ci.quantity, " +
                        "p.name, p.image_url, v.color, v.size, COALESCE(v.price, p.price) AS unit_price, v.stock_qty " +
                        "FROM cart_items ci " +
                        "JOIN products p ON p.id = ci.product_id " +
                        "LEFT JOIN product_variants v ON v.id = ci.variant_id " +
                        "WHERE ci.cart_id=? FOR UPDATE";

        List<CartItem> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem it = new CartItem();
                    it.setCartItemId(rs.getInt("cart_item_id"));
                    it.setProductId(rs.getInt("product_id"));

                    int vid = rs.getInt("variant_id");
                    it.setVariantId(rs.wasNull() ? null : vid);

                    it.setQuantity(rs.getInt("quantity"));
                    it.setProductName(rs.getString("name"));
                    it.setImageUrl(rs.getString("image_url"));
                    it.setColor(rs.getString("color"));
                    it.setSize(rs.getString("size"));
                    it.setUnitPrice(rs.getDouble("unit_price"));

                    int stock = rs.getInt("stock_qty");
                    it.setStockQty(rs.wasNull() ? -1 : stock);

                    list.add(it);
                }
            }
        }
        return list;
    }

    private int insertAddressAsDefault(Connection conn, int userId,
                                       String fullName, String phone, String addressLine,
                                       String city, String district, String ward) throws SQLException {

        try (PreparedStatement ps = conn.prepareStatement("UPDATE user_addresses SET is_default=0 WHERE user_id=?")) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }

        String ins =
                "INSERT INTO user_addresses(user_id, full_name, phone, address_line, city, district, ward, is_default) " +
                        "VALUES(?,?,?,?,?,?,?,1)";
        try (PreparedStatement ps = conn.prepareStatement(ins, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, fullName);
            ps.setString(3, phone);
            ps.setString(4, addressLine);
            ps.setString(5, city);
            ps.setString(6, district);
            ps.setString(7, ward);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }

        throw new SQLException("Cannot insert address");
    }

    private int insertOrder(Connection conn, int userId, int addressId, double total, String status) throws SQLException {
        String ins = "INSERT INTO orders(user_id, address_id, total_amount, status) VALUES(?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(ins, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, addressId);
            ps.setDouble(3, total);
            ps.setString(4, status);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }

        throw new SQLException("Cannot insert order");
    }

    private void insertOrderItems(Connection conn, int orderId, List<CartItem> items) throws SQLException {
        String ins = "INSERT INTO order_items(order_id, product_id, variant_id, color, size, quantity, unit_price, subtotal) " +
                "VALUES(?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(ins)) {
            for (CartItem it : items) {
                ps.setInt(1, orderId);
                ps.setInt(2, it.getProductId());

                if (it.getVariantId() == null) ps.setNull(3, Types.INTEGER);
                else ps.setInt(3, it.getVariantId());

                ps.setString(4, it.getColor());
                ps.setString(5, it.getSize());
                ps.setInt(6, it.getQuantity());
                ps.setDouble(7, it.getUnitPrice());
                ps.setDouble(8, it.getSubtotal());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }
}
