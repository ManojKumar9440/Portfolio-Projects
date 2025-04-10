
-- 1. Staff Overview
-- Goal: Understand employee distribution and hierarchy.
-- Queries & Analysis:
-- 1.1 Total number of staff members

SELECT COUNT(*) AS total_staff FROM staff;

-- 1.2 Staff per store

SELECT store_id, COUNT(*) AS staff_count 
FROM staff 
GROUP BY store_id;

-- 1.3 List of managers and their team size

SELECT manager_id, COUNT(*) AS team_size 
FROM staff 
WHERE manager_id IS NOT NULL 
GROUP BY manager_id;

-- 1.4 Inactive staff (if applicable)

SELECT * FROM staff WHERE active = 0;


-- Insights:

-- Understand which store has the most employees.

-- Identify team leaders (managers) and their teams.


-- 2. Inventory Analysis

-- Goal: Evaluate product stock levels by store and product.

-- Queries & Analysis:

-- 2.1 Total quantity of each product across all stores

SELECT product_id, SUM(quantity) AS total_quantity 
FROM stocks 
GROUP BY product_id;

-- 2.2 Stock per store

SELECT store_id, SUM(quantity) AS total_stock 
FROM stocks 
GROUP BY store_id;

-- 2.3 Out-of-stock items

SELECT * FROM stocks WHERE quantity = 0;


-- Insights:

-- Highlight low or out-of-stock products.

-- Stores with high or low stock levels.



---

-- 3. Store Analysis

-- Goal: Understand the location and contact distribution of stores.

-- Queries & Analysis:

-- 3.1 List of all stores with their location

SELECT store_id, store_name, city, state, zip_code FROM stores;

-- 3.2 Stores by state

SELECT state, COUNT(*) AS total_stores 
FROM stores 
GROUP BY state;


-- Insights:

-- Store distribution by geography.

-- Contact details for communication.



---

-- 4. Product & Brand Analysis

-- Goal: Understand product availability and brand popularity.

-- Queries & Analysis:

-- 4.1 Count of products by brand

SELECT brand_id, COUNT(*) AS product_count 
FROM products 
GROUP BY brand_id;

-- 4.2 List brands with product availability

SELECT b.brand_name, COUNT(p.product_id) AS available_products
FROM products p
JOIN brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name;


-- Insights:

-- Most stocked brands.

-- Underrepresented brands that might need promotion or restocking.



---

-- 5. Combined Insights (Advanced)

-- Which store has the highest inventory value?

SELECT s.store_id, s.store_name, SUM(i.quantity * p.list_price) AS inventory_value
FROM stocks i
JOIN products p ON i.product_id = p.product_id
JOIN stores s ON i.store_id = s.store_id
GROUP BY s.store_id, s.store_name
ORDER BY inventory_value DESC;

-- high-value products in stock

SELECT p.product_id, p.product_name, SUM(i.quantity) AS total_quantity, (p.list_price * SUM(i.quantity)) AS total_value
FROM products p
JOIN stocks i ON p.product_id = i.product_id
GROUP BY p.product_id, p.product_name, p.list_price
ORDER BY total_value DESC
LIMIT 5;


-- 1. How many total orders have been placed?

SELECT COUNT(*) AS total_orders FROM orders;

-- Purpose: Get overall order volume to understand business activity.


---

-- 2. What is the total revenue generated?

SELECT ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS total_revenue
FROM order_items;

-- Purpose: Calculate the total revenue from all orders.


---

-- 3. Which store has received the most orders?

SELECT store_id, COUNT(*) AS order_count
FROM orders
GROUP BY store_id
ORDER BY order_count DESC;

-- Purpose: Identify top-performing stores based on number of orders.


---

-- 4. What is the monthly trend of orders?

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, COUNT(*) AS orders_count
FROM orders
GROUP BY month
ORDER BY month;

-- Purpose: Show order trends over time for seasonality or growth analysis.


---

-- 5. What is the average order value?

SELECT ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT order_id, SUM(quantity * list_price * (1 - discount)) AS order_total
    FROM order_items
    GROUP BY order_id
) AS sub;

-- Purpose: Find how much customers spend per order on average.


---

-- 6. Which customer placed the highest number of orders?

SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 1;

-- Purpose: Identify top customers by frequency.


---

-- 7. How many orders are pending/delivered/shipped?

SELECT order_status, COUNT(*) AS count
FROM orders
GROUP BY order_status;

-- Purpose: Monitor order fulfillment status.

---

-- 8. What is the revenue per store?

SELECT o.store_id, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.store_id;

-- Purpose: Compare store performance based on total sales.

select * from orders



