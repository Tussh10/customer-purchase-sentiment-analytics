# Project Workflow

```text
Raw CSV files
   -> Python ETL and TextBlob sentiment analysis
   -> Cleaned CSV output
   -> MySQL Workbench import
   -> SQL validation and analytical views
   -> Power BI dashboard
```

## Python Responsibilities

1. Read raw CSV files.
2. Clean and standardize columns.
3. Handle duplicates and missing values.
4. Convert data types.
5. Create revenue and date columns.
6. Clean review text.
7. Apply TextBlob sentiment analysis.
8. Export cleaned datasets as CSV.

## SQL Responsibilities

1. Create database and final tables.
2. Import cleaned CSV files.
3. Validate imported data.
4. Create KPI and analytical views.
5. Segment customers.
6. Identify high-revenue, low-sentiment products.
7. Prepare clean views for Power BI.

## Power BI Responsibilities

1. Connect to MySQL views.
2. Build KPI cards.
3. Create revenue trend charts.
4. Show product and category performance.
5. Show sentiment distribution.
6. Build customer and product analysis pages.
7. Add slicers for category, year, month, quarter, and sentiment class.
