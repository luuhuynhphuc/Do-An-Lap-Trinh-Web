package com.japansport.dao;

import com.japansport.model.Policy;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PolicyDao extends DAO {

    /**
     * lay tat ca policies cho user
     */
    public List<Policy> getAllActive() {
        List<Policy> list = new ArrayList<>();
        String sql = "SELECT * FROM policies WHERE active = 1 ORDER BY display_order, title";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Policy policy = mapRowToPolicy(rs);
                list.add(policy);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lay tat ca policies cho admin
     */
    public List<Policy> getAll() {
        List<Policy> list = new ArrayList<>();
        String sql = "SELECT * FROM policies ORDER BY display_order, title";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Policy policy = mapRowToPolicy(rs);
                list.add(policy);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lay theo id
     */
    public Policy getById(int id) {
        String sql = "SELECT * FROM policies WHERE id = ?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToPolicy(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lay policy cho user xem theo slug
     */
    public Policy getBySlug(String slug) {
        String sql = "SELECT * FROM policies WHERE slug = ? AND active = 1";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, slug);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToPolicy(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Them policy
     */
    public int insert(Policy policy) {
        String sql = "INSERT INTO policies (title, slug, content, policy_type, display_order, active) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, policy.getTitle());

            String slug = policy.getSlug();
            if (slug == null || slug.trim().isEmpty()) {
                slug = Policy.generateSlug(policy.getTitle());
            }
            ps.setString(2, slug);

            ps.setString(3, policy.getContent());
            ps.setString(4, policy.getPolicyType());
            ps.setInt(5, policy.getDisplayOrder());
            ps.setInt(6, policy.getActive());

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
     * cap nhat policy
     */
    public boolean update(Policy policy) {
        String sql = "UPDATE policies SET title=?, slug=?, content=?, policy_type=?, " +
                "display_order=?, active=? WHERE id=?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, policy.getTitle());

            String slug = policy.getSlug();
            if (slug == null || slug.trim().isEmpty()) {
                slug = Policy.generateSlug(policy.getTitle());
            }
            ps.setString(2, slug);

            ps.setString(3, policy.getContent());
            ps.setString(4, policy.getPolicyType());
            ps.setInt(5, policy.getDisplayOrder());
            ps.setInt(6, policy.getActive());
            ps.setInt(7, policy.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa policy
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM policies WHERE id=?";

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
     * Map ResultSet -> Policy object
     */
    private Policy mapRowToPolicy(ResultSet rs) throws SQLException {
        Policy policy = new Policy();
        policy.setId(rs.getInt("id"));
        policy.setTitle(rs.getString("title"));
        policy.setSlug(rs.getString("slug"));
        policy.setContent(rs.getString("content"));
        policy.setPolicyType(rs.getString("policy_type"));
        policy.setDisplayOrder(rs.getInt("display_order"));
        policy.setActive(rs.getInt("active"));
        return policy;
    }
}