<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="com.app.util.Html" %>
<% String pageTitle = "Directory API"; String active = "api"; %>
<%@ include file="header.jspf" %>
<div class="grid g-side">
  <div class="card">
    <h2>Live Student Directory <small>loaded through the REST service</small></h2>
    <div class="toolbar">
      <button class="btn" id="btnRefresh">Refresh list</button>
      <a class="btn ghost" href="<%= ctx %>/api/students" target="_blank">Open raw JSON</a>
    </div>
    <div class="tbl-wrap">
      <table><thead><tr><th>#</th><th>Student</th><th>Course</th><th style="text-align:right">Actions</th></tr></thead>
      <tbody id="rows"><tr><td colspan="4" class="empty">Loading&hellip;</td></tr></tbody></table>
    </div>
  </div>
  <div class="card">
    <h2 id="formTitle">Add Student</h2>
    <input type="hidden" id="sid">
    <div class="field"><label>First Name</label><input id="f_first"></div>
    <div class="field"><label>Last Name</label><input id="f_last"></div>
    <div class="field"><label>Email</label><input id="f_email" type="email"></div>
    <div class="field"><label>Course</label>
      <select id="f_course"><% for (String c : Html.COURSES) { %><option><%= c %></option><% } %></select></div>
    <div class="actions"><button class="btn green" id="btnSave">Save</button><button class="btn ghost" id="btnClear">Clear</button></div>
    <div class="hint" id="modeHint"><span class="pill m-post">POST</span> Creates a new record</div>
  </div>
</div>

<div class="card">
  <h2>Last API Call <small>request &amp; response</small></h2>
  <div class="kv" style="grid-template-columns:110px 1fr">
    <div class="k">Request</div><div><span class="pill m-get" id="cMethod">-</span> <code id="cUrl">no call yet</code></div>
    <div class="k">Status</div><div><span class="badge" id="cStatus">-</span></div>
  </div>
  <h3 style="margin:16px 0 8px;font-size:14px">Response body (JSON)</h3>
  <pre id="cBody">-</pre>
</div>

<script>
var BASE = '<%= ctx %>/api/students';
var rowsEl = document.getElementById('rows');

function val(id) { return document.getElementById(id).value.trim(); }

function show(method, url, status, text) {
  var m = document.getElementById('cMethod');
  m.textContent = method; m.className = 'pill m-' + method.toLowerCase();
  document.getElementById('cUrl').textContent = url;
  var s = document.getElementById('cStatus');
  s.textContent = status; s.className = 'badge ' + (status < 400 ? 'st-ok' : 'st-err');
  var body = text;
  try { body = JSON.stringify(JSON.parse(text), null, 2); } catch (e) {}
  document.getElementById('cBody').textContent = body;
}

function call(method, url, data) {
  var opt = { method: method, headers: { 'Content-Type': 'application/json' } };
  if (data) opt.body = JSON.stringify(data);
  return fetch(url, opt).then(function (r) {
    return r.text().then(function (t) {
      show(method, url, r.status, t);
      var j = null; try { j = JSON.parse(t); } catch (e) {}
      return { status: r.status, json: j };
    });
  });
}

function td(text, cls) { var c = document.createElement('td'); c.textContent = text; if (cls) c.className = cls; return c; }

function load() {
  call('GET', BASE).then(function (res) {
    rowsEl.innerHTML = '';
    var list = res.json || [];
    if (!list.length) { rowsEl.innerHTML = '<tr><td colspan="4" class="empty">No students found.</td></tr>'; return; }
    list.forEach(function (s) {
      var tr = document.createElement('tr');
      tr.appendChild(td(s.id));
      var tdName = document.createElement('td');
      var b = document.createElement('b'); b.textContent = s.firstName + ' ' + s.lastName;
      var sm = document.createElement('small'); sm.style.display = 'block'; sm.style.color = 'var(--muted)'; sm.textContent = s.email;
      tdName.appendChild(b); tdName.appendChild(sm); tr.appendChild(tdName);
      var tdC = document.createElement('td'); var bd = document.createElement('span');
      bd.className = 'badge c-' + s.course.replace(/[^A-Za-z0-9]/g, ''); bd.textContent = s.course; tdC.appendChild(bd); tr.appendChild(tdC);
      var act = document.createElement('td'); act.style.textAlign = 'right'; act.style.whiteSpace = 'nowrap';
      var e = document.createElement('button'); e.className = 'btn sm ghost'; e.textContent = 'Edit';
      e.onclick = function () { edit(s); };
      var d = document.createElement('button'); d.className = 'btn sm danger'; d.textContent = 'Delete'; d.style.marginLeft = '6px';
      d.onclick = function () {
        window.confirmBox('Delete ' + s.firstName + ' ' + s.lastName + '?', function () {
          call('DELETE', BASE + '/' + s.id).then(function () { window.toast('Student deleted'); load(); });
        });
      };
      act.appendChild(e); act.appendChild(d); tr.appendChild(act);
      rowsEl.appendChild(tr);
    });
  });
}

function edit(s) {
  document.getElementById('sid').value = s.id;
  document.getElementById('f_first').value = s.firstName;
  document.getElementById('f_last').value = s.lastName;
  document.getElementById('f_email').value = s.email;
  document.getElementById('f_course').value = s.course;
  document.getElementById('formTitle').textContent = 'Edit Student #' + s.id;
  document.getElementById('modeHint').innerHTML = '<span class="pill m-put">PUT</span> Updates the selected record';
}
function clearForm() {
  ['sid', 'f_first', 'f_last', 'f_email'].forEach(function (i) { document.getElementById(i).value = ''; });
  document.getElementById('formTitle').textContent = 'Add Student';
  document.getElementById('modeHint').innerHTML = '<span class="pill m-post">POST</span> Creates a new record';
}

document.getElementById('btnRefresh').onclick = load;
document.getElementById('btnClear').onclick = clearForm;
document.getElementById('btnSave').onclick = function () {
  var data = { firstName: val('f_first'), lastName: val('f_last'), email: val('f_email'), course: val('f_course') };
  if (!data.firstName || !data.lastName || !data.email) { window.toast('Please fill in all fields', 'err'); return; }
  var id = val('sid');
  var req = id ? call('PUT', BASE + '/' + id, data) : call('POST', BASE, data);
  req.then(function () { window.toast(id ? 'Student updated' : 'Student added'); clearForm(); load(); });
};
load();
</script>
<%@ include file="footer.jspf" %>
