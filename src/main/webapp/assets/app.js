(function () {
  var root = document.documentElement;
  try { var saved = localStorage.getItem('et-theme'); if (saved) root.setAttribute('data-theme', saved); } catch (e) {}
  function $(id) { return document.getElementById(id); }
  function ready(fn) { if (document.readyState !== 'loading') fn(); else document.addEventListener('DOMContentLoaded', fn); }

  window.toast = function (msg, type) {
    var t = document.createElement('div');
    t.className = 'toast ' + (type || '');
    t.textContent = msg;
    document.body.appendChild(t);
    setTimeout(function () { t.classList.add('show'); }, 20);
    setTimeout(function () { t.classList.remove('show'); setTimeout(function () { t.remove(); }, 400); }, 3500);
  };

  window.confirmBox = function (msg, onYes) {
    var ov = document.createElement('div');
    ov.className = 'overlay';
    ov.innerHTML = '<div class="modal"><h3>Please confirm</h3><p></p><div class="actions">' +
      '<button class="btn ghost" data-no>Cancel</button><button class="btn danger" data-yes>Yes, continue</button></div></div>';
    ov.querySelector('p').textContent = msg;
    document.body.appendChild(ov);
    function close() { ov.remove(); }
    ov.addEventListener('click', function (e) {
      if (e.target === ov || e.target.hasAttribute('data-no')) close();
      else if (e.target.hasAttribute('data-yes')) { close(); onYes(); }
    });
  };

  document.addEventListener('click', function (e) {
    var a = e.target.closest ? e.target.closest('[data-confirm]') : null;
    if (a) { e.preventDefault(); window.confirmBox(a.getAttribute('data-confirm'), function () { location.href = a.href; }); }
  });

  ready(function () {
    /* theme toggle */
    var tb = $('themeBtn');
    function label() { if (tb) tb.textContent = root.getAttribute('data-theme') === 'dark' ? 'Light mode' : 'Dark mode'; }
    if (tb) {
      label();
      tb.addEventListener('click', function () {
        var n = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        root.setAttribute('data-theme', n);
        try { localStorage.setItem('et-theme', n); } catch (e) {}
        label();
      });
    }
    /* mobile menu */
    var mb = $('menuBtn'), sb = $('sidebar');
    if (mb && sb) mb.addEventListener('click', function () { sb.classList.toggle('open'); });

    /* clock */
    var clk = $('clock');
    function tick() { if (clk) clk.textContent = new Date().toLocaleString([], { dateStyle: 'medium', timeStyle: 'medium' }); }
    tick(); setInterval(tick, 1000);

    /* count-up numbers */
    var nums = document.querySelectorAll('[data-count]');
    for (var i = 0; i < nums.length; i++) (function (el) {
      var target = parseInt(el.getAttribute('data-count'), 10) || 0, start = null;
      function step(ts) {
        if (!start) start = ts;
        var p = Math.min((ts - start) / 900, 1);
        el.textContent = Math.round(target * p);
        if (p < 1) requestAnimationFrame(step);
      }
      requestAnimationFrame(step);
    })(nums[i]);

    /* toast from server message */
    var t = $('serverMsg');
    if (t && t.getAttribute('data-msg')) window.toast(t.getAttribute('data-msg'));

    /* live table filter */
    var search = $('search'), course = $('courseFilter');
    if (search) {
      var rows = document.querySelectorAll('#tbl tbody tr[data-name]');
      var apply = function () {
        var q = search.value.toLowerCase().trim(), c = course ? course.value : '', shown = 0;
        for (var k = 0; k < rows.length; k++) {
          var ok = rows[k].getAttribute('data-name').indexOf(q) > -1 && (!c || rows[k].getAttribute('data-course') === c);
          rows[k].style.display = ok ? '' : 'none';
          if (ok) shown++;
        }
        var s = $('shown'); if (s) s.textContent = shown;
        var em = $('noMatch'); if (em) em.style.display = shown ? 'none' : '';
      };
      search.addEventListener('input', apply);
      if (course) course.addEventListener('change', apply);
    }

    /* live preview card on forms */
    var fn = $('fn'), ln = $('ln'), em = $('em'), co = $('co');
    if (fn && $('pvName')) {
      var upd = function () {
        var f = fn.value.trim(), l = ln.value.trim();
        $('pvName').textContent = (f + ' ' + l).trim() || 'Student Name';
        $('pvEmail').textContent = em.value.trim() || 'email@example.com';
        $('pvCourse').textContent = co.value;
        $('pvAvatar').textContent = ((f.charAt(0) + l.charAt(0)).toUpperCase()) || '?';
      };
      [fn, ln, em, co].forEach(function (x) { x.addEventListener('input', upd); x.addEventListener('change', upd); });
      upd();
    }

    /* live session timer */
    var since = document.querySelector('[data-since]');
    if (since) {
      var from = parseInt(since.getAttribute('data-since'), 10);
      setInterval(function () {
        var s = Math.max(0, Math.floor((Date.now() - from) / 1000));
        since.textContent = Math.floor(s / 60) + 'm ' + (s % 60) + 's';
      }, 1000);
    }
  });
})();
