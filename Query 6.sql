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