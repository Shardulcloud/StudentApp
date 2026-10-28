<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<% String pageTitle = "Search & Enquiry"; String active = "enquiry"; %>
<%@ include file="header.jspf" %>
<div class="grid g2">
  <div class="card">
    <h2>Find a Student <small>search the records</small></h2>
    <p class="muted" style="margin-top:0">Look up a student by first name and last name.</p>
    <form action="<%= ctx %>/FormServlet" method="get">
      <div class="field"><label>First Name</label><input type="text" name="firstName" placeholder="e.g. Amit" required></div>
      <div class="field"><label>Last Name</label><input type="text" name="lastName" placeholder="e.g. Sharma" required></div>
      <button class="btn" type="submit">Search</button>
      <div class="hint"><span class="pill m-get">GET</span> Search terms travel in the page address (URL).</div>
    </form>
  </div>
  <div class="card">
    <h2>Admission Enquiry <small>request a call back</small></h2>
    <p class="muted" style="margin-top:0">Leave your name and our admissions team will get in touch.</p>
    <form action="<%= ctx %>/FormServlet" method="post">
      <div class="field"><label>First Name</label><input type="text" name="firstName" placeholder="Your first name" required></div>
      <div class="field"><label>Last Name</label><input type="text" name="lastName" placeholder="Your last name" required></div>
      <button class="btn green" type="submit">Submit Enquiry</button>
      <div class="hint"><span class="pill m-post">POST</span> Details are sent privately in the request body.</div>
    </form>
  </div>
</div>
<%@ include file="footer.jspf" %>
