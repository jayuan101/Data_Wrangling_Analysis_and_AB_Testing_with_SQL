-- Exercise 1: Create a subtable of orders per day. Make sure you decide whether you are counting invoices or line items.
SELECT DATE(paid_at) AS order_day,
COUNT(*) AS line_item_count
FROM dsv1069.orders
GROUP BY DATE(paid_at);

-- Exercise 2: “Check your joins”. We are still trying to count orders per day. In this step join the
-- sub table from the previous exercise to the dates rollup table so we can get a row for every
-- date. Check that the join works by just running a “select *” query
SELECT *
FROM
(SELECT DATE(paid_at) AS order_day, COUNT(DISTINCT invoice_id) AS invoice_count
FROM dsv1069.orders
GROUP BY DATE(paid_at)) AS orders_per_day
JOIN
dsv1069.dates_rollup
ON orders_per_day.order_day = dates_rollup.date;
-- Exercise 3: “Clean up your Columns” In this step be sure to specify the columns you actually 
-- want to return, and if necessary do any aggregation needed to get a count of the orders made per day.
SELECT DATE(created_at) AS order_day, COUNT(*) AS line_item_count
FROM dsv1069.orders
GROUP BY DATE(created_at);
-- Exercise 4: Weekly Rollup. Figure out which parts of the JOIN condition need to be edited create 7 day rolling orders table.
-- Exercise 4: Weekly Rollup. Figure out which parts of the JOIN condition need to be edited create 7 day rolling orders table.
SELECT *
FROM dsv1069.dates_rollup
LEFT OUTER JOIN
 (SELECT DATE (orders.paid_at) AS day,
  COUNT (DISTINCT invoice_id) AS orders,
  COUNT (DISTINCT line_item_id) AS items_ordered
  FROM dsv1069.orders
  GROUP BY DATE (orders.paid_at)) daily_orders
ON daily_orders.day BETWEEN dates_rollup.date AND dates_rollup.d7_ago

-- Exercise 5: Column Cleanup. Finish creating the weekly rolling orders table, by performing any aggregation steps and naming your columns appropriately.
SELECT dates_rollup.date, SUM(daily_orders.orders) AS total_orders, SUM(daily_orders.items_ordered) AS total_items_ordered
FROM dsv1069.dates_rollup
LEFT OUTER JOIN
 (SELECT DATE (orders.paid_at) AS day,
  COUNT (DISTINCT invoice_id) AS orders,
  COUNT (DISTINCT line_item_id) AS items_ordered
  FROM dsv1069.orders
  GROUP BY DATE (orders.paid_at)) daily_orders
ON daily_orders.day BETWEEN dates_rollup.date AND dates_rollup.d7_ago
GROUP BY dates_rollup.date
ORDER BY dates_rollup.date;