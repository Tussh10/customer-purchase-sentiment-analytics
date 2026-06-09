# Customer Purchase Behavior & Sentiment Analytics

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)
![Python](https://img.shields.io/badge/Python-ETL%20%2B%20NLP-blue)
![MySQL](https://img.shields.io/badge/MySQL-Analytics%20Views-orange)
![NLP](https://img.shields.io/badge/NLP-TextBlob%20Sentiment-green)

## Project Overview

This project analyzes customer purchase behavior and review sentiment for an ecommerce business using **Python, MySQL, basic NLP, and Power BI**.

The objective is to identify revenue trends, product performance, customer segments, sentiment distribution, and products that generate strong revenue but have weak customer sentiment.

This project is designed as a practical Data Analyst portfolio project suitable for an internship or entry-level analytics profile.

---

## Business Problem

Ecommerce businesses often track sales and customer reviews separately. This creates a gap between **what customers buy** and **how customers feel about the products they purchased**.

This project connects transaction data with review sentiment to answer:

- Which products and categories generate the most revenue?
- Which customers contribute the most to sales?
- What is the overall sentiment distribution of customer reviews?
- Which products have high revenue but negative or weak sentiment?
- What areas should the business prioritize for product or customer experience improvement?

---

## Tools and Technologies

| Area | Tools Used |
|---|---|
| Data Cleaning | Python, pandas |
| NLP | TextBlob sentiment analysis |
| Database | MySQL, MySQL Workbench |
| SQL Analysis | Validation queries, KPI views, segmentation views |
| Visualization | Power BI |
| Repository | GitHub |

---

## Dashboard Preview

### E-Commerce Overview

![E-Commerce Overview](dashboard/screenshots/E-Commerce%20Overview.png)

### Customer and Sentiment Analysis

![Customer and Sentiment Analysis](dashboard/screenshots/Customer%20and%20Sentiment%20Analysis.png)

### Customer and Product Analysis

![Customer and Product Analysis](dashboard/screenshots/Customer%20and%20Product%20Analysis.png)

---

## Repository Structure

```text
customer-purchase-sentiment-analytics/
│
├── data/
│   ├── raw/
│   │   └── .gitkeep
│   └── processed/
│       └── .gitkeep
│
├── scripts/
│   └── python_etl_sentiment_analysis.py
│
├── sql/
│   └── customer_sentiment_essential_queries.sql
│
├── dashboard/
│   ├── pbix/
│   │   └── Ecommerce Analytics Dashboard.pbix
│   └── screenshots/
│       ├── E-Commerce Overview.png
│       ├── Customer and Sentiment Analysis.png
│       └── Customer and Product Analysis.png
│
├── docs/
│   ├── DATA_DICTIONARY.md
│   ├── IMPORTANT_MYSQL_NOTE.md
│   └── PROJECT_WORKFLOW.md
│
├── requirements.txt
├── .gitignore
└── README.md
```

---

## Dataset

The project uses two CSV files:

1. `customer_purchase_data.csv`
2. `customer_reviews_data.csv`

Place both raw files inside:

```text
data/raw/
```

The Python script exports cleaned files into:

```text
data/processed/
```

Generated output files:

```text
cleaned_purchase_data.csv
cleaned_reviews_with_sentiment.csv
```

---

## Project Workflow

```text
Raw CSV files
   -> Python cleaning and NLP sentiment analysis
   -> Cleaned CSV files
   -> MySQL Workbench import
   -> SQL validation and analytical views
   -> Power BI dashboard
```

---

## Python ETL and NLP Process

The Python script performs:

- Raw CSV loading
- Column name standardization
- Duplicate handling
- Missing value handling
- Data type conversion
- Revenue calculation
- Date feature creation
- Review text cleaning
- TextBlob sentiment scoring
- Sentiment label creation
- Cleaned CSV export

Run:

```bash
pip install -r requirements.txt
python -m textblob.download_corpora
python scripts/python_etl_sentiment_analysis.py
```

---

## MySQL Process

The SQL script performs:

- Database creation
- Cleaned table creation
- CSV import
- Data validation
- KPI view creation
- Monthly revenue view creation
- Product performance view creation
- Sentiment distribution view creation
- Customer segmentation view creation
- Product risk analysis view creation

Main SQL file:

```text
sql/customer_sentiment_essential_queries.sql
```

If `LOAD DATA LOCAL INFILE` does not work, use the note in:

```text
docs/IMPORTANT_MYSQL_NOTE.md
```

---

## Power BI Dashboard

The Power BI dashboard connects to MySQL views created by the SQL script.

Recommended views to import into Power BI:

```text
vw_executive_kpis
vw_monthly_revenue
vw_product_performance
vw_sentiment_distribution
vw_customer_segments
vw_product_risk_analysis
```

Dashboard file:

```text
dashboard/pbix/Ecommerce Analytics Dashboard.pbix
```

---

## Dashboard Pages

### 1. E-Commerce Overview

Includes:

- Revenue KPI
- Purchase frequency
- Customer count
- Product count
- Quantity sold
- Revenue by category
- Products by total revenue
- Sales trend over time
- Purchase frequency and customers by country

### 2. Customer and Sentiment Analysis

Includes:

- Average purchase value
- Total reviews
- Average sentiment score
- Average quantity
- Top customers by purchased amount
- Purchase price vs sentiment
- Reviews by sentiment class
- Review sentiment by product

### 3. Customer and Product Analysis

Includes:

- Revenue by customer and product category
- Customer order count
- Revenue by country
- Transaction-level purchase table
- Year and month filters
- Product category and sentiment class filters

---

## Key SQL Views

| View | Business Use |
|---|---|
| `vw_executive_kpis` | Revenue, orders, customers, and average order value |
| `vw_monthly_revenue` | Monthly sales trend analysis |
| `vw_product_performance` | Product and category sales performance |
| `vw_sentiment_distribution` | Positive, neutral, and negative review split |
| `vw_customer_segments` | High, medium, and low-value customer segmentation |
| `vw_product_risk_analysis` | High-revenue products with weak customer sentiment |

---

## Key Insights to Highlight

- Identified top revenue-generating customers and products.
- Tracked monthly revenue and sentiment trends.
- Classified customer reviews into positive, neutral, and negative sentiment.
- Connected purchase behavior with sentiment analysis to identify product risk.
- Built Power BI pages for executive overview, customer analysis, sentiment analysis, and product performance.

---

## Resume Summary

**Customer Purchase Behavior & Sentiment Analytics | Python, MySQL, NLP, Power BI**

Built an end-to-end ecommerce analytics project using Python, MySQL, TextBlob NLP, and Power BI. Cleaned transaction and review datasets in Python, applied sentiment analysis to customer reviews, imported processed data into MySQL, created validation queries and Power BI-ready SQL views, and developed an interactive dashboard to analyze revenue trends, customer behavior, product performance, and sentiment-based product risk.

---

## Resume Bullet Points

- Developed an end-to-end customer analytics pipeline using Python, MySQL, and Power BI to analyze ecommerce purchase behavior, revenue trends, and product performance.
- Applied basic NLP sentiment analysis using TextBlob to classify customer reviews into positive, neutral, and negative sentiment categories.
- Created SQL validation queries and analytical views for executive KPIs, customer segmentation, monthly revenue trends, product performance, and product risk analysis.
- Built an interactive Power BI dashboard to identify high-revenue products with weak customer sentiment and support customer experience improvement decisions.

---

## How to Run This Project

1. Clone the repository.
2. Place raw CSV files inside `data/raw/`.
3. Install Python dependencies.
4. Run the Python ETL script.
5. Open MySQL Workbench and run the SQL script.
6. Import MySQL views into Power BI.
7. Open the `.pbix` file and refresh the dashboard.

---

## Author

**Tushar Yadgire**  
Data Analyst | Python | SQL | Power BI | Basic NLP

