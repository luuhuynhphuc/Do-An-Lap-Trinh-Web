package com.japansport.dao;

import com.japansport.model.ProductImage;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductImageDao extends DAO {

    public ProductImageDao() {
        super();
    }

    private ProductImage map(ResultSet rs) throws SQLException {
        ProductImage img = new ProductImage();
        img.setId(rs.getInt("id"));
        img.setProductId(rs.getInt("product_id"));
        img.setImageUrl(rs.getString("image_url"));
        img.setAlt(rs.getString("alt"));
        img.setMainImage(rs.getInt("is_main") == 1);
        img.setSortOrder(rs.getInt("sort_order"));
        img.setActive(rs.getInt("active") == 1);
        img.setColor(rs.getString("color"));
        return img;
    }

    // Lấy toàn bộ ảnh của sản phẩm (để lọc theo màu ở JSP/JS)
    public List<ProductImage> getByProductId(int productId) {
        List<ProductImage> list = new ArrayList<>();
        String sql =
                "SELECT id, product_id, image_url, alt, is_main, sort_order, active, color " +
                        "FROM product_images " +
                        "WHERE product_id = ? AND active = 1 " +
                        "ORDER BY (color IS NULL) ASC, color ASC, is_main DESC, sort_order ASC, id ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // (Không bắt buộc) Nếu bạn muốn lọc ảnh theo màu ngay từ DB
    public List<ProductImage> getByProductIdAndColor(int productId, String color) {
        List<ProductImage> list = new ArrayList<>();
        String sql =
                "SELECT id, product_id, image_url, alt, is_main, sort_order, active, color " +
                        "FROM product_images " +
                        "WHERE product_id = ? AND active = 1 AND LOWER(TRIM(color)) = LOWER(TRIM(?)) " +
                        "ORDER BY is_main DESC, sort_order ASC, id ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, productId);
            ps.setString(2, color);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
