package com.japansport.model;

public class Category {
    private int id;
    private String name;
    private String image_url;
    private String link;
    private int is_featured;
    private int active;

    public Category() {
    }

    public Category(int id, String name, String image_url,
                    String link, int is_featured, int active) {
        this.id = id;
        this.name = name;
        this.image_url = image_url;
        this.link = link;
        this.is_featured = is_featured;
        this.active = active;
    }

    // GETTER / SETTER – rất quan trọng để EL dùng được (${cat.xxx})

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public int getIs_featured() {
        return is_featured;
    }

    public void setIs_featured(int is_featured) {
        this.is_featured = is_featured;
    }

    public int getActive() {
        return active;
    }

    public void setActive(int active) {
        this.active = active;
    }
}
