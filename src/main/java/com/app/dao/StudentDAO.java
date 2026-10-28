package com.app.dao;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import com.app.model.Student;

/** In-memory data access layer (no SQL). Replace the bodies with JDBC/Hibernate later. */
public class StudentDAO {
    private static final StudentDAO INSTANCE = new StudentDAO();
    private final Map<Integer, Student> store = new ConcurrentHashMap<Integer, Student>();
    private final AtomicInteger seq = new AtomicInteger(0);

    private StudentDAO() {
        insert(new Student(0, "Amit", "Sharma", "amit@mail.com", "BCA"));
        insert(new Student(0, "Priya", "Singh", "priya@mail.com", "MCA"));
        insert(new Student(0, "Rahul", "Verma", "rahul@mail.com", "B.Tech"));
    }
    public static StudentDAO getInstance() { return INSTANCE; }

    public Student insert(Student s) {
        s.setId(seq.incrementAndGet());
        store.put(s.getId(), s);
        return s;
    }
    public List<Student> findAll() {
        List<Student> list = new ArrayList<Student>(store.values());
        list.sort(Comparator.comparingInt(Student::getId));
        return list;
    }
    public Student findById(int id) { return store.get(id); }
    public boolean update(Student s) {
        if (!store.containsKey(s.getId())) return false;
        store.put(s.getId(), s);
        return true;
    }
    public boolean delete(int id) { return store.remove(id) != null; }
}
