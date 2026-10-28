<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,com.app.model.Student,com.app.util.Html" %>
<%
  String method = (String) request.getAttribute("method");
  boolean isGet = "GET".equals(method);
  String pageTitle = isGet ? "Search Results" : "Enquiry Received"; String active = "enquiry";
  @SuppressWarnings("unchecked")
  List<Student> results = (List<Student>) request.getAttribute("results");
%>
<%@ include file="header.jspf" %>
<div class="grid g-side">
  <div>
  <% if (isGet) { %>
    <div class="card">
      <h2>Results for &ldquo;<%= Html.esc(request.getAttribute("firstName")) %> <%= Html.esc(request.getAttribute("lastName")) %>&rdquo;
          <small><%= results == null ? 0 : results.size() %> found</small></h2>
      <% if (results == null || results.isEmpty()) { %>
        <p class="empty">No matching student found. Try a different name.</p>
      <% } else { %>
        <ul class="recent">
        <% for (Student s : results) { %>
          <li><span class="avatar"><%= Html.initials(s.getFirstName(), s.getLastName()) %></span>
              <div><b><%= Html.esc(s.getFirstName()) %> <%= Html.esc(s.getLastName()) %></b><small><%= Html.esc(s.getEmail()) %></small></div>
              <span class="badge <%= Html.cls(s.getCourse()) %>"><%= Html.esc(s.getCourse()) %></span>
              <a class="btn sm ghost" href="<%= ctx %>/students?action=edit&id=<%= s.getId() %>">Open</a></li>
        <% } %>
        </ul>
      <% } %>
      <div class="actions"><a class="btn ghost" href="<%= ctx %>/enquiry.jsp">&larr; New search</a></div>
    </div>
  <% } else { %>
    <div class="card center">
      <div class="big-ok">&#10003;</div>
      <h2 style="margin-bottom:6px">Thank you, <%= Html.esc(request.getAttribute("firstName")) %>!</h2>
      <p class="muted">Your enquiry has been received. Our admissions team will contact you shortly.</p>
      <div class="kv" style="text-align:left;max-width:480px;margin:14px auto 0">
        <div class="k">Reference No.</div><div><b><%= Html.esc(request.getAttribute("reference")) %></b></div>
        <div class="k">Name</div><div><%= Html.esc(request.getAttribute("firstName")) %> <%= Html.esc(request.getAttribute("lastName")) %></div>
        <div class="k">Institute</div><div><%= Html.esc(request.getAttribute("college")) %></div>
      </div>
      <div class="actions" style="justify-content:center"><a class="btn ghost" href="<%= ctx %>/enquiry.jsp">&larr; Back</a></div>
    </div>
  <% } %>
  </div>
  <div class="card">
    <h2>Request Details</h2>
    <div class="kv" style="grid-template-columns:110px 1fr">
      <div class="k">Method</div><div><span class="pill <%= isGet ? "m-get" : "m-post" %>"><%= method %></span></div>
      <div class="k">Address</div><div><code><%= Html.esc(request.getAttribute("fullUrl")) %></code></div>
      <div class="k">Data sent</div><div><%= isGet ? "Visible in the URL" : "Hidden in request body" %></div>
      <div class="k">Content type</div><div><%= request.getAttribute("contentType") == null ? "-" : Html.esc(request.getAttribute("contentType")) %></div>
      <div class="k">Institute</div><div><%= Html.esc(request.getAttribute("college")) %></div>
    </div>
  </div>
</div>
<%@ include file="footer.jspf" %>
