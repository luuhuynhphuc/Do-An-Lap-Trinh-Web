package com.japansport.dao;

import com.japansport.model.ProductVariant;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ProductVariantDAO extends DAO {

    public ProductVariantDAO() {
        super();
    }

    private ProductVariant mapRow(ResultSet rs) throws SQLException {
        ProductVariant v = new ProductVariant();
        v.setId(rs.getInt("id"));
        v.setProductId(rs.getInt("product_id"));
        v.setColor(rs.getString("color"));
        v.setSize(rs.getString("size"));
        v.setStockQty(rs.getInt("stock_qty"));
        v.setSku(rs.getString("sku"));

        // price có thể null
        double p = rs.getDouble("price");
        if (rs.wasNull()) v.setPrice(null);
        else v.setPrice(p);

        // created_at / updated_at (có thể có hoặc không tùy schema)
        try {
            Timestamp c = rs.getTimestamp("created_at");
            v.setCreatedAt(c);
        } catch (SQLException ignored) {}

        try {
            Timestamp u = rs.getTimestamp("updated_at");
            v.setUpdatedAt(u);
        } catch (SQLException ignored) {}

        return v;
    }

    /** Lấy tất cả biến thể theo productId (size, color, stock...) */
    public List<ProductVariant> findByProductId(int productId) {
        List<ProductVariant> list = new ArrayList<>();
        String sql =
                "SELECT id, product_id, color, size, stock_qty, sku, price, created_at, updated_at " +
                        "FROM product_variants " +
                        "WHERE product_id = ? " +
                        "ORDER BY color ASC, CAST(size AS UNSIGNED) ASC\n";

        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /** Lấy 1 biến thể theo id (dùng khi add-to-cart / checkout) */
    public ProductVariant findById(int id) {
        String sql =
                "SELECT id, product_id, color, size, stock_qty, sku, price, created_at, updated_at " +
                        "FROM product_variants " +
                        "WHERE id = ?";

        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Trừ kho an toàn: chỉ trừ nếu còn đủ hàng (tránh âm kho).
     * Trả về true nếu trừ thành công.
     */
    public boolean decreaseStock(int variantId, int qty) {
        String sql =
                "UPDATE product_variants " +
                        "SET stock_qty = stock_qty - ? " +
                        "WHERE id = ? AND stock_qty >= ?";

        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, qty);
            ps.setInt(2, variantId);
            ps.setInt(3, qty);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
