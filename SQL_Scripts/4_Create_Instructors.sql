
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY IDENTITY(1,1),
    InstructorName VARCHAR(100) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    DepartmentID INT,
    CourseID INT,
    HireDate DATE,
    Email VARCHAR(100) UNIQUE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO
