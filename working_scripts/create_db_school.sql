# Creates a database that we will use
CREATE database School;
USE School;

# Create a database table in Database School called Students
CREATE TABLE Students (
    StudentID int PRIMARY KEY,
    LastName varchar(255),
    FirstName varchar(255),
    Age int,
    Class varchar(255),
    HomeTeacher varchar(255)
);

# Insert some entries to populate Students table
INSERT INTO Students (StudentID, LastName, FirstName, Age, Class, HomeTeacher) 
VALUES (2190, 'Zaki', 'Ahmad', 13, '1e3', 'Ms Tan');

INSERT INTO Students (StudentID, LastName, FirstName, Age, Class, HomeTeacher) 
VALUES (2182, 'Teo', 'John', 14, '2e4', 'Ms Leong');

INSERT INTO Students (StudentID, LastName, FirstName, Age, Class, HomeTeacher) 
VALUES (2119, 'Leong', 'Hannah', 16, '4e6', 'Ms Toh');

INSERT INTO Students (StudentID, LastName, FirstName, Age, Class, HomeTeacher) 
VALUES (2195, 'Selva', 'John', 13, '1e3', 'Ms Tan');

INSERT INTO Students (StudentID, LastName, FirstName, Age, Class, HomeTeacher) 
VALUES (2196, 'Sim', 'Philip', 13, '1e4', 'Mr Teo');

INSERT INTO Students (StudentID, LastName, FirstName, Age, Class, HomeTeacher) 
VALUES (2199, 'Huang', 'Li', 13, '1e8', 'Mr Haris');

INSERT INTO Students (StudentID, LastName, FirstName, Age, Class, HomeTeacher) 
VALUES (2114, 'Lee', 'David', 16, '4e6', 'Ms Toh');

# Show all records in Database table Students
SELECT * FROM Students;

# Show all records for students whose Home Teacher is Ms Toh
SELECT * FROM Students
WHERE HomeTeacher = 'Ms Toh';

# Show all records for students whose Age is 13
SELECT * FROM Students
WHERE Age = 13;
