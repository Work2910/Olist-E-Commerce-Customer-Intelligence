# Olist E-Commerce Customer Intelligence

End-to-end customer intelligence analysis of the Olist Brazilian e-commerce dataset using Python, SQL, RFM segmentation, Power BI and machine learning.

**Status:** Complete

## Business Questions
- How are revenue and orders changing over time?
- Which products and categories drive sales?
- Which customers are most valuable, and which are at risk?
- How does delivery performance relate to customer reviews?
- Can we spot late orders and likely repeat buyers early, and what do unhappy customers complain about?

## Key Findings
- Monthly orders grew from 750 (Jan 2017) to a peak of 7,288 (Nov 2017), then levelled off at around 6,000-7,000 a month.
- Only 3.0% of customers placed more than one order, so retention is the biggest growth opportunity.
- SP, RJ and MG generate 62.5% of revenue; the top 10 categories generate 62.4%.
- Late orders average 2.27 stars versus 4.29 for on-time orders, and 52.5% of late orders get a 1-star review.
- Two one-time buyer segments, High-value new and At risk, are 30.2% of customers but 55.7% of revenue.
- Customers whose first order was late came back 3.02% of the time, compared with 4.05% after an on-time first order.
- The biggest complaint in negative reviews is missing or wrong items (32.6%), followed by delivery delays (21.4%).

## Machine Learning

| Notebook | Question | Result |
|---|---|---|
| `5_Late_Delivery_Prediction` | Can we tell at purchase time that an order will be late? | Logistic regression ROC AUC 0.690. The riskiest 10% of orders were late 10.34% of the time vs 4.40% overall, and contained 23.5% of all late orders. |
| `6_Repeat_Purchase_Prediction` | Does the first order predict a second purchase? | Random forest ROC AUC 0.611. The top 10% of customers by score repeated at 7.06% vs 3.98% overall (lift 1.78). |
| `7_Review_Text_Analysis` | What do unhappy customers write about? | Text model ROC AUC 0.972. Five complaint themes found; delivery themes cover 48.4% of negative reviews and missing or wrong items 32.6%. |

How the models were built:
- Late delivery uses only information known when the order is placed. Delivery dates and review scores are left out so the model can't see the answer.
- The late delivery model is trained on orders before May 2018 and tested on later orders.
- Late orders and repeat buyers are rare, so models use balanced class weights and are judged on ROC AUC, PR AUC and top-10% results, not accuracy.
- The prediction models are modest. They work best for ranking orders and customers by risk, not as yes/no answers.

## Dataset
[Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — 9 relational tables covering orders, customers, products, sellers, payments, reviews and geolocation.

Data files are not included in this repository.

## Tools
Python (pandas, matplotlib, scikit-learn), MySQL, SQLAlchemy, Power BI (DAX, Power Query)

## Power BI Dashboard
- 5 pages covering sales, customers, RFM segments, delivery and reviews.
- Star schema with `Orders` at the centre, linked to Customers, RFM_Customers and a Date table, with Order_Items, Payments and Reviews at their own grain.
- 25 DAX measures. All revenue and customer measures use the same `in_analysis_scope` rule as the Python and SQL analysis.
- Core measures validated against Python and SQL: revenue 15,418,394.83 BRL, 96,470 orders, 93,350 customers.

## Dashboard Preview

### Page 1 — Sales Overview

![Sales Overview](Images/Page_1_Sales_Overview.png)

Olist brought in **15.42M BRL** from **96,470 delivered orders**. Orders grew fast through 2017, from 750 in Jan 2017 to a peak of **7,288 in Nov 2017** (Black Friday), then levelled off at around 6,000–7,000 a month in 2018. Sales are concentrated: **SP, RJ and MG** bring in 62.5% of revenue, and the **top 10 categories** bring in 62.4%.

### Page 2 — Customers

![Customers](Images/Page_2_Customers.png)

Olist served **93,350 customers**, but only **3.0%** of them ever placed a second order. Almost all revenue comes from first-time buyers, which makes getting customers to come back the biggest growth opportunity in the data.

### Page 3 — RFM Segments

![RFM Segments](Images/Page_3_RFM_Segments.png)

Customers are grouped into 7 segments by how recently they bought, whether they bought more than once, and how much they spent. Two one-time buyer segments stand out: **High-value new** (14,411 customers, 28.2% of revenue) are recent big spenders and the best target for a second purchase, while **At risk** (13,773 customers, 27.5% of revenue) spent just as much but have not bought in over a year. Together they are 30.2% of customers but 55.7% of revenue.

### Page 4 — Delivery Performance

![Delivery Performance](Images/Page_4_Delivery.png)

**6.77%** of orders arrived late, and orders took **12.1 days** on average. Late delivery is not spread evenly: the north-east is worst, with **AL at 21.4%**, MA at 17.4% and SE at 15.2%, while SP is only 4.49%. **RJ** is the second-largest market but has a 12.11% late rate, almost three times SP's, so it affects the most customers.

### Page 5 — Reviews

![Reviews](Images/Page_5_Reviews.png)

The average review score is **4.16**, but late orders average only **2.27 stars** against 4.29 for on-time orders, and **52.5%** of late orders get a 1-star review. Scores stay above 4 for deliveries up to 21 days, then drop sharply. Bulky categories such as furniture_decor and bed_bath_table have the highest freight share and the lowest scores among the top 10 categories.

## Insights and Recommendations
See [Insights_and_Recommendations.md](Insights_and_Recommendations.md) for the full findings and business recommendations.

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
7. Open `E_Dashboard.pbix` in Power BI Desktop and click **Refresh** to load the processed data.
8. Run the three ML notebooks from the `Notebooks` folder:
   ```
   jupyter nbconvert --to notebook --execute --inplace 5_Late_Delivery_Prediction.ipynb 6_Repeat_Purchase_Prediction.ipynb 7_Review_Text_Analysis.ipynb
   ```
   This also creates `late_risk_predictions.csv` and `repeat_purchase_scores.csv` in `Data/Processed/`.

## Progress
- ✅ Data understanding
- ✅ Data cleaning
- ✅ SQL analysis
- ✅ Exploratory data analysis
- ✅ RFM segmentation
- ✅ Power BI dashboard
- ✅ Insights and recommendations
- ✅ Machine learning (late delivery, repeat purchase, review text)

---

## Feedback

If you found this project useful or interesting, feel free to give the repository a **star** on GitHub.

I'm also open to **feedback, suggestions, and ideas for improvement**.

## Author

**Shoumik Chakravarty**

B.Tech Computer Science & Engineering

Interested in **Data Analytics, Data Science, Machine Learning, and Business Intelligence**.

This project was created as part of my data analytics portfolio to demonstrate practical experience across the full analytics workflow: **data cleaning, SQL, exploratory analysis, customer segmentation, Power BI dashboard development, machine learning, and business-oriented storytelling**.
