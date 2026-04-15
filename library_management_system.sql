CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;
-- Table 1: Books
CREATE TABLE books (
    book_id          INT PRIMARY KEY AUTO_INCREMENT,
    title            VARCHAR(200) NOT NULL,
    author           VARCHAR(100) NOT NULL,
    genre            VARCHAR(50),
    isbn             VARCHAR(20) UNIQUE,
    total_copies     INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    added_date       DATE DEFAULT (CURDATE())
);

-- Table 2: Members
CREATE TABLE members (
    member_id       INT PRIMARY KEY AUTO_INCREMENT,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    phone           VARCHAR(15),
    join_date       DATE DEFAULT (CURDATE()),
    membership_type ENUM('student', 'faculty', 'public') DEFAULT 'student'
);

-- Table 3: Staff
CREATE TABLE staff (
    staff_id  INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    role      ENUM('librarian', 'assistant', 'admin'),
    email     VARCHAR(100) UNIQUE,
    phone     VARCHAR(15),
    hire_date DATE
);

-- Table 4: Borrow Records
CREATE TABLE borrow_records (
    record_id   INT PRIMARY KEY AUTO_INCREMENT,
    member_id   INT NOT NULL,
    book_id     INT NOT NULL,
    issued_by   INT,
    borrow_date DATE DEFAULT (CURDATE()),
    due_date    DATE,
    return_date DATE,
    status      ENUM('borrowed', 'returned', 'overdue') DEFAULT 'borrowed',
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id)   REFERENCES books(book_id),
    FOREIGN KEY (issued_by) REFERENCES staff(staff_id)
);

-- Table 5: Fines
CREATE TABLE fines (
    fine_id     INT PRIMARY KEY AUTO_INCREMENT,
    member_id   INT NOT NULL,
    record_id   INT NOT NULL,
    fine_amount DECIMAL(8,2) NOT NULL,
    issued_date DATE DEFAULT (CURDATE()),
    paid_status BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (record_id) REFERENCES borrow_records(record_id)
);


-- Books
INSERT INTO books (title, author, genre, isbn, total_copies, available_copies) VALUES
('The Alchemist',           'Paulo Coelho',       'Fiction',       '978-0062315007', 3, 2),
('Clean Code',              'Robert C. Martin',   'Technology',    '978-0132350884', 2, 1),
('Harry Potter & Sorcerer', 'J.K. Rowling',       'Fantasy',       '978-0439708180', 4, 3),
('Atomic Habits',           'James Clear',        'Self-Help',     '978-0735211292', 2, 2),
('1984',                    'George Orwell',      'Dystopian',     '978-0451524935', 3, 1),
('The Great Gatsby',        'F. Scott Fitzgerald','Classic',       '978-0743273565', 2, 2),
('Introduction to SQL',     'Alan Beaulieu',      'Technology',    '978-0596518394', 2, 0),
('Rich Dad Poor Dad',       'Robert Kiyosaki',    'Finance',       '978-1612680194', 3, 3),
('Sapiens',                 'Yuval Noah Harari',  'History',       '978-0062316097', 2, 1),
('Deep Work',               'Cal Newport',        'Self-Help',     '978-1455586691', 2, 2);

-- Members
INSERT INTO members (full_name, email, phone, join_date, membership_type) VALUES
('Rahul Sharma',   'rahul.sharma@email.com',   '9876543210', '2024-01-10', 'student'),
('Priya Verma',    'priya.verma@email.com',    '9876543211', '2024-02-15', 'faculty'),
('Amit Gupta',     'amit.gupta@email.com',     '9876543212', '2024-03-05', 'student'),
('Sneha Patel',    'sneha.patel@email.com',    '9876543213', '2024-03-20', 'public'),
('Rohit Singh',    'rohit.singh@email.com',    '9876543214', '2024-04-01', 'student'),
('Ananya Nair',    'ananya.nair@email.com',    '9876543215', '2024-05-12', 'faculty'),
('Vikram Joshi',   'vikram.joshi@email.com',   '9876543216', '2024-06-18', 'student'),
('Pooja Mehta',    'pooja.mehta@email.com',    '9876543217', '2024-07-22', 'public'),
('Karan Malhotra', 'karan.malhotra@email.com', '9876543218', '2024-08-30', 'student'),
('Divya Rao',      'divya.rao@email.com',      '9876543219', '2024-09-14', 'faculty');

-- Staff
INSERT INTO staff (full_name, role, email, phone, hire_date) VALUES
('Mr. Suresh Kumar',  'librarian', 'suresh.kumar@library.com', '9111111111', '2020-06-01'),
('Ms. Kavitha Reddy', 'assistant', 'kavitha.reddy@library.com','9111111112', '2021-09-15'),
('Mr. Arjun Das',     'admin',     'arjun.das@library.com',    '9111111113', '2022-01-10');

-- Borrow Records
INSERT INTO borrow_records (member_id, book_id, issued_by, borrow_date, due_date, return_date, status) VALUES
(1, 1,  1, '2025-03-01', '2025-03-15', '2025-03-14', 'returned'),
(2, 2,  1, '2025-03-05', '2025-03-19', NULL,          'borrowed'),
(3, 5,  2, '2025-03-10', '2025-03-24', NULL,          'overdue'),
(4, 7,  1, '2025-03-12', '2025-03-26', '2025-03-25', 'returned'),
(5, 3,  2, '2025-03-15', '2025-03-29', NULL,          'borrowed'),
(6, 9,  1, '2025-03-18', '2025-04-01', NULL,          'overdue'),
(7, 4,  3, '2025-03-20', '2025-04-03', NULL,          'borrowed'),
(8, 6,  2, '2025-03-22', '2025-04-05', '2025-04-04', 'returned'),
(9, 2,  1, '2025-03-25', '2025-04-08', NULL,          'borrowed'),
(10,10, 3, '2025-03-28', '2025-04-11', NULL,          'borrowed');

-- Fines
INSERT INTO fines (member_id, record_id, fine_amount, issued_date, paid_status) VALUES
(3, 3, 50.00, '2025-03-25', FALSE),
(6, 6, 30.00, '2025-04-02', FALSE),
(1, 1, 0.00,  '2025-03-15', TRUE);


-- View all available books
SELECT title, author, genre, available_copies
FROM books
WHERE available_copies > 0
ORDER BY title;

-- Search by Genre
SELECT title, author
FROM books
WHERE genre = 'Technology';

-- Members List
SELECT member_id, full_name, email, membership_type, join_date
FROM members
ORDER BY join_date DESC;

-- Staff List
SELECT staff_id, full_name, role, email
FROM staff;

-- Current Borrowed Books
SELECT
    m.full_name AS member_name,
    b.title AS book_title,
    b.author,
    br.borrow_date,
    br.due_date,
    br.status
FROM borrow_records br
JOIN members m ON br.member_id = m.member_id
JOIN books b ON br.book_id = b.book_id
WHERE br.status = 'borrowed';

-- Borrow History with Staff
SELECT
    m.full_name AS member,
    b.title AS book,
    s.full_name AS issued_by_staff,
    br.borrow_date,
    br.return_date,
    br.status
FROM borrow_records br
JOIN members m ON br.member_id = m.member_id
JOIN books b ON br.book_id = b.book_id
LEFT JOIN staff s ON br.issued_by = s.staff_id
ORDER BY br.borrow_date DESC;

-- Members with unpaid fines
SELECT
    m.full_name,
    m.email,
    m.phone,
    SUM(f.fine_amount) AS total_due
FROM members m
LEFT JOIN fines f 
    ON m.member_id = f.member_id 
    AND f.paid_status = FALSE
GROUP BY m.member_id, m.full_name, m.email, m.phone
HAVING total_due > 0;

-- Books per Genre
SELECT
    genre,
    COUNT(*) AS total_books,
    SUM(available_copies) AS available
FROM books
GROUP BY genre
ORDER BY total_books DESC;

-- Most Active Members
SELECT
    m.full_name,
    m.membership_type,
    COUNT(br.record_id) AS books_borrowed
FROM members m
JOIN borrow_records br ON m.member_id = br.member_id
GROUP BY m.member_id, m.full_name, m.membership_type
ORDER BY books_borrowed DESC;

-- Books Never Borrowed
SELECT b.title, b.author, b.genre
FROM books b
LEFT JOIN borrow_records br ON b.book_id = br.book_id
WHERE br.book_id IS NULL;

-- Members Never Borrowed
SELECT m.full_name, m.email, m.membership_type
FROM members m
LEFT JOIN borrow_records br ON m.member_id = br.member_id
WHERE br.member_id IS NULL;

-- members who owe more than average fine
SELECT 
    m.full_name,
    m.email
FROM members m
JOIN fines f ON m.member_id = f.member_id
WHERE f.paid_status = FALSE
GROUP BY m.member_id, m.full_name, m.email
HAVING SUM(f.fine_amount) > (
    SELECT AVG(fine_amount) 
    FROM fines 
    WHERE paid_status = FALSE
);