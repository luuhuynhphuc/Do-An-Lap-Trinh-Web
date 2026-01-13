package com.japansport.dao;

import com.japansport.model.News;
import com.japansport.model.NewsCategory;
import com.japansport.model.NewsTag;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NewsDao extends DAO {

    public NewsDao() {
        super();
    }

    public int insert(News news) {
        String sql = "INSERT INTO news (title, slug, summary, content, thumbnail_url, " +
                "author, status, featured) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, news.getTitle());
            ps.setString(2, news.getSlug());
            ps.setString(3, news.getSummary());
            ps.setString(4, news.getContent());
            ps.setString(5, news.getThumbnailUrl());
            ps.setString(6, news.getAuthor());
            ps.setString(7, news.getStatus());
            ps.setBoolean(8, news.isFeatured());

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

    public List<News> getAll() {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM news ORDER BY created_at DESC";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToNews(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<News> getAllPublished() {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE status = 'published' ORDER BY created_at DESC";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToNews(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public News getById(int id) {
        String sql = "SELECT * FROM news WHERE id = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRowToNews(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public News getBySlug(String slug) {
        String sql = "SELECT * FROM news WHERE slug = ? AND status = 'published'";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, slug);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRowToNews(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<News> getFeaturedNews(int limit) {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE status = 'published' AND featured = TRUE " +
                "ORDER BY created_at DESC LIMIT ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRowToNews(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean update(News news) {
        String sql = "UPDATE news SET title=?, slug=?, summary=?, content=?, " +
                "thumbnail_url=?, author=?, status=?, featured=? WHERE id=?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, news.getTitle());
            ps.setString(2, news.getSlug());
            ps.setString(3, news.getSummary());
            ps.setString(4, news.getContent());
            ps.setString(5, news.getThumbnailUrl());
            ps.setString(6, news.getAuthor());
            ps.setString(7, news.getStatus());
            ps.setBoolean(8, news.isFeatured());
            ps.setInt(9, news.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean incrementViewCount(int newsId) {
        String sql = "UPDATE news SET view_count = view_count + 1 WHERE id = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newsId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM news WHERE id = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private News mapRowToNews(ResultSet rs) throws SQLException {
        News news = new News();
        news.setId(rs.getInt("id"));
        news.setTitle(rs.getString("title"));
        news.setSlug(rs.getString("slug"));
        news.setSummary(rs.getString("summary"));
        news.setContent(rs.getString("content"));
        news.setThumbnailUrl(rs.getString("thumbnail_url"));
        news.setAuthor(rs.getString("author"));
        news.setViewCount(rs.getInt("view_count"));
        news.setStatus(rs.getString("status"));
        news.setFeatured(rs.getBoolean("featured"));
        news.setCreatedAt(rs.getTimestamp("created_at"));
        news.setUpdatedAt(rs.getTimestamp("updated_at"));
        return news;
    }

    public List<News> searchByTitle(String keyword) {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE title LIKE ? AND status = 'published' " +
                "ORDER BY created_at DESC";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRowToNews(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) AS total FROM news";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}