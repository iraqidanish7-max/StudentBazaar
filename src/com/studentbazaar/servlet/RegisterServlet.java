package com.studentbazaar.servlet;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.mindrot.jbcrypt.BCrypt;           // ✅ password hashing
import com.studentbazaar.ocr.OCRHelper;     // ✅ our OCR helper

@WebServlet("/RegisterServlet")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB per file, 1 file (ID card)
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String college = request.getParameter("college");
        String city = request.getParameter("city");
        String course = request.getParameter("course");

        String yearParam = request.getParameter("year");
        int year = 0;
        try {
            if (yearParam != null && !yearParam.trim().isEmpty()) {
                year = Integer.parseInt(yearParam.trim());
            }
        } catch (NumberFormatException e) {
            year = 0; // not critical for OCR feature
        }

        // hash password (same logic as before)
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        // only one file: ID card
        Part idCardPart = request.getPart("idCardImage");
        String profilePath = null; // temporarily unused
        String idCardPath = null;  // relative path stored in DB

        try {
            //  Prepare upload directories
            ServletContext context = getServletContext();
            String uploadRoot = context.getRealPath("/uploads"); // absolute path to /uploads
            Path rootDir = Paths.get(uploadRoot);
            Path idDir = rootDir.resolve("id_cards");

            Files.createDirectories(idDir);

            //  Save ID card file (returns something like "uploads/id_cards/xxx.jpg")
            idCardPath = saveFile(idCardPart, idDir, "idcard_");

            //  Decide initial student_status using OCR (soft check)
            String studentStatus = "Verified"; // default

            if (idCardPath != null) {
                // Build absolute path for Tesseract
                // getRealPath("/") gives webapp root, then we append the relative path
                String absoluteIdCardPath = context.getRealPath("/") 
                        + File.separator 
                        + idCardPath.replace("/", File.separator);

                System.out.println("📄 OCR: Absolute ID card path = " + absoluteIdCardPath);

                String ocrText = OCRHelper.extractText(absoluteIdCardPath);
                System.out.println("📄 OCR raw text:\n" + ocrText);

                boolean looksLikeStudentID = OCRHelper.isStudentID(ocrText);

                if (looksLikeStudentID) {
                    studentStatus = "Verified";
                } else {
                    studentStatus = "Pending";
                }

                System.out.println("✅ OCR decided student_status = " + studentStatus);
            } else {
                System.out.println("⚠️ No ID card uploaded, keeping student_status = Pending");
            }

            // Insert into DB (profile_photo will be NULL)
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentbazaar", "root", "")) {

                String query = "INSERT INTO users "
                        + "(name, phone, email, password, college, city, course, year, "
                        + " profile_photo, id_card_image, student_status) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement ps = con.prepareStatement(query)) {
                    ps.setString(1, name);
                    ps.setString(2, phone);
                    ps.setString(3, email);
                    ps.setString(4, hashedPassword);
                    ps.setString(5, college);
                    ps.setString(6, city);
                    ps.setString(7, course);
                    ps.setInt(8, year);
                    ps.setString(9, profilePath);   // NULL for now
                    ps.setString(10, idCardPath);   // relative path (uploads/id_cards/...)
                    ps.setString(11, studentStatus); // ✅ OCR-based status

                    int i = ps.executeUpdate();

                    if (i > 0) {
                        response.sendRedirect("login.jsp");
                    } else {
                        response.sendRedirect("register.jsp?error=insert");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=exception");
        }
    }

    private String saveFile(Part part, Path dir, String prefix) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        String submittedName = part.getSubmittedFileName();
        String ext = "";

        if (submittedName != null && submittedName.contains(".")) {
            ext = submittedName.substring(submittedName.lastIndexOf('.')); 
        }

        String uniqueName = prefix + UUID.randomUUID() + ext;
        Path destination = dir.resolve(uniqueName);

        try (InputStream in = part.getInputStream()) {
            Files.copy(in, destination, StandardCopyOption.REPLACE_EXISTING);
        }

        return "uploads/" + dir.getFileName().toString() + "/" + uniqueName;
    }
}