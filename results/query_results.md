# Query Results

All queries were run in SQLite (SQLite dialect) against the data loaded by sql/00_schema_and_seed.sql. Every result is shown in full. NULL values are shown as NULL. In q04 and q09, some names carry leading/trailing spaces in the data; Markdown does not display them.

## Seed check

Row counts after loading sql/00_schema_and_seed.sql (all four match the brief):

| table     | SELECT COUNT(\*) | expected |
| --------- | ---------------- | -------- |
| reps      | 4                | 4        |
| products  | 9                | 9        |
| customers | 24               | 24       |
| orders    | 90               | 90       |

## q01

Business question: which orders are still pending, so the team can chase them?

**Rows returned:** 19

| order_id | customer_id | item              | amount |
| -------- | ----------- | ----------------- | ------ |
| 1001     | 10          | Bluetooth Speaker | NULL   |
| 1002     | 16          | Smart Watch       | 4500   |
| 1004     | 19          | Cotton Kurta      | 2800   |
| 1010     | 19          | Wireless Earbuds  | NULL   |
| 1033     | 18          | Denim Jacket      | 2500   |
| 1035     | 5           | Bluetooth Speaker | 2800   |
| 1036     | 22          | Denim Jacket      | 5000   |
| 1037     | 3           | Bedsheet Set      | 3800   |
| 1042     | 14          | Table Lamp        | 1100   |
| 1044     | 10          | Running Shoes     | 3600   |
| 1052     | 15          | Smart Watch       | 13500  |
| 1057     | 4           | Bluetooth Speaker | 2800   |
| 1058     | 13          | Bedsheet Set      | 1900   |
| 1063     | 10          | Air Fryer         | 5200   |
| 1064     | 20          | Bluetooth Speaker | NULL   |
| 1068     | 23          | Air Fryer         | 5200   |
| 1071     | 22          | Air Fryer         | 5200   |
| 1075     | 4           | Running Shoes     | 3600   |
| 1078     | 3           | Cotton Kurta      | 1400   |

## q02

Business question: which orders have a missing amount and need a data fix?

**Rows returned:** 3

| order_id | customer_id | item              | status  |
| -------- | ----------- | ----------------- | ------- |
| 1001     | 10          | Bluetooth Speaker | pending |
| 1010     | 19          | Wireless Earbuds  | pending |
| 1064     | 20          | Bluetooth Speaker | pending |

## q03

Business question: what are the five biggest completed orders by amount?

**Rows returned:** 5

| order_id | customer_id | item        | amount |
| -------- | ----------- | ----------- | ------ |
| 1061     | 16          | Air Fryer   | 15600  |
| 1065     | 22          | Air Fryer   | 15600  |
| 1069     | 15          | Air Fryer   | 15600  |
| 1077     | 3           | Air Fryer   | 15600  |
| 1006     | 5           | Smart Watch | 13500  |

## q04

Business question: who are the North or West customers aged 25 to 40 (target segment)?

**Rows returned:** 8

| customer_id | first_name | last_name | region | age |
| ----------- | ---------- | --------- | ------ | --- |
| 24          | Reena      | Kulkarni  | West   | 25  |
| 8           | Divya      | Gupta     | West   | 26  |
| 17          | Farhan     | Shah      | North  | 27  |
| 1           | aarav      | Sharma    | North  | 28  |
| 16          | Nisha      | Mishra    | West   | 36  |
| 5           | Vikram     | Singh     | North  | 37  |
| 12          | Pooja      | Menon     | West   | 39  |
| 21          | Manoj      | Desai     | North  | 40  |

## q05

Business question: what are the headline KPIs across completed orders?

**Rows returned:** 1

| total_orders | total_revenue | avg_order_value | min_order_value | max_order_value |
| ------------ | ------------- | --------------- | --------------- | --------------- |
| 63           | 346200        | 5495.24         | 1100            | 15600           |

## q06

Business question: how many orders and how much money sit in each order status?

**Rows returned:** 3

| status    | number_of_orders | total_amount |
| --------- | ---------------- | ------------ |
| completed | 63               | 346200       |
| pending   | 19               | 64900        |
| disputed  | 8                | 73200        |

## q07

Business question: which items are strong sellers (completed revenue above 20000)?

**Rows returned:** 4

| item             | number_of_orders | revenue |
| ---------------- | ---------------- | ------- |
| Air Fryer        | 9                | 104000  |
| Smart Watch      | 9                | 67500   |
| Wireless Earbuds | 11               | 60800   |
| Running Shoes    | 8                | 43200   |

## q08

Business question: what does the customer base look like (size and age) in each region?

**Rows returned:** 4

| region | number_of_customers | average_age | min_age | max_age |
| ------ | ------------------- | ----------- | ------- | ------- |
| East   | 6                   | 34.0        | 29      | 41      |
| North  | 6                   | 37.5        | 27      | 48      |
| South  | 6                   | 36.33       | 24      | 52      |
| West   | 6                   | 28.5        | 22      | 39      |

## q09

Business question: one order-level fact table with customer, region and rep attached (input to Part B).

**Rows returned:** 90

| order_id | order_month | first_name | last_name | region | rep_name      | item              | quantity | status    | amount |
| -------- | ----------- | ---------- | --------- | ------ | ------------- | ----------------- | -------- | --------- | ------ |
| 1001     | 2026-09     | MEERA      | Patil     | South  | Kavya Nair    | Bluetooth Speaker | 2        | pending   | NULL   |
| 1002     | 2026-09     | Nisha      | Mishra    | West   | Neha Kulkarni | Smart Watch       | 1        | pending   | 4500   |
| 1003     | 2026-09     | Lakshmi    | Kapoor    | South  | Kavya Nair    | Air Fryer         | 2        | disputed  | 10400  |
| 1004     | 2026-09     | Gaurav     | Yadav     | East   | Sanjay Roy    | Cotton Kurta      | 2        | pending   | 2800   |
| 1005     | 2026-09     | Tanvi      | Thakur    | South  | Kavya Nair    | Table Lamp        | 1        | completed | 1100   |
| 1006     | 2026-09     | Vikram     | Singh     | North  | Arjun Mehta   | Smart Watch       | 3        | completed | 13500  |
| 1007     | 2026-09     | Tanvi      | Thakur    | South  | Kavya Nair    | Bedsheet Set      | 1        | completed | 1900   |
| 1008     | 2026-09     | Sneha      | Das       | West   | Neha Kulkarni | Wireless Earbuds  | 2        | completed | 6400   |
| 1009     | 2026-09     | RAHUL      | VERMA     | East   | Sanjay Roy    | Bedsheet Set      | 1        | completed | 1900   |
| 1010     | 2026-09     | Gaurav     | Yadav     | East   | Sanjay Roy    | Wireless Earbuds  | 1        | pending   | NULL   |
| 1011     | 2026-09     | Isha       | Pillai    | West   | Neha Kulkarni | Air Fryer         | 3        | disputed  | 15600  |
| 1012     | 2026-09     | Sneha      | Das       | West   | Neha Kulkarni | Running Shoes     | 1        | completed | 3600   |
| 1013     | 2026-09     | Harsh      | Chopra    | East   | Sanjay Roy    | Smart Watch       | 2        | disputed  | 9000   |
| 1014     | 2026-09     | Aditya     | Rao       | East   | Sanjay Roy    | Smart Watch       | 1        | completed | 4500   |
| 1015     | 2026-09     | Lakshmi    | Kapoor    | South  | Kavya Nair    | Smart Watch       | 2        | completed | 9000   |
| 1016     | 2026-09     | Pooja      | Menon     | West   | Neha Kulkarni | Denim Jacket      | 3        | completed | 7500   |
| 1017     | 2026-09     | Vikram     | Singh     | North  | Arjun Mehta   | Wireless Earbuds  | 1        | completed | 3200   |
| 1018     | 2026-09     | Manoj      | Desai     | North  | Arjun Mehta   | Bedsheet Set      | 2        | completed | 3800   |
| 1019     | 2026-09     | Vikram     | Singh     | North  | Arjun Mehta   | Running Shoes     | 2        | completed | 7200   |
| 1020     | 2026-09     | Tanvi      | Thakur    | South  | Kavya Nair    | Wireless Earbuds  | 2        | completed | 6400   |
| 1021     | 2026-09     | Manoj      | Desai     | North  | Arjun Mehta   | Air Fryer         | 2        | completed | 10400  |
| 1022     | 2026-09     | Vikram     | Singh     | North  | Arjun Mehta   | Air Fryer         | 2        | completed | 10400  |
| 1023     | 2026-09     | Manoj      | Desai     | North  | Arjun Mehta   | Running Shoes     | 1        | completed | 3600   |
| 1024     | 2026-09     | Priya      | iyer      | South  | Kavya Nair    | Cotton Kurta      | 1        | completed | 1400   |
| 1025     | 2026-09     | Divya      | Gupta     | West   | Neha Kulkarni | Table Lamp        | 1        | completed | 1100   |
| 1026     | 2026-09     | Vikram     | Singh     | North  | Arjun Mehta   | Cotton Kurta      | 1        | completed | 1400   |
| 1027     | 2026-10     | aarav      | Sharma    | North  | Arjun Mehta   | Smart Watch       | 1        | completed | 4500   |
| 1028     | 2026-10     | Swati      | Banerjee  | South  | Kavya Nair    | Wireless Earbuds  | 1        | completed | 3200   |
| 1029     | 2026-10     | Aditya     | Rao       | East   | Sanjay Roy    | Denim Jacket      | 2        | completed | 5000   |
| 1030     | 2026-10     | Lakshmi    | Kapoor    | South  | Kavya Nair    | Denim Jacket      | 2        | completed | 5000   |
| 1031     | 2026-10     | Isha       | Pillai    | West   | Neha Kulkarni | Denim Jacket      | 2        | disputed  | 5000   |
| 1032     | 2026-10     | karthik    | nair      | East   | Sanjay Roy    | Table Lamp        | 2        | completed | 2200   |
| 1033     | 2026-10     | Swati      | Banerjee  | South  | Kavya Nair    | Denim Jacket      | 1        | pending   | 2500   |
| 1034     | 2026-10     | Divya      | Gupta     | West   | Neha Kulkarni | Running Shoes     | 2        | completed | 7200   |
| 1035     | 2026-10     | Vikram     | Singh     | North  | Arjun Mehta   | Bluetooth Speaker | 1        | pending   | 2800   |
| 1036     | 2026-10     | Tanvi      | Thakur    | South  | Kavya Nair    | Denim Jacket      | 2        | pending   | 5000   |
| 1037     | 2026-10     | RAHUL      | VERMA     | East   | Sanjay Roy    | Bedsheet Set      | 2        | pending   | 3800   |
| 1038     | 2026-10     | RAHUL      | VERMA     | East   | Sanjay Roy    | Cotton Kurta      | 2        | completed | 2800   |
| 1039     | 2026-10     | RAHUL      | VERMA     | East   | Sanjay Roy    | Table Lamp        | 2        | completed | 2200   |
| 1040     | 2026-10     | aarav      | Sharma    | North  | Arjun Mehta   | Smart Watch       | 3        | completed | 13500  |
| 1041     | 2026-10     | Divya      | Gupta     | West   | Neha Kulkarni | Bluetooth Speaker | 1        | completed | 2800   |
| 1042     | 2026-10     | Lakshmi    | Kapoor    | South  | Kavya Nair    | Table Lamp        | 1        | pending   | 1100   |
| 1043     | 2026-10     | Rohit      | Khan      | North  | Arjun Mehta   | Bluetooth Speaker | 1        | completed | 2800   |
| 1044     | 2026-10     | MEERA      | Patil     | South  | Kavya Nair    | Running Shoes     | 1        | pending   | 3600   |
| 1045     | 2026-10     | Nisha      | Mishra    | West   | Neha Kulkarni | Cotton Kurta      | 3        | completed | 4200   |
| 1046     | 2026-10     | Vikram     | Singh     | North  | Arjun Mehta   | Bedsheet Set      | 1        | completed | 1900   |
| 1047     | 2026-10     | Isha       | Pillai    | West   | Neha Kulkarni | Wireless Earbuds  | 3        | disputed  | 9600   |
| 1048     | 2026-10     | Priya      | iyer      | South  | Kavya Nair    | Table Lamp        | 1        | completed | 1100   |
| 1049     | 2026-10     | aarav      | Sharma    | North  | Arjun Mehta   | Smart Watch       | 2        | completed | 9000   |
| 1050     | 2026-10     | Pooja      | Menon     | West   | Neha Kulkarni | Running Shoes     | 1        | completed | 3600   |
| 1051     | 2026-10     | Sneha      | Das       | West   | Neha Kulkarni | Cotton Kurta      | 2        | completed | 2800   |
| 1052     | 2026-10     | Aditya     | Rao       | East   | Sanjay Roy    | Smart Watch       | 3        | pending   | 13500  |
| 1053     | 2026-10     | Tanvi      | Thakur    | South  | Kavya Nair    | Air Fryer         | 1        | completed | 5200   |
| 1054     | 2026-10     | Manoj      | Desai     | North  | Arjun Mehta   | Wireless Earbuds  | 3        | completed | 9600   |
| 1055     | 2026-10     | Swati      | Banerjee  | South  | Kavya Nair    | Smart Watch       | 1        | completed | 4500   |
| 1056     | 2026-10     | Pooja      | Menon     | West   | Neha Kulkarni | Wireless Earbuds  | 1        | disputed  | 3200   |
| 1057     | 2026-11     | Sneha      | Das       | West   | Neha Kulkarni | Bluetooth Speaker | 1        | pending   | 2800   |
| 1058     | 2026-11     | suresh     | BOSE      | North  | Arjun Mehta   | Bedsheet Set      | 1        | pending   | 1900   |
| 1059     | 2026-11     | Priya      | iyer      | South  | Kavya Nair    | Bluetooth Speaker | 2        | completed | 5600   |
| 1060     | 2026-11     | suresh     | BOSE      | North  | Arjun Mehta   | Wireless Earbuds  | 3        | disputed  | 9600   |
| 1061     | 2026-11     | Nisha      | Mishra    | West   | Neha Kulkarni | Air Fryer         | 3        | completed | 15600  |
| 1062     | 2026-11     | Isha       | Pillai    | West   | Neha Kulkarni | Wireless Earbuds  | 2        | completed | 6400   |
| 1063     | 2026-11     | MEERA      | Patil     | South  | Kavya Nair    | Air Fryer         | 1        | pending   | 5200   |
| 1064     | 2026-11     | Isha       | Pillai    | West   | Neha Kulkarni | Bluetooth Speaker | 1        | pending   | NULL   |
| 1065     | 2026-11     | Tanvi      | Thakur    | South  | Kavya Nair    | Air Fryer         | 3        | completed | 15600  |
| 1066     | 2026-11     | suresh     | BOSE      | North  | Arjun Mehta   | Wireless Earbuds  | 1        | completed | 3200   |
| 1067     | 2026-11     | Priya      | iyer      | South  | Kavya Nair    | Air Fryer         | 1        | completed | 5200   |
| 1068     | 2026-11     | Harsh      | Chopra    | East   | Sanjay Roy    | Air Fryer         | 1        | pending   | 5200   |
| 1069     | 2026-11     | Aditya     | Rao       | East   | Sanjay Roy    | Air Fryer         | 3        | completed | 15600  |
| 1070     | 2026-11     | MEERA      | Patil     | South  | Kavya Nair    | Table Lamp        | 2        | completed | 2200   |
| 1071     | 2026-11     | Tanvi      | Thakur    | South  | Kavya Nair    | Air Fryer         | 1        | pending   | 5200   |
| 1072     | 2026-11     | Isha       | Pillai    | West   | Neha Kulkarni | Bedsheet Set      | 1        | completed | 1900   |
| 1073     | 2026-11     | Harsh      | Chopra    | East   | Sanjay Roy    | Smart Watch       | 1        | completed | 4500   |
| 1074     | 2026-11     | Nisha      | Mishra    | West   | Neha Kulkarni | Running Shoes     | 2        | completed | 7200   |
| 1075     | 2026-11     | Sneha      | Das       | West   | Neha Kulkarni | Running Shoes     | 1        | pending   | 3600   |
| 1076     | 2026-11     | Gaurav     | Yadav     | East   | Sanjay Roy    | Cotton Kurta      | 2        | completed | 2800   |
| 1077     | 2026-11     | RAHUL      | VERMA     | East   | Sanjay Roy    | Air Fryer         | 3        | completed | 15600  |
| 1078     | 2026-11     | RAHUL      | VERMA     | East   | Sanjay Roy    | Cotton Kurta      | 1        | pending   | 1400   |
| 1079     | 2026-11     | Sneha      | Das       | West   | Neha Kulkarni | Cotton Kurta      | 1        | completed | 1400   |
| 1080     | 2026-11     | Harsh      | Chopra    | East   | Sanjay Roy    | Bluetooth Speaker | 1        | completed | 2800   |
| 1081     | 2026-11     | Vikram     | Singh     | North  | Arjun Mehta   | Wireless Earbuds  | 2        | completed | 6400   |
| 1082     | 2026-11     | karthik    | nair      | East   | Sanjay Roy    | Running Shoes     | 3        | disputed  | 10800  |
| 1083     | 2026-11     | Lakshmi    | Kapoor    | South  | Kavya Nair    | Air Fryer         | 2        | completed | 10400  |
| 1084     | 2026-11     | Lakshmi    | Kapoor    | South  | Kavya Nair    | Running Shoes     | 1        | completed | 3600   |
| 1085     | 2026-11     | aarav      | Sharma    | North  | Arjun Mehta   | Wireless Earbuds  | 1        | completed | 3200   |
| 1086     | 2026-11     | Manoj      | Desai     | North  | Arjun Mehta   | Running Shoes     | 2        | completed | 7200   |
| 1087     | 2026-11     | Manoj      | Desai     | North  | Arjun Mehta   | Smart Watch       | 1        | completed | 4500   |
| 1088     | 2026-11     | Sneha      | Das       | West   | Neha Kulkarni | Wireless Earbuds  | 1        | completed | 3200   |
| 1089     | 2026-11     | MEERA      | Patil     | South  | Kavya Nair    | Table Lamp        | 1        | completed | 1100   |
| 1090     | 2026-11     | karthik    | nair      | East   | Sanjay Roy    | Wireless Earbuds  | 3        | completed | 9600   |

## q10

Business question: which customers have never placed an order (re-engagement list)?

**Rows returned:** 4

| customer_id | first_name | last_name | region |
| ----------- | ---------- | --------- | ------ |
| 6           | Ananya     | Reddy     | South  |
| 11          | Imran      | Joshi     | East   |
| 17          | Farhan     | Shah      | North  |
| 24          | Reena      | Kulkarni  | West   |

## q11

Business question: how do completed orders, customers and revenue look by region and month?

**Rows returned:** 12

| region | order_month | number_of_orders | number_of_customers | total_revenue | average_revenue |
| ------ | ----------- | ---------------- | ------------------- | ------------- | --------------- |
| East   | 2026-09     | 2                | 2                   | 6400          | 3200.0          |
| East   | 2026-10     | 4                | 3                   | 12200         | 3050.0          |
| East   | 2026-11     | 6                | 5                   | 50900         | 8483.33         |
| North  | 2026-09     | 8                | 2                   | 53500         | 6687.5          |
| North  | 2026-10     | 6                | 4                   | 41300         | 6883.33         |
| North  | 2026-11     | 5                | 4                   | 24500         | 4900.0          |
| South  | 2026-09     | 5                | 3                   | 19800         | 3960.0          |
| South  | 2026-10     | 5                | 4                   | 19000         | 3800.0          |
| South  | 2026-11     | 7                | 4                   | 43700         | 6242.86         |
| West   | 2026-09     | 4                | 3                   | 18600         | 4650.0          |
| West   | 2026-10     | 5                | 4                   | 20600         | 4120.0          |
| West   | 2026-11     | 6                | 3                   | 35700         | 5950.0          |

## q12

Business question: which tier (High/Medium/Low) does each item's completed revenue fall into?

**Rows returned:** 9

| item              | total_revenue | contribution_tier |
| ----------------- | ------------- | ----------------- |
| Air Fryer         | 104000        | High              |
| Smart Watch       | 67500         | High              |
| Wireless Earbuds  | 60800         | High              |
| Running Shoes     | 43200         | Medium            |
| Denim Jacket      | 17500         | Medium            |
| Cotton Kurta      | 16800         | Medium            |
| Bluetooth Speaker | 14000         | Low               |
| Bedsheet Set      | 11400         | Low               |
| Table Lamp        | 11000         | Low               |

## q13

Business question: did each rep beat their monthly target in each month (completed orders only)?

**Rows returned:** 12

| rep_name      | order_month | monthly_target | revenue | performance_tier |
| ------------- | ----------- | -------------- | ------- | ---------------- |
| Arjun Mehta   | 2026-09     | 40000          | 53500   | Above Target     |
| Arjun Mehta   | 2026-10     | 40000          | 41300   | On Target        |
| Arjun Mehta   | 2026-11     | 40000          | 24500   | Below Target     |
| Kavya Nair    | 2026-09     | 20000          | 19800   | Below Target     |
| Kavya Nair    | 2026-10     | 20000          | 19000   | Below Target     |
| Kavya Nair    | 2026-11     | 20000          | 43700   | Above Target     |
| Neha Kulkarni | 2026-09     | 20000          | 18600   | Below Target     |
| Neha Kulkarni | 2026-10     | 20000          | 20600   | On Target        |
| Neha Kulkarni | 2026-11     | 20000          | 35700   | Above Target     |
| Sanjay Roy    | 2026-09     | 12000          | 6400    | Below Target     |
| Sanjay Roy    | 2026-10     | 12000          | 12200   | On Target        |
| Sanjay Roy    | 2026-11     | 12000          | 50900   | Above Target     |