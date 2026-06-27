/*
===============================================================================
Monitoring Model: missing_trading_days
===============================================================================

PURPOSE
-------
This model identifies calendar dates where no stock trading data exists.

This helps detect:

• ETL failures
• API outages
• Missing historical loads
• Pipeline interruptions

The model compares the calendar dimension with available trading dates.

NOTE
----
Weekends will naturally appear because markets are closed.

A production implementation could additionally exclude:

• Weekends
• Public holidays
• Exchange holidays

BUSINESS GRAIN
--------------
One row per missing calendar date.

SOURCE
------
dim_date
stg_stock_prices

===============================================================================
*/

SELECT

    ---------------------------------------------------------------------------
    -- Calendar date
    ---------------------------------------------------------------------------
    d.trading_date,

    ---------------------------------------------------------------------------
    -- Useful investigation fields
    ---------------------------------------------------------------------------
    d.year,

    d.quarter,

    d.month,

    d.week,

    d.weekday,

    d.is_weekend

FROM {{ ref('dim_date') }} d

LEFT JOIN (

    ---------------------------------------------------------------------------
    -- Existing trading dates
    ---------------------------------------------------------------------------
    SELECT DISTINCT

        trading_date

    FROM {{ ref('stg_stock_prices') }}

) p

ON d.trading_date = p.trading_date

WHERE

    ---------------------------------------------------------------------------
    -- Dates with no matching trading data
    ---------------------------------------------------------------------------
    p.trading_date IS NULL

ORDER BY

    d.trading_date