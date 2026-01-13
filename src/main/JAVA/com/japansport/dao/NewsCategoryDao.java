package com.japansport.dao;

import com.japansport.model.NewsCategory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NewsCategoryDao extends DAO {

    public NewsCategoryDao() {
        super();
    }

    public int insert(NewsCategory category) {
        String sql = "INSERT INTO news_categories (name, slug, description, active) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, category.getName());
            ps.setString(2, category.getSlug());
            ps.setString(3, category.getDescription());
            ps.setBoolean(4, category.isActive());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
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

    public List<NewsCategory> getAll() {
        List<NewsCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM news_categories ORDER BY name ASC";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<NewsCategory> getAllActive() {
        List<NewsCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM news_categories WHERE active = TRUE ORDER BY name ASC";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public NewsCategory getById(int id) {
        String sql = "SELECT * FROM news_categories WHERE id = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRowToCategory(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public NewsCategory getBySlug(String slug) {
        String sql = "SELECT * FROM news_categories WHERE slug = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, slug);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRowToCategory(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(NewsCategory category) {
        String sql = "UPDATE news_categories SET name=?, slug=?, description=?, active=? WHERE id=?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getName());
            ps.setString(2, category.getSlug());
            ps.setString(3, category.getDescription());
            ps.setBoolean(4, category.isActive());
            ps.setInt(5, category.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM news_categories WHERE id = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addCategoryToNews(int newsId, int categoryId) {
        String sql = "INSERT INTO news_category_mapping (news_id, category_id) VALUES (?, ?)";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newsId);
            ps.setInt(2, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeCategoriesFromNews(int newsId) {
        String sql = "DELETE FROM news_category_mapping WHERE news_id = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newsId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<NewsCategory> getCategoriesByNewsId(int newsId) {
        List<NewsCategory> list = new ArrayList<>();
        String sql = "SELECT c.* FROM news_categories c " +
                "INNER JOIN news_category_mapping m ON c.id = m.category_id " +
                "WHERE m.news_id = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newsId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRowToCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private NewsCategory mapRowToCategory(ResultSet rs) throws SQLException {
        NewsCategory category = new NewsCategory();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setSlug(rs.getString("slug"));
        category.setDescription(rs.getString("description"));
        category.setActive(rs.getBoolean("active"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        return category;
    }
}