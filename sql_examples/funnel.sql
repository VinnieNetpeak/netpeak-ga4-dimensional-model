-- Funnel report
WITH base AS (
SELECT fs.event_date,
       fs.user_pseudo_id,
       fs.session_id,
       fs.platform,
       ds.channel_grouping,
       SUM(CASE WHEN kv.event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart,
       SUM(CASE WHEN kv.event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS begin_checkout,
       SUM(CASE WHEN kv.event_name = 'purchase' THEN 1 ELSE 0 END) AS purchase
FROM `gtm-txdvwmd.base_reports_data.fact_sessions` fs
LEFT JOIN `gtm-txdvwmd.base_reports_data.dim_sources` ds ON fs.source_id = ds.source_id
LEFT JOIN `gtm-txdvwmd.base_reports_data.fact_events` kv ON fs.event_date = kv.event_date AND fs.session_id = kv.session_id
GROUP BY 1, 2, 3, 4, 5
ORDER BY 8 DESC)

SELECT event_date,
       platform,
       channel_grouping,
       COUNT(DISTINCT session_id) AS `All sessions`,
       SUM(add_to_cart) AS `Add to cart`,
       SUM(begin_checkout) AS `Begin checkout`,
       SUM(purchase) AS `Purchase`
FROM base
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;