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