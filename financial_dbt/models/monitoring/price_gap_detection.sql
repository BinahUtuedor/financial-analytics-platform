/*
===============================================================================
Monitoring Model: price_gap_detection
===============================================================================

PURPOSE
-------
This monitoring model detects unusually large daily price movements for each
stock.

Large movements may be perfectly legitimate (for example, after earnings
announcements or major market news), but they can also indicate data quality
issues such as:

• Missing historical records
• Incorrect price values
• Duplicate loads
• Stock splits not yet adjusted
• API extraction errors

This model compares today's closing price with the previous trading day's
closing price and calculates the percentage change.

A configurable threshold of 20% is used to determine whether the movement
should be flagged for investigation.

BUSINESS GRAIN
--------------
One row per company per trading day.

SOURCE
------
stg_stock_prices

OUTPUT
------
Returns:

• Previous day's close
• Current close
• Percentage change
• Monitoring status
• Boolean alert flag

===============================================================================
*/

WITH price_history AS (

    SELECT

        -----------------------------------------------------------------------
        -- Company identifier
        -----------------------------------------------------------------------
        symbol,

        -----------------------------------------------------------------------
        -- Trading date
        -----------------------------------------------------------------------
        trading_date,

        -----------------------------------------------------------------------
        -- Current day's closing price
        -----------------------------------------------------------------------
        close_price,

        -----------------------------------------------------------------------
        -- Previous trading day's closing price
        -----------------------------------------------------------------------
        LAG(close_price)

        OVER (

            PARTITION BY symbol

            ORDER BY trading_date

        ) AS previous_close

    FROM {{ ref('stg_stock_prices') }}

)

SELECT

    ---------------------------------------------------------------------------
    -- Company identifier
    ---------------------------------------------------------------------------
    symbol,

    ---------------------------------------------------------------------------
    -- Trading date
    ---------------------------------------------------------------------------
    trading_date,

    ---------------------------------------------------------------------------
    -- Previous day's closing price
    ---------------------------------------------------------------------------
    previous_close,

    ---------------------------------------------------------------------------
    -- Current closing price
    ---------------------------------------------------------------------------
    close_price,

    ---------------------------------------------------------------------------
    -- Daily percentage movement
    ---------------------------------------------------------------------------
    ROUND(

        SAFE_DIVIDE(

            ABS(close_price - previous_close),

            previous_close

        ) * 100,

        2

    ) AS pct_change,

    ---------------------------------------------------------------------------
    -- Monitoring status
    ---------------------------------------------------------------------------
    CASE

        WHEN SAFE_DIVIDE(

                ABS(close_price - previous_close),

                previous_close

             ) > 0.20

        THEN 'ALERT'

        ELSE 'OK'

    END AS monitoring_status,

    ---------------------------------------------------------------------------
    -- Boolean alert flag
    ---------------------------------------------------------------------------
    CASE

        WHEN SAFE_DIVIDE(

                ABS(close_price - previous_close),

                previous_close

             ) > 0.20

        THEN TRUE

        ELSE FALSE

    END AS price_gap_flag

FROM price_history