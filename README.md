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
<b>Query 01: Calculate Total visit, Pageview and Transaction for January, February and March 2017 (order by month)</b>
<h5>SQL Query Example</h5>
<div class="code-box">
  <pre><code>SELECT
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
  </code></pre>
</div>
<h5>Query results</h5>
![image](https://github.com/user-attachments/assets/a2f4dd3e-0be8-4ae3-8202-773a8e9c4eda)

