package com.japansport.model;

public class Policy {
    private int id;
    private String title;
    private String slug;
    private String content;
    private String policyType;
    private int displayOrder;
    private int active;

    public Policy() {
        this.active = 1;
        this.displayOrder = 0;
    }

    public Policy(int id, String title, String slug, String content) {
        this.id = id;
        this.title = title;
        this.slug = slug;
        this.content = content;
        this.active = 1;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getPolicyType() {
        return policyType;
    }

    public void setPolicyType(String policyType) {
        this.policyType = policyType;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public int getActive() {
        return active;
    }

    public void setActive(int active) {
        this.active = active;
    }

    public boolean isActive() {
        return this.active == 1;
    }

    /**
     * Generate slug from title
     */
    public static String generateSlug(String title) {
        if (title == null || title.trim().isEmpty()) {
            return "";
        }

        return title.toLowerCase()
                .trim()
                .replaceAll("\\s+", "-")
                .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                .replaceAll("[ìíịỉĩ]", "i")
                .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                .replaceAll("[ùúụủũưừứựửữ]", "u")
                .replaceAll("[ỳýỵỷỹ]", "y")
                .replaceAll("[đ]", "d")
                .replaceAll("[^a-z0-9-]", "")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");
    }

    @Override
    public String toString() {
        return "Policy{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", slug='" + slug + '\'' +
                ", policyType='" + policyType + '\'' +
                ", active=" + active +
                '}';
    }
}