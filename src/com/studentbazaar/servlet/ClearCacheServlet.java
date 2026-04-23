package com.studentbazaar.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

@WebServlet("/ClearCacheServlet")
public class ClearCacheServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // relative folder inside webapp that is allowed to be cleared
    private static final String RELATIVE_TEMP_FOLDER = "/uploads/tmp";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // admin-only check
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            sendJson(resp, HttpServletResponse.SC_FORBIDDEN, Map.of(
                    "deletedFiles", 0, "deletedBytes", 0, "errors", "Unauthorized"
            ));
            return;
        }

        // Always return JSON
        resp.setContentType("application/json");
        resp.setCharacterEncoding("utf-8");

        // Resolve real path safely
        String realPath = getServletContext().getRealPath(RELATIVE_TEMP_FOLDER);
        if (realPath == null) {
            
            try {
                String ctxRoot = getServletContext().getResource("/").getPath();
                realPath = ctxRoot + RELATIVE_TEMP_FOLDER;
            } catch (Exception ex) {
                // cannot determine path
                sendJson(resp, HttpServletResponse.SC_OK, Map.of(
                        "deletedFiles", 0, "deletedBytes", 0, "errors", "Could not resolve uploads/tmp path on server."
                ));
                return;
            }
        }

        File allowed = new File(realPath);
        if (!allowed.exists() || !allowed.isDirectory()) {
            sendJson(resp, HttpServletResponse.SC_OK, Map.of(
                    "deletedFiles", 0, "deletedBytes", 0, "message", "Folder not found: " + RELATIVE_TEMP_FOLDER
            ));
            return;
        }

        AtomicLong filesDeleted = new AtomicLong(0);
        AtomicLong bytesFreed = new AtomicLong(0);
        List<String> errors = Collections.synchronizedList(new ArrayList<>());

        try {
            // Delete children first
            Files.walk(allowed.toPath())
                .sorted(Comparator.reverseOrder())
                .forEach(path -> {
                    File f = path.toFile();
                    try {
                        //  ensure path inside allowed
                        if (!f.getCanonicalPath().startsWith(allowed.getCanonicalPath())) {
                            errors.add("Skipped outside path: " + f.getPath());
                            return;
                        }
                        if (f.isFile()) {
                            long len = f.length();
                            if (f.delete()) {
                                filesDeleted.incrementAndGet();
                                bytesFreed.addAndGet(len);
                            } else {
                                errors.add("Failed to delete file: " + f.getPath());
                            }
                        } else {
                            // attempt to delete empty directory
                            try { f.delete(); } catch (Exception e) { /* ignore */ }
                        }
                    } catch (IOException ioe) {
                        errors.add("IO error on " + f.getPath() + " : " + ioe.getMessage());
                    }
                });
        } catch (Exception e) {
            // If walk fails, return error JSON with stack message
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of(
                    "deletedFiles", filesDeleted.get(), "deletedBytes", bytesFreed.get(),
                    "errors", "Exception during deletion: " + e.getClass().getSimpleName() + " - " + e.getMessage()
            ));
            return;
        }

        // Success response
        Map<String,Object> result = new HashMap<>();
        result.put("deletedFiles", filesDeleted.get());
        result.put("deletedBytes", bytesFreed.get());
        if (!errors.isEmpty()) result.put("errors", String.join("; ", errors));
        sendJson(resp, HttpServletResponse.SC_OK, result);
    }

    private void sendJson(HttpServletResponse resp, int status, Map<String, Object> payload) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("utf-8");
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        boolean first = true;
        for (Map.Entry<String,Object> e : payload.entrySet()) {
            if (!first) sb.append(",");
            first = false;
            sb.append("\"").append(escapeJson(e.getKey())).append("\":");
            Object v = e.getValue();
            if (v instanceof Number) {
                sb.append(v.toString());
            } else {
                sb.append("\"").append(escapeJson(String.valueOf(v))).append("\"");
            }
        }
        sb.append("}");
        resp.getWriter().write(sb.toString());
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n","\\n").replace("\r","\\r");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST only");
    }
}