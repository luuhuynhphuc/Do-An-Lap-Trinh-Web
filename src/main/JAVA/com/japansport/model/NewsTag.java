package com.japansport.model;

public class NewsTag {
    private int id;
    private String name;
    private String slug;

    public NewsTag() {}

    public NewsTag(int id, String name) {
        this.id = id;
        this.name = name;
        this.slug = generateSlug(name);
    }

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

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public static String generateSlug(String name) {
        return News.generateSlug(name);
    }
}