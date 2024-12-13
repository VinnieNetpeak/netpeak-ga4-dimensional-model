-- Top 10 items added to cart
SELECT fi.item_id,
       di.item_name,
       COUNT(*)
FROM `gtm-txdvwmd.base_reports_data.fact_events` fe
LEFT JOIN `gtm-txdvwmd.base_reports_data.fact_events_items` fi ON fe.event_date = fi.event_date AND fe.event_id = fi.event_id
LEFT JOIN `gtm-txdvwmd.base_reports_data.dim_items` di ON fi.item_id = di.item_id
WHERE fe.event_name = 'add_to_cart'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

-- Top 10 purchased items
SELECT fi.item_id,
       di.item_name,
       COUNT(*)
FROM `gtm-txdvwmd.base_reports_data.fact_events` fe
LEFT JOIN `gtm-txdvwmd.base_reports_data.fact_events_items` fi ON fe.event_date = fi.event_date AND fe.event_id = fi.event_id
LEFT JOIN `gtm-txdvwmd.base_reports_data.dim_items` di ON fi.item_id = di.item_id
WHERE fe.event_name = 'purchase'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;