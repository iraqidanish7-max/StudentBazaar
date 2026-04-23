package com.studentbazaar.dao;

import com.studentbazaar.model.Product;
import com.studentbazaar.servlet.DBConnection;

import java.sql.*;
import java.util.*;

public class ProductDAO {

    // SINGLE PRODUCT BY ID 
    public static Product getProductById(int id) {
        Product p = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM products WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                p = new Product();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setDescription(rs.getString("description"));
                p.setCategory(rs.getString("category"));
                p.setPrice(rs.getInt("price"));
                p.setCondition(rs.getString("product_condition"));
                p.setContact(rs.getString("contact"));
                p.setImagePath(rs.getString("image_path"));
                p.setBackImagePath(rs.getString("back_image_path"));
                p.setUploader(rs.getString("uploader"));
                p.setCity(rs.getString("city"));
                p.setDiscount(rs.getInt("discount"));
                p.setRating(rs.getFloat("rating"));
                try { p.setStatus(rs.getString("status")); } catch (Exception ignore) {}
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }

    //PRODUCTS BY CATEGORY + SORT 
    public static List<Product> getProductsByCategory(String category, String priceSort, String ratingSort) {
        List<Product> list = new ArrayList<>();

        if (category == null || category.trim().isEmpty()) {
            System.out.println("Category parameter is null or empty.");
            return list;
        }

        try {
            Connection con = DBConnection.getConnection();

            StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE category = ?");
            // Build safe ORDER BY using only allowed tokens
            List<String> orders = new ArrayList<>();

            if ("low".equalsIgnoreCase(priceSort)) {
                orders.add("price ASC");
            } else if ("high".equalsIgnoreCase(priceSort)) {
                orders.add("price DESC");
            }

            if ("rating_high".equalsIgnoreCase(ratingSort)) {
                orders.add("rating DESC");
            } else if ("rating_low".equalsIgnoreCase(ratingSort)) {
                orders.add("rating ASC");
            }

            if (!orders.isEmpty()) {
                sql.append(" ORDER BY ").append(String.join(", ", orders));
            } else {
                sql.append(" ORDER BY id DESC"); // default: newest first
            }

            PreparedStatement ps = con.prepareStatement(sql.toString());
            ps.setString(1, category.trim());

            System.out.println("Executing SQL: " + ps);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setDescription(rs.getString("description"));
                p.setCategory(rs.getString("category"));
                p.setPrice(rs.getInt("price"));
                p.setCondition(rs.getString("product_condition"));
                p.setContact(rs.getString("contact"));
                p.setImagePath(rs.getString("image_path"));
                p.setBackImagePath(rs.getString("back_image_path"));
                p.setUploader(rs.getString("uploader"));
                try { p.setCity(rs.getString("city")); } catch (Exception ignore) {}
                try { p.setDiscount(rs.getInt("discount")); } catch (Exception ignore) {}
                try { p.setRating(rs.getFloat("rating")); } catch (Exception ignore) {}
                try { p.setStatus(rs.getString("status")); } catch (Exception ignore) {}

                list.add(p);
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   
    public static boolean insertProduct(Product p) {
        boolean success = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO products " +
                    "(title, description, category, price, product_condition, contact, " +
                    " image_path, back_image_path, uploader, city, discount, rating) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, p.getTitle());
            pst.setString(2, p.getDescription());
            pst.setString(3, p.getCategory());
            pst.setInt(4, p.getPrice());
            pst.setString(5, p.getCondition());
            pst.setString(6, p.getContact());
            pst.setString(7, p.getImagePath());
            pst.setString(8, p.getBackImagePath());
            pst.setString(9, p.getUploader());
            pst.setString(10, p.getCity());
            pst.setInt(11, p.getDiscount());
            pst.setFloat(12, p.getRating());

            int rows = pst.executeUpdate();
            success = (rows > 0);

            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
}