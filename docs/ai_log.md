# AI Log (Part D)

## AI usage disclosure

I used an AI assistant (Claude, by Anthropic) while preparing this repository. It helped me copy the seed data from the brief, draft the SQL, generate the CSV exports, write the documents and draft the prompts in this log. I didn't take its word for anything. The query results come from actually running the SQL in SQLite, and I checked the key numbers against the brief's own checkpoints (row counts 4/9/24/90, 63 completed orders, revenue 346,200, 106 units). The spreadsheet figures were reproduced from the same data and formulas, and I confirm them in the spreadsheet myself. Every AI claim in this log was checked against the data.

## Task 1: Five-part prompt for Part A, q13

Role: You are a senior SQL analyst who writes clear, correct, portable SQL.  
<br/>Task: Write one query that reports each sales rep's completed-order revenue per month and classifies it against the rep's monthly target. Return the columns rep_name, order_month, monthly_target, revenue and performance_tier, grouped by rep, month and the rep's monthly_target, ordered by rep_name then order_month.  
<br/>Context: SQL dialect is SQLite. Tables and columns:  
reps(rep_id, rep_name, region, monthly_target)  
customers(customer_id, first_name, last_name, city, region, age, rep_id)  
orders(order_id, customer_id, item, quantity, amount, status, order_month)  
Join path: orders.customer_id = customers.customer_id and customers.rep_id = reps.rep_id.  
order_month is text such as '2026-09'. status is one of completed, pending, disputed.  
<br/>Constraints:  
\- Completed orders only (o.status = 'completed').  
\- performance_tier is 'Below Target' when revenue is below monthly_target, 'On Target' when revenue is at least monthly_target but below 1.1 x monthly_target, and 'Above Target' otherwise.  
\- Compute the tier from the full aggregate expression SUM(o.amount); do not reference an alias of an aggregate in WHERE.  
\- No WITH clauses (no CTEs) and no stored procedures.  
\- Qualify every column with its table alias.  
<br/>Format: Raw SQL only, no explanation and no Markdown fences, with short inline comments.

## Task 2: Defects in Scenario D1

Assistant's query (for the question "which regions sold the most?"):

SELECT region_name, SUM(total_sales) AS sales  
FROM sales  
WHERE SUM(total_sales) > 80000  
GROUP BY region_name  
ORDER BY sales DESC;

| #   | Defect                                                                                                                                                                                                                      | Classification       | Correct clause / fix                                                            |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- | ------------------------------------------------------------------------------- |
| 1   | FROM sales: there is no table named sales; running it in SQLite gives no such table: sales. The real tables are reps, products, customers, orders.                                                                          | Fake method/function | FROM orders AS o INNER JOIN customers AS c ON o.customer_id = c.customer_id     |
| 2   | region_name and total_sales do not exist as columns. Region is customers.region; the money column is orders.amount.                                                                                                         | Fake method/function | SELECT c.region, SUM(o.amount) AS sales                                         |
| 3   | WHERE SUM(total_sales) > 80000 puts an aggregate in WHERE, which is not allowed (rows are filtered before grouping). The query also never limits to completed orders, although revenue is defined as completed orders only. | Logic error          | WHERE o.status = 'completed' ... GROUP BY c.region HAVING SUM(o.amount) > 80000 |
| 4   | "North is the strongest region, and its revenue grew 38% month over month": no source or calculation backs the 38% figure, and the data contradicts it (see Task 3).                                                        | Phantom statistic    | Remove the claim, or replace it with the value computed from the data (-22.8%)  |

## Task 3: Verify Scenario D1

Corrected query, saved as sql/d1_corrected.sql:

SELECT c.region, SUM(o.amount) AS sales  
FROM orders AS o  
INNER JOIN customers AS c ON o.customer_id = c.customer_id  
WHERE o.status = 'completed'  
GROUP BY c.region  
HAVING SUM(o.amount) > 80000  
ORDER BY sales DESC;

Result when run on the seed (2 rows):

| region | sales  |
| ------ | ------ |
| North  | 119300 |
| South  | 82500  |

(The other two regions are below the threshold: West 74900 and East 69500. All four add up to 346200, the q05 total.)

North's actual month-over-month change from 2026-09 to 2026-10, using the q11 result: revenue was 53,500 in 2026-09 and 41,300 in 2026-10, so (41,300 - 53,500) / 53,500 = **\-22.8%**.

The assistant's claim of +38% is **contradicted by the data**. North's revenue fell by 22.8% between 2026-09 and 2026-10, and fell again in 2026-11, to 24,500. No month-to-month change for North in the data comes close to +38%.

## Task 4: Human-in-the-loop protocol applied to D1

**Specification.** Before judging the assistant's answer, I wrote down what a correct answer to "which regions sold the most?" needs: only real tables and columns (orders, customers), revenue as the sum of amount for completed orders only, the 80,000 threshold applied to each region's total, and no figure that can't be traced back to a query.

**Execution.** I ran the assistant's query exactly as written on the seed database. It failed straight away with no such table: sales, so it could never have produced the result it implied. Then I ran my corrected version, sql/d1_corrected.sql, and it worked.

**Inspection.** I went through the answer line by line and found four defects: a table that doesn't exist (sales), columns that don't exist (region_name, total_sales), an aggregate in WHERE, and a 38% growth figure with nothing behind it. Two are fake method/function, one is a logic error and one is a phantom statistic (see Task 2).

**Verification.** I checked my corrected query against independent numbers. It returns exactly 2 rows, North 119300 and South 82500. The four regional totals (119300 + 82500 + 74900 + 69500) add up to 346200, which is q05's total_revenue. North's total also matches the North rows of q11 (53500 + 41300 + 24500 = 119300). Then I worked out North's real change from 2026-09 to 2026-10 using q11 and got -22.8%, which contradicts the 38% claim.

**Decision.** **Reject** the assistant's original answer. The query can't run, its logic is wrong, and the 38% growth claim is false (evidence: the no such table: sales error, and q11 showing North going from 53,500 to 41,300, a -22.8% change). **Accept** my corrected version, sql/d1_corrected.sql, because it runs, returns North 119300 and South 82500, and ties back to the 346200 total in q05.

## Task 5: Prompt and root cause for Scenario D2

Role: You are a spreadsheet debugging assistant who explains the root cause before giving a fix.  
<br/>Task: Find the root cause of a lookup error and give a repaired formula.  
<br/>Context: The "products" tab occupies A1:C10 (header in row 1, item names in column A, unit prices in column C). On the "orders" tab, cell G2 (the item column) holds the text " Smart Watch" with a space before the first letter. The actual formula is =VLOOKUP(G2, \$A\$2:\$C\$10, 3, FALSE). It returns an error saying the value was not found, even though Smart Watch is in the table.  
Expected behaviour: the formula should return the unit price of Smart Watch (4500), and keep working for every row copied down.  
<br/>Constraints: Keep exact-match lookup (last argument FALSE); do not change or retype the data in the products tab; explain the cause in one or two sentences before the fix.  
<br/>Format: (1) Root cause in plain words, (2) the repaired formula on one line, (3) one quick check to confirm the fix worked.

**Root cause (my words):** G2 holds " Smart Watch" with a hidden space at the front, but the products tab has "Smart Watch" with no space. An exact-match lookup compares the whole text, so the two strings count as different and the lookup says "not found", even though they look identical on screen.

**Repaired formula:** =VLOOKUP(TRIM(G2),\$A\$2:\$C\$10,3,FALSE) (TRIM strips the leading space from the lookup key. If the formula is on a different tab from the products data, write the range as products!\$A\$2:\$C\$10).

## Task 6: Skeptical-analyst check on Part C (first recommendation)

Role: Act as a skeptical analyst who challenges business recommendations.  
<br/>Task: Challenge this recommendation: "Run an Electronics promotion for West customers, because West Electronics revenue is only 18,800 against 73,400 in North; target 28,700 (the South level)." List every assumption I have not stated, ask for evidence of cause and not just correlation, and say what data would confirm or weaken each assumption.  
<br/>Context: Completed-order data for Sep-Nov 2026 (63 orders, INR). Revenue by region: North 119300, South 82500, West 74900, East 69500. West by category: Apparel 37500, Electronics 18800, Home 18600. There is no promotion, price or marketing-spend column in the data.  
<br/>Constraints: Do not accept "revenue is low" as proof that a promotion would work; separate correlation from causation; keep to the numbers given.  
<br/>Format: A numbered list of assumptions, each with one check I can run on this dataset.

Unstated assumptions behind Recommendation 1, each with a check from my data:

1. **I assumed West's low Electronics revenue is a missed opportunity, not just what West customers prefer.** Check: West's Apparel revenue is 37,500 (50.1% of West's 74,900), the highest Apparel figure of any region. If West customers simply like Apparel, a promotion might move spend around instead of adding to it. I'd compare West's Electronics share (25.1%) with the other regions' shares.
2. **I assumed 18,800 is a stable measure of demand.** Check: it rests on only 4 completed West Electronics orders (6 units) over three months, and one of them (1062, 6,400) is about a third of the total. Adding or removing a single order moves the figure by 17% or more, so the gap could just be noise.
3. **I assumed the gap is about demand and not about conversion or fulfilment.** Check: West also has 2 disputed Electronics orders (12,800) and 3 pending ones (7,300, plus one with a missing amount). The non-completed West Electronics value (20,100) is bigger than the completed value (18,800). If those disputes were settled, the gap to North would shrink without any promotion.
4. **I assumed a promotion would cause the lift to 28,700.** Check: the data has no promotion, price or spend column, so I can't test cause here. All I have is a comparison across regions. A real test would run the promotion on some West customers and compare them with the rest. Also, every region has 6 customers, but only 3 West customers bought Electronics, so the limit may be the number of buyers and not the size of each basket.