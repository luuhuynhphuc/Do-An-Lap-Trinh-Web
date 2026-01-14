package com.japansport.dao;

import com.japansport.IDAO;
import com.japansport.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao extends DAO implements IDAO<User> {

    @Override
    public List<User> getAll() {
        try {
            final Statement statement = getStatement();
            final ResultSet rs = statement.executeQuery(
                    "SELECT id, email, name, password, active, role, created_at, updated_at FROM users"
            );
            List<User> users = new ArrayList<>();
            while (rs.next()) {
                User user = new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("password"),
                        rs.getInt("active"),
                        rs.getString("role")
                );
                // Set timestamps
                user.setCreated_at(rs.getTimestamp("created_at"));
                user.setUpdated_at(rs.getTimestamp("updated_at"));
                users.add(user);
            }
            return users;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public User getById(int id) {
        try {
            final Statement statement = getStatement();
            final ResultSet rs = statement.executeQuery(
                    "SELECT id, email, name, password, active, role, created_at, updated_at " +
                            "FROM users WHERE id=" + id
            );
            if (rs.next()) {
                User user = new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("password"),
                        rs.getInt("active"),
                        rs.getString("role")
                );
                user.setCreated_at(rs.getTimestamp("created_at"));
                user.setUpdated_at(rs.getTimestamp("updated_at"));
                return user;
            }
            return null;
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
        try {
            final Statement statement = getStatement();
            ResultSet rs = statement.executeQuery("SELECT id FROM users WHERE id=" + user.getId());
            if (rs.next()) {
                System.out.println("User already exists: " + user.getId());
                return 0;
            }

            String sql = String.format(
                    "INSERT INTO users (id, email, password, name, active, role) VALUES (%d,'%s','%s','%s',%d,'%s')",
                    user.getId(),
                    user.getEmail(),
                    user.getPassword(),
                    user.getName(),
                    user.getActive(),
                    user.getRole() != null ? user.getRole() : "customer"
            );
            return statement.executeUpdate(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int update(User t) {
        try {
            final Statement statement = getStatement();
            ResultSet rs = statement.executeQuery("SELECT id FROM users WHERE id=" + t.getId());
            if (!rs.next()) {
                System.out.println("User doesn't exist: " + t.getId());
                return 0;
            }

            String sql = String.format(
                    "UPDATE users SET email='%s', password='%s', name='%s', active=%d, role='%s' WHERE id=%d",
                    t.getEmail(),
                    t.getPassword(),
                    t.getName(),
                    t.getActive(),
                    t.getRole() != null ? t.getRole() : "customer",
                    t.getId()
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
            ResultSet rs = st.executeQuery("SELECT id FROM users WHERE id=" + t.getId());

            if (rs.next()) {
                // Tồn tại -> UPDATE
                String sql = String.format(
                        "UPDATE users SET email='%s', password='%s', name='%s', active=%d, role='%s' WHERE id=%d",
                        t.getEmail(),
                        t.getPassword(),
                        t.getName(),
                        t.getActive(),
                        t.getRole() != null ? t.getRole() : "customer",
                        t.getId()
                );
                int affected = st.executeUpdate(sql);
                System.out.println("save: UPDATE affected = " + affected);
            } else {
                // Chưa có -> INSERT
                if (t.getId() <= 0) {
                    System.out.println("save: Không thể INSERT vì id <= 0");
                    return;
                }
                String sql = String.format(
                        "INSERT INTO users (id, email, password, name, active, role) VALUES (%d,'%s','%s','%s',%d,'%s')",
                        t.getId(),
                        t.getEmail(),
                        t.getPassword(),
                        t.getName(),
                        t.getActive(),
                        t.getRole() != null ? t.getRole() : "customer"
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
            if (u == null || u.getId() <= 0) continue;
            if (v.length() > 0) v.append(",");
            v.append(String.format(
                    "(%d,'%s','%s','%s',%d,'%s')",
                    u.getId(),
                    u.getEmail(),
                    u.getPassword(),
                    u.getName(),
                    u.getActive(),
                    u.getRole() != null ? u.getRole() : "customer"
            ));
        }
        if (v.length() == 0) return 0;

        String sql = "INSERT IGNORE INTO users (id, email, password, name, active, role) VALUES " + v;
        try {
            Statement st = getStatement();
            return st.executeUpdate(sql);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /* Login */
    public User login(String email, String password) throws SQLException {
        String sql = "SELECT id, email, password, name, active, role, created_at, updated_at " +
                "FROM users WHERE email=? AND active=1";

        try (Connection cn = DBConnect.getInstance().getConnect();
             PreparedStatement ps = cn.prepareStatement(
                     sql,
                     ResultSet.TYPE_SCROLL_INSENSITIVE,
                     ResultSet.CONCUR_READ_ONLY)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.last()) return null;
                int count = rs.getRow();
                rs.beforeFirst();

                if (count != 1) return null;

                rs.next();

                String dbPass = rs.getString("password");
                if (!password.equals(dbPass)) return null;

                User user = new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        "",  // không trả mật khẩu
                        rs.getInt("active"),
                        rs.getString("role")
                );
                user.setCreated_at(rs.getTimestamp("created_at"));
                user.setUpdated_at(rs.getTimestamp("updated_at"));
                return user;
            }
        }
    }

    /* Register */
    public boolean existsByEmail(String email) {
        try {
            String sql = "SELECT 1 FROM users WHERE email=? LIMIT 1";
            var ps = DBConnect.getInstance().getConnect().prepareStatement(sql);
            ps.setString(1, email);
            var rs = ps.executeQuery();
            return rs.next();
        } catch (java.sql.SQLException e) {
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






