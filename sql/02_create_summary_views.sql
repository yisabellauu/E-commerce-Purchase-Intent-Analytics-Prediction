/*
===============================================================================
E-commerce Purchase Intent Analytics
File: 02_create_summary_views.sql

Purpose:
    Create reusable MySQL views for analyzing purchase conversion across
    visitor types, traffic sources, months, and engagement levels.

Prerequisite:
    Run 01_create_cleaned_table.sql before running this script.

Database:
    MySQL
===============================================================================
*/

USE ecommerce_analysis;


/* ---------------------------------------------------------------------------
   1. Session-level data view

   This view provides the analysis-ready dataset used for detailed analysis
   and Tableau visualization.
--------------------------------------------------------------------------- */

CREATE OR REPLACE VIEW online_shoppers_sessions AS
SELECT *
FROM online_shoppers;


/* ---------------------------------------------------------------------------
   2. Overall conversion performance
--------------------------------------------------------------------------- */

CREATE OR REPLACE VIEW overall_conversion AS
SELECT
    COUNT(*) AS total_sessions,
    SUM(converted) AS converted_sessions,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct,
    ROUND(AVG(product_related_pages), 2)
        AS avg_product_related_pages,
    ROUND(AVG(product_related_duration_seconds) / 60.0, 2)
        AS avg_product_related_duration_minutes
FROM online_shoppers;


/* ---------------------------------------------------------------------------
   3. Conversion by visitor type
--------------------------------------------------------------------------- */

CREATE OR REPLACE VIEW conversion_by_visitor AS
SELECT
    visitor_type,
    COUNT(*) AS total_sessions,
    SUM(converted) AS converted_sessions,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct,
    ROUND(AVG(product_related_pages), 2)
        AS avg_product_related_pages,
    ROUND(AVG(product_related_duration_seconds) / 60.0, 2)
        AS avg_product_related_duration_minutes
FROM online_shoppers
GROUP BY visitor_type;


/* ---------------------------------------------------------------------------
   4. Conversion by traffic source
--------------------------------------------------------------------------- */

CREATE OR REPLACE VIEW conversion_by_traffic AS
SELECT
    traffic_source_id,
    COUNT(*) AS total_sessions,
    SUM(converted) AS converted_sessions,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct,
    ROUND(AVG(product_related_pages), 2)
        AS avg_product_related_pages,
    ROUND(AVG(product_related_duration_seconds) / 60.0, 2)
        AS avg_product_related_duration_minutes
FROM online_shoppers
GROUP BY traffic_source_id;


/* ---------------------------------------------------------------------------
   5. Conversion by month
--------------------------------------------------------------------------- */

CREATE OR REPLACE VIEW conversion_by_month AS
SELECT
    month_name,
    month_order,
    COUNT(*) AS total_sessions,
    SUM(converted) AS converted_sessions,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct
FROM online_shoppers
GROUP BY
    month_name,
    month_order;


/* ---------------------------------------------------------------------------
   6. Conversion by product-page engagement
--------------------------------------------------------------------------- */

CREATE OR REPLACE VIEW conversion_by_engagement AS
SELECT
    engagement,
    engagement_order,
    COUNT(*) AS total_sessions,
    SUM(converted) AS converted_sessions,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct,
    ROUND(AVG(product_related_pages), 2)
        AS avg_product_related_pages,
    ROUND(AVG(bounce_rate) * 100, 2)
        AS avg_bounce_rate_pct,
    ROUND(AVG(exit_rate) * 100, 2)
        AS avg_exit_rate_pct
FROM online_shoppers
GROUP BY
    engagement,
    engagement_order;


/* ---------------------------------------------------------------------------
   7. Validate the completed views
--------------------------------------------------------------------------- */

SELECT *
FROM online_shoppers_sessions
LIMIT 20;

SELECT *
FROM overall_conversion;

SELECT *
FROM conversion_by_visitor
ORDER BY conversion_rate_pct DESC;

-- Exclude traffic sources with very small session counts when comparing rates.

SELECT *
FROM conversion_by_traffic
WHERE total_sessions >= 30
ORDER BY conversion_rate_pct DESC;

SELECT *
FROM conversion_by_month
ORDER BY month_order;

SELECT *
FROM conversion_by_engagement
ORDER BY engagement_order;
