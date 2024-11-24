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
