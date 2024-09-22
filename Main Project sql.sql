create database library;
use library; 

create table Branch
(
Branch_no int PRIMARY KEY,
Manager_Id  int,
Branch_address varchar(300), 
Contact_no varchar(20)
);

create table Employee 
(
Emp_Id int PRIMARY KEY,
Emp_name  varchar(50),
Position varchar (50), 
Salary decimal(10,2),
branch_no int,
foreign KEY(Branch_no) references  Branch(Branch_no)
);

create table Books
(
ISBN varchar(50) PRIMARY KEY ,
Book_title varchar(200) ,
Category varchar(100) ,
Rental_Price decimal(10,2),
Status varchar (3), 
Author varchar(100),
Publisher varchar(100),
constraint check_status check (status in('yes','no'))
);

create table Customer
(
Customer_Id int PRIMARY KEY ,
Customer_name varchar(100),
Customer_address  varchar(200),
Reg_date date
);

create table IssueStatus
(
Issue_Id int PRIMARY KEY , 
Issued_cust_id int ,
FOREIGN KEY (Issued_cust_id) references customer(customer_id),
Issued_book_name varchar(200),
Issue_date date,
Isbn_book varchar(50),
FOREIGN KEY (Isbn_book) references Books(isbn)
);

create table ReturnStatus
(
Return_Id int PRIMARY KEY , 
Return_cust  int,
foreign key (Return_cust) references customer(Customer_id),
Return_book_name  varchar(200),
Return_date date, 
Isbn_book2 varchar(50),
FOREIGN KEY (Isbn_book2) references books(isbn) 
); 

insert into Branch values
(1,101,"Head Office, Calicut",9758746125),
(2,102,"thalassery, kannur",9787485961),
(3,103,"vadakara,calicut",9874563210);
select* from branch;

insert into employee values
(101,"Rajesh","Manager","85000",1),
(102,"Ramya","Manager",50000,2),
(103,"Jey","Manager", 55000,3),
(104,"jane","librarian",40000,1),
(105,"lucky","Book Keeper",35000,2),
(106,"thara","librarian", 40000,2),
(107,"james","cleaner",30000,2),
(108,"sara","Book Keeper",35000,2),
(109,"jaya","Assistant librarian",35000,2);
select*from employee;

insert into books values
('978-0-452-28423-4', '1984', 'Fiction', 25.00, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-7432-7356-5', 'The 7 Habits of Highly Effective People', 'Self-help', 26.00, 'yes', 'Stephen Covey', 'Free Press'),
('978-1-4088-5565-2', 'Harry Potter and the Philosopher''s Stone', 'Fantasy', 15.00, 'no', 'J.K. Rowling', 'Bloomsbury'),
('978-0-06-092987-9', 'The Brave new World', 'Fiction', 20.00, 'no', 'Aldous Huxley', 'Harper Perennial'),
('978-0-670-03216-5', 'The Catcher in the Rye', 'Fiction', 14.00, 'yes', 'J.D. Salinger', 'Little, Brown'),
('978-0-9876-5432-1', 'The history of ancient civilizations', 'History', 22.00, 'yes', 'John Doe', 'Historical Press');
select*from books;

insert into customer values
(1,"john","thalassery, kannur","2024-07-12"),
(2,"sara","kottayam","2024-06-15"),
(3,"juni","valliyad, vadakara","2024-09-05"),
(4,"sahla","vadakara, kozhikode","2021-01-01"),
(5,"risana","karthikapalli","2024-06-15");
select*from customer;

INSERT INTO IssueStatus VALUES
(1, 1, '1984', "2024-07-12", '978-0-452-28423-4'),
(2, 2, 'The 7 Habits of Highly Effective People', "2024-06-15", '978-0-7432-7356-5'),
(3, 3, 'Harry Potter and the Philosopher''s Stone', '2023-09-01', '978-1-4088-5565-2'),
(4, 3, 'The Catcher in the Rye', "2024-06-15", '978-0-670-03216-5'),
(5, 2, 'The Brave new World', "2023-06-06", '978-0-06-092987-9');
select*from issuestatus;

insert into returnstatus values
(1, 1, '1984', '2024-08-01', '978-0-452-28423-4'),
(2, 2, 'The 7 Habits of Highly Effective People', '2024-07-01', '978-0-7432-7356-5'),
(3, 4, 'The Brave new World', '2024-09-10', '978-0-06-092987-9');
select*from returnstatus;

-- 1. Retrieve the book title, category, and rental price of all available books. 
select Book_title,Category,Rental_Price from books where status="yes";

-- 2. List the employee names and their respective salaries in descending order of salary.
select Emp_name, Salary from employee order by salary desc ;

-- 3. Retrieve the book titles and the corresponding customers who have issued those books.
select Books.Book_title, customer.Customer_name from issuestatus
 inner join books on 
 issuestatus.Isbn_book=books.ISBN
inner join customer on 
issuestatus.Issued_cust_id=customer.Customer_Id;

-- 4. Display the total count of books in each category. 
select category, count(*) as total_count from books group by Category;

-- 5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000.
select Emp_name, Position from employee where Salary >50000;

-- 6. List the customer names who registered before 2022-01-01 and have not issued any books yet.
select customer.Customer_name
from customer 
left join issuestatus 
on customer.Customer_Id=issuestatus.Issued_cust_id 
where customer.Reg_date<"2022-01-01" 
and issuestatus.Issue_Id is null;

-- 7. Display the branch numbers and the total count of employees in each branch. 
select Branch_no, count(Emp_Id) as Total_employee from employee group by branch_no;

-- 8. Display the names of customers who have issued books in the month of June 2023.
SELECT DISTINCT Customer_name
FROM IssueStatus 
JOIN Customer ON Issued_cust_id = Customer_Id
WHERE Issue_date BETWEEN '2023-06-01' AND '2023-06-30';

-- 9. Retrieve book_title from book table containing history. 
select Book_title from books where Book_title like "%history%";

-- 10.Retrieve the branch numbers along with the count of employees for branches having more than 5 employees
select Branch_no, count(Emp_Id) as total_emp from employee group by branch_no having count(Emp_Id)>5;

-- 11. Retrieve the names of employees who manage branches and their respective branch addresses.
SELECT E.Emp_name, B.Branch_address
FROM Employee E
JOIN Branch B ON E.Branch_no = B.Branch_no
WHERE E.Position = 'Manager';

-- 12.  Display the names of customers who have issued books with a rental price higher than Rs. 25.
SELECT DISTINCT C.Customer_name
FROM IssueStatus I
JOIN Books B ON I.Isbn_book = B.ISBN
JOIN Customer C ON I.Issued_cust_id = C.Customer_Id
WHERE B.Rental_Price > 25;
