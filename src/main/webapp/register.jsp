<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,com.app.dao.StudentDAO,com.app.model.Student,com.app.util.Html" %>
<%! int pageHits = 0;   /* JSP declaration */ %>
<%
  request.setCharacterEncoding("UTF-8");
  pageHits++;
  String pageTitle = "Register Student"; String active = "register";
%>
<jsp:useBean id="stu" class="com.app.model.Student" scope="request" />
<jsp:setProperty name="stu" property="*" />
<%
  boolean submitted = "POST".equals(request.getMethod());
  if (submitted) { stu.setId(0); StudentDAO.getInstance().insert(stu); session.setAttribute("lastStudent", stu.getFirstName() + " " + stu.getLastName()); }
%>
<%@ include file="header.jspf" %>

<% if (submitted) { %>
<div class="card center">
  <div class="big-ok">&#10003;</div>
  <h2 style="margin-bottom:6px">Registration successful</h2>
  <p class="muted">Student ID <b>#<jsp:getProperty name="stu" property="id" /></b> has been created.</p>
  <div class="kv" style="text-align:left;max-width:520px;margin:14px auto 0">
    <div class="k">Name</div><div><%= Html.esc(stu.getFirstName()) %> <%= Html.esc(stu.getLastName()) %></div>
    <div class="k">Email</div><div><%= Html.esc(stu.getEmail()) %></div>
    <div class="k">Course</div><div><span class="badge <%= Html.cls(stu.getCourse()) %>"><%= Html.esc(stu.getCourse()) %></span></div>
  </div>
  <div class="actions" style="justify-content:center"><a class="btn" href="<%= ctx %>/students">View all students</a><a class="btn ghost" href="<%= ctx %>/register.jsp">Register another</a></div>
</div>
<% } %>

<div class="grid g-side">
  <div class="card">
    <h2>Student Information Form</h2>
    <form method="post" action="<%= ctx %>/register.jsp">
      <div class="row2">
        <div class="field"><label>First Name</label><input id="fn" name="firstName" required></div>
        <div class="field"><label>Last Name</label><input id="ln" name="lastName" required></div>
      </div>
      <div class="field"><label>Email Address</label><input id="em" type="email" name="email" required></div>
      <div class="field"><label>Course</label>
        <select id="co" name="course"><% for (String c : Html.COURSES) { %><option><%= c %></option><% } %></select>
      </div>
      <div class="actions"><button class="btn" type="submit">Register</button><button class="btn ghost" type="reset">Clear</button></div>
    </form>
  </div>
  <div>
    <div class="card preview">
      <h2>Live Preview</h2>
      <div class="avatar lg" id="pvAvatar">?</div>
      <h3 id="pvName">Student Name</h3><p id="pvEmail">email@example.com</p><span class="badge" id="pvCourse">BCA</span>
    </div>
    <div class="card"><h2>Latest Registrations</h2>
      <jsp:include page="recent-widget.jsp"><jsp:param name="limit" value="3" /></jsp:include>
    </div>
  </div>
</div>

<details class="card">
  <summary>Page diagnostics <span class="muted" style="font-weight:400;font-size:13px">(JSP implicit objects &amp; scripting elements)</span></summary>
  <div class="tbl-wrap"><table>
    <thead><tr><th>Object / Element</th><th>Value</th></tr></thead>
    <tbody>
    <tr><td><b>request</b></td><td>method <%= request.getMethod() %> &middot; URI <%= Html.esc(request.getRequestURI()) %> &middot; client <%= Html.esc(request.getRemoteAddr()) %></td></tr>
    <tr><td><b>response</b></td><td>content type <%= Html.esc(response.getContentType()) %> &middot; status <%= response.getStatus() %></td></tr>
    <tr><td><b>session</b></td><td>ID <%= session.getId() %> &middot; last registered: <%= Html.esc(session.getAttribute("lastStudent")) %></td></tr>
    <tr><td><b>application</b></td><td><%= Html.esc(application.getServerInfo()) %></td></tr>
    <tr><td><b>config</b></td><td>servlet name <%= Html.esc(config.getServletName()) %></td></tr>
    <tr><td><b>pageContext</b></td><td>context path "<%= Html.esc(pageContext.getServletContext().getContextPath()) %>"</td></tr>
    <tr><td><b>out</b></td><td><% out.print("JspWriter buffer size = " + out.getBufferSize() + " bytes"); %></td></tr>
    <tr><td><b>page</b></td><td><%= page.getClass().getSimpleName() %></td></tr>
    <tr><td><b>Declaration</b></td><td>page hits since server start = <%= pageHits %></td></tr>
    <tr><td><b>Expression</b></td><td>10 + 20 = <%= 10 + 20 %></td></tr>
    </tbody>
  </table></div>
</details>
<%@ include file="footer.jspf" %>
