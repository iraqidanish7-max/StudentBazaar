package com.studentbazaar.dao;

import com.studentbazaar.servlet.DBConnection;
import com.studentbazaar.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public static List<Product> getCartItems(String email) throws Exception {
        List<Product> cartItems = new ArrayList<>();
        Connection con = DBConnection.getConnection();

        String query = "SELECT p.* FROM cart c " +
                       "JOIN products p ON c.product_id = p.id " +
                       "WHERE c.user_email = ?";

        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, email);
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
            p.setCity(rs.getString("city"));
            p.setDiscount(rs.getInt("discount"));
            p.setRating(rs.getFloat("rating"));

            cartItems.add(p);
        }

        System.out.println("Fetching cart for email: " + email);
        System.out.println("Cart items found: " + cartItems.size());

        return cartItems;
    }
}