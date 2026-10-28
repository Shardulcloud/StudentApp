package com.app.model;

public class Student {
    private int id;
    private String firstName = "";
    private String lastName = "";
    private String email = "";
    private String course = "";

    public Student() {}
    public Student(int id, String firstName, String lastName, String email, String course) {
        this.id = id; this.firstName = firstName; this.lastName = lastName;
        this.email = email; this.course = course;
    }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }

    public String toJson() {
        return "{\"id\":" + id + ",\"firstName\":\"" + esc(firstName) + "\",\"lastName\":\""
             + esc(lastName) + "\",\"email\":\"" + esc(email) + "\",\"course\":\"" + esc(course) + "\"}";
    }
    private static String esc(String s) {
        return s == null ? "" : s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
