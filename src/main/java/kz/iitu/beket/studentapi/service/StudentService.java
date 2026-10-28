package kz.iitu.beket.studentapi.service;

import java.util.List;

import kz.iitu.beket.studentapi.exception.StudentNotFoundException;
import kz.iitu.beket.studentapi.model.Student;
import kz.iitu.beket.studentapi.repository.StudentRepository;
import org.springframework.stereotype.Service;

@Service
public class StudentService {

    private final StudentRepository repository;

    public StudentService(StudentRepository repository) {
        this.repository = repository;
    }

    public List<Student> findAll() {
        return repository.findAll();
    }

    public Student findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new StudentNotFoundException(id));
    }

    public Student create(Student student) {
        if (repository.existsByEmail(student.getEmail())) {
            throw new IllegalArgumentException("Student with email " + student.getEmail() + " already exists");
        }
        student.setId(null);
        return repository.save(student);
    }

    public Student update(Long id, Student data) {
        Student existing = findById(id);
        existing.setFirstName(data.getFirstName());
        existing.setLastName(data.getLastName());
        existing.setEmail(data.getEmail());
        existing.setGroupName(data.getGroupName());
        return repository.save(existing);
    }

    public void delete(Long id) {
        Student existing = findById(id);
        repository.delete(existing);
    }
}
