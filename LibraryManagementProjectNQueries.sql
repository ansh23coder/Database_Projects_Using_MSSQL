---------- CREATION OF DATABASE ----------
create database LibraryDB;
use LibraryDB

---------- CREATION OF TABLE ----------
-- BOOK TABLE
create table Books(
	book_id int identity(1, 1) primary key,
	title varchar(255) not null,
	author varchar(255) not null,
	genre varchar(100),
	published_year INT,
	is_available bit default 1
);
select * from Books;

-- MEMBERS TABLE
create table Members(
	member_id int not null identity(1, 1) primary key,
	name varchar(255) not null,
	email varchar(255),
	phone_number varchar(15),
	join_date date default getdate()
);
select * from Members;

-- Librarians Table
create table Librarians(
	librarian_id int not null identity(1,1) primary key, 
	name varchar(255) not null,
	email varchar(255),
	phone_number varchar(15),
	hire_date date default (current_date)
);
select * from Librarians

-- Borrowing (Loans) Table
CREATE TABLE Borrowing (
    loan_id INT NOT NULL identity(1,1) PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    return_date DATE,
    librarian_id INT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (librarian_id) REFERENCES Librarians(librarian_id)
);
select * from Borrowing;

---------- INSERTING DATA ----------
-- Insert book records into the Books table
INSERT INTO Books (title, author, genre, published_year) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925),
('1984', 'George Orwell', 'Dystopian', 1949),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', 1960);

-- Insert member records into the Members table
INSERT INTO Members (name, email, phone_number) VALUES
('Alen King', 'alenking@example.com', '1234567890'),
('Alece Hofman', 'alecehofman@example.com', '9876543210');

-- Insert librarian records into the Librarians table
INSERT INTO Librarians (name, email, phone_number) VALUES 
('Nail Horn', 'nail@example.com', '4567891230'), 
('Garden McGraw', 'garden@example.com', '7894561230');


---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- 
-- Query-1: Borrow a Book (Insert into Borrowing Table and Update Book Availability)
-- Insert a new record into the Borrowing table
INSERT INTO Borrowing (book_id, member_id, librarian_id, borrow_date)
-- Specify the values for book_id, member_id, librarian_id, and the current borrow date
VALUES (1, 1, 1, CURRENT_DATE);
-- Update the Books table to mark book 1 as unavailable
UPDATE Books
-- Set the is_available field to FALSE (unavailable)
SET is_available = 'FALSE'
-- Specify the book with book_id 1 to update
WHERE book_id = 1;

select * from Books


-- Query-2: Return a Book (Update Return Date and Book Availability)
-- Update the Borrowing table to record the return date for loan 1
UPDATE Borrowing
-- Set the return_date field to the current date (indicating the book has been returned)
SET return_date = CURRENT_DATE
-- Specify the loan with loan_id 1 to update
WHERE loan_id = 1;
-- Update the Books table to mark book 1 as available
UPDATE Books
-- Set the is_available field to TRUE (indicating the book is available again)
SET is_available = 'TRUE'
-- Specify the book with book_id 1 to update
WHERE book_id = 1;


-- Query-3: Check Available Books
select * from Books
where is_available = 'TRUE'


-- Query-4: View Member Loan History
select * from Borrowing
-- Select member name, book title, borrow date, and return date for member 1
SELECT m.name, b.title, br.borrow_date, br.return_date
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Members table to get member information
JOIN Members m ON br.member_id = m.member_id
-- Join the Books table to get book titles
JOIN Books b ON br.book_id = b.book_id
-- Filter the results to show borrowing history for member 1
WHERE m.member_id = 1;


-- Query-5: List Overdue Books (Books Not Returned in 14 Days)
select m.name, b.title, br.borrow_date
from Borrowing br
join members m ON br.member_id = m.member_id
join books b on br.book_id = b.book_id
where br.return_date is null
and br.borrow_date < dateadd(day,  -14, getdate());


-- Query-6: List All Books by a Specific Author
-- Select the title, genre, and published year of books
SELECT title, genre, published_year
-- From the Books table
FROM Books
-- Filter the results to include only books written by 'George Orwell'
WHERE author = 'George Orwell';


-- Query-7: Find Books Published After a Certain Year
-- Select the title, author, and published year of books
SELECT title, author, published_year
-- From the Books table
FROM Books
-- Filter the results to include only books published after the year 2000
WHERE published_year > 2000;


-- Query-8: Count Total Books in the Library
-- Count the total number of books in the Books table
SELECT COUNT(*) AS total_books
-- From the Books table
FROM Books;


-- Query-9: View All Members Who Borrowed a Specific Book
select m.name, br.borrow_date, br.return_date
from Borrowing br
join members m on br.member_id = m.member_id
join books b on br.book_id = b.book_id
where b.title = '1984';
-- Output not genetated for insufficient data


-- Query-10: Find Borrowing History of a Specific Member
-- Select the book title, borrow date, and return date for the borrowing history of member 1
SELECT b.title, br.borrow_date, br.return_date
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Books table to get the book titles
JOIN Books b ON br.book_id = b.book_id
-- Filter the results to show the borrowing history for member 1
WHERE br.member_id = 1;


-- Query-11: List All Available Books of a Specific Genre
-- Select the title, author, and published year of available Fiction books
SELECT title, author, published_year
-- From the Books table
FROM Books
-- Filter the results to include only books in the Fiction genre
WHERE genre = 'Fiction'
-- Further filter the results to include only books that are available
AND is_available = 'TRUE';


-- Query-12: Calculate the Total Number of Books Borrowed by Each Member
-- Select the member name and count of books borrowed by each member
SELECT m.name, COUNT(br.loan_id) AS total_books_borrowed
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Members table to get member information
JOIN Members m ON br.member_id = m.member_id
-- Group the results by member name to get the count of borrowed books per member
GROUP BY m.name;


-- Query-13: List All Overdue Books Not Yet Returned
-- Select the member name, book title, and borrow date for overdue books that have not been returned
SELECT m.name, b.title, br.borrow_date
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Members table to get member information
JOIN Members m ON br.member_id = m.member_id
-- Join the Books table to get book titles
JOIN Books b ON br.book_id = b.book_id
-- Filter for records where the book has not been returned (return_date is NULL)
WHERE br.return_date IS NULL
-- Further filter for books borrowed more than 30 days ago (overdue)
AND br.borrow_date < dateadd(day, -30, getdate());


-- Query-14: List the Librarians Who Processed the Most Borrowings
-- Select the librarian name and count of borrowings they processed
SELECT l.name, COUNT(br.loan_id) AS total_borrowings
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Librarians table to get librarian information
JOIN Librarians l ON br.librarian_id = l.librarian_id
-- Group the results by librarian name to count their total borrowings
GROUP BY l.name
-- Order the results by total borrowings in descending order
ORDER BY total_borrowings DESC;


-- Query-15: Find All Books Borrowed But Not Yet Returned
-- Select the member name, book title, and borrow date for books that have not been returned
SELECT m.name, b.title, br.borrow_date
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Members table to get information about the member who borrowed the book
JOIN Members m ON br.member_id = m.member_id
-- Join the Books table to get the titles of the borrowed books
JOIN Books b ON br.book_id = b.book_id
-- Filter the results to include only records where the book has not been returned (return_date is NULL)
WHERE br.return_date IS NULL;

