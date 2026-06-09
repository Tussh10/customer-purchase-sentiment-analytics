# Important MySQL Note

This project uses `LOAD DATA LOCAL INFILE` to import cleaned CSV files into MySQL Workbench.

## If `LOAD DATA LOCAL INFILE` works

Update the file paths in `sql/customer_sentiment_essential_queries.sql`:

```sql
LOAD DATA LOCAL INFILE 'C:/Users/YourName/Downloads/cleaned_purchase_data.csv'
LOAD DATA LOCAL INFILE 'C:/Users/YourName/Downloads/cleaned_reviews_with_sentiment.csv'
```

Then run the full SQL script in MySQL Workbench.

## If you get an import error

Use the MySQL Workbench import wizard instead:

1. Right-click the `ecommerce_sentiment_analytics` database.
2. Select **Table Data Import Wizard**.
3. Import `cleaned_purchase_data.csv` into `customer_purchases_cleaned`.
4. Import `cleaned_reviews_with_sentiment.csv` into `customer_reviews_sentiment`.
5. Skip the two `LOAD DATA LOCAL INFILE` statements in the SQL script.
6. Run the validation queries and view creation queries.

## Common reasons for import errors

- `LOCAL INFILE` is disabled in MySQL.
- The CSV file path is incorrect.
- MySQL does not have permission to read the file.
- Windows paths need forward slashes, for example: `C:/Users/YourName/Downloads/file.csv`.

For a portfolio project, using the Workbench Import Wizard is acceptable. The important part is that the cleaned Python output is imported into MySQL and Power BI connects to the final SQL views.
