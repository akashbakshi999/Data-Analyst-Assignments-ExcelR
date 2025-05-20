/* Assignment 1 */
use classicmodels;
select employeeNumber,firstName,lastName
from employees
where jobTitle="sales Rep" and reportsTo=1102;

/* Assignment 1.2 */
SELECT DISTINCT productLine FROM products
WHERE productLine LIKE '%cars';

/* Assignment 2 */
select  customerNumber,customername,
Case when country="USA" or country="Canada" then "North America"
when country="UK" or country="France" or country="Germany" then "Europe"
else "Others"
end as customerSegment
from customers;

/* Assignment 3 */
SELECT productCode, SUM(quantityOrdered) AS total_quantity
FROM OrderDetails
GROUP BY productCode
ORDER BY total_quantity DESC
LIMIT 10;

/* Assignment 3.2 */
SELECT MONTHNAME(paymentDate) AS payment_month, COUNT(*) AS Num_payments
FROM Payments
GROUP BY monthname(paymentDate)
HAVING Num_payments > 20
ORDER BY Num_payments DESC;

/* Assignment 4 */
create database Customers_Orders;
use customers_Orders;
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20),
    CONSTRAINT chk_email_format CHECK (email LIKE '%_@__%.__%')
);

/* Assignment 4.1 */
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CHECK (total_amount >= 0)
    );
    
    /* Assignment 5 */ 
use classicmodels;
SELECT 
    c.Country,COUNT(o.OrderNumber) AS OrderCount
FROM 
    Customers c JOIN Orders o 
ON c.CustomerNumber = o.CustomerNumber
WHERE c.Country IS NOT NULL
GROUP BY c.Country
ORDER BY OrderCount DESC
LIMIT 5;
    
   /* Assignment 6 */ 
   use classicmodels;
CREATE TABLE project (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    Gender ENUM('Male', 'Female'),
    ManagerID INT
);
insert into project values(1,"Pranaya","Male",3),
				          (2,"priyanka","Female",1),
						  (3,"Preeti","Female",null),
						  (4,"Anurag","Male",1),
                          (5,"Sambit","Male",1),
						  (6,"Rajesh","Male",3),
						  (7,"Hina","Female",3);
											
SELECT 
    mgr.FullName AS ManagerName,
    emp.FullName AS EmployeeName
FROM project AS emp JOIN project AS mgr 
ON emp.ManagerID = mgr.EmployeeID;

/* Assignment 7 */
CREATE TABLE facility (
    Facility_ID INT NOT NULL,
    Name VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    City VARCHAR(100) NOT NULL
);
ALTER TABLE facility
ADD CONSTRAINT PK_FacilityID PRIMARY KEY (Facility_ID),
MODIFY Facility_ID INT AUTO_INCREMENT;

desc facility;

/* Assignment 8 */
CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine AS productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM Products p JOIN OrderDetails od ON p.productCode = od.productCode
JOIN Orders o ON od.orderNumber = o.orderNumber
JOIN ProductLines pl ON p.productLine = pl.productLine
GROUP BY pl.productLine;

/* Assignment 9 */
DELIMITER //
CREATE PROCEDURE Get_country_payments (
    IN input_year INT,
    IN input_country VARCHAR(50),
    OUT total_amount_formatted VARCHAR(50)
)
BEGIN
    DECLARE total_amount DECIMAL(15, 2);

    SELECT 
        ROUND(SUM(amount) / 1000) * 1000  -- Round and format to nearest thousand (K)
    INTO 
        total_amount
    FROM 
        Payments p
    JOIN 
        Customers c ON p.customerNumber = c.customerNumber
    WHERE 
        YEAR(paymentDate) = input_year
        AND c.country = input_country;

    SET total_amount_formatted = CONCAT(FORMAT(total_amount, 0), 'K');
END//
DELIMITER ;

/* Assignment 10 */
SELECT CUSTOMERNAME,COUNT(CUSTOMERS.CUSTOMERNUMBER)AS ORDER_COUNT,DENSE_RANK() OVER(ORDER BY COUNT(CUSTOMERS.CUSTOMERNUMBER) DESC) AS ORDER_FREQUENCY_RANK FROM ORDERS INNER JOIN CUSTOMERS 
ON ORDERS.CUSTOMERNUMBER=CUSTOMERS.CUSTOMERNUMBER
GROUP BY ORDERS.CUSTOMERNUMBER;
    
 /* Assignment 10.1 */
SELECT YEAR(ORDERDATE) AS YEAR, MONTHNAME(ORDERDATE) AS MONTH, COUNT(ORDERNUMBER) AS TOTAL_ORDERS, 
CONCAT(ROUND((COUNT(ORDERNUMBER)-LAG(COUNT(ORDERNUMBER),1,0) OVER(ORDER BY YEAR(ORDERDATE))) / 
(LAG(COUNT(ORDERNUMBER),1,0) OVER(ORDER BY YEAR(ORDERDATE)))*100),'%') AS '% YOY_CHANGE'
FROM ORDERS
GROUP BY YEAR,MONTH;

/* Assignment 11 */
SELECT productLine,COUNT(*) AS Count
FROM products
WHERE buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY productLine;

/* Assignment 12 */
CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    EmailAddress VARCHAR(100)
);
DELIMITER //

CREATE PROCEDURE Insert_Emp_EH (
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(100),
    IN p_EmailAddress VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error occurred
        SELECT 'Error occurred' AS Message;
    END;

    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (p_EmpID, p_EmpName, p_EmailAddress);

    SELECT 'Insert successful' AS Message;
    
END //

DELIMITER ;

/* Assignment 13 */
CREATE TABLE Emp_BIT (
    Name VARCHAR(100),
    Occupation VARCHAR(100),
    Working_date DATE,
    Working_hours INT
);
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

DELIMITER //

CREATE TRIGGER before_insert_working_hours_positive
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END //

DELIMITER ;

INSERT INTO Emp_BIT VALUES ('Akash', 'DataEngineer', '2018-10-01', -6);





