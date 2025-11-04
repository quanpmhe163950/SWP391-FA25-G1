package model;

import java.sql.Timestamp;

public class Blog {
    private int blogID;
    private String title;
    private String content;
    private int authorID;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    private String image;
    private String createdByName; // nếu cần

    // Getter & Setter
    public int getBlogID() { return blogID; }
    public void setBlogID(int blogID) { this.blogID = blogID; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getAuthorID() { return authorID; }
    public void setAuthorID(int authorID) { this.authorID = authorID; }

    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }

    public Timestamp getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(Timestamp updatedDate) { this.updatedDate = updatedDate; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }
}
