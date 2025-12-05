package com.japansport.dao;

import com.japansport.model.ProductImage;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductImageDao extends DAO {

    public ProductImageDao() {
        super();
    }

    private ProductImage mapRowToProductImage(ResultSet rs) throws SQLException {
        ProductImage img = new ProductImage();
        img.setId(rs.getInt("id"));
        img.setProductId(rs.getInt("product_id"));
        img.setImageUrl(rs.getString("image_url"));
        img.setAlt(rs.getString("alt"));
        img.setMainImage(rs.getBoolean("is_main"));
        img.setSortOrder(rs.getInt("sort_order"));
        return img;
    }

    public List<ProductImage> getByProductId(int productId) {
        List<ProductImage> list = new ArrayList<>();
        try {
            Statement st = getStatement();
            String sql =
                    "SELECT id, product_id, image_url, alt, is_main, sort_order " +
                            "FROM product_images " +
                            "WHERE product_id = " + productId +
                            " ORDER BY is_main DESC, sort_order ASC, id ASC";

            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                list.add(mapRowToProductImage(rs));
            }
            return list;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
