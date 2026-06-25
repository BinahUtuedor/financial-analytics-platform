SELECT
    p.symbol,
    c.name,
    p.trading_date,
    p.close_price,
    p.volume,

    AVG(p.close_price)
        OVER(
            PARTITION BY p.symbol
            ORDER BY p.trading_date
            ROWS BETWEEN 29 PRECEDING
            AND CURRENT ROW
        ) AS moving_avg_30d

FROM {{ ref('stg_stock_prices') }} p
LEFT JOIN {{ ref('stg_company_profiles') }} c
ON p.symbol = c.ticker