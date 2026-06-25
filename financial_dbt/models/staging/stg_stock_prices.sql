SELECT
    symbol,
    DATE(date) AS trading_date,
    CAST(open AS FLOAT64) AS open_price,
    CAST(high AS FLOAT64) AS high_price,
    CAST(low AS FLOAT64) AS low_price,
    CAST(close AS FLOAT64) AS close_price,
    CAST(volume AS INT64) AS volume
FROM {{ source('financial_raw', 'stock_prices') }}