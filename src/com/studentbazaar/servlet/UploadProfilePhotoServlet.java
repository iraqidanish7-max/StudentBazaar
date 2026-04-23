package com.studentbazaar.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UploadProfilePhotoServlet")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB
public class UploadProfilePhotoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");
        Part photoPart = request.getPart("profilePhoto");

        if (photoPart == null || photoPart.getSize() == 0) {
            // no file selected
            response.sendRedirect("home.jsp?photo=empty");
            return;
        }

        String savedPath;
        try {
            savedPath = saveProfilePhoto(photoPart, request.getServletContext());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp?photo=error");
            return;
        }

        // Update DB: set profile_photo for this user
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentbazaar", "root", "")) {

                String sql = "UPDATE users SET profile_photo = ? WHERE email = ?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, savedPath);
                    ps.setString(2, userEmail);
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp?photo=error");
            return;
        }

        // Optional: keep it in session too (for future use)
        session.setAttribute("profilePhoto", savedPath);

        response.sendRedirect("home.jsp?photo=success");
    }

    private String saveProfilePhoto(Part part, ServletContext context) throws IOException {
        String uploadRoot = context.getRealPath("/uploads");
        Path rootDir = Paths.get(uploadRoot);
        Path profileDir = rootDir.resolve("profile_photos");

        Files.createDirectories(profileDir);

        String submittedName = part.getSubmittedFileName();
        String ext = "";
        if (submittedName != null && submittedName.contains(".")) {
            ext = submittedName.substring(submittedName.lastIndexOf('.')); // ".jpg", ".png", etc.
        }

        String uniqueName = "profile_" + UUID.randomUUID() + ext;
        Path destination = profileDir.resolve(uniqueName);

        try (InputStream in = part.getInputStream()) {
            Files.copy(in, destination, StandardCopyOption.REPLACE_EXISTING);
        }

        // path stored in DB (relative)
        return "uploads/" + profileDir.getFileName().toString() + "/" + uniqueName;
    }
}