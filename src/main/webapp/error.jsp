<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="com.app.util.Html" %>
<%
  String pageTitle = "Something went wrong"; String active = "";
  Object code = request.getAttribute("jakarta.servlet.error.status_code");
%>
<%@ include file="header.jspf" %>
<div class="card center" style="max-width:560px;margin:40px auto">
  <div style="font-size:64px;font-weight:800;color:var(--primary)"><%= code == null ? "Oops" : Html.esc(code) %></div>
  <h2>We couldn't find what you were looking for</h2>
  <p class="muted">The page may have moved, or something unexpected happened on the server.</p>
  <a class="btn" href="<%= ctx %>/index.jsp">Back to Dashboard</a>
</div>
<%@ include file="footer.jspf" %>
