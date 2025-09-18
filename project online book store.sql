CREATE TABLE ORDERSTABLE  (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM ORDERSTABLE;
COPY   ORDERSTABLE (Order_ID,	Customer_ID,Book_ID,Order_Date,	Quantity,	Total_Amount)
FROM 'E:\New folder\Orders (2).csv'
CSV HEADER ;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT);
	CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150));
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'E:\New folder\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'E:\New folder\Customers (1).csv' 
CSV HEADER;
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM OrdersTABLE;


--1) RETRIVE ALL THE BOOKS IN THE FICTION GENERE
SELECT * FROM Books
WHERE GENRE ='Fiction';

--2) find books published after year 1950
select * from books where published_year> 1950;

--3)list all the customers from canada .
select * from Customers where country = 'Canada';

--4) SHOW ORDERS PLACED IN NOVEMBER 2023.

SELECT * FROM ORDERSTABLE WHERE ORDER_DATE BETWEEN ('2023-11-01') AND ('2023-11-30') ;

--5)RETRIVE THE TOTAL STOCKS OF BOOKS AVAILABLE.
SELECT SUM(STOCK) AS TOTAL_STOCKS FROM BOOKS;

-- 6) Find the details of the most expensive book:
SELECT * FROM BOOKS ORDER BY PRICE DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM OrderSTABLE 
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM ORDERSTABLE WHERE TOTAL_AMOUNT>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;


-- 10) Find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY stock ASC
LIMIT 1;


-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) As Revenue 
FROM ORDERSTABLE;

--ADVANCE QUESTIONS 
--1)RETRIVE THE TOTAL NO. OF BOOKS SOLD FOR EACH GENRE.
SELECT * FROM ORDERSTABLE
SELECT b.Genre, SUM(o.Quantity) AS TOTALBOOKS_SOLD  FROM ORDERSTABLE O  JOIN BOOKS B ON O.BOOK_ID = B.BOOK_ID
GROUP BY B.GENRE ;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(PRICE ) FROM BOOKS WHERE GENRE= 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orderstable o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;

-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orderstable o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orderstable o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;





-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orderstable o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;


-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orderstable o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orderstable o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;



















