-- INNER JOIN: Get passengers and their flight details
SELECT p.first_name, p.last_name, f.flight_number, f.departure_city, f.arrival_city, f.departure_time, f.arrival_time
FROM Passengers p
INNER JOIN Tickets t ON p.passenger_id = t.passenger_id
INNER JOIN Flights f ON t.flight_id = f.flight_id;

-- LEFT JOIN: Get all passengers and their flight details (if any)
SELECT p.first_name, p.last_name, f.flight_number, f.departure_city, f.arrival_city, f.departure_time, f.arrival_time
FROM Passengers p
LEFT JOIN Tickets t ON p.passenger_id = t.passenger_id
LEFT JOIN Flights f ON t.flight_id = f.flight_id;

-- UPDATE: Change ticket status for a specific passenger (for example, cancelling a ticket)
UPDATE Tickets
SET ticket_status = 'Cancelled'
WHERE passenger_id = 1 AND ticket_status = 'Booked';

-- DELETE: Remove ticket details for a cancelled booking
DELETE FROM Tickets
WHERE ticket_status = 'Cancelled' AND booking_date < '2024-01-01';

-- Aggregation: Get the number of tickets booked by each passenger, filtering out those with fewer than 2 tickets
SELECT p.first_name, p.last_name, COUNT(t.ticket_id) AS total_tickets
FROM Passengers p
LEFT JOIN Tickets t ON p.passenger_id = t.passenger_id
GROUP BY p.passenger_id
HAVING COUNT(t.ticket_id) >= 2;

-- Subquery: Find passengers who spent more than the average payment amount
SELECT p.first_name, p.last_name
FROM Passengers p
WHERE p.passenger_id IN (
    SELECT t.passenger_id
    FROM Payments pay
    JOIN Tickets t ON pay.ticket_id = t.ticket_id
    GROUP BY t.passenger_id
    HAVING SUM(pay.payment_amount) > (SELECT AVG(payment_amount) FROM Payments)
);
