# Data Dictionary

## customer_purchases_cleaned

| Column | Description |
|---|---|
| transaction_id | Unique identifier for each purchase transaction |
| customer_id | Unique identifier for each customer |
| customer_name | Customer name |
| product_id | Unique identifier for each product |
| product_name | Product name |
| product_category | Product category such as Electronics or Home Appliances |
| purchase_quantity | Quantity purchased in the transaction |
| purchase_price | Purchase price amount |
| revenue | Calculated field: purchase_quantity * purchase_price |
| purchase_date | Date of purchase |
| purchase_year | Purchase year extracted from purchase_date |
| purchase_month | Purchase month in YYYY-MM format |
| purchase_month_name | Purchase month name |
| country | Customer country |

## customer_reviews_sentiment

| Column | Description |
|---|---|
| review_id | Unique identifier for each review |
| customer_id | Customer identifier linked to purchase data |
| product_id | Product identifier linked to purchase data |
| review_text | Original customer review text |
| clean_review_text | Cleaned review text used for sentiment analysis |
| review_length | Character length of cleaned review text |
| review_date | Date of customer review |
| review_year | Review year extracted from review_date |
| review_month | Review month in YYYY-MM format |
| sentiment_score | TextBlob polarity score between -1 and +1 |
| sentiment_label | Positive, Neutral, or Negative sentiment class |

## Power BI Views

| View | Purpose |
|---|---|
| vw_executive_kpis | KPI cards for revenue, orders, customers, and average order value |
| vw_monthly_revenue | Monthly revenue and order trend analysis |
| vw_product_performance | Product and category-level sales performance |
| vw_sentiment_distribution | Review sentiment summary |
| vw_customer_segments | Customer value segmentation |
| vw_product_risk_analysis | Products with high revenue but weak sentiment |
