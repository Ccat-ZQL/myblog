package cn.edu.hziee.bean;

import java.util.Date;

public class Myblog {
    private Integer id;
    private Integer userId;
    private String title;
    private String content;
    private Integer tagId;
    private Date addTime;
    private String addTimeFormat;
    private Integer recommend;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getTagId() {
        return tagId;
    }

    public void setTagId(Integer tagId) {
        this.tagId = tagId;
    }

    public Date getAddTime() {
        return addTime;
    }

    public void setAddTime(Date addTime) {
        this.addTime = addTime;
    }

    public String getAddTimeFormat() {
        return addTimeFormat;
    }

    public void setAddTimeFormat(String addTimeFormat) {
        this.addTimeFormat = addTimeFormat;
    }

    public Integer getRecommend() {
        return recommend;
    }

    public void setRecommend(Integer recommend) {
        this.recommend = recommend;
    }
}
