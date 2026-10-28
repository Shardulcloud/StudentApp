package com.app.servlet;

import java.io.IOException;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/** Shows HttpSession details: creation time, last accessed time, visit counter. */
@WebServlet("/SessionServlet")
public class SessionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if ("reset".equals(req.getParameter("action"))) {
            HttpSession old = req.getSession(false);
            if (old != null) old.invalidate();
            res.sendRedirect(req.getContextPath() + "/SessionServlet");
            return;
        }

        HttpSession session = req.getSession(true);   // create one if it does not exist
        boolean isNew = session.isNew();

        Long previous = (Long) session.getAttribute("lastSeen");
        Integer count = (Integer) session.getAttribute("visits");
        count = (count == null) ? 1 : count + 1;
        session.setAttribute("visits", count);
        session.setAttribute("lastSeen", session.getLastAccessedTime());

        req.setAttribute("sessionId", session.getId());
        req.setAttribute("isNew", isNew);
        req.setAttribute("created", new Date(session.getCreationTime()));
        req.setAttribute("lastAccessed", new Date(session.getLastAccessedTime()));
        req.setAttribute("previous", previous == null ? null : new Date(previous));
        req.setAttribute("visits", count);
        req.setAttribute("timeoutMin", session.getMaxInactiveInterval() / 60);

        req.getRequestDispatcher("/session-info.jsp").forward(req, res);
    }
}
