package com.japansport.dao;

import com.japansport.IDAO;
import com.japansport.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.japansport.util.PasswordUtil;

public class UserDao extends DAO implements IDAO<User> {
    @Override
    public List<User> getAll() {
        String sql = "SELECT id, email, password, name, active FROM users";
        List<User> users = new ArrayList<>();
        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // User ctor: (id, email, name, password, active)
                users.add(new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("password"),
                        rs.getInt("active")
                ));
            }
            return users;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public User getById(int id) {
        String sql = "SELECT id, email, password, name, active FROM users WHERE id=?";
        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("password"),
                        rs.getInt("active")
                );
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }



    @Override
    public void delete(User user) {
        try {
            final Statement statement = getStatement();
            statement.executeUpdate("DELETE FROM users WHERE id=" + user.getId());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int insert(User user) throws SQLException {
        String sql = "INSERT INTO users (email, password, name, active) VALUES (?, ?, ?, ?)";
        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getName());
            ps.setInt(4, user.getActive());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) user.setId(keys.getInt(1));
                }
            }
            return affected;
        }
    }

    @Override
    public int update(User t) {
        try {
            final Statement statement = getStatement();
            ResultSet rs = statement.executeQuery("SELECT id FROM users WHERE id=" + t.getId());
            if (!rs.next()) {
                System.out.println("User doesn't exists" + t.getId());
                return 0;
            }
            String sql = String.format(
                    "update users set email ='%s', password ='%s', name='%s', active=%d where id=%d",
                    t.getEmail(), t.getPassword(), t.getName(), t.getActive(), t.getId()
            );
            return statement.executeUpdate(sql);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void save(User t) {
        try {
            Statement st = getStatement();

            // Kiểm tra xem id đã tồn tại chưa
            ResultSet rs = st.executeQuery("SELECT id FROM users WHERE id=" + t.getId());
            if (rs.next()) {
                // Tồn tại -> UPDATE
                String sql = String.format(
                        "UPDATE users SET email='%s', password='%s', name='%s', active=%d WHERE id=%d",
                        t.getEmail(), t.getPassword(), t.getName(), t.getActive(), t.getId()
                );
                int affected = st.executeUpdate(sql);
                System.out.println("save: UPDATE affected = " + affected);
            } else {
                // Chưa có -> INSERT với id do bạn truyền vào
                if (t.getId() <= 0) {
                    System.out.println("save: Không thể INSERT vì id <= 0 (đang dùng chiến lược tự đặt id).");
                    return;
                }
                String sql = String.format(
                        "INSERT INTO users (id, email, password, name, active) VALUES (%d,'%s','%s','%s',%d)",
                        t.getId(), t.getEmail(), t.getPassword(), t.getName(), t.getActive()
                );
                int affected = st.executeUpdate(sql);
                System.out.println("save: INSERT affected = " + affected);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override

    public int inserts(List<User> t) {
        if (t == null || t.isEmpty()) return 0;

        StringBuilder v = new StringBuilder();
        for (User u : t) {
            if (u == null || u.getId() <= 0) continue; // chỉ nhận id > 0
            if (v.length() > 0) v.append(",");
            v.append(String.format("(%d,'%s','%s','%s',%d)",
                    u.getId(), u.getEmail(), u.getPassword(), u.getName(), u.getActive()));
        }
        if (v.length() == 0) return 0;

        String sql = "INSERT IGNORE INTO users (id,email,password,name,active) VALUES " + v;
        try {
            Statement st = getStatement();
            return st.executeUpdate(sql); // số bản ghi chèn thành công
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /* Login */
    public User login(String email, String password) throws SQLException {
        String sql = "SELECT id, email, password, name, active FROM users WHERE email=? AND active=1 LIMIT 1";

        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                String dbPass = rs.getString("password");
                if (!PasswordUtil.verify(password, dbPass)) return null;

                // Trả về user, KHÔNG set password ra ngoài
                User u = new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        "", // không trả password
                        rs.getInt("active")
                );
                return u;
            }
        }
    }



    /* Register */
    public boolean existsByEmail(String email) {
        String sql = "SELECT 1 FROM users WHERE email=? LIMIT 1";
        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }



    public static void main(String[] args) throws SQLException {
        UserDao dao = new UserDao();


//        List<User> list = new ArrayList<>();
//        long ts = System.currentTimeMillis();
//
//        list.add(new User(101, "u101_" + ts + "@mail.com", "123", "User 101", 1));
//        list.add(new User(102, "u102_" + ts + "@mail.com", "123", "User 102", 1));
//        list.add(new User(103, "u103_" + ts + "@mail.com", "123", "User 103", 0));
//        list.add(new User(102, "dup_" + ts + "@mail.com", "123", "Duplicate 102", 1)); // trùng id -> từ chối thêm
//        list.add(new User(0, "bad_" + ts + "@mail.com", "123", "Bad ID 0", 1));      // id <= 0 -> không thêm vào SQL
//
//        int inserted = dao.inserts(list);
//        System.out.println("Inserted rows = " + inserted); // kỳ vọng 3
//
//        // (Tuỳ chọn) xem nhanh tổng số user sau khi chèn
//        List<User> all = dao.getAll();
//        System.out.println("Total users now = " + all.size());

        //        final List<User> all = dao.getAll();
//        System.out.println(all);

//        /* DELETE */
//        System.out.println(dao.getById(2));
//        dao.delete(dao.getById(102));

        /*INSERT*/
//        User u = new User(3, "270803@gmail.com", "NLS", "12345", 1);
//        System.out.println("affected = " + dao.insert(u));

//        /*UPDATE*/
//        User u = new User(2, "270803@gmail.com", "123", "12345", 1);
//        User u1 = new User( 5, "2025@gmail.com", "111", "NLU", 0 );
//        dao.update(u1);
    }
}






