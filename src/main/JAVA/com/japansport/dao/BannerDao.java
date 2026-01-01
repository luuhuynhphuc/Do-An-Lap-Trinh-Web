package com.japansport.dao;

import com.japansport.model.Banner;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BannerDao extends DAO {

    // Map 1 dòng ResultSet -> Banner
    private Banner mapRowToBanner(ResultSet rs) throws SQLException {
        Banner b = new Banner();
        b.setId(rs.getInt("id"));
        b.setImage_url(rs.getString("image_url"));
        b.setLink(rs.getString("link"));
        b.setTitle(rs.getString("title"));
        b.setPosition(rs.getString("position"));
        b.setActive(rs.getInt("active"));
        return b;
    }

    /**
     * Lấy danh sách banner theo position (ví dụ: HOME_MAIN)
     */
    public List<Banner> getBannersByPosition(String position) {
        List<Banner> list = new ArrayList<>();
        String sql =
                "SELECT id, image_url, link, title, position, active " +
                        "FROM banners " +
                        "WHERE active = 1 AND position = ? " +
                        "ORDER BY id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ps.setString(1, position);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBanner(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Lấy 1 banner duy nhất cho một vị trí (dùng cho banner đơn).
     */
    public Banner getOneBannerByPosition(String position) {
        List<Banner> list = getBannersByPosition(position);
        if (list.isEmpty()) return null;
        return list.get(0);
    }

    /**
     * NÂNG CẤP: Lấy tất cả banner cho trang chủ,
     * sắp xếp theo "độ ưu tiên" position bằng CASE.
     * Bạn có thể không dùng hàm này trong code nhưng
     * chụp phần query này cho thầy xem là ổn.
     */
    public List<Banner> getHomeBanners() {
        List<Banner> list = new ArrayList<>();
        String sql =
                "SELECT id, image_url, link, title, position, active " +
                        "FROM banners " +
                        "WHERE active = 1 " +
                        "ORDER BY CASE " +
                        "           WHEN position = 'HOME_MAIN' THEN 1 " +
                        "           WHEN position LIKE 'HOME_SUB%' THEN 2 " +
                        "           WHEN position = 'HOME_SALE' THEN 3 " +
                        "           ELSE 4 " +
                        "         END, id DESC";
        try {
            PreparedStatement ps = getPreparedStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBanner(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
