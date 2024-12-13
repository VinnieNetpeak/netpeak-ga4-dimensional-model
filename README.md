# Google Analytics 4 Dimensional model

A comprehensive Dimensional model for Google Analytics 4 (GA4) data using Dataform and BigQuery. This project implements a robust data modeling framework with attribution modeling, source level segmentation, and dimensional model.

## 🌟 Key Features
- **Multi-Model Attribution**: Supports multiple attribution models including:
  - Last-click attribution
  - Time decay
  - Position-based (40-20-40)
  - Total conversions
- **Source level segmentation**:
  - Segments track user journey with unique source_id within a session.
  - Example: During one sessions person came from Direct -> PPC -> SEO, it will be 3 segments.
  - In case of Direct -> PPC -> Direct, it will be 3 segments (order is important).
  - In case of Direct -> Direct -> PPC, it will be 2 segments (order is important).

- **Comprehensive Dimensional Model**:
  - Users dimension
  - Pages dimension
  - Sources dimension
  - Geo dimension
  - Dates dimension
  - Items dimension
  - Events dimension

- **Fact Tables**:
  - Events
  - Sessions
  - Page views
  - Purchases

## Example Queries
The `/sql_examples` directory contains ready-to-use queries for common analytics scenarios:

### Marketing Analysis
- **[Campaigns Report](sql_examples/campaigns.sql)**: Analyze transactions and revenue by campaign, source, medium, and channel grouping
- **[Last Click Attribution](sql_examples/last_click.sql)**: Review conversion attribution based on last non-direct click model
- **[Marketing Funnel](sql_examples/funnel.sql)**: Track user journey through add-to-cart, checkout, and purchase stages

- **[E-commerce Performance](sql_examples/top10_ecommerce.sql)**: Track top performing products in cart additions and purchases


### User Behavior
- **[Page Views Analysis](sql_examples/page_views.sql)**: Monitor page performance, time on page, and exit rates

Each query is documented with comments and can be used as a starting point for custom analysis.

## 🏗 Architecture
- **Raw Data Layer**: Processes raw GA4 events, handles UTC offset, cleans and standardizes data.
- **Staging Layer**: Contains intermediate tables for data transformation and aggregation, intermediate transformations, data validation, business logic application.
- **Mart Layer**: Contains fact and dimensional tables optimized for reporting and analysis, attribution table.

## 🔑 Key Features
- **Incremental Processing**: Supports incremental data loads with a 4-day lookback window
- **UTM Parameter Handling**: Comprehensive tracking of marketing parameters
- **Session Management**: Sophisticated session handling with segment tracking
- **Custom Event Tracking**: Support for key business events:
```sql
KEY_EVENTS: [
        'purchase',
        'phone_number_click',
        'callback_request',
        'email_subscription',
        'representative_form',
        'prices_form',
        'product_request',
        'qualified_lead',
        'Bitrix24ChatOpen_click',
        'add_to_cart'
    ]
```

## 📊 Attribution Models
The pipeline implements multiple attribution models for marketing analysis:

```sql
WITH last_click AS (
SELECT key_event_id,
       1 AS last_click_attribution,
       MAX(segment_timestamp) AS segment_timestamp
FROM ${ref("stg_attribution")}
GROUP BY 1, 2),

time_decay AS (
SELECT segment_date,
       key_event_id,
       segment_timestamp,
       POWER(2, -days_before_key_event / 7) / (SUM(POWER(2, -days_before_key_event / 7)) OVER (PARTITION BY key_event_id)) AS time_decay_attribution
FROM ${ref("stg_attribution")}
),

position_based AS (
-- First and last segment 40% each, remaining 20% uniformly distributed among all segments in between
WITH number_events AS (
SELECT segment_date,
       key_event_id,
       segment_timestamp,
       ROW_NUMBER() OVER (PARTITION BY key_event_id ORDER BY segment_timestamp) AS event_number
FROM ${ref("stg_attribution")}
ORDER BY 1, 2),

add_total_segments AS (
SELECT *,
       MAX(event_number) OVER (PARTITION BY key_event_id ORDER BY segment_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS total_segments
FROM number_events)

SELECT segment_date,
       key_event_id,
       segment_timestamp,
       CASE WHEN total_segments = 1 THEN 1
       WHEN total_segments = 2 THEN 0.5
       WHEN total_segments > 2 THEN (
        CASE WHEN event_number = 1 THEN 0.4
        WHEN event_number = total_segments THEN 0.4
        ELSE 0.2 / (total_segments -2) END)
        END AS position_based_attribution
FROM add_total_segments
),

total_conversions AS (
SELECT DISTINCT segment_date,
                key_event_id,
                source_id,
                segment_timestamp,
                1 AS total_conversions_attribution
FROM ${ref("stg_attribution")}
WHERE source_id <> '0'
)
```

## 🛠 Technical Stack
- **Dataform**
- **BigQuery**
- **JavaScript** (for macros and constants)

## 🔄 Data Refresh
- Incremental updates with 4-day lookback window
- Partitioned tables for optimal performance
- Automated cleanup of old data

## 📝 Prerequisites
- Access to GA4 data in BigQuery
- Dataform CLI or Dataform Web UI
- BigQuery permissions
- Google Cloud project setup
