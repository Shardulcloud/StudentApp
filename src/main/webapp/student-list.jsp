<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,com.app.model.Student,com.app.util.Html" %>
<%
  String pageTitle = "Students"; String active = "students";
  @SuppressWarnings("unchecked")
  List<Student> list = (List<Student>) request.getAttribute("students");
  if (list == null) list = new ArrayList<Student>();
  String msg = request.getParameter("msg");
%>
<%@ include file="header.jspf" %>
<div id="serverMsg" data-msg="<%= Html.esc(msg) %>"></div>

<div class="card">
  <h2>Student Records <small><span id="shown"><%= list.size() %></span> of <%= list.size() %> shown</small></h2>
  <div class="toolbar">
    <input class="grow" id="search" type="text" placeholder="Search by name or email..." autocomplete="off">
    <select id="courseFilter">
      <option value="">All courses</option>
      <% for (String c : Html.COURSES) { %><option><%= c %></option><% } %>
    </select>
    <a class="btn green" href="<%= ctx %>/students?action=new">+ Add Student</a>
  </div>
  <div class="tbl-wrap">
  <table id="tbl">
    <thead><tr><th>#</th><th>Student</th><th>Course</th><th style="text-align:right">Actions</th></tr></thead>
    <tbody>
    <% for (Student s : list) { %>
      <tr data-name="<%= Html.esc((s.getFirstName() + " " + s.getLastName() + " " + s.getEmail()).toLowerCase()) %>" data-course="<%= Html.esc(s.getCourse()) %>">
        <td><%= s.getId() %></td>
        <td><div class="person"><span class="avatar"><%= Html.initials(s.getFirstName(), s.getLastName()) %></span>
            <div><b><%= Html.esc(s.getFirstName()) %> <%= Html.esc(s.getLastName()) %></b><small><%= Html.esc(s.getEmail()) %></small></div></div></td>
        <td><span class="badge <%= Html.cls(s.getCourse()) %>"><%= Html.esc(s.getCourse()) %></span></td>
        <td style="text-align:right;white-space:nowrap">
          <a class="btn sm ghost" href="<%= ctx %>/students?action=edit&id=<%= s.getId() %>">Edit</a>
          <a class="btn sm danger" href="<%= ctx %>/students?action=delete&id=<%= s.getId() %>"
             data-confirm="Delete <%= Html.esc(s.getFirstName()) %> <%= Html.esc(s.getLastName()) %>? This cannot be undone.">Delete</a>
        </td>
      </tr>
    <% } %>
    </tbody>
  </table>
  </div>
  <p class="empty" id="noMatch" style="display:<%= list.isEmpty() ? "block" : "none" %>">No students found.</p>
</div>
<%@ include file="footer.jspf" %>
