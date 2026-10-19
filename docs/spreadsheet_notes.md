# Spreadsheet Notes (Part B)

Tool: Google Sheets (free). Input: data/orders_enriched.csv (the q09 export). Output: data/orders_clean.csv. I checked every figure below against the SQL results in results/query_results.md.

## Setup

- **Tabs created:** orders and products. The cleaned rows later went into a third tab, completed_orders.
- **Rows imported into orders:** 90 data rows plus the header row, so the used range is A1:J91. I imported order_month as **Plain text** (automatic conversion off), so it still shows values like 2026-09.
- **Range occupied by products:** A1:C10, with the header in row 1 and 9 item rows. Column A is item, B is category and C is unit_price. The rows come from SELECT item, category, unit_price FROM products ORDER BY item:

| item              | category    | unit_price |
| ----------------- | ----------- | ---------- |
| Air Fryer         | Home        | 5200       |
| Bedsheet Set      | Home        | 1900       |
| Bluetooth Speaker | Electronics | 2800       |
| Cotton Kurta      | Apparel     | 1400       |
| Denim Jacket      | Apparel     | 2500       |
| Running Shoes     | Apparel     | 3600       |
| Smart Watch       | Electronics | 4500       |
| Table Lamp        | Home        | 1100       |
| Wireless Earbuds  | Electronics | 3200       |

- **Columns on orders:** A order_id, B order_month, C first_name, D last_name, E region, F rep_name, G item, H quantity, I status, J amount, then the added columns K clean_first_name, L clean_last_name, M category, N unit_price, O revenue_calc.
- **Filter and sort applied before building completed_orders:** I filtered status = completed (63 rows visible), then sorted those rows by amount from largest to smallest, keeping ties in order_id ascending order. I pasted the 63 visible rows **as values** into a new tab, completed_orders. There I deleted the raw first_name and last_name columns and arranged the rest as in task 8.
- **XLOOKUP fallback test (spare cell outside the data):** R1 holds the text Mystery Item and S1 holds =XLOOKUP(R1,products!\$A\$2:\$A\$10,products!\$C\$2:\$C\$10,"UNKNOWN_ITEM"). S1 shows UNKNOWN_ITEM, so the fallback works. No order in the seed uses an item that's missing from products, so the fallback never fires on the real rows.

## (a) Formulas typed in the first data row (row 2 of orders)

| Added column     | Cell | Formula (as text)                                                            |
| ---------------- | ---- | ---------------------------------------------------------------------------- |
| clean_first_name | K2   | \=PROPER(TRIM(C2))                                                           |
| clean_last_name  | L2   | \=PROPER(TRIM(D2))                                                           |
| category         | M2   | \=VLOOKUP(G2,products!\$A\$2:\$C\$10,2,FALSE)                                |
| unit_price       | N2   | \=XLOOKUP(G2,products!\$A\$2:\$A\$10,products!\$C\$2:\$C\$10,"UNKNOWN_ITEM") |
| revenue_calc     | O2   | \=N2\*H2                                                                     |

I copied all five down all 90 rows. The lookup ranges are fully absolute (\$A\$2:\$C\$10, \$A\$2:\$A\$10, \$C\$2:\$C\$10), so they don't drift when copied down. TRIM removes leading, trailing and doubled spaces. PROPER then gives each word one capital letter followed by lower case, so ' Vikram' becomes Vikram and 'RAHUL' becomes Rahul.

## (b) Aggregates on completed_orders (labelled block O1:P6, outside the exported range A1:M64)

| Metric  | Formula           | Value   |
| ------- | ----------------- | ------- |
| COUNT   | \=COUNT(K2:K64)   | 63      |
| SUM     | \=SUM(K2:K64)     | 346200  |
| AVERAGE | \=AVERAGE(K2:K64) | 5495.24 |
| MIN     | \=MIN(K2:K64)     | 1100    |
| MAX     | \=MAX(K2:K64)     | 15600   |

(Column K is amount on completed_orders. The exact average is 5495.238095..., which I show to two decimals.)

## (c) Pivot tables (built from completed_orders)

**Pivot (i): rows = category, columns = region, values = SUM of amount**

| category        | East      | North      | South     | West      | Grand Total |
| --------------- | --------- | ---------- | --------- | --------- | ----------- |
| Apparel         | 10600     | 19400      | 10000     | 37500     | 77500       |
| Electronics     | 21400     | 73400      | 28700     | 18800     | 142300      |
| Home            | 37500     | 26500      | 43800     | 18600     | 126400      |
| **Grand Total** | **69500** | **119300** | **82500** | **74900** | **346200**  |

**Pivot (ii): rows = order_month, values = SUM of amount and COUNT of order_id**

| order_month     | Sum of amount | Count of order_id |
| --------------- | ------------- | ----------------- |
| 2026-09         | 98300         | 19                |
| 2026-10         | 93100         | 20                |
| 2026-11         | 154800        | 24                |
| **Grand Total** | **346200**    | **63**            |

## (d) Reconciliation with Part A (q05)

| Measure | Spreadsheet (completed_orders) | Part A q05                | Match / Mismatch |
| ------- | ------------------------------ | ------------------------- | ---------------- |
| COUNT   | 63                             | 63 (total_orders)         | Match            |
| SUM     | 346200                         | 346200 (total_revenue)    | Match            |
| AVERAGE | 5495.24                        | 5495.24 (avg_order_value) | Match            |

## (e) Data validation

- **Missing amounts:** Three orders have no amount: 1001, 1010 and 1064 (the rows q02 returns). All three are pending, so none of them ends up in completed_orders. I left them blank in orders rather than typing 0 or guessing a price. A 0 would look like a real sale of Rs 0 and pull the averages down. A blank is also what SQL's SUM and AVG skip, so the spreadsheet and the SQL stay consistent.
- **Data types:** amount and quantity are real numbers, not text. They right-align, and =COUNT(K2:K64) returns 63, the same as =COUNTA(K2:K64). order_month is plain text on purpose (2026-09, 2026-10, 2026-11). One more check: amount equals revenue_calc (unit_price x quantity) on all 63 completed orders, so the lookups and the recorded amounts agree.
- **Duplicates and outliers:** None of the 63 completed orders repeats an order_id. The largest completed amount is **15600**, and four orders share it: **1061, 1065, 1069 and 1077**. Each one is 3 Air Fryers at 5200, so it's a genuine maximum and not a mistake. I kept them.
- **Note for whoever inherits this sheet:** always filter status = completed before adding up amount, and never fill a blank amount with 0 or with revenue_calc. revenue_calc is only a cross-check. amount is the source of truth.