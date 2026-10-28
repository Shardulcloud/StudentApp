package com.app.util;

public final class Html {
    private Html() {}

    public static final String[] COURSES = {"BCA", "MCA", "B.Tech", "M.Tech", "BSc IT"};

    /** Escape text for safe output in HTML (also inside attribute values). */
    public static String esc(Object o) {
        if (o == null) return "";
        String s = o.toString();
        StringBuilder sb = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '&': sb.append("&amp;"); break;
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#39;"); break;
                default: sb.append(c);
            }
        }
        return sb.toString();
    }
    /** null-safe string */
    public static String nz(String s) { return s == null ? "" : s; }

    public static String initials(String first, String last) {
        String f = nz(first).trim(), l = nz(last).trim();
        String r = "";
        if (!f.isEmpty()) r += Character.toUpperCase(f.charAt(0));
        if (!l.isEmpty()) r += Character.toUpperCase(l.charAt(0));
        return r.isEmpty() ? "?" : r;
    }
    /** CSS class for a course badge, e.g. "B.Tech" -> "c-BTech" */
    public static String cls(String course) {
        return "c-" + nz(course).replaceAll("[^A-Za-z0-9]", "");
    }
}
