# [SQL] Explore Ecommerce Dataset
<h2>I. Introduction</h1>
<p>In this project, I explored an E-commerce dataset using SQL on <a href="https://cloud.google.com/bigquery">Google BigQuery</a> to uncover insights into operational performance.</p>
<p>The dataset is based on the Google Analytics public dataset and contains data from an E-commerce website.</p>
<p>My primary objective is to assess key metrics that impact customer satisfaction, revenue growth, and operational efficiency.</p>
<h2>II. Requirements</h2>
<ul>
  <li><a href="https://cloud.google.com/bigquery">SQL Query Editor or IDE</a></li>
  <li><a href="https://support.google.com/analytics/answer/3437719?hl=en">Table Schema</a></li>
  <li><a href="https://cloud.google.com/bigquery/docs/reference/standard-sql/format-elements">Format Element</a></li>
</ul>
<h2>III. Data Access</h2>
<ul>
  <li>Log in to your Google Cloud Platform account and create a new project.</li>
  <li>Navigate to the BigQuery console and select your newly created project.</li>
  <li>In the navigation panel, select "Add Data" and then "Search a Project".</li>
  <li>Enter the project ID "bigquery-public-data.google_analytics_sample.ga_sessions_2017" and click "Enter".</li>
  <li>Click on the "ga_sessions_" table to open it.</li>
</ul>
<h2>IV. Exploring the Dataset</h2>
<p>In this project, I will write 08 query in Bigquery base on Google Analytics dataset.</p>
<h3>Query 01: Calculate Total visit, Pageview and Transaction for January, February and March 2017</h3>
<h5>SQL Query Example</h5>
<div class="code-box">
  <pre><code>
SELECT
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  SUM(totals.visits) AS visits,
  SUM(totals.pageviews) AS pageviews,
  SUM(totals.transactions) AS transactions,
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331'
GROUP BY 1
ORDER BY 1;
  </code></pre>
</div>
<h5>Query results</h5>
<img src="https://github.com/user-attachments/assets/a2f4dd3e-0be8-4ae3-8202-773a8e9c4eda"  style="width: 100%;">
<h3>Query 02: Bounce rate per traffic source in July 2017</h3>
<h5>SQL Query Example</h5>
<div class="code-box">
  <pre><code>
SELECT
    trafficSource.source as source,
    sum(totals.visits) as total_visits,
    sum(totals.Bounces) as total_no_of_bounces,
    (sum(totals.Bounces)/sum(totals.visits))* 100 as bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY source
ORDER BY total_visits DESC;
  </code></pre>
</div>
<h5>Query results</h5>
<img src="https://github.com/user-attachments/assets/28736980-e79e-4611-8490-4c15f3f86f13"  style="width: 100%;">
<h3>Query 3: Revenue by traffic source by week, by month in June 2017</h3>
<h5>SQL Query Example</h5>
<div class="code-box">
  <pre><code>
WITH month_data as(
  SELECT
    "Month" as time_type,
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    trafficSource.source AS source,
    SUM(p.productRevenue)/1000000 AS revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    unnest(hits) hits,
    unnest(product) p
  WHERE p.productRevenue is not null
  GROUP BY 1,2,3
  order by revenue DESC
),
week_data as(
  SELECT
    "Week" as time_type,
    format_date("%Y%W", parse_date("%Y%m%d", date)) as week,
    trafficSource.source AS source,
    SUM(p.productRevenue)/1000000 AS revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    unnest(hits) hits,
    unnest(product) p
  WHERE p.productRevenue is not null
  GROUP BY 1,2,3
  ORDER BY revenue DESC
)
SELECT * FROM month_data
UNION ALL
SELECT * FROM week_data
ORDER BY time_type;
  </code></pre>
</div>
<h5>Query results</h5>
<img src="https://github.com/user-attachments/assets/18c9af75-e874-40db-b5c6-f82ef1ff8bb7"  style="width: 100%;">
<h3>Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017</h3>
<h5>SQL Query Example</h5>
<div class="code-box">
  <pre><code>
with 
purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      (sum(totals.pageviews)/count(distinct fullvisitorid)) as avg_pageviews_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions>=1
  and product.productRevenue is not null
  group by month
),

non_purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.pageviews)/count(distinct fullvisitorid) as avg_pageviews_non_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
      ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions is null
  and product.productRevenue is null
  group by month
)
select
    pd.*,
    avg_pageviews_non_purchase
from purchaser_data pd
full join non_purchaser_data using(month)
order by pd.month;
  </code></pre>
</div>
<h5>Query results</h5>
<img src="https://github.com/user-attachments/assets/639eda90-6d13-4e76-9001-178a908d3c42"  style="width: 100%;">
