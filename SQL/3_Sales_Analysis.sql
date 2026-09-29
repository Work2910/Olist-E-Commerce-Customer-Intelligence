-- Olist E-Commerce Customer Intelligence
-- Day 3 - sales analysis
-- revenue = price + freight per item (item_revenue, from Day 2)
-- only orders with in_analysis_scope = TRUE are counted

USE olist_ecommerce;


-- 1. headline numbers: total revenue, orders, average order value
SELECT
    ROUND(SUM(oi.item_revenue), 2)                                AS total_revenue,
    COUNT(DISTINCT o.order_id)                                    AS total_orders,
    ROUND(SUM(oi.item_revenue) / COUNT(DISTINCT o.order_id), 2)   AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.in_analysis_scope = TRUE;


-- 2. revenue and orders by month
SELECT
    o.purchase_month,
    COUNT(DISTINCT o.order_id)        AS orders,
    ROUND(SUM(oi.item_revenue), 2)    AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.in_analysis_scope = TRUE
GROUP BY o.purchase_month
ORDER BY o.purchase_month;


-- 3. average order value by month
-- totals worked out per order first, so orders with many items aren't counted twice
WITH order_totals AS (
    SELECT
        o.order_id,
        o.purchase_month,
        SUM(oi.item_revenue) AS order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.in_analysis_scope = TRUE
    GROUP BY o.order_id, o.purchase_month
)
SELECT
    purchase_month,
    ROUND(AVG(order_value), 2) AS avg_order_value
FROM order_totals
GROUP BY purchase_month
ORDER BY purchase_month;


-- 4. revenue by category
SELECT
    p.product_category_name_english   AS category,
    COUNT(*)                          AS items_sold,
    COUNT(DISTINCT o.order_id)        AS orders,
    ROUND(SUM(oi.item_revenue), 2)    AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
WHERE o.in_analysis_scope = TRUE
GROUP BY p.product_category_name_english
ORDER BY revenue DESC;


-- 5. revenue and orders by customer state
SELECT
    c.customer_state                  AS state,
    COUNT(DISTINCT o.order_id)        AS orders,
    ROUND(SUM(oi.item_revenue), 2)    AS revenue
FROM orders o
JOIN customers c    ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.in_analysis_scope = TRUE
GROUP BY c.customer_state
ORDER BY revenue DESC;


-- 6. top 10 products by revenue
SELECT
    oi.product_id,
    p.product_category_name_english   AS category,
    COUNT(*)                          AS items_sold,
    ROUND(SUM(oi.item_revenue), 2)    AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
WHERE o.in_analysis_scope = TRUE
GROUP BY oi.product_id, p.product_category_name_english
ORDER BY revenue DESC
LIMIT 10;


-- 7. top 10 products by quantity sold
SELECT
    oi.product_id,
    p.product_category_name_english   AS category,
    COUNT(*)                          AS items_sold,
    ROUND(SUM(oi.item_revenue), 2)    AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
WHERE o.in_analysis_scope = TRUE
GROUP BY oi.product_id, p.product_category_name_english
ORDER BY items_sold DESC
LIMIT 10;


-- 8. top 10 sellers by revenue
SELECT
    oi.seller_id,
    s.seller_state,
    COUNT(DISTINCT o.order_id)        AS orders,
    ROUND(SUM(oi.item_revenue), 2)    AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN sellers s      ON oi.seller_id = s.seller_id
WHERE o.in_analysis_scope = TRUE
GROUP BY oi.seller_id, s.seller_state
ORDER BY revenue DESC
LIMIT 10;