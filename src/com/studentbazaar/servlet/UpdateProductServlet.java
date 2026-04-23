package com.studentbazaar.servlet;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/UpdateProductServlet")
@MultipartConfig
public class UpdateProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String condition = request.getParameter("condition");
        String contact = request.getParameter("contact");
        int price = Integer.parseInt(request.getParameter("price"));
        String city = request.getParameter("city");

        Part frontImagePart = request.getPart("image");
        Part backImagePart = request.getPart("backImage");

        String imagePath = null;
        String backImagePath = null;

        String folderName = category.toLowerCase(); // category-based folder
        String uploadDirPath = getServletContext().getRealPath("") + File.separator + "img" + File.separator + "products" + File.separator + folderName;
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        if (frontImagePart != null && frontImagePart.getSize() > 0 && frontImagePart.getSubmittedFileName() != null) {
            String frontFileName = Paths.get(frontImagePart.getSubmittedFileName()).getFileName().toString();
            imagePath = "img/products/" + folderName + "/" + frontFileName;
            frontImagePart.write(uploadDirPath + File.separator + frontFileName);
        }

        if (backImagePart != null && backImagePart.getSize() > 0 && backImagePart.getSubmittedFileName() != null) {
            String backFileName = Paths.get(backImagePart.getSubmittedFileName()).getFileName().toString();
            backImagePath = "img/products/" + folderName + "/" + backFileName;
            backImagePart.write(uploadDirPath + File.separator + backFileName);
        }

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/studentbazaar", "root", "")) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String query;
            PreparedStatement pst;

            // Build query based on what was updated
            if (imagePath != null && backImagePath != null) {
                query = "UPDATE products SET title=?, category=?, price=?, product_condition=?, contact=?, city=?, image_path=?, back_image_path=? WHERE id=?";
                pst = con.prepareStatement(query);
                pst.setString(1, title);
                pst.setString(2, category);
                pst.setInt(3, price);
                pst.setString(4, condition);
                pst.setString(5, contact);
                pst.setString(6, city);
                pst.setString(7, imagePath);
                pst.setString(8, backImagePath);
                pst.setInt(9, id);
            } else if (imagePath != null) {
                query = "UPDATE products SET title=?, category=?, price=?, product_condition=?, contact=?, city=?, image_path=? WHERE id=?";
                pst = con.prepareStatement(query);
                pst.setString(1, title);
                pst.setString(2, category);
                pst.setInt(3, price);
                pst.setString(4, condition);
                pst.setString(5, contact);
                pst.setString(6, city);
                pst.setString(7, imagePath);
                pst.setInt(8, id);
            } else if (backImagePath != null) {
                query = "UPDATE products SET title=?, category=?, price=?, product_condition=?, contact=?, city=?, back_image_path=? WHERE id=?";
                pst = con.prepareStatement(query);
                pst.setString(1, title);
                pst.setString(2, category);
                pst.setInt(3, price);
                pst.setString(4, condition);
                pst.setString(5, contact);
                pst.setString(6, city);
                pst.setString(7, backImagePath);
                pst.setInt(8, id);
            } else {
                query = "UPDATE products SET title=?, category=?, price=?, product_condition=?, contact=?, city=? WHERE id=?";
                pst = con.prepareStatement(query);
                pst.setString(1, title);
                pst.setString(2, category);
                pst.setInt(3, price);
                pst.setString(4, condition);
                pst.setString(5, contact);
                pst.setString(6, city);
                pst.setInt(7, id);
            }

            int rows = pst.executeUpdate();

            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<html><head><script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>");
            if (rows > 0) {
                out.println("<script>");
                out.println("Swal.fire({ icon: 'success', title: 'Product Updated!', text: 'Your product has been updated.', confirmButtonColor: '#2575fc' })");
                out.println(".then(() => { window.location.href = 'ViewMyProductServlet'; });");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("Swal.fire({ icon: 'error', title: 'Update Failed!', text: 'Try again later.', confirmButtonColor: '#2575fc' })");
                out.println(".then(() => { window.location.href = 'editproduct.jsp?id=" + id + "'; });");
                out.println("</script>");
            }
            out.println("</body></html>");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
            out.println("<script>");
            out.println("Swal.fire({ icon: 'error', title: 'Update Error!', text: 'Something went wrong.', confirmButtonColor: '#2575fc' })");
            out.println(".then(() => { window.location.href = 'editproduct.jsp?id=" + id + "'; });");
            out.println("</script>");
        }
    }
}