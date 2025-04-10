DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Customers;

-- Task 2: Create Customers table with integrity constraints (UNIQUE + NOT NULL)
CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT NOT NULL UNIQUE, -- Integrity Constraint 1
    phone TEXT,
    address TEXT,
    date_of_birth DATE
);

-- Task 2: Create Accounts table with integrity constraints (CHECK + FOREIGN KEY)
CREATE TABLE Accounts (
    account_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    account_type TEXT,
    balance DECIMAL(15, 2) CHECK (balance >= 0), -- Integrity Constraint 2
    created_at DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create Transactions table
CREATE TABLE Transactions (
    transaction_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    transaction_type TEXT, -- 'deposit' or 'withdrawal'
    amount DECIMAL(15, 2),
    transaction_date TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- Create Loans table
CREATE TABLE Loans (
    loan_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    loan_type TEXT,
    amount DECIMAL(15, 2),
    interest_rate DECIMAL(5, 2),
    start_date DATE,
    end_date DATE,
    status TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert sample customers
INSERT INTO Customers VALUES
(1, 'Alice Johnson', 'alice@example.com', '555-1234', '123 Main St, Springfield', '1990-05-12'),
(2, 'Bob Smith', 'bob@example.com', '555-2345', '456 Elm St, Shelbyville', '1985-09-23'),
(3, 'Charlie Brown', 'charlie@example.com', '555-3456', '789 Oak St, Capital City', '1978-11-02'),
(4, 'Diana Prince', 'diana@example.com', '555-4567', '101 Maple St, Metropolis', '1992-08-17'),
(5, 'Ethan Hunt', 'ethan@example.com', '555-5678', '202 Birch St, Gotham', '1988-12-30');

-- Insert sample accounts
INSERT INTO Accounts VALUES
(1001, 1, 'savings', 15000.00, '2021-01-15'),
(1002, 1, 'checking', 3000.00, '2022-03-10'),
(1003, 2, 'savings', 20000.00, '2020-06-20'),
(1004, 3, 'checking', 5000.00, '2021-12-01'),
(1005, 4, 'savings', 10000.00, '2023-05-05'),
(1006, 5, 'checking', 8000.00, '2022-09-19');

-- Insert sample transactions
INSERT INTO Transactions VALUES
(1, 1001, 'deposit', 5000.00, '2023-01-01 10:00:00'),
(2, 1001, 'withdrawal', 2000.00, '2023-02-10 14:30:00'),
(3, 1002, 'deposit', 3000.00, '2023-03-15 09:45:00'),
(4, 1003, 'withdrawal', 1000.00, '2023-04-20 11:20:00'),
(5, 1004, 'deposit', 2500.00, '2023-05-25 15:00:00'),
(6, 1005, 'withdrawal', 1500.00, '2023-06-30 12:00:00'),
(7, 1006, 'deposit', 4000.00, '2023-07-10 16:00:00'),
(8, 1003, 'deposit', 3000.00, '2023-07-11 13:30:00'),
(9, 1006, 'withdrawal', 2000.00, '2023-08-12 10:10:00');

-- Insert sample loans
INSERT INTO Loans VALUES
(501, 1, 'home loan', 250000.00, 3.5, '2022-01-01', '2032-01-01', 'active'),
(502, 2, 'car loan', 20000.00, 5.0, '2021-06-15', '2026-06-15', 'active'),
(503, 3, 'personal loan', 10000.00, 7.5, '2020-03-01', '2023-03-01', 'closed'),
(504, 4, 'education loan', 50000.00, 4.0, '2023-02-01', '2028-02-01', 'active'),
(505, 5, 'business loan', 100000.00, 6.0, '2022-09-01', '2027-09-01', 'active');

-- Task 1: Create a VIEW to hide sensitive data
DROP VIEW IF EXISTS CustomerPublicInfo;

CREATE VIEW CustomerPublicInfo AS
SELECT customer_id, name, email
FROM Customers;

-- 2. INTEGRITY CONSTRAINTS ALREADY ADDED IN TABLE CREATION ABOVE

-- Task 3: Create an INDEX on customer_id (used in JOINs)
CREATE INDEX idx_customer_id ON Accounts(customer_id);

-- Task 4: Create and Test a Transaction (ROLLBACK demo)
BEGIN TRANSACTION;

INSERT INTO Customers (customer_id, name, email, phone, address, date_of_birth)
VALUES (6, 'Frank Castle', 'frank@example.com', '555-6789', '303 Pine St, Star City', '1982-07-14');

UPDATE Accounts
SET balance = balance + 5000
WHERE account_id = 1002;

ROLLBACK;
-- COMMIT; -- Uncomment this instead of ROLLBACK to apply changes

-- Task 5: Complex Query (JOIN + SUBQUERY + WHERE)
SELECT c.name, a.account_type, t.amount
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
WHERE t.amount > (
    SELECT AVG(amount)
    FROM Transactions
    WHERE transaction_type = 'deposit'
);