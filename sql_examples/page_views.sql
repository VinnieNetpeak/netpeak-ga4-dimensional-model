-- Page views report: page views by date, user, session, page view id, geo, device category, browser, page id, time on page, exits
SELECT event_date AS date,
       user_pseudo_id,
       session_id, -- then join to source_id to know the source
       page_view_id, -- for page view count
       geo_id,
       device_category,
       browser,
       page_id,
       time_on_page,
       exit_page AS exits
FROM `gtm-txdvwmd.base_reports_data.fact_page_views`;