-- LAB 3: SQL Operations & Database Management
-- Student: [Your Name]
-- Date: April 10, 2025

-- TASK 1: VIEW ALREADY EXISTS
-- Test the existing view instead of creating a new one
SELECT * FROM PassengerBookingSummary LIMIT 3;

-- TASK 2: ADD INTEGRITY CONSTRAINTS
-- For SQLite, we'll need to use a specific approach to add constraints to existing tables

-- First, let's check if the constraints already exist by attempting a violation
-- Try inserting an invalid ticket type to test if the constraint is already in place
BEGIN TRANSACTION;
-- This should fail if the constraint is already in place
INSERT INTO Tickets (passenger_id, flight_id, ticket_type, seat_number, ticket_status, booking_date)
VALUES (1, 1, 'Invalid Type', 'X1', 'Booked', datetime('now'));
-- If it doesn't fail, we need to add the constraint
ROLLBACK;

-- To add constraints to existing tables in SQLite, we need to:
-- 1. Create new tables with the constraints
-- 2. Copy data from old tables to new tables
-- 3. Drop old tables
-- 4. Rename new tables to the original names

-- Let's start with the Tickets table
-- Create a new table with the constraint
CREATE TABLE IF NOT EXISTS Tickets_New (
    ticket_id INTEGER PRIMARY KEY AUTOINCREMENT,
    passenger_id INTEGER NOT NULL,
    flight_id INTEGER NOT NULL,
    ticket_type TEXT NOT NULL CHECK (ticket_type IN ('Economy', 'Business', 'First Class', 'Premium Economy')),
    seat_number TEXT,
    ticket_status TEXT DEFAULT 'Booked',
    booking_date TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id) ON DELETE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

-- Copy data from old table to new table
INSERT INTO Tickets_New
SELECT * FROM Tickets;

-- Drop old table
DROP TABLE Tickets;

-- Rename new table to original name
ALTER TABLE Tickets_New RENAME TO Tickets;

-- Now do the same for the Flights table to add the price constraint
CREATE TABLE IF NOT EXISTS Flights_New (
    flight_id INTEGER PRIMARY KEY AUTOINCREMENT,
    flight_number TEXT NOT NULL UNIQUE,
    departure_city TEXT NOT NULL,
    arrival_city TEXT NOT NULL,
    departure_time TEXT NOT NULL,
    arrival_time TEXT NOT NULL,
    airline TEXT,
    price REAL NOT NULL CHECK (price > 0)
);

-- Copy data from the old table to the new table
INSERT INTO Flights_New
SELECT * FROM Flights;

-- Drop the old table
DROP TABLE Flights;

-- Rename the new table to the original name
ALTER TABLE Flights_New RENAME TO Flights;

-- TASK 3: CREATE AN INDEX
-- Create indexes for passport_number and flight_number if they don't exist
CREATE INDEX IF NOT EXISTS idx_passport_number ON Passengers(passport_number);
CREATE INDEX IF NOT EXISTS idx_flight_number ON Flights(flight_number);

-- TASK 4: CREATE AND TEST A TRANSACTION
-- Transaction that adds a new passenger, books a flight, and processes payment

-- Start Transaction
BEGIN TRANSACTION;

-- Insert new passenger
INSERT INTO Passengers (first_name, last_name, date_of_birth, passport_number, email, phone_number, address)
VALUES ('Alice', 'Johnson', '1992-07-18', 'P555666777', 'alice.johnson@example.com', '456-789-0123', '567 Maple Ave, Springfield');

-- Get the ID of the newly inserted passenger
-- In SQLite, we can use last_insert_rowid() to get the ID of the last inserted row
SELECT last_insert_rowid() AS new_passenger_id;

-- Store this ID in a variable (in a real application)
-- For this script, we'll assume it's the next sequential ID after your existing data
-- Let's say it's passenger_id = 4 for this example

-- Insert new ticket for the passenger
INSERT INTO Tickets (passenger_id, flight_id, ticket_type, seat_number, ticket_status, booking_date)
VALUES (4, 2, 'Economy', 'D4', 'Booked', datetime('now'));

-- Get the ID of the newly inserted ticket
SELECT last_insert_rowid() AS new_ticket_id;

-- Assuming ticket_id = 4 for this example

-- Process payment for the ticket
INSERT INTO Payments (ticket_id, payment_amount, payment_method, payment_date, payment_status)
VALUES (4, 200.00, 'Credit Card', datetime('now'), 'Completed');

-- Commit the transaction
COMMIT;

-- Verify the transaction results
SELECT * FROM Passengers WHERE first_name = 'Alice' AND last_name = 'Johnson';
SELECT * FROM Tickets WHERE passenger_id = 4;
SELECT * FROM Payments WHERE ticket_id = 4;

-- Example of a transaction that gets rolled back
BEGIN TRANSACTION;

-- Update a flight price
UPDATE Flights SET price = price * 1.2 WHERE flight_id = 1;

-- Check the updated price
SELECT flight_number, price FROM Flights WHERE flight_id = 1;

-- Rollback the transaction (undo the changes)
ROLLBACK;

-- Verify the price is back to original
SELECT flight_number, price FROM Flights WHERE flight_id = 1;

-- TASK 5: WRITE A COMPLEX QUERY (JOIN + SUBQUERY)
-- Find all passengers who have booked tickets more expensive than the average flight price

SELECT 
    p.first_name || ' ' || p.last_name AS passenger_name,
    p.email,
    f.flight_number,
    f.departure_city,
    f.arrival_city,
    f.departure_time,
    t.ticket_type,
    t.seat_number,
    pay.payment_amount,
    pay.payment_method,
    pay.payment_status
FROM Passengers p
JOIN Tickets t ON p.passenger_id = t.passenger_id
JOIN Flights f ON t.flight_id = f.flight_id
JOIN Payments pay ON t.ticket_id = pay.ticket_id
WHERE f.price > (
    SELECT AVG(price) 
    FROM Flights
)
ORDER BY pay.payment_amount DESC;

-- BONUS TASK: AUTHORIZATION (ROLE & GRANT)
-- Note: SQLite does not support roles and grants like other database systems
-- This is included as a comment to fulfill the assignment requirement

-- If this were implemented in a database system that supports roles (like MySQL):
/*
CREATE ROLE IF NOT EXISTS 'customer_service';
GRANT SELECT ON PassengerBookingSummary TO 'customer_service';
CREATE USER IF NOT EXISTS 'cs_rep1'@'localhost' IDENTIFIED BY 'securePassword123';
GRANT 'customer_service' TO 'cs_rep1'@'localhost';

CREATE ROLE IF NOT EXISTS 'booking_admin';
GRANT SELECT, INSERT, UPDATE ON Passengers TO 'booking_admin';
GRANT SELECT, INSERT, UPDATE ON Tickets TO 'booking_admin';
GRANT SELECT, INSERT, UPDATE ON Flights TO 'booking_admin';
GRANT SELECT, INSERT, UPDATE ON Payments TO 'booking_admin';

CREATE USER IF NOT EXISTS 'admin1'@'localhost' IDENTIFIED BY 'adminSecurePass456';
GRANT 'booking_admin' TO 'admin1'@'localhost';
*/

-- For SQLite, security is typically implemented at the application level or through file permissions
-- You could document this approach as follows:

-- 1. File system permissions: Restrict access to the SQLite database file
-- 2. Application-level security: Implement user authentication and authorization in your application
-- 3. Use SQLite encryption extensions if sensitive data protection is required
