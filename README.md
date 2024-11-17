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
<h3>2. Query 2 - Count Bounce rate per traffic source in July 2017</h3>
<h4>Step:</h4>
<ul>
  <li>Step 1: Select the Dataset</li>
  <li>Step 2: Group the data by Traffic source</li>
  <li>Step 3: Calculate the Bounce rate</li>
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
<img src="https://github.com/user-attachments/assets/2048b600-f3d3-4c28-8a7d-39fa0c9d4bd0" alt="Query 1" style="width: 100%;">
