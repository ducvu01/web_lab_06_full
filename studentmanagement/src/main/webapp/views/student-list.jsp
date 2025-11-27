<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
       
        * { margin:0; padding:0; box-sizing:border-box }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg,#667eea 0%,#764ba2 100%); min-height:100vh; padding:20px }
        .container { max-width:1200px; margin:0 auto; background:white; border-radius:10px; padding:30px; box-shadow:0 10px 40px rgba(0,0,0,0.2) }
        h1 { color:#333; margin-bottom:10px; font-size:32px }
        .subtitle { color:#666; margin-bottom:20px; font-style:italic }

        .controls {
            display:flex;
            gap:12px;
            align-items:center;
            margin-bottom:16px;
            flex-wrap:wrap;
        }

        .search-box { flex:1; display:flex; gap:10px; padding:12px; border-radius:8px; background:#f6f7fb }
        .search-input { flex:1; padding:10px 12px; border-radius:6px; border:1px solid #ddd; font-size:14px }
        .search-actions { display:flex; gap:8px }

        .filter-box { display:flex; gap:10px; align-items:center; padding:10px 12px; border-radius:8px; background:#fff; border:1px solid #eee }
        .filter-box select { padding:8px 10px; border-radius:6px; border:1px solid #ddd }

        .btn { padding:10px 14px; border-radius:6px; font-weight:500; border:none; cursor:pointer }
        .btn-primary { background: linear-gradient(135deg,#667eea 0%,#764ba2 100%); color:white }
        .btn-secondary { background:#6c757d; color:white }

        table { width:100%; border-collapse:collapse; margin-top:20px }
        thead { background: linear-gradient(135deg,#667eea 0%,#764ba2 100%); color:white }
        th, td { padding:15px; text-align:left; border-bottom:1px solid #ddd }
        th a { color:white; text-decoration:none }
        th .sort-ind { margin-left:6px; font-size:12px }

        tbody tr:hover { background:#f8f9fa }

        .empty-state { text-align:center; padding:60px 20px; color:#999 }
        .message { padding:12px; margin-bottom:12px; border-radius:6px; font-weight:500 }
        .success { background:#d4edda; color:#155724; border:1px solid #c3e6cb }
        .error { background:#f8d7da; color:#721c24; border:1px solid #f5c6cb }
        
        .pagination {
    margin: 20px 0;
    text-align: center;
}
.pagination a {
    padding: 8px 12px;
    margin: 0 4px;
    border: 1px solid #ddd;
    text-decoration: none;
    border-radius: 4px;
    color: #333;
}
.pagination strong {
    padding: 8px 12px;
    margin: 0 4px;
    background-color: #4CAF50;
    color: white;
    border: 1px solid #4CAF50;
    border-radius: 4px;
}
.pagination .disabled {
    color: #aaa;
    border-color: #eee;
    pointer-events: none;
}
.page-info {
    text-align: center;
    margin-top: 8px;
    color: #555;
    font-size: 14px;
}
        
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <div class="navbar">
        <h2>📚 Student Management System</h2>
        <div class="navbar-right">
            <div class="user-info">
                <span>Welcome, ${sessionScope.fullName}</span>
                <span class="role-badge role-${sessionScope.role}">
                    ${sessionScope.role}
                </span>
            </div>
            <a href="dashboard" class="btn-nav">Dashboard</a>
            <a href="logout" class="btn-logout">Logout</a>
        </div>
    </div>
    
    
    
    <div class="container">
        <h1>📚 Student Management System</h1>
        <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>

        <!-- messages -->
        <c:if test="${not empty param.message}">
            <div class="message success">✅ ${param.message}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="message error">❌ ${param.error}</div>
        </c:if>

        <!-- controls row: search + filter + add button -->
        <div class="controls">
            <!-- search box -->
            <div class="search-box" style="min-width:300px">
                <form action="student" method="get" style="display:flex; width:100%;" novalidate>
                    <input type="hidden" name="action" value="search">
                    <input class="search-input" type="text" name="keyword" placeholder="Search by student code, name or email" value="${keyword}">
                    <div class="search-actions">
                        <button type="submit" class="btn btn-primary">🔍</button>
                        <c:if test="${not empty keyword}">
                            <a href="student" class="btn btn-secondary" style="text-decoration:none">Show All</a>
                        </c:if>
                    </div>
                </form>
            </div>

            <!-- filter box -->
            <div class="filter-box">
                <form action="student" method="get" style="display:flex; gap:8px; align-items:center">
                    <input type="hidden" name="action" value="filter">
                    <label style="font-weight:600; color:#333">Filter by Major</label>
                    <select name="major">
                        <option value="">All Majors</option>
                        <option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                        <option value="Information Technology" ${selectedMajor == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                        <option value="Software Engineering" ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                        <option value="Business Administration" ${selectedMajor == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Apply</button>
                    <c:if test="${not empty selectedMajor}">
                        <a href="student?action=list" class="btn btn-secondary" style="text-decoration:none">Clear</a>
                    </c:if>
                </form>
            </div>

            <!-- add button -->
           <!-- Add button - Admin only -->
        <c:if test="${sessionScope.role eq 'admin'}">
            <div style="margin: 20px 0;">
                <a href="student?action=new" class="btn-add">➕ Add New Student</a>
            </div>
        </c:if>
        </div>

        <!-- search results message -->
        <c:if test="${not empty keyword}">
            <div class="message success">🔎 Search results for: ${keyword}</div>
        </c:if>

        <!-- table with sortable headers -->
        <c:choose>
            <c:when test="${not empty students}">
                <!-- Student Table -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Code</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Major</th>
                    <c:if test="${sessionScope.role eq 'admin'}">
                        <th>Actions</th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="student" items="${students}">
                    <tr>
                        <td>${student.id}</td>
                        <td>${student.studentCode}</td>
                        <td>${student.fullName}</td>
                        <td>${student.email}</td>
                        <td>${student.major}</td>
                        
                        <!-- Action buttons - Admin only -->
                        <c:if test="${sessionScope.role eq 'admin'}">
                            <td>
                                <a href="student?action=edit&id=${student.id}" 
                                   class="btn-edit">Edit</a>
                                <a href="student?action=delete&id=${student.id}" 
                                   class="btn-delete"
                                   onclick="return confirm('Delete this student?')">Delete</a>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
                
                <c:if test="${empty students}">
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            No students found
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
                
                            <!-- pagination controls -->
                    <div class="pagination">
                           <!-- Previous -->
                    <c:if test="${currentPage > 1}">
                        <a href="student?action=list&page=${currentPage - 1}">« Previous</a>
                    </c:if>
                    <c:if test="${currentPage <= 1}">
                        <a class="disabled">« Previous</a>
                    </c:if>

                        <!-- Page numbers -->
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                             <c:when test="${i == currentPage}">
                                 <strong>${i}</strong>
                            </c:when>
                        <c:otherwise>
                                 <a href="student?action=list&page=${i}">${i}</a>
                        </c:otherwise>
                        </c:choose>
                    </c:forEach>

                        <!-- Next -->
                    <c:if test="${currentPage < totalPages}">
                             <a href="student?action=list&page=${currentPage + 1}">Next »</a>
                     </c:if>
                    <c:if test="${currentPage >= totalPages}">
                         <a class="disabled">Next »</a>
                    </c:if>
                </div>

                    <!-- page info and record range -->
                    <c:choose>
                        <c:when test="${totalRecords > 0}">
                            <div class="page-info">
                                 Showing page ${currentPage} of ${totalPages} —  records 
                                     ${ (currentPage - 1) * recordsPerPage + 1 } 
                                     - 
                                ${ (currentPage * recordsPerPage) > totalRecords ? totalRecords : (currentPage * recordsPerPage) } 
                                of ${totalRecords}
                </div>
                        </c:when>
                    <c:otherwise>
                         <div class="page-info">
                                Showing page ${currentPage} of ${totalPages}
                           </div>
                    </c:otherwise>
                    </c:choose>

                        </c:when>
                             <c:otherwise>
                                     <div class="empty-state">
                                     <div style="font-size:64px; margin-bottom:20px">📭</div>
                                      <h3>No students found</h3>
                                        <p>Start by adding a new student</p>
                                    </div>
                            </c:otherwise>
                    </c:choose>
    </div>
</body>
</html>
