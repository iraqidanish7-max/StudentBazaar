package com.studentbazaar.ocr;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

public class OCRHelper {

    private static final String TESSERACT_PATH = "C:\\Program Files\\Tesseract-OCR\\tesseract.exe";

     public static String extractText(String imagePath) {
        StringBuilder output = new StringBuilder();

        try {
            File imageFile = new File(imagePath);
            if (!imageFile.exists()) {
                System.out.println("❌ OCRHelper: Image file does not exist: " + imagePath);
                return "OCR_ERROR";
            }

            
            ProcessBuilder pb = new ProcessBuilder(
                    TESSERACT_PATH,    
                    imagePath,
                    "stdout"           
            );

            pb.redirectErrorStream(true); 

            Process process = pb.start();

            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream()))) {

                String line;
                while ((line = reader.readLine()) != null) {
                    output.append(line).append("\n");
                }
            }

            int exitCode = process.waitFor();
            if (exitCode != 0) {
                System.out.println(" OCRHelper: Tesseract exited with code: " + exitCode);
                return "OCR_ERROR";
            }

            String text = output.toString().trim();
            if (text.isEmpty()) {
                System.out.println(" OCRHelper: OCR result is empty.");
                return "OCR_ERROR";
            }

            System.out.println("OCRHelper: OCR extracted text successfully.");
            return text;

        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            return "OCR_ERROR";
        }
    }

    /**
     * check if OCR text contains cpmmon student ID keywords
     */
    public static boolean isStudentID(String ocrText) {
        if (ocrText == null) return false;

        String text = ocrText.toLowerCase();

      
        return text.contains("college")
                || text.contains("university")
                || text.contains("institute")
                || text.contains("student")
                || text.contains("id card")
                || text.contains("department")
                || text.contains("faculty");
    }
}