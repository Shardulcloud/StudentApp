<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="com.app.model.Student,com.app.util.Html" %>
<%
  Student s = (Student) request.getAttribute("student");
  boolean edit = (s != null);
  String pageTitle = edit ? "Edit Student" : "Add Student"; String active = "students";
%>
<%@ include file="header.jspf" %>
<div class="grid g-side">
  <div class="card">
    <h2><%= edit ? "Update student details" : "New student details" %></h2>
    <form action="<%= ctx %>/students" method="post">
      <% if (edit) { %><input type="hidden" name="id" value="<%= s.getId() %>"><% } %>
      <div class="row2">
        <div class="field"><label>First Name</label><input id="fn" name="firstName" required value="<%= edit ? Html.esc(s.getFirstName()) : "" %>"></div>
        <div class="field"><label>Last Name</label><input id="ln" name="lastName" required value="<%= edit ? Html.esc(s.getLastName()) : "" %>"></div>
      </div>
      <div class="field"><label>Email Address</label><input id="em" type="email" name="email" required value="<%= edit ? Html.esc(s.getEmail()) : "" %>"></div>
      <div class="field"><label>Course</label>
        <select id="co" name="course">
          <% for (String c : Html.COURSES) { %><option <%= (edit && c.equals(s.getCourse())) ? "selected" : "" %>><%= c %></option><% } %>
        </select>
      </div>
      <div class="actions">
        <button class="btn" type="submit"><%= edit ? "Update Student" : "Save Student" %></button>
        <a class="btn ghost" href="<%= ctx %>/students">Cancel</a>
      </div>
    </form>
  </div>
  <div class="card preview">
    <h2>Live Preview</h2>
    <div class="avatar lg" id="pvAvatar">?</div>
    <h3 id="pvName">Student Name</h3>
    <p id="pvEmail">email@example.com</p>
    <span class="badge" id="pvCourse">BCA</span>
  </div>
</div>
<%@ include file="footer.jspf" %>
