# Dashboard Specification (Part C)

Tool target: Tableau Public. Source file: data/orders_clean.csv (63 completed orders). All money is in INR.

## 1\. Data source

Connect to data/orders_clean.csv (13 columns). I treat order_id as a Dimension because it's an identifier, not something to add up.

| Column           | Classification |
| ---------------- | -------------- |
| order_id         | Dimension      |
| order_month      | Dimension      |
| clean_first_name | Dimension      |
| clean_last_name  | Dimension      |
| region           | Dimension      |
| rep_name         | Dimension      |
| item             | Dimension      |
| category         | Dimension      |
| unit_price       | Measure        |
| quantity         | Measure        |
| amount           | Measure        |
| revenue_calc     | Measure        |
| status           | Dimension      |

That makes 9 Dimensions and 4 Measures. order_month has to be set to a string (text) data type so Tableau doesn't turn it into a date.

## 2\. KPI cards

| Card             | Definition    | Value it must show |
| ---------------- | ------------- | ------------------ |
| Total Revenue    | SUM(amount)   | 346,200 (INR)      |
| Total Units Sold | SUM(quantity) | 106 units          |

The Total Revenue card equals Part A q05 total_revenue (346200).

## 3\. Chart sheets

### Sheet 1: Revenue by Region (bar chart)

- Rows: region. Columns: SUM(amount). Colour: none (one colour, bars sorted descending).
- Why a bar chart: it compares one measure across a few separate regions, and bar length is easy to rank.

| region | Revenue (INR) |
| ------ | ------------- |
| North  | 119300        |
| South  | 82500         |
| West   | 74900         |
| East   | 69500         |

### Sheet 2: Revenue by Category (bar chart)

- Rows: category. Columns: SUM(amount). Colour: category.
- Why a bar chart: I'm comparing three categories on one measure, so bars show the ranking and the gaps right away.

| category    | Revenue (INR) |
| ----------- | ------------- |
| Electronics | 142300        |
| Home        | 126400        |
| Apparel     | 77500         |

### Sheet 3: Revenue Trend by Month and Category (line chart)

- Columns: order_month (discrete). Rows: SUM(amount). Colour: category (one line per category).
- Why a line chart: the question is how revenue changes over time, and lines make the direction and turning points easy to see.

| order_month | Apparel | Electronics | Home  | Total  |
| ----------- | ------- | ----------- | ----- | ------ |
| 2026-09     | 24700   | 43000       | 30600 | 98300  |
| 2026-10     | 30600   | 49900       | 12600 | 93100  |
| 2026-11     | 22200   | 49400       | 83200 | 154800 |

### Sheet 4: Region x Category Detail (text table)

- Rows: region. Columns: category. Text (label): SUM(amount). Colour: none.
- Why a text table: the reader needs the exact value for each region and category, and a chart would only give a rough idea.

| region | Apparel | Electronics | Home   | Total  |
| ------ | ------- | ----------- | ------ | ------ |
| East   | 10600   | 21400       | 37500  | 69500  |
| North  | 19400   | 73400       | 26500  | 119300 |
| South  | 10000   | 28700       | 43800  | 82500  |
| West   | 37500   | 18800       | 18600  | 74900  |
| Total  | 77500   | 142300      | 126400 | 346200 |

## 4\. Dashboard layout

From top to bottom, the dashboard is laid out like this:

1. **KPI cards:** a horizontal container with Total Revenue and Total Units Sold side by side.
2. **Category filter:** a category quick filter (multiple values, dropdown) in the top band, right below the KPI cards. I set it to Apply to Worksheets > All Using This Data Source, so it filters all four chart worksheets. The KPI cards share the data source, so they update too.
3. **Trend chart:** Revenue Trend by Month and Category, full width.
4. **Comparison charts:** a horizontal container with Revenue by Region on the left and Revenue by Category on the right.
5. **Detail table:** Region x Category Detail, full width at the bottom.

Containers: one outer vertical container holds the whole dashboard; inside it are a horizontal container for the KPI cards, the filter, the trend chart, a horizontal container for the two comparison charts, and the detail table as the last item.

Click behaviour: with Use as Filter switched on for Revenue by Region, clicking the North bar filters Revenue by Category, the trend chart, the detail table and the KPI cards down to North only. The region chart itself keeps all four bars and just highlights North.

## 5\. Insight and recommendation narrative

### Visualization summary

The dashboard shows completed-order revenue for Big Billion Days: 346,200 INR from 63 orders and 106 units. Two KPI cards sit at the top with a category filter under them. Below that come a monthly trend by category, the region and category comparisons side by side, and a table with the exact figure for each region and category. Every view adds up the same amount field from orders_clean.csv, so they all agree on one total.

### Summary analysis

1. **Regions:** North is clearly ahead with 119,300 (34.5% of revenue), that's about 1.7 times East, which is lowest at 69,500. South (82,500) and West (74,900) sit in the middle.
2. **Change across months (Home):** Home revenue dropped from 30,600 in 2026-09 to 12,600 in 2026-10, then shot up to 83,200 in 2026-11. That is 53.7% of November's 154,800, and it's the reason total revenue grew 66.3% over October's 93,100.
3. **A concern in North:** North went from 53,500 in 2026-09 to 41,300 in 2026-10 (-22.8%) and then to 24,500 in 2026-11. That's below Arjun Mehta's 40,000 target, in the same month the company grew fastest.
4. **Category mix:** Electronics is the biggest category at 142,300 (41.1%), and a lot of it sits in North (73,400, or 61.5% of North's revenue). West does best in Apparel (37,500) and sells only 18,800 of Electronics.

### Recommendations

1. **West / Electronics:** run an Electronics promotion for West customers, for example a Wireless Earbuds bundle. West Electronics is only 18,800 against 73,400 in North. A reasonable target is South's level of 28,700, which would add about 9,900. Metric to watch: West completed Electronics revenue per month.
2. **North / Home:** push Home items in North, especially Air Fryer stock and promotion. Home there is 26,500, compared with 43,800 in South and 37,500 in East. The aim is to close the 15,500 gap to the 40,000 target in 2026-11 (actual 24,500). Metric to watch: North monthly revenue against the 40,000 target.
3. **South / Apparel:** shift part of South's Apparel stock towards Home. South Apparel is 10,000, the lowest region-category figure, while Home sells 43,800 there. Apparel overall also fell 27.5%, from 30,600 in 2026-10 to 22,200 in 2026-11. Metric to watch: South Apparel sell-through and South Home revenue per month.

## 6\. Reconciliation

| Source                                                    | Revenue (INR) |
| --------------------------------------------------------- | ------------- |
| Total Revenue KPI                                         | 346200        |
| Sum of Revenue by Region (119300 + 82500 + 74900 + 69500) | 346200        |
| Sum of Revenue by Category (142300 + 126400 + 77500)      | 346200        |
| Part B pivot grand total                                  | 346200        |

All four values are equal.