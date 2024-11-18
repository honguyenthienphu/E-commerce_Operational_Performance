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
