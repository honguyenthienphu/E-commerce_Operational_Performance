with month_data as(
  select
    "Month" as time_type,
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    trafficSource.source as source,
    sum(p.productRevenue)/1000000 as revenue
  from `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    unnest(hits) hits,
    unnest(product) p
  where p.productRevenue is not null
  group by 1,2,3
  order by revenue desc
),

week_data as(
  select
    "Week" as time_type,
    format_date("%Y%W", parse_date("%Y%m%d", date)) as week,
    trafficSource.source AS source,
    sum(p.productRevenue)/1000000 as revenue
  from `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    unnest(hits) hits,
    unnest(product) p
  where p.productRevenue is not null
  group by 1,2,3
  order by revenue desc
)
select * from month_data
union all
select * from week_data;
order by time_type