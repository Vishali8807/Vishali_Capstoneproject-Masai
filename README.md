Big Billion Days Regional Performance Review: SQL, Spreadsheet, Dashboard and AI-Verified Analysis
Summary
This project takes one dataset (reps, products, customers and orders) and follows it from raw tables to a business story. In Part A I loaded the seed data (4, 9, 24 and 90 rows) and wrote 13 queries. One of them, q09, gives an order-level table, and I exported it as `data/orders_enriched.csv`. In Part B I cleaned that file in a spreadsheet. I tidied the names, looked up the category and unit price, recalculated revenue, and checked everything against Part A's KPIs (63 completed orders, 346,200 INR, average 5,495.24). The result is `data/orders_clean.csv`. Part C describes the Tableau dashboard I'd build on that file: two KPI cards, four worksheets, the layout and filter behaviour, three observations and three recommendations. The four revenue totals in the reconciliation table all come to 346,200. Part D is about checking AI output against the data. The assistant's query pointed at a table that doesn't exist, put an aggregate in `WHERE`, and claimed 38% growth that the data doesn't support. I rejected it and wrote `sql/d1_corrected.sql` instead.
1. Project title
Big Billion Days Regional Performance Review: SQL, Spreadsheet, Dashboard and AI-Verified Analysis
2. SQL tool and dialect used
SQLite (SQLite dialect), run through Python's `sqlite3` module. The multi-row `INSERT` statements ran fine as written, so I didn't have to split them up.
3. Spreadsheet tool used
Google Sheets (free).
4. Tableau Public used?
No. I wrote the dashboard up in `docs/dashboard_spec.md` as if it were already built. Every number in it comes from `data/orders_clean.csv` and ties back to Parts A and B.
5. Three most important findings
North is the biggest region, but it's slipping. North brings in 119,300 INR (34.5% of 346,200). Even so, its revenue fell 22.8% from September to October, then dropped again to 24,500 in November. That is well under its 40,000 monthly target. The AI said North grew 38% month over month, and that's wrong.
A few products carry the sale. Air Fryer alone brings in 104,000 (30.0%). The three High-tier items (Air Fryer, Smart Watch, Wireless Earbuds) together bring in 232,300, which is 67.1% of revenue.
November's jump is really a Home-category story. Revenue rose 66.3%, from 93,100 in October to 154,800 in November, and Home went from 12,600 to 83,200 (53.7% of November). Also worth knowing: 5 of the 12 rep-months finished Below Target.
6. Which file belongs to which Part
File	Part
`README.md`	Submission (all Parts)
`sql/00_schema_and_seed.sql`	Part A
`sql/q01.sql` ... `sql/q13.sql`	Part A
`sql/d1_corrected.sql`	Part D (Scenario D1 correction)
`results/query_results.md`	Part A
`data/orders_enriched.csv`	Part A output / Part B input
`data/orders_clean.csv`	Part B output / Part C input
`docs/spreadsheet_notes.md`	Part B
`docs/dashboard_spec.md`	Part C
`docs/ai_log.md`	Part D
7. Assumptions
I copied the seed data from the brief and checked it against the required counts (4/9/24/90) and the brief's own numbers: 63 completed orders, 346,200 revenue, 106 units, 3 missing amounts and 4 customers who never ordered.
Some names have extra spaces at the start or end. I didn't count them, since `TRIM` removes them all anyway.
Revenue means completed orders only, which is how the brief defines it. That's why `q05`, `q07`, `q11`, `q12` and `q13` filter on `status = 'completed'`, while `q06` covers every status.
`SUM` skips NULLs, so the pending total in `q06` (64,900) leaves out the three orders that have no amount.
"Region" in `q09`, `q11` and the dashboard means the customer's region, and the rep comes from `customers.rep_id`. `INNER JOIN` is safe here because all 90 orders match a customer and a rep.
For `q13`, Below Target means revenue is under the target. On Target means it's at least the target but under 1.1 times the target. Above Target is everything else.
I rounded averages to 2 decimals and percentages to 1 decimal. Month-over-month changes use the completed revenue from `q11`.
In `completed_orders`, orders with the same `amount` stay in `order_id` order after the descending sort.
`results/query_results.md` shows every row of every result, including all 90 rows of q09.
