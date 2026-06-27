/*
===============================================================================
Dimension: dim_date
===============================================================================
*/

{{ config(materialized='table') }}

WITH dates AS (

    SELECT
        date AS trading_date
    FROM UNNEST(
        GENERATE_DATE_ARRAY(
            DATE('2024-01-01'),
            CURRENT_DATE()
        )
    ) AS date

)

SELECT

    --------------------------------------------------------------------------
    -- Primary key
    --------------------------------------------------------------------------
    trading_date,

    --------------------------------------------------------------------------
    -- Calendar breakdown
    --------------------------------------------------------------------------
    EXTRACT(YEAR FROM trading_date) AS year,
    EXTRACT(QUARTER FROM trading_date) AS quarter,
    EXTRACT(MONTH FROM trading_date) AS month,
    EXTRACT(DAY FROM trading_date) AS day,
    EXTRACT(WEEK FROM trading_date) AS week,
    FORMAT_DATE('%A', trading_date) AS weekday,

    --------------------------------------------------------------------------
    -- Weekend flag
    --------------------------------------------------------------------------
    CASE
        WHEN EXTRACT(DAYOFWEEK FROM trading_date) IN (1, 7)
        THEN TRUE
        ELSE FALSE
    END AS is_weekend

FROM dates