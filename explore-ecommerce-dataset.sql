-- Query 1
SELECT
  SUBSTRING(date, 1, 6) AS month,
  COUNT(visitId) AS visits,
  SUM(totals.pageviews) AS pageviews,
  SUM(totals.transactions) as transactions
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_2017*` 
WHERE 
  _table_suffix BETWEEN '0101' AND '0331'
GROUP BY
  month
ORDER BY
  month ASC;

-- Query 2
SELECT
  trafficSource.`source` AS source,
  COUNT(visitId) AS total_visits,
  COUNT(totals.bounces) AS total_no_of_bounces,
  ROUND(COUNT(totals.bounces) / COUNT(visitId) * 100.0, 3) AS bounce_rate
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE
  _table_suffix BETWEEN '0701' AND '0731'
GROUP BY
  source
ORDER BY
  total_visits DESC;

-- Query 3
WITH month_table AS (
  SELECT
    'MONTH' AS time_type,
    SUBSTRING(date, 1, 6) AS time,
    trafficSource.`source` AS source,
    ROUND(SUM(product.productRevenue) / 1000000, 4) AS revenue
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    UNNEST(hits) hits,
    UNNEST(product) product
  WHERE
    _table_suffix BETWEEN '0601' AND '0630'
    AND product.productRevenue IS NOT NULL
  GROUP BY
    time,
    source
),
week_table AS (
  SELECT
    'WEEK' AS time_type,
    FORMAT_TIMESTAMP('%Y%W', PARSE_TIMESTAMP('%Y%m%d', date)) AS time,
    trafficSource.`source` AS source,
    ROUND(SUM(product.productRevenue) / 1000000, 4) AS revenue
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    unnest(hits) hits,
    unnest(product) product
  WHERE
    _table_suffix BETWEEN "0612" AND "0625"
    AND product.productRevenue IS NOT NULL
  GROUP BY
    time,
    source
)
SELECT * FROM month_table
UNION ALL
SELECT * FROM week_table
ORDER BY
  revenue DESC;

-- Query 4
WITH purchase_table AS (
  SELECT
    SUBSTRING(date, 1, 6) AS month,
    ROUND(SUM(totals.pageviews) / COUNT(DISTINCT(fullVisitorId)), 7) AS avg_pageviews_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product)
  WHERE
    _table_suffix BETWEEN '0601' AND '0731' 
    AND totals.transactions >=1 
    AND productRevenue IS NOT NULL
  GROUP BY
    month
),
non_purchase_table AS (
  SELECT
    SUBSTRING(date, 1, 6) AS month,
    ROUND(SUM(totals.pageviews) / COUNT(DISTINCT(fullVisitorId)), 7) AS avg_pageviews_non_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product)
  WHERE
    _table_suffix BETWEEN '0601' AND '0731' 
    AND totals.transactions IS NULL
    AND productRevenue IS NULL
  GROUP BY
    month
)
SELECT
  pt.month,
  avg_pageviews_purchase,
  avg_pageviews_non_purchase
FROM
  purchase_table pt
LEFT JOIN
  non_purchase_table nt
  ON pt.month = nt.month
ORDER BY
  pt.month ASC;

-- Query 5
SELECT
  SUBSTRING(date, 1, 6) AS month,
  ROUND(SUM(totals.transactions) / COUNT(DISTINCT(fullVisitorId)), 9) AS Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
  UNNEST(hits) AS hits,
  UNNEST(hits.product)
WHERE
  _table_suffix BETWEEN '0701' AND '0731'
  AND totals.transactions >= 1
  AND productRevenue IS NOT NULL
GROUP BY
  month;

-- Query 6
SELECT
  SUBSTRING(date, 1, 6) AS month,
  ROUND((SUM(productRevenue) / COUNT(visitId)) / 1000000, 2) AS avg_revenue_by_user_per_visit
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
  UNNEST(hits) AS hits,
  UNNEST(hits.product)
WHERE
  _table_suffix BETWEEN '0701' AND '0731'
  AND totals.transactions >= 1
  AND productRevenue IS NOT NULL
GROUP BY
  month;

-- Query 7
WITH selected_customer AS (
  SELECT
    DISTINCT(visitId) 
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    UNNEST(hits) hits,
    UNNEST(product) product
  WHERE
    v2ProductName = "YouTube Men's Vintage Henley"
    AND _table_suffix BETWEEN '0701' AND '0731'
    AND product.productRevenue IS NOT NULL
)
SELECT
  v2ProductName AS other_purchased_products,
  SUM(productQuantity) AS quantity
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
  UNNEST(hits) hits,
  UNNEST(product) product
WHERE
  visitId IN (SELECT visitId FROM selected_customer)
  AND v2ProductName <> "YouTube Men's Vintage Henley"
  AND _table_suffix BETWEEN '0701' AND '0731'
  AND product.productRevenue IS NOT NULL
GROUP BY
  other_purchased_products
ORDER BY
  quantity DESC;

-- Query 8
WITH combined_table AS (
  SELECT
    SUBSTRING(date, 1, 6) AS month,
    COUNTIF(eCommerceAction.action_type = '2') AS num_product_view,
    COUNTIF(eCommerceAction.action_type = '3') AS num_addtocart,
    COUNTIF(eCommerceAction.action_type = '6' AND productRevenue IS NOT NULL) AS num_purchase
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_2017*` AS sessions,
    UNNEST(sessions.hits) AS hits,
    UNNEST(hits.product) AS product
  WHERE 
    _table_suffix BETWEEN '0101' AND '0331'
  GROUP BY
    month
)
SELECT
  month,
  num_product_view,
  num_addtocart,
  num_purchase,
  ROUND(num_addtocart / num_product_view * 100, 2) AS add_to_cart_rate,
  ROUND(num_purchase / num_product_view * 100, 2) AS purchase_rate
FROM
  combined_table
ORDER BY
  month ASC;