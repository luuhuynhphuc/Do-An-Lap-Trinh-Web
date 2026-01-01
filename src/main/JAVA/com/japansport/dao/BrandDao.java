package com.japansport.dao;

import com.japansport.model.Brand;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BrandDao extends DAO {

    public BrandDao() {
        super();
    }

    private Brand mapRowToBrand(ResultSet rs) throws SQLException {
        Brand b = new Brand();
        b.setId(rs.getInt("id"));
        b.setName(rs.getString("name"));
        b.setSlug(rs.getString("slug"));
        b.setLogoUrl(rs.getString("logo_url"));
        b.setActive(rs.getBoolean("active"));
        return b;
    }

    // ========== 1. Danh sách brand active (dùng cho filter brand) ==========

    public List<Brand> getAllActive() {
        List<Brand> list = new ArrayList<>();
        String sql =
                "SELECT b.id, b.name, b.slug, b.logo_url, b.active " +
                        "FROM brands b " +
                        "WHERE b.active = 1 " +
                        "ORDER BY b.name ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBrand(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ========== 2. Brand theo id (cho trang chi tiết) ==========

    public Brand getById(int id) {
        String sql =
                "SELECT b.id, b.name, b.slug, b.logo_url, b.active " +
                        "FROM brands b " +
                        "WHERE b.id = ?";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToBrand(rs);
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }


    public List<Brand> getActiveBrandsWithProductCount() {
        List<Brand> list = new ArrayList<>();
        String sql =
                "SELECT b.id, b.name, b.slug, b.logo_url, b.active, " +
                        "       COUNT(p.id) AS product_count " +
                        "FROM brands b " +
                        "LEFT JOIN products p ON p.brand_id = b.id AND p.active = 1 " +
                        "WHERE b.active = 1 " +
                        "GROUP BY b.id, b.name, b.slug, b.logo_url, b.active " +
                        "ORDER BY product_count DESC, b.name ASC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Giống Category: mình không cần set product_count vào Brand,
                // nhưng câu query thể hiện rõ sự nâng cấp.
                list.add(mapRowToBrand(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
