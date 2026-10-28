package com.app.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.app.dao.StudentDAO;
import com.app.model.Student;
import com.app.util.Html;

/** Student CRUD controller: list / new / edit (GET) and insert / update (POST), delete (GET). */
@WebServlet("/students")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StudentDAO dao = StudentDAO.getInstance();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                req.getRequestDispatcher("/student-form.jsp").forward(req, res);      // forward
                break;
            case "edit": {
                Student s = dao.findById(parseId(req.getParameter("id")));
                if (s == null) { res.sendRedirect("students?msg=Student+not+found"); return; }
                req.setAttribute("student", s);
                req.getRequestDispatcher("/student-form.jsp").forward(req, res);
                break;
            }
            case "delete":
                boolean ok = dao.delete(parseId(req.getParameter("id")));
                res.sendRedirect("students?msg=" + (ok ? "Student+deleted+successfully" : "Student+not+found"));  // redirect
                break;
            default:
                req.setAttribute("students", dao.findAll());
                req.getRequestDispatcher("/student-list.jsp").forward(req, res);
        }
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id");
        Student s = new Student();
        s.setFirstName(Html.nz(req.getParameter("firstName")).trim());
        s.setLastName(Html.nz(req.getParameter("lastName")).trim());
        s.setEmail(Html.nz(req.getParameter("email")).trim());
        s.setCourse(Html.nz(req.getParameter("course")));

        if (idStr == null || idStr.isEmpty()) {
            dao.insert(s);
            res.sendRedirect("students?msg=Student+added+successfully");
        } else {
            s.setId(parseId(idStr));
            boolean ok = dao.update(s);
            res.sendRedirect("students?msg=" + (ok ? "Student+updated+successfully" : "Student+not+found"));
        }
    }

    private int parseId(String v) {
        try { return Integer.parseInt(v); } catch (Exception e) { return -1; }
    }
}
