# Olist E-Commerce Customer Intelligence

End-to-end customer intelligence analysis of the Olist Brazilian e-commerce dataset using Python, SQL, RFM segmentation and Power BI.

**Status:** In progress — data understanding, cleaning, SQL analysis, EDA and RFM segmentation complete. Power BI data model and measures complete; dashboard pages in progress.

## Business Questions
- How are revenue and orders changing over time?
- Which products and categories drive sales?
- Which customers are most valuable, and which are at risk?
- How does delivery performance relate to customer reviews?

## Key Findings So Far
- Monthly orders grew from 750 (Jan 2017) to a peak of 7,288 (Nov 2017), then levelled off at around 6,000-7,000 a month.
- Only 3.0% of customers placed more than one order, so retention is the biggest growth opportunity.
- SP, RJ and MG generate 62.5% of revenue; the top 10 categories generate 62.4%.
- Late orders average 2.27 stars versus 4.29 for on-time orders, and 52.5% of late orders get a 1-star review.
- Two one-time buyer segments, High-value new and At risk, are 30.2% of customers but 55.7% of revenue.

## Dataset
[Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — 9 relational tables covering orders, customers, products, sellers, payments, reviews and geolocation.

Data files are not included in this repository.

## Tools
Python (pandas, matplotlib), MySQL, SQLAlchemy, Power BI (DAX, Power Query)

## Power BI Model
- Star schema with `Orders` at the centre, linked to Customers, RFM_Customers and a Date table, with Order_Items, Payments and Reviews at their own grain.
- 18 DAX measures covering sales, customers, RFM segments, delivery and reviews. All revenue and customer measures use the same `in_analysis_scope` rule as the Python and SQL analysis.
- Core measures validated against Python and SQL: revenue 15,418,394.83 BRL, 96,470 orders, 93,350 customers.

## How to Reproduce
1. Download the CSVs from Kaggle into `Data/Raw/`.
2. Run `Notebooks/1_Data_Understanding.ipynb` to review the data.
3. Run `Notebooks/2_Data Cleaning & Preprocessing.ipynb` to create the cleaned tables in `Data/Processed/`.
4. In MySQL, run the files in `SQL/` in this order:
   - `1_Create_Database.sql` (as root, set your own password for `olist_user`)
   - `2_Database_setup.sql`
   - `4_load_to_MYSQL.py` (loads the cleaned CSVs and checks totals against pandas)
   - `3_Sales_Analysis.sql`
5. Run `Notebooks/3_EDA.ipynb` for the exploratory analysis.
6. Run `Notebooks/4_RFM.ipynb` for customer segmentation. This also creates `rfm_customers.csv` in `Data/Processed/`.
7. Open the Power BI file in Power BI Desktop and click **Refresh** to load the processed data.

## Progress
- ✅ Data understanding
- ✅ Data cleaning
- ✅ SQL analysis
- ✅ Exploratory data analysis
- ✅ RFM segmentation
- ⏳ Power BI dashboard (data model and measures done, pages in progress)
- ⬜ Insights and recommendations