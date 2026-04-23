package com.studentbazaar.servlet;

import com.studentbazaar.dao.ProductDAO;
import com.studentbazaar.model.Product;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/CategoryServlet")
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String category   = request.getParameter("category");
        String priceSort  = request.getParameter("priceSort");    
        String ratingSort = request.getParameter("ratingSort");   

        if (category == null) {
            category = "";
        }

        //  Get products using your existing DAO logic (sorting etc.)
        List<Product> products = ProductDAO.getProductsByCategory(category, priceSort, ratingSort);
        if (products == null) {
            products = new ArrayList<>();
        }

        //  Filter on moderation: only status = 'approved' (if status is available)
        List<Product> visibleProducts = new ArrayList<>();

        for (Product p : products) {
            boolean include = true;

            try {
                // Try to call getStatus() reflectively, so code doesn't break if method is absent
                java.lang.reflect.Method m = p.getClass().getMethod("getStatus");
                Object val = m.invoke(p);

                if (val != null) {
                    String status = val.toString();
                    // Only keep approved; pending/rejected will be hidden from buyers
                    if (!"approved".equalsIgnoreCase(status)) {
                        include = false;
                    }
                }
            } catch (Exception ignore) {
                // If Product has no getStatus(),  don't filter -> behaviour stays as before
            }

            if (include) {
                visibleProducts.add(p);
            }
        }

        //  Friendly category label for JSP heading
        String displayCategory = category;
        if (displayCategory == null || displayCategory.trim().isEmpty()) {
            displayCategory = "All Products";
        }

        // Set attributes for CategoryProducts.jsp
        request.setAttribute("products", visibleProducts);
        request.setAttribute("category", displayCategory);

        // preserve sort selections
        request.setAttribute("priceSort", priceSort);
        request.setAttribute("ratingSort", ratingSort);

        RequestDispatcher rd = request.getRequestDispatcher("categoryproducts.jsp");
        rd.forward(request, response);
    }
}