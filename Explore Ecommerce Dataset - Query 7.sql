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
