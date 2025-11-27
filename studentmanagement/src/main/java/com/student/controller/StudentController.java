/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.student.controller;

import com.student.dao.StudentDAO;
import com.student.model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentController extends HttpServlet {
    
    private StudentDAO studentDAO;
    
    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "search":
                searchStudents(request,response);
                break;
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
                 case "sort":
            sortStudents(request, response);
                  break;
            case "filter":
             filterStudents(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
        }
    }
    
    private void searchStudents (HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
//        System.out.print(keyword);
                List<Student> students = studentDAO.searchStudents(keyword);
                System.out.print(students);
                request.setAttribute("message","Found"+students.size()+"results");
                request.setAttribute("keyword",keyword);
                request.setAttribute("students",students);
                 RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
        
    }
    // List all students
    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

    // get current page param, default to 1
    String pageParam = request.getParameter("page");
    int currentPage = 1;
    try {
        if (pageParam != null) currentPage = Integer.parseInt(pageParam);
    } catch (NumberFormatException e) {
        currentPage = 1;
    }

    // records per page
    int recordsPerPage = 10;

    // total records and total pages
    int totalRecords = studentDAO.getTotalStudents();
    int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
    if (totalPages < 1) totalPages = 1;

    // handle edge cases: page < 1 or page > totalPages
    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPages) currentPage = totalPages;

    // calculate offset and get page data
    int offset = (currentPage - 1) * recordsPerPage;
    List<Student> students = studentDAO.getStudentsPaginated(offset, recordsPerPage);

    // set attributes for view
    request.setAttribute("students", students);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("recordsPerPage", recordsPerPage);
    request.setAttribute("totalRecords", totalRecords);

    // forward to JSP
    RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
    dispatcher.forward(request, response);
}
    
    // Show form for new student
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    // Show form for editing student
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);
        
        request.setAttribute("student", existingStudent);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

    String studentCode = request.getParameter("studentCode");
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String major = request.getParameter("major");

    Student newStudent = new Student(studentCode, fullName, email, major);

    // server-side validation
    if (!validateStudent(newStudent, request)) {
        request.setAttribute("student", newStudent);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
        return;
    }

    if (studentDAO.addStudent(newStudent)) {
        response.sendRedirect("student?action=list&message=Student added successfully");
    } else {
        response.sendRedirect("student?action=list&error=Failed to add student");
    }
}

    
    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

    int id = Integer.parseInt(request.getParameter("id"));
    String studentCode = request.getParameter("studentCode");
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String major = request.getParameter("major");

    Student student = new Student(studentCode, fullName, email, major);
    student.setId(id);

    // server-side validation
    if (!validateStudent(student, request)) {
        request.setAttribute("student", student);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
        return;
    }

    if (studentDAO.updateStudent(student)) {
        response.sendRedirect("student?action=list&message=Student updated successfully");
    } else {
        response.sendRedirect("student?action=list&error=Failed to update student");
    }
}
    
    // Delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect("student?action=list&message=Student deleted successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to delete student");
        }
    }
    
private boolean validateStudent(Student student, HttpServletRequest request) {
    boolean isValid = true;

    // validate student code
    String code = student.getStudentCode();
    if (code == null || code.trim().isEmpty()) {
        request.setAttribute("errorCode", "Student code is required");
        isValid = false;
    } else {
        String codePattern = "[A-Z]{2}[0-9]{3,}";
        if (!code.trim().matches(codePattern)) {
            request.setAttribute("errorCode", "Invalid format. Use 2 letters + 3+ digits (e.g., SV001)");
            isValid = false;
        }
    }
    // validate full name
    String name = student.getFullName();
    if (name == null || name.trim().isEmpty()) {
        request.setAttribute("errorName", "Full name is required");
        isValid = false;
    } else if (name.trim().length() < 2) {
        request.setAttribute("errorName", "Full name must be at least 2 characters");
        isValid = false;
    }
    // validate email only if provided
    String email = student.getEmail();
    if (email != null && !email.trim().isEmpty()) {
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";
        if (!email.trim().matches(emailPattern)) {
            request.setAttribute("errorEmail", "Invalid email format");
            isValid = false;
        }
    }else{
        request.setAttribute("errorEmail", "Email is required");
        isValid=false;
    }

    // validate major
    String major = student.getMajor();
    if (major == null || major.trim().isEmpty()) {
        request.setAttribute("errorMajor", "Major is required");
        isValid = false;
    }

    return isValid;
}




private void sortStudents(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String sortBy = request.getParameter("sortBy");
    String order = request.getParameter("order");

    List<Student> students = studentDAO.getStudentsSorted(sortBy, order);

    // keep state for view
    request.setAttribute("students", students);
    request.setAttribute("sortBy", sortBy == null ? "id" : sortBy);
    request.setAttribute("order", order == null ? "asc" : order.toLowerCase());

    RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
    dispatcher.forward(request, response);
}

private void filterStudents(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String major = request.getParameter("major");

    // call DAO to filter by major
    List<Student> students = studentDAO.getStudentsByMajor(major);

    // keep state for view
    request.setAttribute("students", students);
    request.setAttribute("selectedMajor", major == null ? "" : major);

    RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
    dispatcher.forward(request, response);
}

    
    }

