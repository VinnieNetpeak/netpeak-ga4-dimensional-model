-- Campaigns report: transactions and revenue by campaign, source, medium, campaign, channel_grouping
SELECT fs.event_date,
       fs.user_pseudo_id,
       fs.session_id,
       (CASE WHEN fs.ga_session_num = 1 THEN TRUE ELSE FALSE END) AS is_new_user,
       ds.source,
       ds.medium,
       ds.campaign,
       ds.channel_grouping,
       fp.transaction_id,
       fp.purchase_revenue
FROM `gtm-txdvwmd`.base_reports_data.fact_sessions fs
LEFT JOIN `gtm-txdvwmd`.base_reports_data.dim_sources ds ON fs.source_id = ds.source_id
LEFT JOIN `gtm-txdvwmd`.base_reports_data.fact_purchases fp ON fs.session_id = fp.session_id AND fs.event_date = fp.event_date