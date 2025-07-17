-- 設問1
DROP DATABASE IF EXISTS kiharaefe_step7test;
CREATE DATABASE kiharaefe_step7test;
USE kiharaefe_step7test;
-- 設問2
SELECT * FROM users;

-- 設問3
SELECT * 
FROM users 
WHERE age < 30 AND gender = 'female';

-- 設問4
SELECT name, price FROM products;

-- 設問5
SELECT users.name, orders.order_date
FROM orders
JOIN users ON orders.user_id = users.id;

-- 設問6
SELECT 
  products.name AS product_name,
  order_items.quantity,
  products.price AS unit_price,
  order_items.quantity * products.price AS total_price
FROM order_items
JOIN products ON order_items.product_id = products.id;

-- 設問7
SELECT 
  users.id AS user_id,
  users.name,
  COUNT(orders.id) AS order_count
FROM users
JOIN orders ON users.id = orders.user_id
GROUP BY users.id, users.name;

-- 設問8
SELECT 
  users.id AS user_id,
  users.name,
  SUM(order_items.quantity * products.price) AS total_spent
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
GROUP BY users.id, users.name;

-- 設問9
SELECT 
  users.name,
  SUM(order_items.quantity * products.price) AS total_spent
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
GROUP BY users.id, users.name
ORDER BY total_spent DESC LIMIT 1;

-- 設問10
SELECT 
  products.name AS product_name,
  SUM(order_items.quantity) AS total_quantity
FROM order_items
JOIN products ON order_items.product_id = products.id
GROUP BY products.id;

-- 設問11
SELECT * 
FROM users
WHERE id NOT IN (
  SELECT DISTINCT user_id FROM orders
);

-- 設問12
SELECT order_id
FROM order_items
GROUP BY order_id
HAVING COUNT(DISTINCT product_id) >= 2;

-- 設問13
SELECT DISTINCT users.name
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
WHERE products.name LIKE '%テレビ%';

-- 設問14
SELECT 
  users.name AS user_name,
  products.name AS product_name,
  order_items.quantity,
  (order_items.quantity * products.price) AS total_price
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id;

-- 設問15
SELECT 
  products.name,
  orders.order_date,
  SUM(order_items.quantity) AS total_quantity
FROM order_items
JOIN products ON order_items.product_id = products.id
JOIN orders ON order_items.order_id = orders.id
GROUP BY products.id, products.name, orders.order_date
ORDER BY total_quantity DESC
LIMIT 1;

-- 設問16
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month, COUNT(*) AS order_count
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- 設問17
SELECT 
  products.id, 
  products.name
FROM products
LEFT JOIN order_items ON products.id = order_items.product_id
WHERE order_items.product_id IS NULL;

-- 設問18
SELECT 
  order_id
FROM order_items
GROUP BY order_id
HAVING COUNT(DISTINCT product_id) >= 2;

-- 設問19
SELECT u.user_id, u.name, AVG(p.price * oi.quantity) AS avg_order_price
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY u.user_id, u.name;
-- 設問20
SELECT o.*
FROM orders o
INNER JOIN (
  SELECT user_id, MAX(order_date) AS latest_date
  FROM orders
  GROUP BY user_id
) latest ON o.user_id = latest.user_id AND o.order_date = latest.latest_date;
-- 設問21
INSERT INTO users (name, age, gender, created_at)
VALUES ('中村愛', 25, '女性', '2025-06-01');
-- 設問22
INSERT INTO products (name, price)
VALUES ('エアコン', 60000);
--設問23
INSERT INTO orders (order_id, user_id, order_date)
VALUES (10, 1, '2025-06-10');
--設問24
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (10, 6, 1);
--設問25
UPDATE users
SET age = 24
WHERE user_id = 1 AND age = 23;
--設問26
UPDATE products
SET price = price * 1.1;
--設問27
UPDATE orders
SET order_date = '2024-05-01'
WHERE order_date < '2024-05-01';
--設問28
DELETE FROM users
WHERE name = '高橋健一';
--設問29
DELETE FROM order_items
WHERE order_id = 5;
--設問30
DELETE FROM products
WHERE product_id NOT IN (
  SELECT DISTINCT product_id FROM order_items
);