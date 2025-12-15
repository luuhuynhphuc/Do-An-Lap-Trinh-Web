package com.japansport.model;

public class Product {

    private int id;
    private String name;
    private String image_url;
    private double price;
    private double old_price;

    private String gender;
    private Integer categoryId; // id danh mục, có thể null

    private Integer brandId;
    private Brand brand;


    public Product() {
    }


    public Product(int id, String name, double price, double old_price, String image_url) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.old_price = old_price;
        this.image_url = image_url;
    }

    public int getId() {          //  cho ${p.id}

        return id;
    }

    public void setId(int id) {

        this.id = id;
    }

    public String getName() {     // dùng cho ${p.name}

        return name;
    }

    public void setName(String name) {

        this.name = name;
    }

    public String getImage_url() { // dùng cho ${p.image_url}

        return image_url;
    }

    public void setImage_url(String image_url) {

        this.image_url = image_url;
    }

    public double getPrice() {    // dùng cho ${p.price}

        return price;
    }

    public void setPrice(double price) {

        this.price = price;
    }

    public double getOld_price() {

        return old_price;
    }

    public void setOld_price(double old_price) {

        this.old_price = old_price;
    }


    public String getGender() {    // dùng cho lọc/slider Nam/Nữ

        return gender;
    }

    public void setGender(String gender) {

        this.gender = gender;
    }

    public Integer getCategoryId() { // dùng cho lọc theo danh mục

        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }


    public Integer getBrandId() {
        return brandId;
    }

    public void setBrandId(Integer brandId) {
        this.brandId = brandId;
    }

    public Brand getBrand() {
        return brand;
    }

    public void setBrand(Brand brand) {
        this.brand = brand;
    }

}
