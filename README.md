# [SQL] E-commerce Operational Performance
<h2>I. Introduction</h1>
<p>This project focuses on analyzing an E-commerce dataset using SQL on <a href="https://cloud.google.com/bigquery">Google BigQuery</a> to uncover insights into operational performance.</p>
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

<h3>1. Query 1 - Calculate Total Visits, Pageviews and Transactions for January, February and March 2017</h3>
<h4>1.1 Steps:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Filter the data from January to March in 2017</li>
  <div class="code-box">
    <pre><code>
    from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    where _TABLE_SUFFIX between '0101' and '0331'
    </code></pre>
  </div>
  <li>Step 3: Count total Visit, Pageview and Transaction</li>
  <div class="code-box">
    <pre><code>
    sum(totals.visits) as visits,
    sum(totals.pageviews) as pageviews,
    sum(totals.transactions) as transactions,
    </code></pre>  
  </div>
</ul>
<h4>1.2 Result:</h4>
<img src="https://github.com/user-attachments/assets/9f7fb8c3-f157-4a9a-8df1-8d9d572a7f2b" alt="Query 1" style="width: 100%;">
<h4>1.3 Insights:</h4>
<ul>
  <li>The highest visits is in March 2017 (69,931 visits in total)</li>
  <li>Total pageviews have the highest value in March 2017 (259,522 pages) and lowest in February 2017 (233,373 pages)</li>
  <li>The most transactions made finished in March 2017 (993 finished transactions)</li>
</ul>

<h3>2. Query 2 - Calculate Bounce rate per traffic source in July 2017</h3>
<h4>2.1 Steps:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Group the data by Traffic source</li>
  <li>Step 3: Calculate the Bounce rate per traffic source</li>
  <div class="code-box">
    <pre><code>
    trafficSource.source as source,
    sum(totals.visits) as total_visits,
    sum(totals.Bounces) as total_no_of_bounces,
    (sum(totals.Bounces)/sum(totals.visits))* 100 as bounce_rate
    </code></pre>  
  </div>
</ul>
<h4>2.2 Result:</h4>
<img src="https://github.com/user-attachments/assets/2048b600-f3d3-4c28-8a7d-39fa0c9d4bd0" alt="Query 2" style="width: 100%;">
<h4>2.3 Insights:</h4>
<ul>
  <li>Show the total visits and bounces from each source: Example with Google are 38400 and 19798</li>
  <li>The bounce rate will be 19798/38400 equal to 51.55%</li>
</ul>

<h3>3. Query 3 - Calculate Revenue by traffic source by week, by month in June 2017</h3>
<h4>3.1 Steps:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Separate month and week data then union all</li>
  <li>Step 3: Unnest hits and product to access productRevenue field</li>
  <li>Step 4: Calculate Revenue by traffic source</li>
    <div class="code-box">
    <pre><code>
    with month_data as(
      select
        "Month" as time_type,
        format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
        trafficSource.source as source,
        sum(p.productRevenue)/1000000 as revenue
      from `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    </code></pre>
    <pre><code>
    week_data as(
      select
        "Week" as time_type,
        format_date("%Y%W", parse_date("%Y%m%d", date)) as week,
        trafficSource.source AS source,
        sum(p.productRevenue)/1000000 as revenue
      from `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    </code></pre>
    <pre><code>
    select * from month_data
    union all
    select * from week_data;
    order by time_type
    </code></pre>  
  </div>
</ul>
<h4>3.2 Result:</h4>
<img src="https://github.com/user-attachments/assets/d0ba34b9-c6b8-43bb-9310-9c6710542d7f" alt="Query 3" style="width: 100%;">
<h4>3.3 Insights:</h4>
<ul>
  <li>The total revenue from different sources by week, by month in June 2017</li>
  <li>Google in June 2016: 18757</li>
  <li>Google in the first week in June 2016: 5330</li>
</ul>

<h3>4. Query 4 - Calculate Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017</h3>
<h4>4.1 Steps:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Create a table with Purchaser</li>
    <div class="code-box">
    <pre><code>
    with purchaser_data as (
      select
          format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
          (sum(totals.pageviews)/count(distinct fullvisitorid)) as avg_pageviews_purchase,
      from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    </code></pre>
    </div>  
  <li>Step 3: Create a table with Non-Purchaser</li>
    <div class="code-box">
    <pre><code>
    non_purchaser_data as (
      select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.pageviews)/count(distinct fullvisitorid) as avg_pageviews_non_purchase,
    from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    </code></pre>
    </div>  
  <li>Step 4: Join two tables to compare Average number of pageviews</li>
  <div class="code-box">
    <pre><code>
    select
      pd.*,
      avg_pageviews_non_purchase
    from purchaser_data pd
    full join non_purchaser_data using(month)
    order by pd.month;
    </code></pre>
    </div>  
</ul>
<h4>4.2 Result:</h4>
<img src="https://github.com/user-attachments/assets/1b579419-9d58-4caf-9cbf-67adf980ba2e" alt="Query 4" style="width: 100%;">
<h4>4.3 Insights:</h4>
<ul>
  <li>Compare average pageviews between purchaser and non-purchaser in June, July 2017</li>
  <li>Average pageviews with non-purchaser is higher than purchaser both in June and July</li>
</ul>

<h3>5. Query 5 - Calculate Average number of transactions per user that made a purchase in July 2017</h3>
<h4>5.1 Steps:</h4>
<ul>
  <li>Step 1: Select the Dataset </li>
  <li>Step 2: Calculate Average number of transactions per user</li>
    <div class="code-box">
    <pre><code>
    select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.transactions)/count(distinct fullvisitorid) as Avg_total_transactions_per_user
    from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    </code></pre>
    </div>  
</ul>
<h4>5.2 Result:</h4>
<img src="https://github.com/user-attachments/assets/4d9de549-c9ec-49b9-9c80-8b9db2e602ec" alt="Query 5" style="width: 100%;">
<h4>5.3 Insights:</h4>
<ul>
  <li>Average transactions per customer is about 4.16 times in month</li>
</ul>

<h3>6. Query 6 - Calculate Average amount of money spent per session. Only include purchaser data in July 2017</h3>
<h4>6.1 Steps:</h4>
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
<h4>6.2 Result:</h4>
<img src="https://github.com/user-attachments/assets/f988eec1-5fec-481a-9fa7-8b796dfa7dd5" alt="Query 6" style="width: 100%;">
<h4>6.3 Insights:</h4>
<ul>
  <li>Average amount spent per customer is about $43.85 times in July 2017</li>
</ul>

<h3>7. Query 7 - Show product name and the quantity purchased from selected customer</h3>
<h4>7.1 Steps:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Create a selected customer table</li>
    <div class="code-box">
    <pre><code>
    with selected_customer as (
      select
        distinct(visitId) 
      from
        `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
        unnest(hits) hits,
        unnest(product) product
      where
        v2ProductName = "YouTube Men's Vintage Henley"
        and _table_suffix between '0701' and '0731'
        and product.productRevenue is not null
    )
    </code></pre>
    </div>  
</ul>
<h4>7.2 Result:</h4>
<img src="https://github.com/user-attachments/assets/a029c093-51b7-4136-b37d-606d201ce05b" alt="Query 7" style="width: 100%;">
<h4>7.3 Insights:</h4>
<ul>
  <li>Customers who purchased product "YouTube Men's Vintage Henley" also purchased the other products:</li>
  <li>Google Sunglasses: 20pcs</li>
  <li>Google Women's Vintage Hero Tee Black: 7pcs</li>
</ul>

<h3>8. Query 8 - Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017</h3>
<h4>8.1 Step:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Create a product data</li>
  <div class="code-box">
    <pre><code>
    with product_data as (
    select
      format_date('%Y%m', parse_date('%Y%m%d',date)) as month,
      count(case when eCommerceAction.action_type = '2' then product.v2ProductName end) as num_product_view,
      count(case when eCommerceAction.action_type = '3' then product.v2ProductName end) as num_add_to_cart,
      count(case when eCommerceAction.action_type = '6' and product.productRevenue is not null then product.v2ProductName end) as num_purchase
    from `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    </code></pre>
    </div>  
</ul>
<h4>8.2 Result:</h4>
<img src="https://github.com/user-attachments/assets/cffb902c-d096-4d12-9938-eb417420bd26" alt="Query 7" style="width: 100%;">
<h4>8.3 Insights:</h4>
<ul>
  <li>The result show number of views, add-to-cart and purchase times in each month</li>
  <li>Calculate the add-to-cart and purchase rate in each month</li>
  <li>In March 2017 has the highest add-to-cart and purchase rate</li>
</ul>
