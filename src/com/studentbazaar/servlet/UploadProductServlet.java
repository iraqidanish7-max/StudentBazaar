package com.studentbazaar.servlet;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/UploadProductServlet")
@MultipartConfig
public class UploadProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uploaderEmail = (String) request.getSession().getAttribute("userEmail");

        String title       = request.getParameter("title");
        String description = request.getParameter("description");
        String category    = request.getParameter("category");
        String condition   = request.getParameter("condition");
        String contact     = request.getParameter("contact");
        String city        = request.getParameter("city");
        int price          = Integer.parseInt(request.getParameter("price"));

        Part frontImagePart = request.getPart("image");
        Part backImagePart  = request.getPart("backImage");

        // ====== Save images ======
        String folderName    = category.toLowerCase();
        String uploadDirPath = getServletContext().getRealPath("") +
                File.separator + "img" + File.separator + "products" + File.separator + folderName;

        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String frontImagePath = null, backImagePath = null;

        // Front image
        if (frontImagePart != null && frontImagePart.getSize() > 0 &&
                frontImagePart.getSubmittedFileName() != null) {

            String frontFileName = Paths.get(frontImagePart.getSubmittedFileName())
                                        .getFileName().toString();
            frontImagePath = "img/products/" + folderName + "/" + frontFileName;
            frontImagePart.write(uploadDirPath + File.separator + frontFileName);
        }

        // Back image
        if (backImagePart != null && backImagePart.getSize() > 0 &&
                backImagePart.getSubmittedFileName() != null) {

            String backFileName = Paths.get(backImagePart.getSubmittedFileName())
                                       .getFileName().toString();
            backImagePath = "img/products/" + folderName + "/" + backFileName;
            backImagePart.write(uploadDirPath + File.separator + backFileName);
        }

        // ====== Random discount & rating ======
        int   discount = 10 + (int) (Math.random() * 41);      // 10–50%
        float rating   = (float) (3.0 + (Math.random() * 2));  // 3.0–5.0
        rating = Math.round(rating * 2) / 2.0f;                // Round to nearest 0.5

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentbazaar", "root", "");

            // Updated query: now includes 'status'
            String query =
                    "INSERT INTO products (" +
                    " title, description, category, price, product_condition, contact, " +
                    " image_path, back_image_path, uploader, city, discount, rating, status" +
                    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, title);
            pst.setString(2, description);
            pst.setString(3, category);
            pst.setInt(4, price);
            pst.setString(5, condition);
            pst.setString(6, contact);
            pst.setString(7, frontImagePath);
            pst.setString(8, backImagePath);
            pst.setString(9, uploaderEmail);
            pst.setString(10, city);
            pst.setInt(11, discount);
            pst.setFloat(12, rating);

            // Explicit moderation: new products always start as 'pending'
            pst.setString(13, "pending");

            int rows = pst.executeUpdate();

            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<html><head><script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>");
            if (rows > 0) {
                out.println("<script>");
                out.println("Swal.fire({ " +
                        " icon: 'success'," +
                        " title: 'Product Posted!'," +
                        " text: 'Your product has been uploaded and is pending admin approval.'," +
                        " confirmButtonColor: '#2575fc'" +
                        "})");
                out.println(".then(() => { window.location.href = 'ViewMyProductServlet'; });");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("Swal.fire({ " +
                        " icon: 'error'," +
                        " title: 'Upload Failed!'," +
                        " text: 'Something went wrong. Please try again.'," +
                        " confirmButtonColor: '#2575fc'" +
                        "})");
                out.println(".then(() => { window.location.href = 'sellproduct.jsp'; });");
                out.println("</script>");
            }
            out.println("</body></html>");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
            out.println("<script>");
            out.println("Swal.fire({ " +
                    " icon: 'error'," +
                    " title: 'Upload Failed!'," +
                    " text: 'Something went wrong during upload.'," +
                    " confirmButtonColor: '#2575fc'" +
                    "})");
            out.println(".then(() => { window.location.href = 'sellproduct.jsp'; });");
            out.println("</script>");
        }
    }
}