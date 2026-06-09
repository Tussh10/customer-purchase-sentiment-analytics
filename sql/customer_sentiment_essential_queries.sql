-- =====================================================
-- Customer Purchase Behavior & Sentiment Analysis
-- SQL Part: MySQL Workbench
-- =====================================================



-- 1. Create and use project database

CREATE DATABASE IF NOT EXISTS ecommerce_sentiment_analytics;
USE ecommerce_sentiment_analytics;





-- 2. Drop old views and tables if this script is re-run

DROP VIEW IF EXISTS vw_product_risk_analysis;
DROP VIEW IF EXISTS vw_customer_segments;
DROP VIEW IF EXISTS vw_sentiment_distribution;
DROP VIEW IF EXISTS vw_product_performance;
DROP VIEW IF EXISTS vw_monthly_revenue;
DROP VIEW IF EXISTS vw_executive_kpis;

DROP TABLE IF EXISTS customer_reviews_sentiment;
DROP TABLE IF EXISTS customer_purchases_cleaned;





-- 3. Create final cleaned purchase table
-- This table stores cleaned_purchase_data.csv exported from Python.

CREATE TABLE customer_purchases_cleaned (
    transaction_id VARCHAR(100) PRIMARY KEY,
    customer_id VARCHAR(100),
    customer_name VARCHAR(255),
    product_id VARCHAR(100),
    product_name VARCHAR(255),
    product_category VARCHAR(150),
    purchase_quantity INT,
    purchase_price DECIMAL(10,2),
    revenue DECIMAL(12,2),
    purchase_date DATE,
    purchase_year INT,
    purchase_month VARCHAR(20),
    purchase_month_name VARCHAR(20),
    country VARCHAR(100)
);







-- 4. Create final review sentiment table
-- This table stores cleaned_reviews_with_sentiment.csv exported from Python.

CREATE TABLE customer_reviews_sentiment (
    review_id VARCHAR(100) PRIMARY KEY,
    customer_id VARCHAR(100),
    product_id VARCHAR(100),
    review_text TEXT,
    clean_review_text TEXT,
    review_length INT,
    review_date DATE,
    review_year INT,
    review_month VARCHAR(20),
    sentiment_score DECIMAL(8,4),
    sentiment_label VARCHAR(50)
);








-- 5. Import cleaned purchase CSV
-- Replace this path with your local file path before running.

LOAD DATA LOCAL INFILE 'C:/Users/YourName/Downloads/cleaned_purchase_data.csv'
INTO TABLE customer_purchases_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    transaction_id,
    customer_id,
    customer_name,
    product_id,
    product_name,
    product_category,
    @purchase_quantity,
    @purchase_price,
    @revenue,
    @purchase_date,
    @purchase_year,
    purchase_month,
    purchase_month_name,
    country
)
SET
    purchase_quantity = CAST(NULLIF(@purchase_quantity, '') AS UNSIGNED),
    purchase_price = CAST(NULLIF(@purchase_price, '') AS DECIMAL(10,2)),
    revenue = CAST(NULLIF(@revenue, '') AS DECIMAL(12,2)),
    purchase_date = STR_TO_DATE(LEFT(@purchase_date, 10), '%Y-%m-%d'),
    purchase_year = CAST(NULLIF(@purchase_year, '') AS UNSIGNED);






-- 6. Import cleaned review sentiment CSV
-- Replace this path with your local file path before running.

LOAD DATA LOCAL INFILE 'C:/Users/YourName/Downloads/cleaned_reviews_with_sentiment.csv'
INTO TABLE customer_reviews_sentiment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    review_id,
    customer_id,
    product_id,
    review_text,
    clean_review_text,
    @review_length,
    @review_date,
    @review_year,
    review_month,
    @sentiment_score,
    sentiment_label
)
SET
    review_length = CAST(NULLIF(@review_length, '') AS UNSIGNED),
    review_date = STR_TO_DATE(LEFT(@review_date, 10), '%Y-%m-%d'),
    review_year = CAST(NULLIF(@review_year, '') AS UNSIGNED),
    sentiment_score = CAST(NULLIF(@sentiment_score, '') AS DECIMAL(8,4));





-- 7. Validate imported data
-- These checks confirm that both CSV files loaded correctly.

SELECT 'Purchases' AS table_name, COUNT(*) AS total_records
FROM customer_purchases_cleaned
UNION ALL
SELECT 'Reviews' AS table_name, COUNT(*) AS total_records
FROM customer_reviews_sentiment;

-- These duplicate checks should return zero rows.
SELECT transaction_id, COUNT(*) AS duplicate_count
FROM customer_purchases_cleaned
GROUP BY transaction_id
HAVING COUNT(*) > 1;

SELECT review_id, COUNT(*) AS duplicate_count
FROM customer_reviews_sentiment
GROUP BY review_id
HAVING COUNT(*) > 1;







-- Check missing important IDs and review text.

SELECT
    SUM(customer_id IS NULL OR customer_id = '') AS missing_customer_ids,
    SUM(product_id IS NULL OR product_id = '') AS missing_product_ids
FROM customer_purchases_cleaned;

SELECT
    SUM(customer_id IS NULL OR customer_id = '') AS missing_customer_ids,
    SUM(product_id IS NULL OR product_id = '') AS missing_product_ids,
    SUM(clean_review_text IS NULL OR clean_review_text = '') AS missing_review_text
FROM customer_reviews_sentiment;







-- This should return zero rows after Python cleaning.

SELECT *
FROM customer_purchases_cleaned
WHERE purchase_quantity <= 0
   OR purchase_price <= 0
   OR revenue <= 0
   OR purchase_date IS NULL;








-- Quick check of positive, neutral, and negative review split.

SELECT sentiment_label, COUNT(*) AS total_reviews
FROM customer_reviews_sentiment
GROUP BY sentiment_label
ORDER BY total_reviews DESC;







-- 8. Create Power BI-ready views
-- Import these views into Power BI instead of importing raw tables.

CREATE OR REPLACE VIEW vw_executive_kpis AS
SELECT
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT transaction_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(revenue) / COUNT(DISTINCT transaction_id), 2) AS average_order_value
FROM customer_purchases_cleaned;

CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT
    purchase_month,
    purchase_year,
    ROUND(SUM(revenue), 2) AS monthly_revenue,
    COUNT(DISTINCT transaction_id) AS total_orders
FROM customer_purchases_cleaned
GROUP BY purchase_month, purchase_year
ORDER BY purchase_year, purchase_month;

CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    product_id,
    product_name,
    product_category,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(purchase_quantity) AS total_quantity_sold,
    COUNT(DISTINCT transaction_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(revenue) / COUNT(DISTINCT transaction_id), 2) AS average_order_value
FROM customer_purchases_cleaned
GROUP BY product_id, product_name, product_category;

CREATE OR REPLACE VIEW vw_sentiment_distribution AS
SELECT
    sentiment_label,
    COUNT(*) AS review_count,
    ROUND(AVG(sentiment_score), 4) AS average_sentiment_score
FROM customer_reviews_sentiment
GROUP BY sentiment_label;

CREATE OR REPLACE VIEW vw_customer_segments AS
SELECT
    customer_id,
    customer_name,
    country,
    COUNT(DISTINCT transaction_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_spent,
    ROUND(AVG(revenue), 2) AS average_order_value,
    CASE
        WHEN SUM(revenue) >= 5000 THEN 'High Value Customer'
        WHEN SUM(revenue) >= 2000 THEN 'Medium Value Customer'
        ELSE 'Low Value Customer'
    END AS customer_segment
FROM customer_purchases_cleaned
GROUP BY customer_id, customer_name, country;






-- Product risk analysis identifies high-revenue products with weak customer sentiment.

CREATE OR REPLACE VIEW vw_product_risk_analysis AS
SELECT
    p.product_id,
    p.product_name,
    p.product_category,
    p.total_revenue,
    p.total_quantity_sold,
    p.total_orders,
    COALESCE(r.total_reviews, 0) AS total_reviews,
    COALESCE(r.negative_reviews, 0) AS negative_reviews,
    COALESCE(r.positive_reviews, 0) AS positive_reviews,
    COALESCE(r.neutral_reviews, 0) AS neutral_reviews,
    COALESCE(r.average_sentiment_score, 0) AS average_sentiment_score,
    CASE
        WHEN p.total_revenue >= 10000 AND COALESCE(r.average_sentiment_score, 0) < 0 THEN 'High Risk'
        WHEN p.total_revenue >= 5000 AND COALESCE(r.average_sentiment_score, 0) < 0.05 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS product_risk_level
FROM vw_product_performance p
LEFT JOIN (
    SELECT
        product_id,
        COUNT(*) AS total_reviews,
        SUM(sentiment_label = 'Negative') AS negative_reviews,
        SUM(sentiment_label = 'Positive') AS positive_reviews,
        SUM(sentiment_label = 'Neutral') AS neutral_reviews,
        ROUND(AVG(sentiment_score), 4) AS average_sentiment_score
    FROM customer_reviews_sentiment
    GROUP BY product_id
) r ON p.product_id = r.product_id;








-- 9. Final business insight query

SELECT
    product_name,
    product_category,
    total_revenue,
    total_reviews,
    negative_reviews,
    average_sentiment_score,
    product_risk_level
FROM vw_product_risk_analysis
WHERE product_risk_level IN ('High Risk', 'Medium Risk')
ORDER BY total_revenue DESC;
