-- sales_trend_sqlite.sql
-- Purpose: Task 6 - Sales Trend Analysis Using Aggregations (SQLite version)
-- Contains: schema, sample data, analysis queries

-- 1) Create table (SQLite)
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id   INTEGER PRIMARY KEY,
    order_date TEXT NOT NULL,     -- store dates as ISO strings 'YYYY-MM-DD' for SQLite
    amount     REAL,              -- revenue per order; can be NULL in real data
    product_id INTEGER
);

-- 2) Sample data (feel free to replace with your real data)
INSERT INTO orders (order_id, order_date, amount, product_id) VALUES
(1,  '2024-01-05', 500.00, 101),
(2,  '2024-01-18', 300.00, 102),
(3,  '2024-01-22', 450.00, 103),
(4,  '2024-02-03', 700.00, 101),
(5,  '2024-02-11', 200.00, 106),
(6,  '2024-02-27', 150.00, 102),
(7,  '2024-03-02', 1000.00, 105),
(8,  '2024-03-10', 1500.00, 106),
(9,  '2024-03-28', 250.00, 107),
(10, '2024-04-04', 1200.00, 101),
(11, '2024-04-15', 350.00, 103),
(12, '2024-05-06', 950.00, 104),
(13, '2024-05-16', 1250.00, 104),
(14, '2024-05-22', 400.00, 108),
(15, '2024-06-01', 800.00, 101),
(16, '2024-06-09', 600.00, 105),
(17, '2024-06-18', 300.00, 106),
(18, '2024-06-25', 150.00, 107);

-- 3) Core analysis: monthly revenue + order volume
--    SQLite uses strftime('%Y', date) and strftime('%m', date) to extract year and month.
SELECT
    strftime('%Y', order_date) AS year,
    strftime('%m', order_date) AS month,
    SUM(COALESCE(amount, 0))   AS monthly_revenue,
    COUNT(DISTINCT order_id)   AS order_volume
FROM orders
GROUP BY year, month
ORDER BY year ASC, month ASC;

-- 4) Same as above but with a single "year_month" column (YYYY-MM)
SELECT
    strftime('%Y-%m', order_date) AS year_month,
    SUM(COALESCE(amount, 0))      AS monthly_revenue,
    COUNT(DISTINCT order_id)      AS order_volume
FROM orders
GROUP BY year_month
ORDER BY year_month;

-- 5) Filter for a specific period (example: Jan to Apr 2024)
SELECT
    strftime('%Y-%m', order_date) AS year_month,
    SUM(COALESCE(amount, 0))      AS monthly_revenue,
    COUNT(DISTINCT order_id)      AS order_volume
FROM orders
WHERE date(order_date) BETWEEN date('2024-01-01') AND date('2024-04-30')
GROUP BY year_month
ORDER BY year_month;

-- 6) Top 3 months by revenue (descending)
SELECT
    strftime('%Y-%m', order_date) AS year_month,
    SUM(COALESCE(amount, 0))      AS monthly_revenue,
    COUNT(DISTINCT order_id)      AS order_volume
FROM orders
GROUP BY year_month
ORDER BY monthly_revenue DESC
LIMIT 3;

-- 7) COUNT(*) vs COUNT(DISTINCT ...): Example
--    COUNT(*) counts rows; COUNT(DISTINCT order_id) counts unique order ids.
SELECT
    strftime('%Y-%m', order_date) AS year_month,
    COUNT(*)                      AS row_count,
    COUNT(DISTINCT order_id)      AS distinct_orders
FROM orders
GROUP BY year_month
ORDER BY year_month;

-- 8) NULL handling example: Aggregates ignore NULLs, but be explicit with COALESCE if needed
--    This query shows that using COALESCE(amount, 0) makes the intent clear.
SELECT
    strftime('%Y-%m', order_date) AS year_month,
    SUM(COALESCE(amount, 0))      AS monthly_revenue_coalesced
FROM orders
GROUP BY year_month
ORDER BY year_month;