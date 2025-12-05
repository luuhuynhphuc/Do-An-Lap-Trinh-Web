package com.japansport.dao;

import com.japansport.model.Category;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CategoryDao extends DAO {

    // Dùng cho TRANG CHỦ: danh mục nổi bật (ví dụ 6 cái)
    public List<Category> getFeaturedCategories(int limit) {
        List<Category> list = new ArrayList<>();
        try {
            Statement st = getStatement();
            String sql = String.format(
                    "SELECT id, name, image_url, link, is_featured, active " +
                            "FROM categories " +
                            "WHERE active = 1 AND is_featured = 1 " +
                            "LIMIT %d",
                    limit
            );
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                Category c = new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("image_url"),
                        rs.getString("link"),
                        rs.getInt("is_featured"),
                        rs.getInt("active")
                );
                list.add(c);
            }
            return list;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // Dùng cho TRANG DANH SÁCH: tất cả danh mục đang active
    public List<Category> getAllActive() {
        List<Category> list = new ArrayList<>();
        try {
            Statement st = getStatement();
            String sql =
                    "SELECT id, name, image_url, link, is_featured, active " +
                            "FROM categories " +
                            "WHERE active = 1 " +
                            "ORDER BY name";
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                Category c = new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("image_url"),
                        rs.getString("link"),
                        rs.getInt("is_featured"),
                        rs.getInt("active")
                );
                list.add(c);
            }
            return list;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
