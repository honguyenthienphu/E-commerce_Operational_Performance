select
    trafficSource.source as source,
    sum(totals.visits) as total_visits,
    sum(totals.Bounces) as total_no_of_bounces,
    (sum(totals.Bounces)/sum(totals.visits))* 100 as bounce_rate
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
group by source
order by total_visits desc;