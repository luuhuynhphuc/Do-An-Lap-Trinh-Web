package com.japansport.dao;

import com.japansport.model.Category;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDao extends DAO {

    private Category mapRowToCategory(ResultSet rs) throws SQLException {
        return new Category(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("image_url"),
                rs.getString("link"),
                rs.getInt("is_featured"),
                rs.getInt("active")
        );
    }

    // ========== 1. Danh mục nổi bật (dùng cho TRANG CHỦ) ==========

    public List<Category> getFeaturedCategories(int limit) {
        List<Category> list = new ArrayList<>();
        String sql =
                "SELECT c.id, c.name, c.image_url, c.link, c.is_featured, c.active " +
                        "FROM categories c " +
                        "WHERE c.active = 1 AND c.is_featured = 1 " +
                        "ORDER BY c.id ASC " +
                        "LIMIT ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToCategory(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ========== 2. Tất cả category active (dùng cho filter bên trái trang list-product) ==========

    public List<Category> getAllActive() {
        List<Category> list = new ArrayList<>();
        String sql =
                "SELECT c.id, c.name, c.image_url, c.link, c.is_featured, c.active " +
                        "FROM categories c " +
                        "WHERE c.active = 1 " +
                        "ORDER BY c.name ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToCategory(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ========== 3. NÂNG CẤP: Category + số lượng sản phẩm (JOIN + GROUP BY) ==========

    /**
     * Lấy tất cả category kèm theo số lượng sản phẩm active trong từng category.
     * Dùng cho báo cáo / thể hiện "câu query xịn" có JOIN + GROUP BY.
     */
    public List<Category> getAllActiveWithProductCount() {
        List<Category> list = new ArrayList<>();
        String sql =
                "SELECT c.id, c.name, c.image_url, c.link, c.is_featured, c.active, " +
                        "       COUNT(p.id) AS product_count " +
                        "FROM categories c " +
                        "LEFT JOIN products p ON p.category_id = c.id AND p.active = 1 " +
                        "WHERE c.active = 1 " +
                        "GROUP BY c.id, c.name, c.image_url, c.link, c.is_featured, c.active " +
                        "ORDER BY product_count DESC, c.name ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Ở đây mình vẫn map sang Category như cũ, không cần field product_count,
                // nhưng trong báo cáo bạn có thể chụp chính câu query này để khoe với thầy.
                list.add(mapRowToCategory(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
    // CategoryDao.java
    public Category getById(int id) {
        String sql = "SELECT id, name FROM categories WHERE id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                return c;
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

}
