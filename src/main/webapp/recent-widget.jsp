<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,com.app.dao.StudentDAO,com.app.model.Student,com.app.util.Html" %>
<%
  int limit = 5;
  try { limit = Integer.parseInt(request.getParameter("limit")); } catch (Exception e) { }
  List<Student> all = StudentDAO.getInstance().findAll();
  Collections.reverse(all);
%>
<ul class="recent">
<% for (int i = 0; i < all.size() && i < limit; i++) { Student s = all.get(i); %>
  <li>
    <span class="avatar"><%= Html.initials(s.getFirstName(), s.getLastName()) %></span>
    <div><b><%= Html.esc(s.getFirstName()) %> <%= Html.esc(s.getLastName()) %></b><small><%= Html.esc(s.getEmail()) %></small></div>
    <span class="badge <%= Html.cls(s.getCourse()) %>"><%= Html.esc(s.getCourse()) %></span>
  </li>
<% } %>
<% if (all.isEmpty()) { %><li class="muted">No students yet.</li><% } %>
</ul>
