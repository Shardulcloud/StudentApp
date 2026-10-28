<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.Date,com.app.util.Html" %>
<%
  String pageTitle = "My Session"; String active = "session";
  Date created = (Date) request.getAttribute("created");
  Date previous = (Date) request.getAttribute("previous");
  boolean isNew = Boolean.TRUE.equals(request.getAttribute("isNew"));
%>
<%@ include file="header.jspf" %>
<div class="grid g4">
  <div class="card stat"><div class="ico i1">#</div><div><b><%= request.getAttribute("visits") %></b><span>Visits this session</span></div></div>
  <div class="card stat"><div class="ico i2">T</div><div><b style="font-size:20px" data-since="<%= created.getTime() %>">0m 0s</b><span>Session age (live)</span></div></div>
  <div class="card stat"><div class="ico i3">S</div><div><b style="font-size:20px"><%= isNew ? "New" : "Returning" %></b><span>Session status</span></div></div>
  <div class="card stat"><div class="ico i4">M</div><div><b><%= request.getAttribute("timeoutMin") %> min</b><span>Inactivity timeout</span></div></div>
</div>
<div class="card">
  <h2>Session Details</h2>
  <div class="kv">
    <div class="k">Session ID</div><div><code><%= Html.esc(request.getAttribute("sessionId")) %></code></div>
    <div class="k">Creation time</div><div><%= created %></div>
    <div class="k">Last accessed time</div><div><%= request.getAttribute("lastAccessed") %></div>
    <div class="k">Previous access</div><div><%= previous == null ? "First visit in this session" : previous.toString() %></div>
  </div>
  <div class="actions">
    <a class="btn" href="<%= ctx %>/SessionServlet">Refresh &amp; count a visit</a>
    <a class="btn danger" href="<%= ctx %>/SessionServlet?action=reset" data-confirm="End this session and start a new one?">End session</a>
  </div>
  <p class="muted" style="margin-bottom:0">Refresh the page: the visit count and last-accessed time change while the creation time stays the same.</p>
</div>
<%@ include file="footer.jspf" %>
