# pip install pandas textblob -------if required

import pandas as pd
from textblob import TextBlob


# =====================================================
# Customer Purchase Behavior & Sentiment Analysis
# Python Part: ETL + Basic NLP Sentiment Analysis
# =====================================================


# Input files: place these inside data/raw before running this script....

purchase_input_file = "data/raw/customer_purchase_data.csv"
review_input_file = "data/raw/customer_reviews_data.csv"



# Output files: these files will be imported into MySQL Workbench for further process....
cleaned_purchase_output = "data/processed/cleaned_purchase_data.csv"
cleaned_review_output = "data/processed/cleaned_reviews_with_sentiment.csv"


def clean_column_names(df):
    """
    Standardizes column names into snake_case format.
    Example: TransactionID -> transaction_id, ProductCategory -> product_category
    """
    df.columns = (
        df.columns
        .str.strip()
        .str.replace(r"(?<=[a-z0-9])(?=[A-Z])", "_", regex=True)
        .str.replace(" ", "_", regex=False)
        .str.replace("-", "_", regex=False)
        .str.lower()
        .str.replace("__", "_", regex=False)
        .str.strip("_")
    )
    return df


def clean_review_text(text):
    """Cleans review text before sentiment analysis without importing extra libraries."""
    if pd.isna(text):
        return ""

    text = str(text).lower().strip()
    text = pd.Series([text]).str.replace(r"[^a-zA-Z0-9\s]", "", regex=True).iloc[0]
    text = " ".join(text.split())
    return text


def get_sentiment_score(text):
    """
    TextBlob polarity returns a score between -1 and +1.
    Negative score = negative sentiment, positive score = positive sentiment.
    """
    if text == "":
        return 0
    return TextBlob(text).sentiment.polarity


def get_sentiment_label(score):
    """Converts sentiment polarity score into business-friendly labels."""
    if score > 0.05:
        return "Positive"
    if score < -0.05:
        return "Negative"
    return "Neutral"




# ------------------------------------------------------------------------------------------------------------------
# 1. Read raw CSV files
# ------------------------------------------------------------------------------------------------------------------

purchase_df = pd.read_csv(purchase_input_file, engine="python", on_bad_lines="skip")
review_df = pd.read_csv(review_input_file, engine="python", on_bad_lines="skip")





# ------------------------------------------------------------------------------------------------------------------
# 2. Clean and standardize columns
# ------------------------------------------------------------------------------------------------------------------

purchase_df = clean_column_names(purchase_df)
review_df = clean_column_names(review_df)






# ------------------------------------------------------------------------------------------------------------------
# 3. Handle duplicates
# ------------------------------------------------------------------------------------------------------------------

purchase_df = purchase_df.drop_duplicates(subset=["transaction_id"])
review_df = review_df.drop_duplicates(subset=["review_id"])




# ------------------------------------------------------------------------------------------------------------------
# 4. Convert data types
# ------------------------------------------------------------------------------------------------------------------

purchase_df["purchase_date"] = pd.to_datetime(purchase_df["purchase_date"], errors="coerce")
purchase_df["purchase_quantity"] = pd.to_numeric(purchase_df["purchase_quantity"], errors="coerce")
purchase_df["purchase_price"] = pd.to_numeric(purchase_df["purchase_price"], errors="coerce")
review_df["review_date"] = pd.to_datetime(review_df["review_date"], errors="coerce")





# ------------------------------------------------------------------------------------------------------------------
# 5. Handle missing and invalid values
# ------------------------------------------------------------------------------------------------------------------

purchase_df = purchase_df.dropna(
    subset=[
        "transaction_id",
        "customer_id",
        "product_id",
        "purchase_quantity",
        "purchase_price",
        "purchase_date",
    ]
)

review_df = review_df.dropna(subset=["review_id", "customer_id", "product_id", "review_date"])

purchase_df = purchase_df[purchase_df["purchase_quantity"] > 0]
purchase_df = purchase_df[purchase_df["purchase_price"] > 0]
review_df["review_text"] = review_df["review_text"].fillna("")





# ------------------------------------------------------------------------------------------------------------------
# 6. Create revenue and date columns
# ------------------------------------------------------------------------------------------------------------------

purchase_df["revenue"] = purchase_df["purchase_quantity"] * purchase_df["purchase_price"]
purchase_df["purchase_year"] = purchase_df["purchase_date"].dt.year
purchase_df["purchase_month"] = purchase_df["purchase_date"].dt.to_period("M").astype(str)
purchase_df["purchase_month_name"] = purchase_df["purchase_date"].dt.month_name()

review_df["review_year"] = review_df["review_date"].dt.year
review_df["review_month"] = review_df["review_date"].dt.to_period("M").astype(str)






# ------------------------------------------------------------------------------------------------------------------
# 7. Clean text columns
# ------------------------------------------------------------------------------------------------------------------

for column in ["customer_name", "product_name", "product_category", "country"]:
    purchase_df[column] = purchase_df[column].astype(str).str.strip()

review_df["clean_review_text"] = review_df["review_text"].apply(clean_review_text)
review_df["review_length"] = review_df["clean_review_text"].apply(len)





# ------------------------------------------------------------------------------------------------------------------
# 8. Apply TextBlob sentiment analysis
# ------------------------------------------------------------------------------------------------------------------

review_df["sentiment_score"] = review_df["clean_review_text"].apply(get_sentiment_score)
review_df["sentiment_label"] = review_df["sentiment_score"].apply(get_sentiment_label)




# ------------------------------------------------------------------------------------------------------------------
# 9. Final column arrangement
# ------------------------------------------------------------------------------------------------------------------

purchase_columns = [
    "transaction_id",
    "customer_id",
    "customer_name",
    "product_id",
    "product_name",
    "product_category",
    "purchase_quantity",
    "purchase_price",
    "revenue",
    "purchase_date",
    "purchase_year",
    "purchase_month",
    "purchase_month_name",
    "country",
]

review_columns = [
    "review_id",
    "customer_id",
    "product_id",
    "review_text",
    "clean_review_text",
    "review_length",
    "review_date",
    "review_year",
    "review_month",
    "sentiment_score",
    "sentiment_label",
]

purchase_df = purchase_df[purchase_columns]
review_df = review_df[review_columns]





# ------------------------------------------------------------------------------------------------------------------
# 10. Export cleaned datasets as CSV
# ------------------------------------------------------------------------------------------------------------------

purchase_df.to_csv(cleaned_purchase_output, index=False)
review_df.to_csv(cleaned_review_output, index=False)


print("Python ETL and sentiment analysis completed successfully.")
print(f"Cleaned purchase file exported: {cleaned_purchase_output}")
print(f"Cleaned review sentiment file exported: {cleaned_review_output}")
print(f"Purchase records: {len(purchase_df)}")
print(f"Review records: {len(review_df)}")
print("\nSentiment distribution:")
print(review_df["sentiment_label"].value_counts())
