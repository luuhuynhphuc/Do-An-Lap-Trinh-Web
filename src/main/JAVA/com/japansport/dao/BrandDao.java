package com.japansport.dao;

import com.japansport.model.Brand;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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

}
