

SELECT
    o.order_id,
    o.total_price,
    o.ordered_at,
    o.status
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
WHERE u.user_id = 2; 


SELECT
    product_id,
    product_name,
    price
FROM Products
WHERE price = (SELECT MAX(price) FROM Products);


SELECT
    u.user_id,
    u.name,
    u.email,
    SUM(o.total_price) AS total_spent
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name, u.email
HAVING SUM(o.total_price) > 40.00;



 SELECT p.product_id, p.product_name, p.price
 FROM Products p
 LEFT JOIN hasorderitems ho ON p.product_id = ho.product_id
 WHERE ho.order_id IS NULL;


SELECT
    AVG(rating) AS average_order_rating
FROM givesfeedback;


SELECT
    p.product_name,
    ho.quantity,
    ho.price AS price_at_order_time
FROM hasorderitems ho
JOIN Products p ON ho.product_id = p.product_id
WHERE ho.order_id = 1; 


SELECT DISTINCT
    c.category_id,
    c.category_name
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
WHERE p.price > 45.00;


SELECT
    u.user_id,
    u.name,
    u.email,
    o.order_id,
    o.ordered_at,
    o.status
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
WHERE o.ordered_at >= (CURRENT_TIMESTAMP - INTERVAL '30 days')
  AND o.status = 'Pending';


SELECT
    c.category_name,
    COUNT(p.product_id) AS number_of_products
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY c.category_name;


SELECT
    u.user_id,
    u.name,
    u.email
FROM Users u
WHERE u.user_id IN (SELECT DISTINCT user_id FROM Cart);


SELECT 
    c.category_name,
    MAX(p.price) AS max_price_in_category
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name;

--Report

SELECT
    u.user_id,
    u.name,
    u.email,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_price), 0.00) AS total_spent
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name, u.email
ORDER BY total_spent DESC, u.name;


SELECT
    c.category_name,
    p.product_id,
    p.product_name,
    p.quantity AS stock_quantity,
    p.price
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;


SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.quantity AS current_stock
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE p.quantity < 30 
ORDER BY p.quantity ASC, c.category_name;


SELECT
    o.order_id,
    o.ordered_at,
    u.name AS customer_name,
    o.total_price,
    o.status
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
ORDER BY o.ordered_at DESC
LIMIT 50;


SELECT
    c.category_name,
    SUM(ho.quantity) AS total_quantity_sold,
    SUM(ho.quantity * ho.price) AS total_revenue
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN hasorderitems ho ON p.product_id = ho.product_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;


