-- 設問1：kiharaefe_step7test データベースを作成
DROP DATABASE IF EXISTS kiharaefe_step7test;
CREATE DATABASE kiharaefe_step7test;
USE kiharaefe_step7test;
-- 設問2：すべてのユーザー情報を取得するSQL
SELECT * FROM users;

-- 設問3：2024年に作成されたユーザーを取得するSQL
SELECT * FROM users WHERE YEAR(created_at) = 2024;

-- 設問4：30歳未満かつ女性のユーザーを取得するSQL
SELECT * FROM users WHERE age < 30 AND gender = '女性';
-- 設問5：ordersとusersを結合し、ユーザー名と注文日を取得
SELECT users.name, orders.order_date
FROM orders
JOIN users ON orders.user_id = users.id;

-- 設問6：order_itemsとproductsを結合し、各明細ごとに商品名、数量、単価、金額（単価×数量）を取得
SELECT 
  products.name AS product_name,
  order_items.quantity,
  products.price AS unit_price,
  order_items.quantity * products.price AS total_price
FROM order_items
JOIN products ON order_items.product_id = products.id;

-- 設問7：注文ごとの注文日と注文数を取得
SELECT 
  orders.order_date,
  COUNT(order_items.id) AS item_count
FROM orders
JOIN order_items ON orders.id = order_items.order_id
GROUP BY orders.id;

-- 設問8：ユーザーの年齢を基準（例：20代など）で集計（例：10代、20代、30代…）
SELECT 
  FLOOR(age / 10) * 10 AS age_group,
  COUNT(*) AS user_count
FROM users
GROUP BY age_group
ORDER BY age_group;

-- 設問9：注文ごとに合計金額を計算（各注文の合計金額）
SELECT 
  orders.id AS order_id,
  SUM(order_items.quantity * products.price) AS total_amount
FROM orders
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
GROUP BY orders.id;

-- 設問10：商品ごとの合計注文数を取得
SELECT 
  products.name AS product_name,
  SUM(order_items.quantity) AS total_quantity
FROM order_items
JOIN products ON order_items.product_id = products.id
GROUP BY products.id;

-- 設問11：注文が1回もないユーザーを取得
SELECT * 
FROM users
WHERE id NOT IN (
  SELECT DISTINCT user_id FROM orders
);

-- 設問12：1回の注文で2種類以上の商品を購入した注文を取得
SELECT order_id
FROM order_items
GROUP BY order_id
HAVING COUNT(DISTINCT product_id) >= 2;

-- 設問13：「テレビ」という商品を注文したすべてのユーザー名を取得
SELECT DISTINCT users.name
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
WHERE products.name LIKE '%テレビ%';

-- 設問14：明細ごとにユーザー名・商品名・数量・合計金額を一覧で取得
SELECT 
  users.name AS user_name,
  products.name AS product_name,
  order_items.quantity,
  (order_items.quantity * products.price) AS total_price
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id;

-- 設問15：最も多く購入された商品（数量ベース）を取得
SELECT 
  products.name,
  SUM(order_items.quantity) AS total_quantity
FROM order_items
JOIN products ON order_items.product_id = products.id
GROUP BY products.id
ORDER BY total_quantity DESC
LIMIT 1;
-- 設問16
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month, COUNT(*) AS order_count
FROM orders
GROUP BY order_month
ORDER BY order_month;
-- 設問17
SELECT *
FROM products
WHERE product_id NOT IN (
  SELECT DISTINCT product_id
  FROM order_items
);
-- 設問18
CREATE INDEX idx_product_id
ON order_items(product_id);
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