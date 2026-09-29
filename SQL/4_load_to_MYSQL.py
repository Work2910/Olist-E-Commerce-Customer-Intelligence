from getpass import getpass
import pandas as pd
from sqlalchemy import create_engine

PROCESSED_PATH = "../Data/Processed/"

password = getpass("password for olist_user: ")
engine = create_engine(f"mysql+pymysql://olist_user:{password}@localhost:3306/olist_ecommerce")

# ZIP codes read as text, otherwise the leading zeros get dropped again
zip_as_text = {
    "customer_zip_code_prefix": str,
    "seller_zip_code_prefix": str,
    "geolocation_zip_code_prefix": str,
}

# CSVs don't keep date types, so parsing them again
date_columns = {
    "orders": ["order_purchase_timestamp", "order_approved_at", "order_delivered_carrier_date",
               "order_delivered_customer_date", "order_estimated_delivery_date"],
    "order_items": ["shipping_limit_date"],
    "reviews_by_order": ["review_creation_date", "review_answer_timestamp"],
}

# customers, products and sellers go first because other tables point to them
tables = ["customers", "products", "sellers", "orders", "order_items",
          "payments", "payments_by_order", "reviews_by_order", "geolocation_by_zip"]

for table in tables:
    df = pd.read_csv(PROCESSED_PATH + f"{table}_clean.csv",
                     dtype=zip_as_text,
                     parse_dates=date_columns.get(table, []))
    df.to_sql(table, engine, if_exists="append", index=False, chunksize=5000)
    print(f"{table}: {len(df):,} rows loaded")


# row counts in MySQL
print("\nrow counts in MySQL:")
for table in tables:
    count = pd.read_sql(f"SELECT COUNT(*) AS n FROM {table}", engine)["n"][0]
    print(f"{table}: {count:,}")


# headline numbers in pandas vs MySQL
orders = pd.read_csv(PROCESSED_PATH + "orders_clean.csv")
items = pd.read_csv(PROCESSED_PATH + "order_items_clean.csv")

in_scope = orders[orders["in_analysis_scope"]]
scope_items = items[items["order_id"].isin(in_scope["order_id"])]

print("\npandas: revenue =", round(scope_items["item_revenue"].sum(), 2),
      "| orders =", scope_items["order_id"].nunique())

sql = pd.read_sql("""
    SELECT ROUND(SUM(oi.item_revenue), 2) AS revenue, COUNT(DISTINCT o.order_id) AS orders
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.in_analysis_scope = TRUE
""", engine)
print("MySQL:  revenue =", sql["revenue"][0], "| orders =", sql["orders"][0])