<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,com.app.dao.StudentDAO,com.app.model.Student,com.app.util.Html" %>
<%
  String pageTitle = "Dashboard"; String active = "home";
  List<Student> all = StudentDAO.getInstance().findAll();
  Map<String, Integer> byCourse = new TreeMap<String, Integer>();
  for (Student s : all) { String c = Html.nz(s.getCourse()); Integer n = byCourse.get(c); byCourse.put(c, n == null ? 1 : n + 1); }
  int max = 1; for (int v : byCourse.values()) if (v > max) max = v;
  int hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
  String greet = hour < 12 ? "Good morning" : (hour < 17 ? "Good afternoon" : "Good evening");
  Student newest = all.isEmpty() ? null : all.get(all.size() - 1);
%>
<%@ include file="header.jspf" %>

<div class="banner">
  <div><h2><%= greet %>, Administrator!</h2><p>Here is what's happening with your students today.</p></div>
  <div><a class="btn" href="<%= ctx %>/students?action=new">+ Add New Student</a></div>
</div>

<div class="grid g4">
  <div class="card stat"><div class="ico i1">ST</div><div><b data-count="<%= all.size() %>">0</b><span>Total Students</span></div></div>
  <div class="card stat"><div class="ico i2">CR</div><div><b data-count="<%= byCourse.size() %>">0</b><span>Courses Running</span></div></div>
  <div class="card stat"><div class="ico i3">NW</div><div><b style="font-size:18px"><%= newest == null ? "-" : Html.esc(newest.getFirstName()) %></b><span>Latest Admission</span></div></div>
  <div class="card stat"><div class="ico i4">SV</div><div><b style="font-size:18px">Online</b><span><%= Html.esc(application.getServerInfo()) %></span></div></div>
</div>

<div class="grid g-side">
  <div>
    <div class="card">
      <h2>Enrollment by Course <small>live from the student records</small></h2>
      <% for (Map.Entry<String, Integer> e : byCourse.entrySet()) { %>
      <div class="bar">
        <div class="lbl"><span><%= Html.esc(e.getKey()) %></span><b><%= e.getValue() %> student<%= e.getValue() == 1 ? "" : "s" %></b></div>
        <div class="track"><div class="fill" style="width:<%= e.getValue() * 100 / max %>%"></div></div>
      </div>
      <% } %>
      <% if (byCourse.isEmpty()) { %><p class="empty">No data yet.</p><% } %>
    </div>
    <div class="card">
      <h2>Recent Admissions <small><a href="<%= ctx %>/students">View all</a></small></h2>
      <jsp:include page="recent-widget.jsp"><jsp:param name="limit" value="5" /></jsp:include>
    </div>
  </div>
  <div>
    <div class="card">
      <h2>Quick Actions</h2>
      <div class="actions" style="flex-direction:column;margin-top:0">
        <a class="btn" href="<%= ctx %>/students">Manage Students</a>
        <a class="btn ghost" href="<%= ctx %>/register.jsp">Register a Student</a>
        <a class="btn ghost" href="<%= ctx %>/enquiry.jsp">Search &amp; Enquiry</a>
        <a class="btn ghost" href="<%= ctx %>/api-console.jsp">Open Directory API</a>
      </div>
    </div>
    <div class="card">
      <h2>System Status</h2>
      <div class="kv" style="grid-template-columns:110px 1fr">
        <div class="k">Server</div><div><%= Html.esc(application.getServerInfo()) %></div>
        <div class="k">Java</div><div><%= Html.esc(System.getProperty("java.version")) %></div>
        <div class="k">Session</div><div><%= session.getId().substring(0, 8) %>&hellip;</div>
        <div class="k">Context</div><div><%= ctx.isEmpty() ? "/" : Html.esc(ctx) %></div>
      </div>
    </div>
  </div>
</div>
<%@ include file="footer.jspf" %>
