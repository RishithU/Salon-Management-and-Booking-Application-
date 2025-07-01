CREATE DATABASE SALON;
USE SALON;

-- CREATE TABLES 
-- 1. USERS TABLE
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    role ENUM('owner', 'customer') NOT NULL
);

-- 2. SHOPS TABLE
CREATE TABLE Shops (
    shop_id INT PRIMARY KEY AUTO_INCREMENT,
    owner_id INT UNIQUE,  -- One shop per owner
    shop_name VARCHAR(100),
    address TEXT,
    FOREIGN KEY (owner_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 3. STAFF TABLE
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    shop_id INT,
    user_id INT,  -- If owner is a staff too, this points to Users
    skill VARCHAR(100),
    FOREIGN KEY (shop_id) REFERENCES Shops(shop_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 4. SERVICES TABLE
CREATE TABLE Services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- 5. SHOP_SERVICES TABLE (Services with price & duration per shop)
CREATE TABLE Shop_Services (
    shop_service_id INT PRIMARY KEY AUTO_INCREMENT,
    shop_id INT,
    service_id INT,
    price DECIMAL(10, 2),
    duration_minutes INT,
    FOREIGN KEY (shop_id) REFERENCES Shops(shop_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Services(service_id) ON DELETE CASCADE
);

-- 6. DAILY STAFF AVAILABILITY
CREATE TABLE Staff_Availability (
    availability_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT,
    available_date DATE,
    available_from TIME DEFAULT '08:00:00',
    available_to TIME DEFAULT '19:00:00',
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);

-- 7. BOOKINGS TABLE
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    shop_service_id INT,
    shop_id INT,
    service_date DATE,
    start_time TIME,
    end_time TIME,
    status ENUM('booked', 'completed', 'cancelled', 'no_show') DEFAULT 'booked',
    advance_paid DECIMAL(10,2) DEFAULT 0,
    remaining_paid DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (shop_service_id) REFERENCES Shop_Services(shop_service_id) ON DELETE CASCADE,
    FOREIGN KEY (shop_id) REFERENCES Shops(shop_id) ON DELETE CASCADE
);

-- 8. BOOKING STAFF ASSIGNMENT
CREATE TABLE Booking_Assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT UNIQUE,
    staff_id INT,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);

-- 9. PAYMENTS TABLE
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    total_amount DECIMAL(10,2),
    advance_paid DECIMAL(10,2),
    remaining_paid DECIMAL(10,2),
    paid_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE
);

-- 10. STAFF SALARIES
CREATE TABLE Staff_Salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    staff_id INT,
    amount DECIMAL(10,2),
    reason ENUM('completed', 'no_show'),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);

-- 11. OWNER INCOMES
CREATE TABLE Owner_Incomes (
    income_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    owner_id INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (owner_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 12. FEEDBACK TABLE
CREATE TABLE Feedbacks (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    customer_id INT,
    staff_rating DECIMAL(2,1) CHECK (staff_rating BETWEEN 0 AND 5),
    shop_rating DECIMAL(2,1) CHECK (shop_rating BETWEEN 0 AND 5),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Users(user_id) ON DELETE CASCADE
);



-- INSERTING DATA 

USE SALON;
set sql_safe_updates=0;
-- Insert users (owners, staff, customers)
INSERT INTO Users (username, password, full_name, email, phone, role) VALUES
-- Owners
('ramesh123', 'pass123', 'Ramesh Verma', 'ramesh@example.com', '9876543210', 'owner'),
('sita456', 'pass456', 'Sita Iyer', 'sita@example.com', '9876543211', 'owner'),
('karthik892','passkarthik','Karthik Kumar','karthikku@gmail.com','9874215245','owner'),
-- Staff
('rahul89', 'rahul@89', 'Rahul Mehta', 'rahul@example.com', '9876543212', 'customer'),
('anita92', 'anita@92', 'Anita Desai', 'anita@example.com', '9876543213', 'customer'),
('rajesh77', 'rajesh@77', 'Rajesh Kumar', 'rajesh@example.com', '9876543214', 'customer'),
-- Customers
('priya001', 'priya001', 'Priya Sharma', 'priya@example.com', '9876543215', 'customer'),
('arjun002', 'arjun002', 'Arjun Reddy', 'arjun@example.com', '9876543216', 'customer');
select *   FROM Users;
-- Insert Shops (one per owner)
INSERT INTO Shops (owner_id, shop_name, address) VALUES
(1, 'Ramesh Salon & Spa', 'Banjara Hills, Hyderabad'),
(2, 'Sita Beauty Lounge', 'Hitech City, Hyderabad'),
(3,'Style up Hub','Madhapur, Hyderabad');
select *   FROM Shops;


-- Insert Staff (3 per shop)
INSERT INTO Users (username, password, full_name, email, phone, role) VALUES
('staff1', 'staff1', 'Kiran Rao', 'kiran@example.com', '9876543217', 'customer'),
('staff2', 'staff2', 'Meena Kumari', 'meena@example.com', '9876543218', 'customer'),
('staff3', 'staff3', 'Sunil Joshi', 'sunil@example.com', '9876543219', 'customer'),
('staff4', 'staff4', 'Divya Singh', 'divya@example.com', '9876543220', 'customer'),
('staff5', 'staff5', 'Amit Chauhan', 'amit@example.com', '9876543221', 'customer'),
('staff6', 'staff6', 'Neha Kapoor', 'neha@example.com', '9876543222', 'customer');

-- 3 more staff
INSERT INTO Users (username, password, full_name, email, phone, role) VALUES
('staff7', 'staff7', 'Simran', 'simmi@example.com', '9876555217', 'customer'),
('staff8', 'staff8', 'Rajneesh', 'raj@example.com', '9876758518', 'customer'),
('staff9', 'staff9', 'Kushal', 'kushal@example.com', '9456543219', 'customer');
select * from Users;


-- Staff mapping to shops and skills
INSERT INTO Staff (shop_id, user_id, skill) VALUES
-- Shop 1 staff (Ramesh Salon)
(1, 1, 'Haircut,Shaving,Hair Coloring,Spa'),
(1, 9, 'Haircut,Shaving,Facial'),
(1, 13, 'Shaving,Facial,Hair Coloring'),
-- Shop 2 staff (Sita Beauty Lounge)
(2, 2, 'Facial,Hair Coloring,Haircut'),
(2, 10, 'Haircut,Shaving,Facial'),
(2, 12, 'Manicur,Pedicure,Spa'),
(2, 14, 'Spa,Massage'),
(2, 15, 'Haircut,Manicure,Hair coloring'),
-- Shop 3 staff (Style  up hub )
(3, 3, 'Facial,Spa'),
(3, 11, 'Haircut,Shaving,Massage'),
(3, 16, 'Haircut,Shaving,Facial,Hair Coloring'),
(3, 17, 'Shaving,Hair Coloring');
select * from Staff;

-- Insert services
INSERT INTO Services (name, description) VALUES
('Haircut', 'Standard haircut for men/women'),
('Shaving', 'Clean shave and grooming'),
('Facial', 'Rejuvenating facial treatment'),
('Manicure', 'Hand care and nail polish'),
('Pedicure', 'Foot care and nail polish'),
('Spa', 'Relaxing body spa'),
('Massage', 'Full body massage'),
('Hair Coloring', 'Hair dyeing and highlights');
SELECT * FROM Services;

-- Shop services (each shop must offer haircut & shaving + 2–3 extra)
INSERT INTO Shop_Services (shop_id, service_id, price, duration_minutes) VALUES
-- Ramesh Salon
(1, 1, 100.00, 45),
(1, 2, 50.00, 20),
(1, 3, 250.00, 60),
(1, 6, 600.00, 180),
(1, 8, 100.00, 30),
-- Sita Beauty Lounge
(2, 1, 400.00, 150),
(2, 3, 400.00, 45),
(2, 4, 350.00, 60),
(2, 5, 350.00, 60),
(2, 6, 1000.00, 180),
(2, 7, 1500.00, 180),
(2, 8, 500.00, 150),
-- Style up Hub
(3,1,120.00,45),
(3,2,70.00,30),
(3,3,250.00,60),
(3,6,900.00,200),
(3,7,1000.00,180),
(3,8,100.00,30);
Select * from Shop_Services;

-- INSERT INTO AVAILABILITY ON 2025/06/21
-- Staff Availability for 2025-06-21
INSERT INTO Staff_Availability (staff_id, available_date, available_from, available_to) VALUES
-- Shop 1 staff (IDs 1,2,3)
(1, '2025-06-21', '09:00:00', '17:00:00'),
(2, '2025-06-21', '10:00:00', '21:00:00'),
(3, '2025-06-21', '10:00:00', '21:00:00'),


-- Shop 2 staff (IDs 4,5,6,7,8) --- 6 absent
(4, '2025-06-21', '08:00:00', '21:00:00'),
(5, '2025-06-21', '09:00:00', '18:00:00'),
(7, '2025-06-21', '09:00:00', '17:00:00'),
(8, '2025-06-21', '09:00:00', '17:00:00'),

-- Shop 3 Staff (IDs 9,10,11,12)  --- 11 absent
(9, '2025-06-21', '08:00:00', '21:00:00'),
(10, '2025-06-21', '09:00:00', '19:00:00'),
(12, '2025-06-21', '09:00:00', '13:00:00');
select * from Staff_Availability;


-- creating some bookings and assginging staff
-- Bookings on 2025-06-21
INSERT INTO Bookings (customer_id, shop_service_id, shop_id, service_date, start_time, end_time, status, advance_paid, remaining_paid) VALUES
(4, 1, 1, '2025-06-21', '09:00:00', '09:45:00', 'completed', 50.00, 50.00),
(5, 9, 2, '2025-06-21', '10:00:00', '11:00:00', 'completed', 105.00, 245.00),
(8, 17, 3, '2025-06-21', '11:00:00', '14:00:00', 'completed', 300.00, 700.00);

-- Assigned staff for above bookings
INSERT INTO Booking_Assignments (booking_id, staff_id) VALUES
(1, 2),  -- kiran Rao did haircut for rahul
(2, 5),  -- Meena Kumari was alloted for pedicure of Anita
(3, 9);  -- Alloted Kartik for spa of Arjun 

-- adding payments for these bookings
-- PAYMENT DETAILS for each booking
-- Booking 1: ₹50 advance + ₹50 remaining = ₹100
-- Booking 2: ₹105 advance + ₹245 remaining = ₹350
-- Booking 3: ₹300 advance + ₹700 remaining = ₹1000

-- 1. INSERT INTO Payments
INSERT INTO Payments (booking_id, total_amount, advance_paid, remaining_paid)
VALUES 
(1, 100.00, 50.00, 50.00),
(2, 350.00, 105.00, 245.00),
(3, 1000.00, 300.00, 700.00);

-- 2. INSERT INTO Staff_Salaries
-- 50% of total_amount = staff_salary if completed
-- Assigned staff: booking 1 → staff_id 2, booking 2 → staff_id 5, booking 3 → staff_id 9
INSERT INTO Staff_Salaries (booking_id, staff_id, amount, reason)
VALUES 
(1, 2, 50.00, 'completed'),
(2, 5, 175.00, 'completed'),
(3, 9, 500.00, 'completed');

-- 3. INSERT INTO Owner_Incomes
-- Assume shop_id:
-- booking 1 → shop_id 1 (owner_id 1)
-- booking 2 → shop_id 2 (owner_id 2)
-- booking 3 → shop_id 3 (owner_id 3)

INSERT INTO Owner_Incomes (booking_id, owner_id, amount)
VALUES 
(1, 1, 50.00),
(2, 2, 175.00),
(3, 3, 500.00);



-- query to add feedback given for the above 
INSERT INTO feedbacks (booking_id,customer_id,staff_rating,shop_rating) VALUES
(1,4,4.5,3.7),
(2,5,3.9,4.5),
(3,8,4,4);
select * from feedbacks;

-- Query to show shops available for providing a particular service choosen 
SELECT 
    sh.shop_name,
    sh.address,
    sv.name AS service_name,
    ss.price,
    ss.duration_minutes,
    u.full_name AS staff_name,
    st.skill,
    sa.available_from,
    sa.available_to
FROM Shop_Services ss
JOIN Services sv ON ss.service_id = sv.service_id
JOIN Shops sh ON ss.shop_id = sh.shop_id
JOIN Staff st ON st.shop_id = sh.shop_id
JOIN Users u ON u.user_id = st.user_id
JOIN Staff_Availability sa ON sa.staff_id = st.staff_id
WHERE sv.name = 'Massage'  -- Replace with the chosen service
  AND sa.available_date = '2025-06-21'  -- Replace with desired date
  AND st.skill LIKE '%Massage%'  -- Ensure staff can perform this service
ORDER BY sh.shop_name, sa.available_from;


-- Query to make  a make a booking for priya at shop 2 for massage from 14:00 and also aasign someone there 
-- 1. Declare the booking parameters
SET @customer_id = 7;       
SET @shop_id = 2;          
SET @service_id = 7;        
SET @service_date = '2025-06-21';
SET @start_time = '14:00:00';
SET @end_time = '17:00:00';

--  matching shop_service_id (price & duration)
SELECT @shop_service_id := ss.shop_service_id,
       @price := ss.price
FROM Shop_Services ss
WHERE ss.shop_id = @shop_id AND ss.service_id = @service_id
LIMIT 1;

-- 3. Find an available staff member in that shop with required skill and availability
SELECT @staff_id := st.staff_id
FROM Staff st
JOIN Staff_Availability sa ON sa.staff_id = st.staff_id
WHERE st.shop_id = @shop_id
  AND FIND_IN_SET((SELECT name FROM Services WHERE service_id = @service_id), st.skill)
  AND sa.available_date = @service_date
  AND sa.available_from <= @start_time
  AND sa.available_to >= @end_time
  AND st.staff_id NOT IN (
      SELECT ba.staff_id
      FROM Booking_Assignments ba
      JOIN Bookings b ON b.booking_id = ba.booking_id
      WHERE b.service_date = @service_date
        AND ((b.start_time < @end_time) AND (b.end_time > @start_time))
  )
LIMIT 1;

-- 4. Insert the booking (30% advance)
INSERT INTO Bookings (
    customer_id, shop_service_id, shop_id,
    service_date, start_time, end_time,
    status, advance_paid, remaining_paid
)
VALUES (
    @customer_id, @shop_service_id, @shop_id,
    @service_date, @start_time, @end_time,
    'booked', ROUND(@price * 0.3, 2), ROUND(@price * 0.7, 2)
);

-- 5. Get the last inserted booking ID
SET @booking_id = LAST_INSERT_ID();

-- 6. Assign staff to the booking
INSERT INTO Booking_Assignments (booking_id, staff_id)
VALUES (@booking_id, @staff_id);

-- Optional: Check result
SELECT
    b.booking_id, u.full_name AS customer_name, s.name AS service,
    sh.shop_name, b.start_time, b.end_time, stf.skill AS assigned_skill,
    su.full_name AS staff_assigned
FROM Bookings b
JOIN Shop_Services ss ON b.shop_service_id = ss.shop_service_id
JOIN Services s ON ss.service_id = s.service_id
JOIN Shops sh ON b.shop_id = sh.shop_id
JOIN Users u ON b.customer_id = u.user_id
JOIN Booking_Assignments ba ON b.booking_id = ba.booking_id
JOIN Staff stf ON ba.staff_id = stf.staff_id
JOIN Users su ON stf.user_id = su.user_id
WHERE b.booking_id = @booking_id;


select * from bookings;
select * from staff_availability;
select * from booking_assignments;


-- query to close payment done
-- 1. Mark booking as completed and update remaining payment
UPDATE Bookings
SET status = 'completed', remaining_paid = 1050.00
WHERE booking_id = 5;

-- 2. Insert payment record
INSERT INTO Payments (booking_id, total_amount, advance_paid, remaining_paid)
VALUES (5, 1500.00, 450.00, 1050.00);

-- 3. Insert into Staff_Salaries: 50% of full amount if completed
-- Assigned staff is staff_id = 7
INSERT INTO Staff_Salaries (booking_id, staff_id, amount, reason)
VALUES (5, 7, 750.00, 'completed');

-- 4. Insert into Owner_Incomes: 50% of service amount
-- First, get the shop’s owner_id for shop_id = 2
INSERT INTO Owner_Incomes (booking_id, owner_id, amount)
VALUES (5, 2, 750.00); -- Owner SIta (user_id = 2)
select * from Owner_Incomes;
select * from staff_salaries;



-- query to add ffeedback for the above booking 
INSERT INTO feedbacks (booking_id,customer_id,staff_rating,shop_rating) VALUES
(5,7,4.5,4);

select * from feedbacks;
-- query to show booking details(incl feedabck) for the day of a prticular shop
SELECT 
    b.booking_id,
    u_cust.full_name AS customer_name,
    s.name AS service_name,
    u_staff.full_name AS staff_name,
    b.start_time,
    b.end_time,
    b.status,
    f.staff_rating,
    f.shop_rating
FROM Bookings b
JOIN Users u_cust ON b.customer_id = u_cust.user_id
JOIN Shop_Services ss ON b.shop_service_id = ss.shop_service_id
JOIN Services s ON ss.service_id = s.service_id
LEFT JOIN Booking_Assignments ba ON b.booking_id = ba.booking_id
LEFT JOIN Staff st ON ba.staff_id = st.staff_id
LEFT JOIN Users u_staff ON st.user_id = u_staff.user_id
LEFT JOIN Feedbacks f ON b.booking_id = f.booking_id
WHERE b.shop_id = 2 AND b.service_date = '2025-6-21';


-- add more days booking , assignment , availabilty data 

-- query to salary deatils of a particulr stafff member in a particualr shop ina particular date range
SELECT 
    ss.salary_id,
    u.full_name AS staff_name,
    sh.shop_name,
    b.booking_id,
    b.service_date,
    ss.amount AS salary_amount,
    ss.reason
FROM Staff_Salaries ss
JOIN Bookings b ON ss.booking_id = b.booking_id
JOIN Shops sh ON b.shop_id = sh.shop_id
JOIN Staff st ON ss.staff_id = st.staff_id
JOIN Users u ON st.user_id = u.user_id
WHERE ss.staff_id = 7               -- Replace with desired staff ID
  AND b.shop_id = 2                 -- Replace with desired shop ID
  AND b.service_date BETWEEN '2025-06-01' AND '2025-06-30'  -- Replace with desired date range
ORDER BY b.service_date;



-- query to show net sales of a shop
SELECT 
    s.shop_id,
    s.shop_name,
    SUM(p.total_amount) AS net_sales,
    COUNT(b.booking_id) AS total_bookings
FROM Bookings b
JOIN Payments p ON b.booking_id = p.booking_id
JOIN Shops s ON b.shop_id = s.shop_id
WHERE b.status = 'completed'
  AND b.service_date BETWEEN '2025-06-01' AND '2025-06-30'
  AND s.shop_id = 2  -- Replace with the desired shop ID
GROUP BY s.shop_id, s.shop_name;



-- query to show earning of owner of particular shop during a particular date range
SELECT 
    u.full_name AS owner_name,
    u.user_id AS owner_id,
    s.shop_name,
    
    COALESCE(oi.total_owner_income, 0) AS income_from_others,
    COALESCE(ss.total_self_salary, 0) AS income_from_self_services,
    
    COALESCE(oi.total_owner_income, 0) + COALESCE(ss.total_self_salary, 0) AS total_income

FROM Users u
JOIN Shops s ON s.owner_id = u.user_id

LEFT JOIN (
    SELECT 
        oi.owner_id,
        b.shop_id,
        SUM(oi.amount) AS total_owner_income
    FROM Owner_Incomes oi
    JOIN Bookings b ON oi.booking_id = b.booking_id
    WHERE b.service_date BETWEEN '2025-06-01' AND '2025-06-30'
    GROUP BY oi.owner_id, b.shop_id
) oi ON u.user_id = oi.owner_id AND s.shop_id = oi.shop_id

LEFT JOIN (
    SELECT 
        st.user_id,
        b.shop_id,
        SUM(ss.amount) AS total_self_salary
    FROM Staff_Salaries ss
    JOIN Staff st ON ss.staff_id = st.staff_id
    JOIN Bookings b ON ss.booking_id = b.booking_id
    WHERE ss.reason = 'completed'
      AND b.service_date BETWEEN '2025-06-01' AND '2025-06-30'
    GROUP BY st.user_id, b.shop_id
) ss ON u.user_id = ss.user_id AND s.shop_id = ss.shop_id

WHERE u.role = 'owner'
  AND s.shop_id = 2;  







