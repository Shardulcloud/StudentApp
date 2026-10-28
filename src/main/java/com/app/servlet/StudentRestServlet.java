package com.app.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.app.dao.StudentDAO;
import com.app.model.Student;

@WebServlet("/api/students/*")
public class StudentRestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StudentDAO dao = StudentDAO.getInstance();

    private int idFromPath(HttpServletRequest req) {
        String p = req.getPathInfo();
        if (p == null || p.equals("/")) return -1;
        try { return Integer.parseInt(p.substring(1)); } catch (NumberFormatException e) { return -2; }
    }
    private void json(HttpServletResponse res, int status, String body) throws IOException {
        res.setStatus(status);
        res.setContentType("application/json;charset=UTF-8");
        res.getWriter().write(body);
    }
    private String body(HttpServletRequest req) throws IOException {
        req.setCharacterEncoding("UTF-8");
        StringBuilder sb = new StringBuilder();
        String line;
        BufferedReader r = req.getReader();
        while ((line = r.readLine()) != null) sb.append(line);
        return sb.toString();
    }
    private String field(String json, String key) {
        Matcher m = Pattern.compile("\"" + key + "\"\\s*:\\s*\"([^\"]*)\"").matcher(json);
        return m.find() ? m.group(1) : "";
    }
    private Student parse(String b) {
        Student s = new Student();
        s.setFirstName(field(b, "firstName"));
        s.setLastName(field(b, "lastName"));
        s.setEmail(field(b, "email"));
        s.setCourse(field(b, "course"));
        return s;
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int id = idFromPath(req);
        if (id == -1) {
            List<Student> list = dao.findAll();
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                if (i > 0) sb.append(",");
                sb.append(list.get(i).toJson());
            }
            json(res, 200, sb.append("]").toString());
        } else {
            Student s = dao.findById(id);
            if (s == null) json(res, 404, "{\"error\":\"Student not found\"}");
            else json(res, 200, s.toJson());
        }
    }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Student s = dao.insert(parse(body(req)));
        json(res, 201, s.toJson());
    }
    @Override protected void doPut(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Student s = parse(body(req));
        s.setId(idFromPath(req));
        if (dao.update(s)) json(res, 200, s.toJson());
        else json(res, 404, "{\"error\":\"Student not found\"}");
    }
    @Override protected void doDelete(HttpServletRequest req, HttpServletResponse res) throws IOException {
        if (dao.delete(idFromPath(req))) json(res, 200, "{\"message\":\"Deleted\"}");
        else json(res, 404, "{\"error\":\"Student not found\"}");
    }
}
