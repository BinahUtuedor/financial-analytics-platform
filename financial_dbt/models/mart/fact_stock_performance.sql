/*
===============================================================================
Fact Table: fact_stock_performance
===============================================================================

PURPOSE
-------
Stores one record per company per trading day combining:

- Daily stock prices (staging)
- Company dimension attributes
- Derived analytics (moving averages, etc.)

BUSINESS GRAIN
--------------
One row per symbol per trading_date

SOURCE MODELS
-------------
stg_stock_prices
dim_company

FEATURES
--------
✓ Incremental processing (BigQuery merge)
✓ Dimension join
✓ 30-day moving average
✓ Data quality ready structure

===============================================================================
*/

{{
    config(
        materialized='incremental',
        unique_key=['symbol', 'trading_date'],
        incremental_strategy='merge'
    )
}}

WITH base_prices AS (

    SELECT
        symbol,
        trading_date,
        open_price,
        high_price,
        low_price,
        close_price,
        volume
    FROM {{ ref('stg_stock_prices') }}

),

company_dim AS (

    SELECT
        symbol,
        name,
        exchange,
        industry,
        market_cap
    FROM {{ ref('dim_company') }}

),

enriched AS (

    SELECT

        ----------------------------------------------------------------------
        -- Company attributes
        ----------------------------------------------------------------------
        p.symbol,
        c.name,
        c.exchange,
        c.industry,
        c.market_cap,

        ----------------------------------------------------------------------
        -- Trading attributes
        ----------------------------------------------------------------------
        p.trading_date,
        p.open_price,
        p.high_price,
        p.low_price,
        p.close_price,
        p.volume,

        ----------------------------------------------------------------------
        -- 30-day moving average (rolling window)
        ----------------------------------------------------------------------
        AVG(p.close_price) OVER (
            PARTITION BY p.symbol
            ORDER BY p.trading_date
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) AS moving_avg_30d

    FROM base_prices p

    LEFT JOIN company_dim c
        ON p.symbol = c.symbol
)

SELECT *
FROM enriched

{% if is_incremental() %}

-- Only process new trading dates beyond current max in target table
WHERE trading_date > (
    SELECT MAX(trading_date)
    FROM {{ this }}
)

{% endif %}