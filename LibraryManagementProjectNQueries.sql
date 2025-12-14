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
-- Query1: Borrow a Book (Insert into Borrowing Table and Update Book Availability)
-- Insert a new record into the Borrowing table
INSERT INTO Borrowing (book_id, member_id, librarian_id, borrow_date)
-- Specify the values for book_id, member_id, librarian_id, and the current borrow date
VALUES (1, 1, 1, CURRENT_DATE);
