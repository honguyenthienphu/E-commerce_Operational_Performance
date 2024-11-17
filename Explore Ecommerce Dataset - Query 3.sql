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