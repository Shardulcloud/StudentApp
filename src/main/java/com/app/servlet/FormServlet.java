package com.app.servlet;

import java.io.IOException;
import java.time.Year;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.app.dao.StudentDAO;
import com.app.model.Student;
import com.app.util.Html;

/**
 * Handles the "Find a Student" form (GET) and the "Admission Enquiry" form (POST).
 * Uses ServletConfig init-param, request attributes and RequestDispatcher.forward().
 */
@WebServlet(urlPatterns = "/FormServlet",
            initParams = @WebInitParam(name = "college", value = "EduTrack Institute of Technology"))
public class FormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final AtomicInteger enquirySeq = new AtomicInteger(1000);

    @Override public void init() { System.out.println("FormServlet: init() called"); }
    @Override public void destroy() { System.out.println("FormServlet: destroy() called"); }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        handle(req, res, "GET");
    }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        handle(req, res, "POST");
    }

    private void handle(HttpServletRequest req, HttpServletResponse res, String method)
            throws ServletException, IOException {
        String first = Html.nz(req.getParameter("firstName")).trim();
        String last = Html.nz(req.getParameter("lastName")).trim();

        req.setAttribute("method", method);
        req.setAttribute("firstName", first);
        req.setAttribute("lastName", last);
        req.setAttribute("college", getServletConfig().getInitParameter("college"));   // ServletConfig
        req.setAttribute("fullUrl", req.getRequestURL().toString()
                + (req.getQueryString() != null ? "?" + req.getQueryString() : ""));
        req.setAttribute("contentType", req.getContentType());

        if ("GET".equals(method)) {
            List<Student> matches = new ArrayList<Student>();
            for (Student s : StudentDAO.getInstance().findAll()) {
                boolean f = first.isEmpty() || s.getFirstName().toLowerCase().contains(first.toLowerCase());
                boolean l = last.isEmpty() || s.getLastName().toLowerCase().contains(last.toLowerCase());
                if (f && l) matches.add(s);
            }
            req.setAttribute("results", matches);
        } else {
            req.setAttribute("reference", "ENQ-" + Year.now().getValue() + "-" + enquirySeq.incrementAndGet());
        }
        req.getRequestDispatcher("/enquiry-result.jsp").forward(req, res);
    }
}
