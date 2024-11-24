# [SQL] E-commerce Operational Performance
<h2>I. Introduction</h1>
<p>In this project, focuses on analyzing an E-commerce dataset using SQL on <a href="https://cloud.google.com/bigquery">Google BigQuery</a> to uncover insights into operational performance.</p>
<p>The dataset sourced from the Google Analytics public dataset, captures extensive data from an E-commerce platform.</p>
<p>The primary goal was to evaluate key metrics influencing customer satisfaction, revenue growth, and operational efficiency, providing actionable insights for business improvement.</p>
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

<h3>1. Query 1 - Calculate total Visit, Pageview and Transaction for January, February and March 2017</h3>
<h4>Step:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Filter the data from January to March in 2017</li>
  <div class="code-box">
    <pre><code>
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331'
    </code></pre>
  </div>
  <li>Step 3: Count total Visit, Pageview and Transaction</li>
  <div class="code-box">
    <pre><code>
    SUM(totals.visits) AS visits,
    SUM(totals.pageviews) AS pageviews,
    SUM(totals.transactions) AS transactions
    </code></pre>  
  </div>
</ul>
<h4>Result:</h4>
<img src="https://github.com/user-attachments/assets/9f7fb8c3-f157-4a9a-8df1-8d9d572a7f2b" alt="Query 1" style="width: 100%;">

<h3>2. Query 2 - Calculate Bounce rate per traffic source in July 2017</h3>
<h4>Step:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Group the data by Traffic source</li>
  <li>Step 3: Calculate the Bounce rate per traffic source</li>
  <div class="code-box">
    <pre><code>
    trafficSource.source AS source,
    SUM(totals.visits) AS total_visits,
    SUM(totals.Bounces) AS total_no_of_bounces,
    (SUM(totals.Bounces)/SUM(totals.visits))* 100 AS bounce_rate
    </code></pre>  
  </div>
</ul>
<h4>Result:</h4>
<img src="https://github.com/user-attachments/assets/2048b600-f3d3-4c28-8a7d-39fa0c9d4bd0" alt="Query 2" style="width: 100%;">

<h3>3. Query 3 - Calculate Revenue by traffic source by week, by month in June 2017</h3>
<h4>Step:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Separate month and week data then union all</li>
  <li>Step 3: Unnest hits and product to access productRevenue field</li>
  <li>Step 4: Calculate Revenue by traffic source</li>
    <div class="code-box">
    <pre><code>
    WITH month_table AS (
      SELECT
        'MONTH' AS time_type,
        SUBSTRING(date, 1, 6) AS time,
        trafficSource.`source` AS source,
        ROUND(SUM(product.productRevenue) / 1000000, 4) AS revenue
    </code></pre>
    <pre><code>
    week_table AS (
      SELECT
        'WEEK' AS time_type,
        FORMAT_TIMESTAMP('%Y%W', PARSE_TIMESTAMP('%Y%m%d', date)) AS time,
        trafficSource.`source` AS source,
        ROUND(SUM(product.productRevenue) / 1000000, 4) AS revenue
    </code></pre>
    <pre><code>
    SELECT * FROM month_table
    UNION ALL
    SELECT * FROM week_table
    ORDER BY
      revenue DESC;
    </code></pre>  
  </div>
</ul>
<h4>Result:</h4>
<img src="https://github.com/user-attachments/assets/d0ba34b9-c6b8-43bb-9310-9c6710542d7f" alt="Query 3" style="width: 100%;">

<h3>4. Query 4 - Calculate Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017</h3>
<h4>Step:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Create a table with Purchaser</li>
    <div class="code-box">
    <pre><code>
    WITH purchase_table AS (
    SELECT
      SUBSTRING(date, 1, 6) AS month,
      ROUND(SUM(totals.pageviews) / COUNT(DISTINCT(fullVisitorId)), 7) AS avg_pageviews_purchase
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    </code></pre>
    </div>  
  <li>Step 3: Create a table with Non-Purchaser</li>
    <div class="code-box">
    <pre><code>
    non_purchase_table AS (
    SELECT
      SUBSTRING(date, 1, 6) AS month,
      ROUND(SUM(totals.pageviews) / COUNT(DISTINCT(fullVisitorId)), 7) AS avg_pageviews_non_purchase
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    </code></pre>
    </div>  
  <li>Step 4: Join two tables to compare Average number of pageviews</li>
</ul>
<h4>Result:</h4>
<img src="https://github.com/user-attachments/assets/1b579419-9d58-4caf-9cbf-67adf980ba2e" alt="Query 4" style="width: 100%;">

<h3>5. Query 5 - Calculate Average number of transactions per user that made a purchase in July 2017</h3>
<h4>Step:</h4>
<ul>
  <li>Step 1: Select the Dataset </li>
  <li>Step 2: Calculate Average number of transactions per user</li>
    <div class="code-box">
    <pre><code>
    SELECT
      SUBSTRING(date, 1, 6) AS month,
      ROUND(SUM(totals.transactions) / COUNT(DISTINCT(fullVisitorId)), 9) AS Avg_total_transactions_per_user
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    </code></pre>
    </div>  
</ul>
<h4>Result:</h4>
<img src="https://github.com/user-attachments/assets/4d9de549-c9ec-49b9-9c80-8b9db2e602ec" alt="Query 5" style="width: 100%;">

<h3>6. Query 6 - Calculate Average amount of money spent per session. Only include purchaser data in July 2017</h3>
<h4>Step:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Calculate Average amount of money spent per session</li>
    <div class="code-box">
    <pre><code>
    select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      ((sum(product.productRevenue)/sum(totals.visits))/power(10,6)) as avg_revenue_by_user_per_visit
    from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
      ,unnest(hits) hits
      ,unnest(product) product
    where product.productRevenue is not null
    and totals.transactions>=1
    group by month;
    </code></pre>
    </div>  
</ul>
<h4>Result:</h4>
<img src="https://github.com/user-attachments/assets/f988eec1-5fec-481a-9fa7-8b796dfa7dd5" alt="Query 6" style="width: 100%;">

<h3>7. Query 7 - Show product name and the quantity purchased from selected customer</h3>
<h4>Step:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Create a selected customer table</li>
    <div class="code-box">
    <pre><code>
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
      AND product.productRevenue IS NOT NULL)
    </code></pre>
    </div>  
</ul>
<h4>Result:</h4>
<img src="https://github.com/user-attachments/assets/a029c093-51b7-4136-b37d-606d201ce05b" alt="Query 7" style="width: 100%;">

<h3>8. Query 8 - Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017</h3>
<h4>Step:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Create a product data</li>
  <div class="code-box">
    <pre><code>
    with product_data as(
    select
      format_date('%Y%m', parse_date('%Y%m%d',date)) as month,
      count(CASE WHEN eCommerceAction.action_type = '2' THEN product.v2ProductName END) as num_product_view,
      count(CASE WHEN eCommerceAction.action_type = '3' THEN product.v2ProductName END) as num_add_to_cart,
      count(CASE WHEN eCommerceAction.action_type = '6' and product.productRevenue is not null THEN product.v2ProductName END) as num_purchase
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    </code></pre>
    </div>  
</ul>
<h4>Result:</h4>
<img src="https://github.com/user-attachments/assets/cffb902c-d096-4d12-9938-eb417420bd26" alt="Query 7" style="width: 100%;">
