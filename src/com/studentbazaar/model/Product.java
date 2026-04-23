package com.studentbazaar.model;

public class Product {

    private int id;
    private String name;
    private String title;
    private String description;
    private String category;
    private int price;
    private String condition;
    private String contact;
    private String imagePath;
    private String backImagePath;
    private String uploader;
    private String city;
    private int discount;
    private float rating;
    private String status;

    //  GETTERS & SETTERS

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public String getCondition() { return condition; }
    public void setCondition(String condition) { this.condition = condition; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getBackImagePath() { return backImagePath; }
    public void setBackImagePath(String backImagePath) { this.backImagePath = backImagePath; }

    public String getUploader() { return uploader; }
    public void setUploader(String uploader) { this.uploader = uploader; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public int getDiscount() { return discount; }
    public void setDiscount(int discount) { this.discount = discount; }

    public float getRating() { return rating; }
    public void setRating(float rating) { this.rating = rating; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}