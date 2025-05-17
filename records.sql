-- We have used dummy data for the records.sql file to populate the database with sample data.
-- This file is used to insert sample data into the database tables. 
-- We will use more data in the future while working on the project.

-- 1. Populate Categories Table
INSERT INTO Categories (category_name) VALUES
('Frozen Food'), -- category_id 1
('Snacks'),      -- category_id 2
('Electronics'), -- category_id 3
('Beverages'),   -- category_id 4
('Stationery');  -- category_id 5

-- 2. Populate Users Table
INSERT INTO Users (name, email, password) VALUES
('Alice Smith', 'alice.s@example.com', 'pass123'),
('Bob Johnson', 'b.johnson@example.net', 'pass456'),
('Charlie Brown', 'charlie@example.org', 'pass789'),
('Diana Prince', 'diana.p@email.com', 'wonderpw'),
('Ethan Hunt', 'ethan.h@mail.net', 'mission'),
('Fiona Glenanne', 'fiona.g@email.org', 'burnnotice'),
('George Costanza', 'george.c@example.com', 'serenity'),
('Hannah Abbott', 'hannah.a@example.net', 'hufflepuff'),
('Ian Malcolm', 'ian.m@email.com', 'chaos'),
('Jane Doe', 'jane.d@mail.org', 'unknown'),
('Kyle Broflovski', 'kyle.b@example.com', 'southpark'),
('Laura Palmer', 'laura.p@example.net', 'twinpeaks'),
('Michael Scott', 'michael.s@email.com', 'dunder'),
('Nora Durst', 'nora.d@mail.org', 'leftovers'),
('Oscar Martinez', 'oscar.m@example.com', 'accountant'); -- user_id 1 to 15

-- 3. Populate Products Table
INSERT INTO Products (product_name, price, quantity, category_id) VALUES
-- Frozen Food (Cat 1)
('Frozen Pizza - Pepperoni', 7.99, 50, 1),
('Frozen Peas Bag', 2.49, 100, 1),
('Ice Cream Tub - Vanilla', 5.50, 40, 1),
('Frozen Chicken Nuggets', 8.99, 60, 1),
('Waffles - Box of 8', 3.99, 75, 1),
-- Snacks (Cat 2)
('Potato Chips - Salted', 3.29, 120, 2),
('Chocolate Bar - Dark', 1.99, 200, 2),
('Pretzels Bag', 2.99, 80, 2),
('Trail Mix - Nuts & Fruit', 4.50, 90, 2),
('Cookies - Chocolate Chip', 3.79, 110, 2),
-- Electronics (Cat 3)
('Wireless Mouse', 25.99, 30, 3),
('USB-C Cable 1m', 12.50, 70, 3),
('Bluetooth Headphones', 79.99, 25, 3),
('Smartphone Screen Protector', 15.00, 50, 3),
('Portable Power Bank 10000mAh', 35.50, 40, 3),
('Webcam HD 1080p', 49.99, 35, 3),
('Laptop Stand - Aluminum', 29.99, 45, 3),
-- Beverages (Cat 4)
('Cola Can 12-Pack', 6.99, 80, 4),
('Orange Juice 1L', 3.49, 60, 4),
('Bottled Water 24-Pack', 4.99, 100, 4),
('Green Tea Bags - 20 Count', 2.99, 150, 4),
('Coffee Beans - 1kg Bag', 14.99, 50, 4),
-- Stationery (Cat 5)
('Notebook - Lined A5', 2.50, 150, 5),
('Ballpoint Pens - Pack of 10', 4.99, 200, 5),
('Highlighters - Set of 4', 3.99, 120, 5),
('Sticky Notes Pad', 1.50, 300, 5),
('Stapler - Standard', 8.99, 60, 5),
('Paper Clips - Box of 100', 1.20, 250, 5),
('Binder - 1 inch', 3.50, 100, 5),
('Scissors - Office', 5.50, 90, 5); -- product_id 1 to 30

-- 4. Populate Cart Table
INSERT INTO Cart (user_id) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (13), (15);
-- cart_id 1 to 13

-- 5. Populate Cart_Items Table
INSERT INTO Cart_Items (cart_id, product_id, quantity) VALUES
(1, 6, 2),
(1, 18, 1),
(2, 11, 1),
(2, 12, 2),
(4, 13, 1),
(4, 15, 1),
(4, 23, 3),
(5, 1, 1),
(5, 19, 1),
(7, 24, 5),
(7, 26, 2),
(10, 8, 1);

-- 6 & 7. Populate Orders and hasorderitems Tables
-- Order 1
INSERT INTO Orders (user_id, cart_id, total_price, ordered_at, status) VALUES
(2, 2, 51.99, '2025-04-10 10:30:00', 'Completed'); -- order_id 1
INSERT INTO hasorderitems (order_id, product_id, quantity, price) VALUES
(1, 11, 1, 25.99),
(1, 12, 2, 12.50);
-- Order 2
INSERT INTO Orders (user_id, cart_id, total_price, ordered_at, status) VALUES
(1, 1, 19.48, '2025-04-15 14:00:00', 'Shipped'); -- order_id 2
INSERT INTO hasorderitems (order_id, product_id, quantity, price) VALUES
(2, 7, 1, 1.99),
(2, 21, 1, 14.99),
(2, 23, 1, 2.50);
-- Order 3
INSERT INTO Orders (user_id, cart_id, total_price, ordered_at, status) VALUES
(5, 5, 11.48, '2025-04-20 09:15:00', 'Completed'); -- order_id 3
INSERT INTO hasorderitems (order_id, product_id, quantity, price) VALUES
(3, 1, 1, 7.99),
(3, 19, 1, 3.49);
-- Order 4
INSERT INTO Orders (user_id, cart_id, total_price, ordered_at, status) VALUES
(4, 4, 79.99, '2025-04-25 11:00:00', 'Completed'); -- order_id 4
INSERT INTO hasorderitems (order_id, product_id, quantity, price) VALUES
(4, 13, 1, 79.99);
-- Order 5
INSERT INTO Orders (user_id, cart_id, total_price, ordered_at, status) VALUES
(7, 7, 7.99, '2025-05-01 16:45:00', 'Pending'); -- order_id 5
INSERT INTO hasorderitems (order_id, product_id, quantity, price) VALUES
(5, 24, 1, 4.99),
(5, 26, 2, 1.50);
-- Order 6
INSERT INTO Orders (user_id, cart_id, total_price, ordered_at, status) VALUES
(1, 3, 8.97, '2025-05-02 10:00:00', 'Completed'); -- order_id 6
INSERT INTO hasorderitems (order_id, product_id, quantity, price) VALUES
(6, 2, 2, 2.49),
(6, 25, 1, 3.99);
-- Order 7
INSERT INTO Orders (user_id, cart_id, total_price, ordered_at, status) VALUES
(13, 12, 35.50, '2025-05-03 12:00:00', 'Shipped'); -- order_id 7
INSERT INTO hasorderitems (order_id, product_id, quantity, price) VALUES
(7, 15, 1, 35.50);
-- Order 8
INSERT INTO Orders (user_id, cart_id, total_price, ordered_at, status) VALUES
(14, 10, 49.99, '2025-05-04 08:30:00', 'Pending'); -- order_id 8
INSERT INTO hasorderitems (order_id, product_id, quantity, price) VALUES
(8, 16, 1, 49.99);
-- Order 9
INSERT INTO Orders (user_id, cart_id, total_price, ordered_at, status) VALUES
(9, 9, 2.49, '2025-05-04 15:00:00', 'Completed'); -- order_id 9
INSERT INTO hasorderitems (order_id, product_id, quantity, price) VALUES
(9, 2, 1, 2.49);
-- Order 10
INSERT INTO Orders (user_id, cart_id, total_price, ordered_at, status) VALUES
(6, 6, 12.98, '2025-05-05 09:00:00', 'Completed'); -- order_id 10
INSERT INTO hasorderitems (order_id, product_id, quantity, price) VALUES
(10, 4, 1, 8.99),
(10, 5, 1, 3.99);

-- 8. Populate givesfeedback Table
INSERT INTO givesfeedback (user_id, order_id, comment, rating) VALUES
(2, 1, 'Great products, fast delivery!', 5),
(1, 2, 'Coffee beans were excellent.', 4),
(5, 3, 'Pizza was okay, juice was good.', 3),
(4, 4, 'Headphones work perfectly.', 5),
(1, 6, 'Good value for the price.', 4),
(9, 9, 'Just needed peas, got peas.', 5);

COMMIT; -- Commit all inserts
