/*
===============================================================================
E-commerce Purchase Intent Analytics
File: 01_create_cleaned_table.sql

Purpose:
    Create an analysis-ready session-level table from the raw Online
    Shoppers Purchasing Intention dataset.

Key transformations:
    - Rename variables for readability
    - Convert Revenue and Weekend values into binary indicators
    - Create chronological month ordering
    - Create product-engagement categories
    - Add a unique session identifier

Database:
    MySQL
===============================================================================
*/

USE ecommerce_analysis;


/* ---------------------------------------------------------------------------
   1. Remove existing dependent views and cleaned table

   Views must be removed before rebuilding the underlying table because they
   depend on online_shoppers.
--------------------------------------------------------------------------- */

DROP VIEW IF EXISTS
    online_shoppers_sessions,
    overall_conversion,
    conversion_by_visitor,
    conversion_by_traffic,
    conversion_by_month,
    conversion_by_engagement;

DROP TABLE IF EXISTS online_shoppers;


/* ---------------------------------------------------------------------------
   2. Create the analysis-ready session table
--------------------------------------------------------------------------- */

CREATE TABLE online_shoppers AS
SELECT
    Administrative AS administrative_pages,
    Administrative_Duration AS administrative_duration_seconds,

    Informational AS informational_pages,
    Informational_Duration AS informational_duration_seconds,

    ProductRelated AS product_related_pages,
    ProductRelated_Duration AS product_related_duration_seconds,

    BounceRates AS bounce_rate,
    ExitRates AS exit_rate,
    PageValues AS page_value,
    SpecialDay AS special_day,

    `Month` AS month_name,

    CASE `Month`
        WHEN 'Feb'  THEN 2
        WHEN 'Mar'  THEN 3
        WHEN 'Apr'  THEN 4
        WHEN 'May'  THEN 5
        WHEN 'June' THEN 6
        WHEN 'Jul'  THEN 7
        WHEN 'Aug'  THEN 8
        WHEN 'Sep'  THEN 9
        WHEN 'Oct'  THEN 10
        WHEN 'Nov'  THEN 11
        WHEN 'Dec'  THEN 12
        ELSE 99
    END AS month_order,

    OperatingSystems AS operating_system_id,
    Browser AS browser_id,
    Region AS region_id,
    TrafficType AS traffic_source_id,
    VisitorType AS visitor_type,

    CASE
        WHEN UPPER(TRIM(Weekend)) IN ('TRUE', '1') THEN 1
        ELSE 0
    END AS is_weekend,

    CASE
        WHEN UPPER(TRIM(Revenue)) IN ('TRUE', '1') THEN 1
        ELSE 0
    END AS converted,

    CASE
        WHEN ProductRelated_Duration < 60   THEN '<1 minute'
        WHEN ProductRelated_Duration < 300  THEN '1-5 minutes'
        WHEN ProductRelated_Duration < 900  THEN '5-15 minutes'
        WHEN ProductRelated_Duration < 1800 THEN '15-30 minutes'
        ELSE '>30 minutes'
    END AS engagement,

    CASE
        WHEN ProductRelated_Duration < 60   THEN 1
        WHEN ProductRelated_Duration < 300  THEN 2
        WHEN ProductRelated_Duration < 900  THEN 3
        WHEN ProductRelated_Duration < 1800 THEN 4
        ELSE 5
    END AS engagement_order

FROM online_shoppers_raw;


/* ---------------------------------------------------------------------------
   3. Add a unique session identifier
--------------------------------------------------------------------------- */

ALTER TABLE online_shoppers
ADD COLUMN session_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;


/* ---------------------------------------------------------------------------
   4. Validate the cleaned table
--------------------------------------------------------------------------- */

-- Confirm that no rows were lost during transformation.

SELECT
    (SELECT COUNT(*) FROM online_shoppers_raw) AS raw_rows,
    (SELECT COUNT(*) FROM online_shoppers) AS cleaned_rows;


-- Check the distribution of purchase outcomes.

SELECT
    converted,
    COUNT(*) AS sessions
FROM online_shoppers
GROUP BY converted
ORDER BY converted;


-- Check the distribution of weekday and weekend sessions.

SELECT
    is_weekend,
    COUNT(*) AS sessions
FROM online_shoppers
GROUP BY is_weekend
ORDER BY is_weekend;
