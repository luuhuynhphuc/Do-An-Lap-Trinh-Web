package com.japansport.dao;

import com.japansport.model.Product;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductDao extends DAO {

    public ProductDao() {
        super();
    }

    // ================== HÀM DÙNG CHUNG ==================

    // Map 1 dòng ResultSet -> 1 đối tượng Product
    private Product mapRowToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();

        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setPrice(rs.getDouble("price"));
        p.setOld_price(rs.getDouble("old_price"));
        p.setImage_url(rs.getString("image_url"));

        // gender (nếu có cột này trong bảng)
        try {
            String gender = rs.getString("gender");
            if (!rs.wasNull() && gender != null) {
                p.setGender(gender);
            }
        } catch (SQLException ignored) {
            // nếu chưa có cột gender thì bỏ qua
        }

        // category_id
        try {
            int categoryId = rs.getInt("category_id");
            if (!rs.wasNull()) {
                p.setCategoryId(categoryId);
            }
        } catch (SQLException ignored) {
            // nếu chưa có cột category_id thì bỏ qua
        }

        // brand_id (cách pro: dùng brand_id thay vì dò brand trong tên)
        try {
            int brandId = rs.getInt("brand_id");
            if (!rs.wasNull()) {
                p.setBrandId(brandId);
            }
        } catch (SQLException ignored) {
            // nếu chưa có cột brand_id thì bỏ qua
        }

        return p;
    }

    // Xây dựng câu ORDER BY dựa vào sortKey – dùng updated_at cho kiểu mới nhất
    private String getOrderByClause(String sortKey) {
        if (sortKey == null || sortKey.isEmpty()) {
            // Mặc định: sản phẩm mới/cập nhật gần đây nhất lên trước
            return " ORDER BY updated_at DESC, id DESC";
        }

        switch (sortKey) {
            case "price_asc":
                return " ORDER BY price ASC";
            case "price_desc":
                return " ORDER BY price DESC";
            case "newest":
                return " ORDER BY updated_at DESC, id DESC";
            default:
                // sortKey lạ -> fallback về updated_at
                return " ORDER BY updated_at DESC, id DESC";
        }
    }

    // ================== LẤY DANH SÁCH CƠ BẢN ==================

    // Lấy tất cả sản phẩm (dùng cho trang chủ, trang danh sách)
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        try {
            Statement st = getStatement();
            String sql =
                    "SELECT id, name, price, old_price, image_url, gender, category_id, brand_id " +
                            "FROM products";

            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Product p = mapRowToProduct(rs);
                list.add(p);
            }
            return list;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // Lấy sản phẩm theo id (dùng cho trang chi tiết)
    public Product getById(int id) {
        try {
            Statement st = getStatement();
            String sql =
                    "SELECT id, name, price, old_price, image_url, gender, category_id, brand_id " +
                            "FROM products WHERE id = " + id;

            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) {
                return mapRowToProduct(rs);
            }
            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // Lấy sản phẩm theo giới tính (dùng cho slider Nam/Nữ ở trang chủ)
    // Ở đây dùng LIMIT là hợp lý vì chỉ lấy vài sản phẩm cho slider, không phải phân trang lớn
    public List<Product> getByGender(String gender, int limit) {
        List<Product> list = new ArrayList<>();
        try {
            Statement st = getStatement();
            String sql = String.format(
                    "SELECT id, name, price, old_price, image_url, gender, category_id, brand_id " +
                            "FROM products " +
                            "WHERE gender = '%s' " +
                            "ORDER BY updated_at DESC, id DESC " +
                            "LIMIT %d",
                    gender, limit
            );

            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Product p = mapRowToProduct(rs);
                list.add(p);
            }
            return list;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // Lấy sản phẩm theo category (không sort riêng – dùng cho chỗ nào cần)
    public List<Product> getByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        try {
            Statement st = getStatement();
            String sql = String.format(
                    "SELECT id, name, price, old_price, image_url, gender, category_id, brand_id " +
                            "FROM products WHERE category_id = %d " +
                            "ORDER BY updated_at DESC, id DESC",
                    categoryId
            );

            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Product p = mapRowToProduct(rs);
                list.add(p);
            }
            return list;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ================== LẤY DS + SẮP XẾP (CHO LIST-PRODUCT) ==================

    // Lấy tất cả sản phẩm + sắp xếp
    public List<Product> getAllSorted(String sortKey) {
        List<Product> list = new ArrayList<>();
        try {
            Statement st = getStatement();
            String sql =
                    "SELECT id, name, price, old_price, image_url, gender, category_id, brand_id " +
                            "FROM products" +
                            getOrderByClause(sortKey);

            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Product p = mapRowToProduct(rs);
                list.add(p);
            }
            return list;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // Lấy theo category + sắp xếp
    public List<Product> getByCategorySorted(int categoryId, String sortKey) {
        List<Product> list = new ArrayList<>();
        try {
            Statement st = getStatement();
            String baseSql = String.format(
                    "SELECT id, name, price, old_price, image_url, gender, category_id, brand_id " +
                            "FROM products WHERE category_id = %d",
                    categoryId
            );
            String sql = baseSql + getOrderByClause(sortKey);

            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Product p = mapRowToProduct(rs);
                list.add(p);
            }
            return list;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ================== TÌM KIẾM & ĐẾM ==================

    // Tìm kiếm theo tên (cho thanh search)
    public List<Product> searchByName(String keyword) {
        List<Product> list = new ArrayList<>();
        try {
            Statement st = getStatement();

            // tránh lỗi nếu keyword có dấu '
            String safeKeyword = keyword.replace("'", "''");

            String sql =
                    "SELECT id, name, price, old_price, image_url, gender, category_id, brand_id " +
                            "FROM products " +
                            "WHERE name LIKE '%" + safeKeyword + "%' " +
                            "ORDER BY updated_at DESC, id DESC";

            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Product p = mapRowToProduct(rs);
                list.add(p);
            }
            return list;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // Đếm tổng số sản phẩm
    public int countAll() {
        try {
            Statement st = getStatement();
            String sql = "SELECT COUNT(*) AS total FROM products";
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // Đếm theo category
    public int countByCategory(int categoryId) {
        try {
            Statement st = getStatement();
            String sql = String.format(
                    "SELECT COUNT(*) AS total FROM products WHERE category_id = %d",
                    categoryId
            );
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // ================== 3 HÀM TIỆN ÍCH (GIỮ CHO ĐỒ ÁN) ==================

    public Product findNew(int id) {
        return getById(id);
    }

    public Product findHot(int id) {
        return getById(id);
    }

    public Product findBestSellers(int id) {
        return getById(id);
    }
}
