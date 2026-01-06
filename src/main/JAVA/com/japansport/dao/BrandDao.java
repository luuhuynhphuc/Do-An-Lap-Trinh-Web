package com.japansport.dao;

import com.japansport.model.Brand;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BrandDao extends DAO {

    public BrandDao() {
        super();
    }

    public List<Brand> getAllActive() {
        List<Brand> list = new ArrayList<>();
        try {
            Statement st = getStatement();
            String sql = "SELECT id, name, slug, logo_url, active " +
                    "FROM brands WHERE active = 1 ORDER BY name ASC";
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                Brand b = new Brand();
                b.setId(rs.getInt("id"));
                b.setName(rs.getString("name"));
                b.setSlug(rs.getString("slug"));
                b.setLogoUrl(rs.getString("logo_url"));
                b.setActive(rs.getBoolean("active"));
                list.add(b);
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public Brand getById(int id) {
        try {
            Statement st = getStatement();
            String sql = "SELECT id, name, slug, logo_url, active " +
                    "FROM brands WHERE id = " + id;
            ResultSet rs = st.executeQuery(sql);

            if (rs.next()) {
                Brand b = new Brand();
                b.setId(rs.getInt("id"));
                b.setName(rs.getString("name"));
                b.setSlug(rs.getString("slug"));
                b.setLogoUrl(rs.getString("logo_url"));
                b.setActive(rs.getBoolean("active"));
                return b;
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
    /**
     * Lay all brand cho admin
     */
    public List<Brand> getAll() {
        List<Brand> list = new ArrayList<>();
        String sql = "SELECT * FROM brands ORDER BY name";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Brand brand = new Brand();
                brand.setId(rs.getInt("id"));
                brand.setName(rs.getString("name"));

                try {
                    brand.setSlug(rs.getString("slug"));
                    brand.setLogoUrl(rs.getString("logo_url"));
                    brand.setActive(rs.getBoolean("active"));
                } catch (SQLException ignored) {}

                list.add(brand);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /**
     * Them brand moi
     */
    public int insert(Brand brand) {
        String sql = "INSERT INTO brands (name, slug, logo_url, active) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, brand.getName());
            ps.setString(2, brand.getSlug());
            ps.setString(3, brand.getLogoUrl());
            ps.setInt(4, brand.getActive());

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
     * Cập nhật brand
     */
    public boolean update(Brand brand) {
        String sql = "UPDATE brands SET name=?, slug=?, logo_url=?, active=? WHERE id=?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, brand.getName());
            ps.setString(2, brand.getSlug());
            ps.setString(3, brand.getLogoUrl());
            ps.setInt(4, brand.getActive());
            ps.setInt(5, brand.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa brand
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM brands WHERE id=?";

        try (Connection conn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
