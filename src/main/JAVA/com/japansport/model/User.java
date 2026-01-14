package com.japansport.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String email;
    private String password;
    private String name;
    private int active;
    private String role;
    private Timestamp created_at;
    private Timestamp updated_at;

    public User(int id, String email, String name, String password, int active, String role) {
        this.active = active;
        this.email = email;
        this.id = id;
        this.name = name;
        this.password = password;
        this.role = role;
    }

    public User(int id, String email, String name, String password, int active) {
        this(id, email, name, password, active, "customer");
    }

    public User() {
        this.role = "customer";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getActive() {
        return active;
    }

    public void setActive(int active) {
        this.active = active;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Timestamp updated_at) {
        this.updated_at = updated_at;
    }
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }

    public boolean isActive() {
        return active == 1;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", email='" + email + '\'' +
                ", name='" + name + '\'' +
                ", active=" + active +
                ", role='" + role + '\'' +
                ", created_at=" + created_at +
                '}';
    }
}