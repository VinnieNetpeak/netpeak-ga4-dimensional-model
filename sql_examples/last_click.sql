-- Last non direct click attribution report
SELECT s.source,
       s.medium,
       s.campaign,
       s.content,
       s.term,
       SUM(attr.last_click_attribution) AS conversions,
       ROUND(SUM(fp.purchase_revenue * attr.last_click_attribution), 2) AS revenue
FROM `gtm-txdvwmd.base_reports_data.attribution_source` attr
INNER JOIN `gtm-txdvwmd.base_reports_data.fact_purchases` fp ON attr.key_event_date = fp.event_date AND attr.transaction_id = fp.transaction_id
LEFT JOIN `gtm-txdvwmd.base_reports_data.dim_sources` s ON attr.source_id = s.source_id
WHERE key_event_date BETWEEN CURRENT_DATE() - 30 - 1 AND CURRENT_DATE() - 1
GROUP BY 1, 2, 3, 4, 5
ORDER BY 6 DESC;