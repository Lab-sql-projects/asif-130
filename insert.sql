-- Inserting sample passengers
INSERT INTO Passengers (first_name, last_name, date_of_birth, passport_number, email, phone_number, address) VALUES
('John', 'Doe', '1985-05-15', 'P123456789', 'john.doe@example.com', '123-456-7890', '123 Elm St, Springfield'),
('Jane', 'Smith', '1990-08-22', 'P987654321', 'jane.smith@example.com', '234-567-8901', '456 Oak St, Springfield'),
('Mark', 'Johnson', '1982-02-10', 'P112233445', 'mark.johnson@example.com', '345-678-9012', '789 Pine St, Springfield');

-- Inserting sample flight details
INSERT INTO Flights (flight_number, departure_city, arrival_city, departure_time, arrival_time, airline, price) VALUES
('AA123', 'New York', 'London', '2025-05-01 08:00:00', '2025-05-01 18:00:00', 'American Airlines', 500.00),
('BA456', 'London', 'Paris', '2025-06-10 09:00:00', '2025-06-10 11:00:00', 'British Airways', 200.00),
('AF789', 'Paris', 'New York', '2025-07-15 15:00:00', '2025-07-15 17:00:00', 'Air France', 450.00);

-- Inserting sample tickets
INSERT INTO Tickets (passenger_id, flight_id, ticket_type, seat_number, ticket_status, booking_date) VALUES
(1, 1, 'Economy', 'A1', 'Booked', '2025-04-01 10:00:00'),
(2, 2, 'Business', 'B2', 'Booked', '2025-04-02 11:00:00'),
(3, 3, 'First Class', 'C3', 'Booked', '2025-04-03 12:00:00');

-- Inserting sample payment details
INSERT INTO Payments (ticket_id, payment_amount, payment_method, payment_date, payment_status) VALUES
(1, 500.00, 'Credit Card', '2025-04-01 12:00:00', 'Completed'),
(2, 200.00, 'PayPal', '2025-04-02 13:00:00', 'Completed'),
(3, 450.00, 'Credit Card', '2025-04-03 14:00:00', 'Pending');
