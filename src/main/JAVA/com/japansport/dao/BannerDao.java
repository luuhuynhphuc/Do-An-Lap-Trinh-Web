package com.japansport.dao;

import com.japansport.model.Banner;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BannerDao extends DAO {

    // Lấy danh sách banner theo position (ví dụ: HOME_TOP)
    public List<Banner> getBannersByPosition(String position) {
        List<Banner> list = new ArrayList<>();
        try {
            Statement st = getStatement();
            String sql = String.format(
                    "SELECT id, image_url, link, title, active, position " +
                            "FROM banners WHERE active = 1 AND position = '%s'",
                    position
            );
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                Banner b = new Banner(
                        rs.getInt("id"),
                        rs.getString("image_url"),
                        rs.getString("link"),
                        rs.getString("title"),
                        rs.getInt("active"),
                        rs.getString("position")
                );
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return list;
    }

    // Lấy 1 banner duy nhất cho một vị trí (dùng cho 3 banner nhỏ)
    public Banner getOneBannerByPosition(String position) {
        List<Banner> list = getBannersByPosition(position);
        if (list.isEmpty()) return null;
        return list.get(0);
    }
}
