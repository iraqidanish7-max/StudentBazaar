package com.studentbazaar.dao;

import com.studentbazaar.model.Product;
import com.studentbazaar.servlet.DBConnection;

import java.sql.*;
import java.util.*;

public class OrderDAO {

    public static List<Map<String, Object>> getUserOrders(String userEmail) throws Exception {
        List<Map<String, Object>> orders = new ArrayList<>();
        Connection con = DBConnection.getConnection();

        String sql = "SELECT p.*, o.purchase_time FROM orders o JOIN products p ON o.product_id = p.id WHERE o.user_email = ? ORDER BY o.purchase_time DESC";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userEmail);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> order = new HashMap<>();
            order.put("title", rs.getString("title"));
            order.put("price", rs.getInt("price"));
            order.put("category", rs.getString("category"));
            order.put("imagePath", rs.getString("image_path"));
            order.put("purchaseTime", rs.getTimestamp("purchase_time"));
            orders.add(order);
        }

        return orders;
    }
}