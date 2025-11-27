STUDENT INFORMATION:
Name: Vu Dinh Duc
Student ID: ITCSIU23004
Class: ITIT23UN41

COMPLETED EXERCISES:
[x] Exercise 1: Database & User Model
[x] Exercise 2: User Model & DAO
[x] Exercise 3: Login/Logout Controllers
[x] Exercise 4: Views & Dashboard
[x] Exercise 5: Authentication Filter
[x] Exercise 6: Admin Authorization Filter
[x] Exercise 7: Role-Based UI
[ ] Exercise 8: Change Password

AUTHENTICATION COMPONENTS:
- Models: User.java
- DAOs: UserDAO.java
- Controllers: LoginController.java, LogoutController.java, DashboardController.java
- Filters: AuthFilter.java, AdminFilter.java
- Views: login.jsp, dashboard.jsp, updated student-list.jsp

TEST CREDENTIALS:
Admin:
- Username: admin
- Password: password123

Regular User:
- Username: john
- Password: password123

FEATURES IMPLEMENTED:
- User authentication with BCrypt
- Session management
- Login/Logout functionality
- Dashboard with statistics
- Authentication filter for protected pages
- Admin authorization filter
- Role-based UI elements
- Password security

SECURITY MEASURES:
- BCrypt password hashing
- Session regeneration after login
- Session timeout (30 minutes)
- SQL injection prevention (PreparedStatement)
- Input validation
- XSS prevention (JSTL escaping)

KNOWN ISSUES:
- [List any bugs or limitations]

BONUS FEATURES:
- [List any bonus features implemented]

TIME SPENT: 3 hours

TESTING NOTES:
Authentication testing
Login with wrong credentials  will show error message
Login with correct credentials (username and password exist in the database) -> show dashboard according to user Role

Filter/Authorization testing: 
Deploy application
Try accessing /student without login → Should redirect to login
Login successfully
Access /student → Should work
Access static files (CSS, images) → Should work without login

Login as admin → Try edit/delete → Should work
Logout
Login as regular user → Try edit/delete → Should be blocked
Try direct URL: /student?action=delete&id=1 → Should be blocked


