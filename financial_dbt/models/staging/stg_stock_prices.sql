/*
Staging model: stock prices

PURPOSE:
- Clean raw ingestion from BigQuery
- Standardise column types
- Remove duplicate rows per (symbol, trading_date)

DUPLICATION STRATEGY:
- If Alpha Vantage sends repeated records for same day,
  we keep only the latest row per symbol + date
*/

WITH cleaned AS (

    SELECT
        symbol,

        -- Ensure proper date type for analytics
        DATE(date) AS trading_date,

        CAST(open AS FLOAT64) AS open_price,
        CAST(high AS FLOAT64) AS high_price,
        CAST(low AS FLOAT64) AS low_price,
        CAST(close AS FLOAT64) AS close_price,
        CAST(volume AS INT64) AS volume

    FROM {{ source('financial_raw', 'stock_prices') }}
),

deduplicated AS (

    SELECT
        *,
        
        -- Rank duplicates per stock per day
        ROW_NUMBER() OVER (
            PARTITION BY symbol, trading_date
            ORDER BY trading_date DESC
        ) AS rn

    FROM cleaned
)

SELECT
    symbol,
    trading_date,
    open_price,
    high_price,
    low_price,
    close_price,
    volume

FROM deduplicated
WHERE rn = 1