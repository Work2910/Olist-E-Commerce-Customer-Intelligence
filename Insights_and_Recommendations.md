# Insights and Recommendations

**Project:** Olist E-Commerce Customer Intelligence
**Data:** Olist Brazilian E-Commerce Public Dataset, delivered orders from Jan 2017 to Aug 2018
**Scope:** 96,470 orders, 93,350 customers, 15.42M BRL revenue

All numbers below come from the analysis notebooks, the machine learning notebooks and the Power BI dashboard in this repository.

---

## Summary

Olist grew quickly through 2017 and then levelled off in 2018. Almost all customers buy only once, so most future growth has to come from getting existing customers to buy again. The clearest problem in the data is late delivery: late orders get much worse reviews, customers whose first order was late come back less often, and late deliveries are concentrated in certain states and in bulky product categories. Review comments add a second problem: the most common complaint is receiving the wrong or incomplete order.

The recommendations focus on four areas:
1. Getting one-time buyers to make a second purchase
2. Reducing late deliveries, and flagging risky orders early
3. Fixing missing and wrong items in orders
4. Fixing the regions and categories where delivery problems are worst

---

## 1. Almost every customer buys only once

**What the data shows**
- Only 3.0% of customers (2,801 of 93,350) placed more than one order.
- The median customer spent 107.78 BRL in total, almost the same as one median order (105.28 BRL).
- Repeat customers spend more per customer: Champions average 371.77 BRL and Loyal 274.01 BRL, compared with 165.17 BRL for all customers.

**What it means**
Olist is almost entirely dependent on new customers. Even a small increase in repeat purchases would add revenue without the cost of finding new buyers.

**Recommendation**
Make the second purchase a business goal. Track the repeat rate every month as a key metric, alongside revenue and orders.

**How to measure it:** repeat rate (currently 3.0%).

---

## 2. High-value new customers are the best chance for a second purchase

**What the data shows**
- The High-value new segment has 14,411 customers (15.4% of customers) but brings in 28.2% of revenue.
- They spent 302.08 BRL on average and bought about 91 days before the end of the data, so they are recent.
- A repeat purchase model built on first-order details finds repeat buyers 1.78 times more often than random: the top 10% of customers by score repeated at 7.06%, compared with 3.98% overall.

**What it means**
These customers spent a lot and still remember Olist. They are the most likely to buy again. The model's scores can narrow the list further so campaign money goes to the customers most likely to respond.

**Recommendation**
Run a second-purchase campaign for this segment, for example a follow-up offer or product suggestions based on their first order. Start with customers who have the highest repeat scores. Test it on part of the segment first and compare it with a group that gets no offer.

**How to measure it:** share of High-value new customers who place a second order, compared with the group that got no offer.

---

## 3. At-risk customers spent a lot but have not come back

**What the data shows**
- The At risk segment has 13,773 customers (14.8% of customers) and brings in 27.5% of revenue.
- They spent 307.77 BRL on average, but their last purchase was about 394 days before the end of the data.

**What it means**
These customers were as valuable as High-value new customers, but they have been gone for over a year. Some of them may come back with the right offer.

**Recommendation**
Test a win-back campaign on a sample of At risk customers before rolling it out. Because they have been inactive for a long time, keep the cost per customer low.

**How to measure it:** share of contacted At risk customers who place a new order.

---

## 4. Late delivery hurts reviews and repeat purchases

**What the data shows**
- 6.77% of orders arrived after the estimated date. Orders take 12.1 days on average.
- Late orders average 2.27 stars, compared with 4.29 for on-time orders.
- 52.5% of late orders get a 1-star review, compared with 6.6% of on-time orders.
- The review score stays above 4 for deliveries up to 21 days (4.41, 4.29, 4.10), then drops to 3.49 for 22–30 days and about 2.2 for anything over 30 days.
- Customers whose first order was late came back 3.02% of the time, compared with 4.05% after an on-time first order, about 25% less often.
- Customers who gave their first order 5 stars came back 4.22% of the time; for 1 to 4 stars the rate was between 3.60% and 3.80%.

**What it means**
Delivery is the biggest driver of customer satisfaction that the data shows. Customers seem to accept normal delivery times, but satisfaction falls sharply once delivery passes about three weeks. A late first order is also linked to fewer customers coming back, so delivery affects retention as well as reviews.

**Recommendation**
- Treat reducing late deliveries as a top priority.
- Set a target that orders arrive within 21 days, since that is where scores start to drop.
- Make estimated delivery dates realistic, especially for distant states, so fewer orders count as late.
- Pay extra attention to first orders, since they shape whether a customer comes back.

**How to measure it:** late delivery rate (currently 6.77%), average review score (currently 4.16), and repeat rate after a first order.

---

## 5. Risky orders can be flagged when they are placed

**What the data shows**
- Late rates rise with distance: 4.45% for orders under 100 km, up to 12.03% for orders over 2,000 km.
- Orders where the seller and customer are in different states are late 8.05% of the time, compared with 4.50% within the same state.
- A late delivery model, using only information known at purchase time, was trained on orders before May 2018 and tested on 25,352 later orders.
- The best model (logistic regression) reached a ROC AUC of 0.690. The 10% of orders it ranked riskiest were late 10.34% of the time, compared with 4.40% overall, and contained 23.5% of all late orders.
- The strongest signals were the seller's past late rate, distance, the promised delivery days, freight, the customer's state and whether the order crosses state lines.

**What it means**
The model cannot say for certain that an order will be late, but it can rank orders by risk. Checking the riskiest 10% finds late orders about 2.3 times more often than checking at random.

**Recommendation**
- Score new orders for late risk and give the riskiest ones extra attention: faster shipping, a more realistic delivery date, or an early message to the customer.
- Review sellers with a poor late history, since this was the strongest signal.

**How to measure it:** late rate among flagged orders before and after action is taken.

---

## 6. Missing or wrong items are the most common complaint

**What the data shows**
- 38,898 of 95,824 reviews (40.6%) have a written comment. Of these, 9,234 are negative (1–2 stars) and 26,233 positive (4–5 stars).
- Grouping negative comments into themes gives:
  - Missing or wrong items, e.g. bought two but only one came: 32.6%
  - Delivery delay and waiting: 21.4%
  - Poor quality or broken product: 19.0%
  - Product not received: 17.2%
  - Order shown as delivered on the website but not received: 9.8%
- 64.6% of negative comments mention delivery, compared with 49.3% of positive ones. Among negative reviews, 83.8% of late orders mention delivery, compared with 56.5% of on-time orders.
- Positive comments often praise early delivery, e.g. "chegou antes do prazo" (arrived before the deadline).

**What it means**
Most complaints are about receiving the right order on time, not about the product itself. Missing or wrong items is the single largest complaint and was not visible in the star ratings alone. Orders shown as delivered but never received point to tracking or carrier problems.

**Recommendation**
- Check items before dispatch, especially for orders with more than one item.
- Investigate orders marked as delivered but not received, starting with the carriers involved.
- Set delivery estimates that Olist can usually beat, since early delivery is a common reason for positive reviews.

**How to measure it:** share of negative reviews about missing or wrong items, and about orders not received.

---

## 7. Delivery problems are concentrated in certain states

**What the data shows**
- The highest late rates are in AL (21.4%), MA (17.4%) and SE (15.2%), all in the north-east.
- SP, the largest market, has a late rate of only 4.49%.
- RJ is the second-largest market (2.06M BRL revenue, 12,350 orders) but has a 12.11% late rate, almost three times SP's.

**What it means**
The north-east has the worst delivery rates, but RJ affects the most customers because it is so much bigger.

**Recommendation**
- Start with RJ: improving delivery there would reach the most customers.
- Review shipping partners and delivery estimates for the north-eastern states.

**How to measure it:** late delivery rate by state, starting with RJ, AL, MA and SE.

---

## 8. Bulky categories have high shipping costs and lower reviews

**What the data shows**
- Freight is 14.26% of revenue overall.
- Among the top 10 categories by revenue, furniture_decor (19.1%) and bed_bath_table (16.5%) have the highest freight share.
- The same two categories have the lowest review scores in the top 10 (4.06 and 4.00).
- bed_bath_table is the third-largest category by revenue (1.23M BRL).

**What it means**
Large, heavy items cost more to ship and probably take longer to arrive, which may explain the lower scores. This analysis shows the link, but does not prove the cause.

**Recommendation**
For bulky categories, review shipping options, packaging and delivery estimates, and check whether these orders are late more often than others.

**How to measure it:** freight share and review score for furniture_decor and bed_bath_table.

---

## 9. Other points worth knowing

- **Peak season:** orders peaked at 7,288 in Nov 2017, likely linked to Black Friday. Delivery capacity should be planned ahead of November, because a late-delivery problem during the busiest month would affect the most customers.
- **Payments:** credit card makes up 78.3% of payment value, and credit card customers use a median of 3 installments. Installment options appear important to customers and should be kept.
- **Concentration:** SP, RJ and MG bring in 62.5% of revenue, so delivery and service in these states matter most.

---

## Limitations

- The data ends in Aug 2018, so it does not reflect current conditions.
- The links between late delivery, low reviews and fewer repeat purchases are strong patterns, but this analysis does not prove that late delivery causes them.
- The RFM segments are a single snapshot as of 30 Aug 2018.
- Because 97% of customers bought only once, Frequency was split into one-time vs repeat instead of a 1–5 score.
- The late delivery and repeat purchase models are modest (ROC AUC 0.690 and 0.611). They are useful for ranking, not for exact predictions.
- The late delivery test period covers only four months and had a lower late rate (4.40%) than the training period (7.62%).
- In the repeat purchase analysis, customers had different amounts of time to come back (6 to 23 months).
- Only 40.6% of reviews have a comment, and unhappy customers may be more likely to write one. Complaint theme names are based on reading the top words in each theme.

---

## Suggested next steps

1. Compare late delivery rates by seller, to see whether a small number of sellers cause most late orders.
2. Test the second-purchase and win-back campaigns on small groups before a full rollout.
3. Try the late-risk scores on new orders for a few weeks and check whether acting on flagged orders lowers the late rate.
4. Look at multi-item orders in more detail to find where missing or wrong items happen most.
