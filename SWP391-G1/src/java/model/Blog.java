package model;

import java.sql.Timestamp;

public class Blog {
    private int blogID;
    private String title;
    private String content;
    private String image;
    private Timestamp createdAt;
    private String createdByName;

    // Getters & Setters
    public int getBlogID() { return blogID; }
    public void setBlogID(int blogID) { this.blogID = blogID; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }
}
