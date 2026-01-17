-- 1. How many students are currently enrolled in each course?
SELECT c.CourseName,c.CourseID, COUNT(e.StudentID) AS EnrolledStudents
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName, c.CourseID
ORDER BY EnrolledStudents DESC;
GO

SELECT c.CourseName,c.CourseID, COUNT(e.StudentID) AS EnrolledStudents
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName, c.CourseID
ORDER BY c.CourseID ASC;
GO

-- 2. Which students are enrolled in multiple courses, and which courses are they taking?
-- Part A: Students in multiple courses
SELECT s.Name,s.StudentID, COUNT(e.CourseID) AS CourseCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.Name, s.StudentID
HAVING COUNT(e.CourseID) > 1;
GO

-- Part B: Courses they are taking
SELECT s.Name, s.StudentID,c.CourseName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE s.StudentID IN (
    SELECT StudentID 
    FROM Enrollments 
    GROUP BY StudentID 
    HAVING COUNT(CourseID) > 1
)
ORDER BY s.Name;
-- GROUP_CONCAT()
GO

-- 3. What is the total number of students per department across all courses?
-- My Interpretation: Count of students belonging to each department.
SELECT d.DepartmentName, COUNT(s.StudentID) AS TotalStudents
FROM Departments d
LEFT JOIN Students s ON d.DepartmentID = s.DepartmentID
GROUP BY d.DepartmentName
ORDER BY TotalStudents DESC;
GO


-- Course & Instructor Analysis

-- 4. Which courses have the highest number of enrollments?
SELECT TOP 5 WITH TIES c.CourseName,c.CourseID, COUNT(e.StudentID) AS EnrollmentCount
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName,c.CourseID
ORDER BY EnrollmentCount DESC;
GO

-- 5. Which department has the least number of students?
SELECT TOP 1 WITH TIES d.DepartmentName,d.DepartmentID, COUNT(s.StudentID) AS StudentCount
FROM Departments d
LEFT JOIN Students s ON d.DepartmentID = s.DepartmentID
GROUP BY d.DepartmentName, d.DepartmentID
ORDER BY StudentCount ASC;
GO


-- Data Integrity & Operational Insights

-- 6. Are there any students not enrolled in any course?
SELECT s.Name, s.StudentID
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.EnrollmentID IS NULL;
GO

-- 7. How many courses does each student take on average?
SELECT AVG(CourseCount*1.0) AS AverageCoursesPerStudent
FROM (
    SELECT StudentID, COUNT(CourseID) AS CourseCount
    FROM Enrollments
    GROUP BY StudentID
) AS StudentCourseCounts;
GO

-- 8. What is the gender distribution of students across courses and instructors?
-- Part A: Gender distribution of students across courses
SELECT c.CourseName, s.Gender, COUNT(s.StudentID) AS StudentCount
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
JOIN Students s ON e.StudentID = s.StudentID
GROUP BY c.CourseName, s.Gender
ORDER BY c.CourseName;
GO

-- Part B: Gender distribution of Instructors
SELECT Gender = 'M', COUNT(InstructorID) AS InstructorCount
FROM Instructors
GROUP BY Gender;
GO

SELECT 
    COUNT(CASE WHEN I.Gender = 'M' THEN 1 END) AS Male_Instructors,
    COUNT(CASE WHEN I.Gender = 'F' THEN 1 END) AS Female_Instructors,
    COUNT(I.InstructorID) AS Total_Instructors
FROM Instructors I;

SELECT *
FROM Instructors

-- 9. Which course has the highest number of male or female students enrolled?
-- Highest Male Enrollment
SELECT TOP 1 'Male' AS Gender, c.CourseName, COUNT(s.StudentID) AS StudentCount
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
JOIN Students s ON e.StudentID = s.StudentID
WHERE s.Gender = 'M'
GROUP BY c.CourseName
ORDER BY StudentCount DESC;
GO

-- Highest Female Enrollment
SELECT TOP 1 'Female' AS Gender, c.CourseName, COUNT(s.StudentID) AS StudentCount
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
JOIN Students s ON e.StudentID = s.StudentID
WHERE s.Gender = 'F'
GROUP BY c.CourseName
ORDER BY StudentCount DESC;
GO
