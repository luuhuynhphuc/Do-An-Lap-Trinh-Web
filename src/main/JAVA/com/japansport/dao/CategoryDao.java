package com.japansport.dao;

import com.japansport.model.Category;

import java.sql.*;
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
    /**
     * Lay tat ca danh muc cho Admin
     */
    public List<Category> getAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT c.* " +
                "FROM categories c " +
                "ORDER BY c.display_order, c.name";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category cat = new Category();
                cat.setId(rs.getInt("id"));
                cat.setName(rs.getString("name"));
                cat.setImage_url(rs.getString("image_url"));
                cat.setLink(rs.getString("link"));
                cat.setIs_featured(rs.getInt("is_featured"));
                cat.setActive(rs.getInt("active"));


                try {
                    cat.setSlug(rs.getString("slug"));
                    cat.setParent_id((Integer) rs.getObject("parent_id"));
                    cat.setDisplay_order(rs.getInt("display_order"));
                } catch (SQLException ignored) {
                }

                categories.add(cat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    /**
     * Lay danh muc theo ID
     */
    public Category getById(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category cat = new Category();
                    cat.setId(rs.getInt("id"));
                    cat.setName(rs.getString("name"));
                    cat.setImage_url(rs.getString("image_url"));
                    cat.setLink(rs.getString("link"));
                    cat.setIs_featured(rs.getInt("is_featured"));
                    cat.setActive(rs.getInt("active"));

                    try {
                        cat.setSlug(rs.getString("slug"));
                        cat.setParent_id((Integer) rs.getObject("parent_id"));
                        cat.setDisplay_order(rs.getInt("display_order"));
                    } catch (SQLException ignored) {}

                    return cat;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Thêm danh mục mới
     */
    public int insert(Category category) {
        // Dynamic SQL dựa trên cột có sẵn
        String sql = "INSERT INTO categories (name, image_url, link, is_featured, active, slug, parent_id, display_order) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, category.getName());
            ps.setString(2, category.getImage_url());
            ps.setString(3, category.getLink());
            ps.setInt(4, category.getIs_featured());
            ps.setInt(5, category.getActive());

            // Tự động tạo slug nếu chưa có
            String slug = category.getSlug();
            if (slug == null || slug.trim().isEmpty()) {
                slug = Category.generateSlug(category.getName());
            }
            ps.setString(6, slug);

            if (category.getParent_id() != null) {
                ps.setInt(7, category.getParent_id());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            ps.setInt(8, category.getDisplay_order());

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

    /**
     * Cập nhật danh mục
     */
    public boolean update(Category category) {
        String sql = "UPDATE categories SET name=?, image_url=?, link=?, " +
                "is_featured=?, active=?, slug=?, parent_id=?, display_order=? " +
                "WHERE id=?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getName());
            ps.setString(2, category.getImage_url());
            ps.setString(3, category.getLink());
            ps.setInt(4, category.getIs_featured());
            ps.setInt(5, category.getActive());

            String slug = category.getSlug();
            if (slug == null || slug.trim().isEmpty()) {
                slug = Category.generateSlug(category.getName());
            }
            ps.setString(6, slug);

            if (category.getParent_id() != null) {
                ps.setInt(7, category.getParent_id());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            ps.setInt(8, category.getDisplay_order());
            ps.setInt(9, category.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa danh mục (admin only)
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM categories WHERE id=?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh mục cha (cho dropdown select)
     */
    public List<Category> getParentCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE parent_id IS NULL AND active = 1 " +
                "ORDER BY display_order, name";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category cat = new Category();
                cat.setId(rs.getInt("id"));
                cat.setName(rs.getString("name"));
                categories.add(cat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Test DAO
     */
    public static void main(String[] args) {
        CategoryDao dao = new CategoryDao();

        // Test getAll
        System.out.println("=== TEST GET ALL ===");
        List<Category> all = dao.getAll();
        System.out.println("Total: " + all.size());
        for (Category cat : all) {
            System.out.println(cat);
        }

        // Test getFeaturedCategories (method cũ)
        System.out.println("\n=== TEST GET FEATURED ===");
        List<Category> featured = dao.getFeaturedCategories(6);
        System.out.println("Featured: " + featured.size());
    }
}
