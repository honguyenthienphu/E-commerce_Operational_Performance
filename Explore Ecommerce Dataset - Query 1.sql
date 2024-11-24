select
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  sum(totals.visits) as visits,
  sum(totals.pageviews) as pageviews,
  sum(totals.transactions) as transactions,
from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
where _TABLE_SUFFIX between '0101' and '0331'
group by 1
order by 1;
