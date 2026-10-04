-- ============================================================
-- Name: Nguyễn Nhật Ánh
-- Student ID: 24070620
-- Assignment: Homework 4 - Introduction to MySQL
-- Date: 2026-10-05
-- ============================================================

-- Recreate the database from scratch
DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE university_db;

-- ============================================================
-- Table: departments
-- Stores academic departments.
-- ============================================================
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(10) NOT NULL UNIQUE,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- Table: instructors
-- Stores instructors and links each instructor to a department.
-- ============================================================
CREATE TABLE instructors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    gender ENUM('Male', 'Female', 'Other') NOT NULL DEFAULT 'Other',
    department_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_instructors_department
        FOREIGN KEY (department_id) REFERENCES departments(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- Table: students
-- Stores student information and their major department.
-- ============================================================
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20) UNIQUE,
    gender ENUM('Male', 'Female', 'Other') NOT NULL DEFAULT 'Other',
    date_of_birth DATE,
    gpa DECIMAL(3,2) DEFAULT 0.00,
    department_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_students_gpa CHECK (gpa >= 0.00 AND gpa <= 4.00),
    CONSTRAINT fk_students_department
        FOREIGN KEY (department_id) REFERENCES departments(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- Table: courses
-- Stores course information, department, and assigned instructor.
-- ============================================================
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(150) NOT NULL,
    credits INT NOT NULL DEFAULT 3,
    description TEXT,
    department_id INT NOT NULL,
    instructor_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_courses_credits CHECK (credits BETWEEN 1 AND 6),
    CONSTRAINT fk_courses_department
        FOREIGN KEY (department_id) REFERENCES departments(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_courses_instructor
        FOREIGN KEY (instructor_id) REFERENCES instructors(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- Table: semesters
-- Stores academic semester information.
-- ============================================================
CREATE TABLE semesters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    semester_code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_semesters_dates CHECK (end_date > start_date)
) ENGINE=InnoDB;

-- ============================================================
-- Table: enrollments
-- Junction table connecting students, courses, and semesters.
-- Prevents duplicate enrollment in the same course/semester.
-- ============================================================
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    grade DECIMAL(4,2),
    grade_letter ENUM('A', 'B', 'C', 'D', 'F') DEFAULT NULL,
    CONSTRAINT chk_enrollments_grade CHECK (grade IS NULL OR (grade >= 0.00 AND grade <= 4.00)),
    CONSTRAINT uq_enrollment UNIQUE (student_id, course_id, semester_id),
    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id) REFERENCES students(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id) REFERENCES courses(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_enrollments_semester
        FOREIGN KEY (semester_id) REFERENCES semesters(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- Sample data: departments (5 records)
-- ============================================================
INSERT INTO departments (name, code, description) VALUES
('Information Systems', 'IS', 'Information systems, business technology and digital transformation.'),
('Computer Science', 'CS', 'Computer science, programming and software development.'),
('Business Administration', 'BA', 'Business management, administration and entrepreneurship.'),
('Finance and Banking', 'FB', 'Finance, banking and financial management.'),
('International Business', 'IB', 'International business, trade and global management.');

-- ============================================================
-- Sample data: instructors (5 records)
-- ============================================================
INSERT INTO instructors (instructor_code, full_name, email, gender, department_id) VALUES
('INS001', 'Nguyễn Minh Anh', 'minhanh@university.edu.vn', 'Female', 1),
('INS002', 'Trần Quốc Huy', 'quochuy@university.edu.vn', 'Male', 2),
('INS003', 'Lê Thu Hà', 'thuha@university.edu.vn', 'Female', 3),
('INS004', 'Phạm Đức Long', 'duclong@university.edu.vn', 'Male', 4),
('INS005', 'Vũ Ngọc Mai', 'ngocmai@university.edu.vn', 'Female', 5);

-- ============================================================
-- Sample data: students (5 records)
-- ============================================================
INSERT INTO students
(student_code, full_name, email, phone, gender, date_of_birth, gpa, department_id) VALUES
('24070620', 'Nguyễn Nhật Ánh', 'anh.nguyen24070620@student.edu.vn', '0901000620', 'Female', '2006-08-06', 3.20, 1),
('24070001', 'Trần Minh Đức', 'duc.tran24070001@student.edu.vn', '0901000001', 'Male', '2006-03-15', 3.45, 2),
('24070002', 'Lê Hoàng Anh', 'anh.le24070002@student.edu.vn', '0901000002', 'Female', '2006-07-21', 3.10, 3),
('24070003', 'Phạm Quỳnh Trang', 'trang.pham24070003@student.edu.vn', '0901000003', 'Female', '2006-11-10', 3.60, 4),
('24070004', 'Đỗ Gia Bảo', 'bao.do24070004@student.edu.vn', '0901000004', 'Male', '2006-01-28', 2.95, 5);

-- ============================================================
-- Sample data: courses (5 records)
-- ============================================================
INSERT INTO courses
(course_code, course_name, credits, description, department_id, instructor_id) VALUES
('INS3064', 'Introduction to MySQL', 3, 'Fundamentals of relational databases and MySQL.', 1, 1),
('CSC101', 'Introduction to Programming', 3, 'Basic programming concepts and problem solving.', 2, 2),
('BUS201', 'Principles of Management', 3, 'Fundamental concepts of business management.', 3, 3),
('FIN202', 'Financial Management', 3, 'Principles and practices of corporate financial management.', 4, 4),
('INT301', 'International Business', 3, 'Global business environment and international trade.', 5, 5);

-- ============================================================
-- Sample data: semesters (5 records)
-- ============================================================
INSERT INTO semesters
(semester_code, name, start_date, end_date) VALUES
('FALL2024', 'Fall 2024', '2024-09-01', '2024-12-31'),
('SPRING2025', 'Spring 2025', '2025-01-01', '2025-05-31'),
('FALL2025', 'Fall 2025', '2025-09-01', '2025-12-31'),
('SPRING2026', 'Spring 2026', '2026-01-01', '2026-05-31'),
('FALL2026', 'Fall 2026', '2026-09-01', '2026-12-31');

-- ============================================================
-- Sample data: enrollments (15 records)
-- ============================================================
INSERT INTO enrollments
(student_id, course_id, semester_id, grade, grade_letter) VALUES
(1, 1, 5, 3.40, 'A'),
(1, 2, 5, 3.20, 'B'),
(1, 3, 4, 3.50, 'A'),
(2, 2, 5, 3.70, 'A'),
(2, 1, 4, 3.30, 'B'),
(2, 4, 3, 3.00, 'B'),
(3, 3, 5, 3.10, 'B'),
(3, 5, 4, 3.60, 'A'),
(3, 1, 3, 2.90, 'B'),
(4, 4, 5, 3.80, 'A'),
(4, 3, 4, 3.50, 'A'),
(4, 5, 3, 3.40, 'A'),
(5, 5, 5, 2.80, 'B'),
(5, 2, 4, 3.00, 'B'),
(5, 4, 3, 2.70, 'C');

-- ============================================================
-- End of university_db.sql
-- ============================================================
