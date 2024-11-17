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