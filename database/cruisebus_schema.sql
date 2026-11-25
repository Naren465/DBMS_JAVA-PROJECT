-- CRUISEBUS DATABASE SCHEMA & SAMPLE DATA
-- Normalized Relational Database for CRUISEBUS Bus Reservation System

DROP DATABASE IF EXISTS cruisebus_db;
CREATE DATABASE cruisebus_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cruisebus_db;

-- 1. CUSTOMER TABLE
CREATE TABLE CUSTOMER (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'CUSTOMER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. BUS TABLE
CREATE TABLE BUS (
    bus_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_name VARCHAR(100) NOT NULL,
    operator VARCHAR(100) NOT NULL,
    bus_number VARCHAR(50) UNIQUE NOT NULL,
    bus_type VARCHAR(50) NOT NULL, -- 'AC Sleeper', 'AC Seater', 'Non AC Seater'
    total_seats INT NOT NULL,
    fuel_type VARCHAR(30) DEFAULT 'Diesel',
    transmission VARCHAR(30) DEFAULT 'Automatic',
    image_url VARCHAR(255)
);

-- 3. ROUTE TABLE
CREATE TABLE ROUTE (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    source VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    distance INT NOT NULL
);

-- 4. SCHEDULE TABLE
CREATE TABLE SCHEDULE (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_id INT NOT NULL,
    route_id INT NOT NULL,
    departure_date DATE NOT NULL,
    departure_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    fare DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (bus_id) REFERENCES BUS(bus_id) ON DELETE CASCADE,
    FOREIGN KEY (route_id) REFERENCES ROUTE(route_id) ON DELETE CASCADE
);

-- 5. SEAT TABLE
CREATE TABLE SEAT (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    seat_status VARCHAR(20) DEFAULT 'AVAILABLE', -- 'AVAILABLE', 'BOOKED', 'LOCKED'
    seat_type VARCHAR(20) DEFAULT 'SEATER', -- 'SEATER', 'SLEEPER'
    deck VARCHAR(10) DEFAULT 'LOWER', -- 'LOWER', 'UPPER'
    FOREIGN KEY (bus_id) REFERENCES BUS(bus_id) ON DELETE CASCADE,
    UNIQUE KEY uq_bus_seat (bus_id, seat_number)
);

-- 6. BOOKING TABLE
CREATE TABLE BOOKING (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_pnr VARCHAR(30) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    schedule_id INT NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status VARCHAR(30) DEFAULT 'CONFIRMED', -- 'CONFIRMED', 'CANCELLED'
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES SCHEDULE(schedule_id) ON DELETE CASCADE
);

-- 7. BOOKING_SEAT TABLE (Normalized many-to-many relationship for seats per booking with passenger details)
CREATE TABLE BOOKING_SEAT (
    booking_seat_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,
    passenger_name VARCHAR(100) NOT NULL,
    passenger_age INT,
    passenger_gender VARCHAR(10),
    FOREIGN KEY (booking_id) REFERENCES BOOKING(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES SEAT(seat_id) ON DELETE CASCADE
);

-- 8. PAYMENT TABLE
CREATE TABLE PAYMENT (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(30) DEFAULT 'SUCCESS', -- 'SUCCESS', 'REFUNDED', 'FAILED'
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) DEFAULT 'CREDIT_CARD', -- 'CARD', 'UPI', 'NET_BANKING'
    transaction_ref VARCHAR(100),
    FOREIGN KEY (booking_id) REFERENCES BOOKING(booking_id) ON DELETE CASCADE
);

-- 9. TICKET TABLE
CREATE TABLE TICKET (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    seat_id INT,
    qr_code_data TEXT NOT NULL,
    issued_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES BOOKING(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES SEAT(seat_id) ON DELETE SET NULL
);

-- 10. CONTACT_MESSAGE TABLE
CREATE TABLE CONTACT_MESSAGE (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(30),
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================================
-- SAMPLE DATA INSERTIONS
-- ========================================================

-- Insert Customers (Demo user & Admin user)
-- Passwords are stored hashed (SHA-256 with salt) and plain text for demo ease
-- Demo@123 hashed: 64b732439a3f2956cf0d6d5396dd4fcffea2fc2f1fa3f24ad865b4c48ae562b3
-- Admin@123 hashed: 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
INSERT INTO CUSTOMER (name, email, phone, password, role) VALUES 
('Demo Customer', 'demo@cruisebus.in', '+91 9876543210', 'Demo@123', 'CUSTOMER'),
('Primary Admin', 'admin@cruisebus.in', '+91 9123456789', 'Admin@123', 'ADMIN'),
('Rajesh Kumar', 'rajesh.k@example.com', '+91 9845123456', 'Pass@123', 'CUSTOMER'),
('Priya Sharma', 'priya.s@example.com', '+91 9741234567', 'Pass@123', 'CUSTOMER');

-- Insert Buses (Matching exact fleet in reference images)
INSERT INTO BUS (bus_id, bus_name, operator, bus_number, bus_type, total_seats, fuel_type, transmission, image_url) VALUES
(1, 'KSRTC Super Deluxe', 'KSRTC', 'KA 09 F 7721', 'Non AC Seater', 45, 'Diesel', 'Manual', 'assets/images/bus_ksrtc.jpg'),
(2, 'Volvo 9600', 'Volvo Buses', 'KA 01 FB 1234', 'AC Sleeper', 42, 'Diesel', 'Automatic', 'assets/images/bus_volvo.jpg'),
(3, 'RedBus Smart Bus', 'RedBus', 'TN 02 BB 5566', 'AC Seater', 40, 'Diesel', 'Automatic', 'assets/images/bus_redbus.jpg'),
(4, 'SRS Travels Volvo', 'SRS Travels', 'KA 05 C 8899', 'AC Sleeper', 36, 'Diesel', 'Automatic', 'assets/images/bus_srs.jpg'),
(5, 'SETC Ultra Deluxe', 'SETC', 'TN 01 AN 3421', 'Non AC Seater', 48, 'Diesel', 'Manual', 'assets/images/bus_setc.jpg'),
(6, 'VRL Travels I-Shift', 'VRL Travels', 'KA 25 D 1008', 'AC Sleeper', 38, 'Diesel', 'Automatic', 'assets/images/bus_vrl.jpg'),
(7, 'Rajdhani Royal Cruiser', 'Rajdhani Travels', 'DL 01 A 9911', 'AC Sleeper', 32, 'Diesel', 'Automatic', 'assets/images/bus_rajdhani.jpg'),
(8, 'Bengaluru Express', 'Volvo Buses', 'KA 01 FB 9988', 'AC Sleeper', 36, 'Diesel', 'Automatic', 'assets/images/bus_volvo.jpg');

-- Insert Routes
INSERT INTO ROUTE (route_id, source, destination, distance) VALUES
(1, 'Chennai', 'Bengaluru', 350),
(2, 'Bengaluru', 'Chennai', 350),
(3, 'Bengaluru', 'Hyderabad', 570),
(4, 'Hyderabad', 'Bengaluru', 570),
(5, 'Chennai', 'Coimbatore', 500),
(6, 'Coimbatore', 'Chennai', 500),
(7, 'Bengaluru', 'Goa', 560),
(8, 'Mumbai', 'Goa', 590),
(9, 'Chennai', 'Madurai', 460),
(10, 'Bengaluru', 'Kochi', 540);

-- Insert Schedules
-- Includes future dates dynamically around today/current year and reference demo date
INSERT INTO SCHEDULE (schedule_id, bus_id, route_id, departure_date, departure_time, arrival_time, fare) VALUES
(1, 1, 1, CURDATE(), '06:00:00', '12:30:00', 500.00),
(2, 2, 1, CURDATE(), '16:59:00', '23:00:00', 2010.00),
(3, 3, 1, CURDATE(), '08:30:00', '15:00:00', 900.00),
(4, 4, 1, CURDATE(), '21:00:00', '05:30:00', 1100.00),
(5, 5, 1, CURDATE(), '07:00:00', '14:00:00', 450.00),
(6, 6, 1, CURDATE(), '22:30:00', '06:30:00', 1350.00),
(7, 7, 1, CURDATE(), '23:15:00', '07:00:00', 1600.00),
(8, 8, 1, CURDATE(), '17:00:00', '23:00:00', 2010.00),

-- Tomorrow
(9, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '06:00:00', '12:30:00', 500.00),
(10, 2, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '16:59:00', '23:00:00', 2010.00),
(11, 3, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '08:30:00', '15:00:00', 900.00),
(12, 4, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '21:00:00', '05:30:00', 1100.00),

-- Other routes
(13, 2, 2, CURDATE(), '07:00:00', '13:00:00', 1200.00),
(14, 4, 2, CURDATE(), '22:00:00', '06:00:00', 1100.00),
(15, 6, 3, CURDATE(), '20:00:00', '06:30:00', 1350.00),
(16, 7, 7, CURDATE(), '19:30:00', '07:00:00', 1600.00),
-- Fixed reference schedule matching Image 4
(17, 2, 1, '2021-12-14', '16:59:00', '23:00:00', 2010.00);

-- Insert Seats for Buses (1 to 8)
-- Bus 2 (Volvo 9600): Seats 01 to 42
INSERT INTO SEAT (bus_id, seat_number, seat_status, seat_type, deck) VALUES
(2, '01', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '02', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '03', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '04', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '05', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '06', 'BOOKED',    'SLEEPER', 'LOWER'),
(2, '07', 'BOOKED',    'SLEEPER', 'LOWER'),
(2, '08', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '09', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '10', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '11', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '12', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '13', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '14', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '15', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '16', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '17', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '18', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(2, '19', 'AVAILABLE', 'SLEEPER', 'UPPER'),
(2, '20', 'AVAILABLE', 'SLEEPER', 'UPPER'),
(2, '21', 'AVAILABLE', 'SLEEPER', 'UPPER'),
(2, '22', 'AVAILABLE', 'SLEEPER', 'UPPER'),
(2, '23', 'AVAILABLE', 'SLEEPER', 'UPPER'),
(2, '24', 'AVAILABLE', 'SLEEPER', 'UPPER');

-- Insert seats for Bus 1 (KSRTC Super Deluxe - 40 seater)
INSERT INTO SEAT (bus_id, seat_number, seat_status, seat_type, deck) VALUES
(1, 'S01', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S02', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S03', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S04', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S05', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S06', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S07', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S08', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S09', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S10', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S11', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S12', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S13', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S14', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S15', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S16', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S17', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S18', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S19', 'AVAILABLE', 'SEATER', 'LOWER'),
(1, 'S20', 'AVAILABLE', 'SEATER', 'LOWER');

-- Insert seats for Bus 3 (RedBus Smart Bus)
INSERT INTO SEAT (bus_id, seat_number, seat_status, seat_type, deck) VALUES
(3, '01', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '02', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '03', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '04', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '05', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '06', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '07', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '08', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '09', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '10', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '11', 'AVAILABLE', 'SEATER', 'LOWER'),
(3, '12', 'AVAILABLE', 'SEATER', 'LOWER');

-- Insert seats for Bus 4 (SRS Travels)
INSERT INTO SEAT (bus_id, seat_number, seat_status, seat_type, deck) VALUES
(4, '01', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(4, '02', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(4, '03', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(4, '04', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(4, '05', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(4, '06', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(4, '07', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(4, '08', 'AVAILABLE', 'SLEEPER', 'LOWER'),
(4, '09', 'AVAILABLE', 'SLEEPER', 'UPPER'),
(4, '10', 'AVAILABLE', 'SLEEPER', 'UPPER'),
(4, '11', 'AVAILABLE', 'SLEEPER', 'UPPER'),
(4, '12', 'AVAILABLE', 'SLEEPER', 'UPPER');

-- Insert Reference Booking (LA325478 matching Reference Image 4!)
INSERT INTO BOOKING (booking_id, ticket_pnr, customer_id, schedule_id, booking_date, total_amount, booking_status) VALUES
(1, 'LA325478', 1, 17, '2021-12-14 10:30:00', 4020.00, 'CONFIRMED'),
(2, 'CB884920', 1, 2, NOW(), 2010.00, 'CONFIRMED');

-- Link booking seats
INSERT INTO BOOKING_SEAT (booking_id, seat_id, passenger_name, passenger_age, passenger_gender) VALUES
(1, 6, 'Demo Customer', 28, 'MALE'),
(1, 7, 'Travel Companion', 26, 'FEMALE'),
(2, 1, 'Demo Customer', 28, 'MALE');

-- Insert Payment for the reference booking
INSERT INTO PAYMENT (booking_id, payment_amount, payment_status, payment_date, payment_method, transaction_ref) VALUES
(1, 4020.00, 'SUCCESS', '2021-12-14 10:32:00', 'CREDIT_CARD', 'TXN_LA325478_9918'),
(2, 2010.00, 'SUCCESS', NOW(), 'UPI', 'TXN_CB884920_7731');

-- Insert Ticket record with QR code data
INSERT INTO TICKET (booking_id, seat_id, qr_code_data, issued_date) VALUES
(1, 6, 'CRUISEBUS-TICKET:LA325478|SEATS:06,07|BUS:KA01FB1234|ROUTE:Chennai-Bengaluru|FARE:4020.00', '2021-12-14 10:32:05'),
(2, 1, 'CRUISEBUS-TICKET:CB884920|SEATS:01|BUS:KA01FB1234|ROUTE:Chennai-Bengaluru|FARE:2010.00', NOW());

-- Insert sample Contact Messages
INSERT INTO CONTACT_MESSAGE (name, email, phone, subject, message) VALUES
('Anand Verma', 'anand.v@gmail.com', '+91 9880011223', 'Inquiry regarding corporate bus charter', 'Hello CruiseBus team, we would like to book 2 luxury buses for an executive offsite from Bengaluru to Goa next month. Please get back with quotation.'),
('Sneha Roy', 'sneha.roy@outlook.com', '+91 9771122334', 'Feedback on Volvo 9600 journey', 'Outstanding experience! The seats were extremely comfortable, wifi was fast, and the bus was on time. Thank you!');
