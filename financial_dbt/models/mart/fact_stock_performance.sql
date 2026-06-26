-- Select the required columns from the staging tables
SELECT
    -- Stock ticker symbol (e.g., AAPL, MSFT)
    p.symbol,

    -- Company name from the company profiles table
    c.name,

    -- Trading date for each stock price record
    p.trading_date,

    -- Closing price of the stock on that trading date
    p.close_price,

    -- Number of shares traded on that date
    p.volume,

    -- Calculate the 30-day moving average of the closing price
    AVG(p.close_price)
        OVER(
            -- Restart the calculation for each stock symbol
            PARTITION BY p.symbol

            -- Process the rows in chronological order
            ORDER BY p.trading_date

            -- Use the current row and the previous 29 rows
            -- (30 trading days in total)
            ROWS BETWEEN 29 PRECEDING
            AND CURRENT ROW
        ) AS moving_avg_30d

-- Use the staged stock prices model
FROM {{ ref('stg_stock_prices') }} p

-- Join with the staged company profiles model
-- to retrieve the company name for each ticker
LEFT JOIN {{ ref('stg_company_profiles') }} c

    -- Match the stock symbol with the company ticker
    ON p.symbol = c.ticker