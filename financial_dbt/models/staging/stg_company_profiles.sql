/*
Staging model: company profiles

PURPOSE:
- Clean raw company metadata from Finnhub
- Ensure consistent naming
- Remove duplicates per ticker

NOTE:
Company data is slow-changing, so staging keeps latest snapshot only.
*/

WITH cleaned AS (

    SELECT
        ticker,
        name,
        exchange,
        finnhubIndustry,
        marketCapitalization

    FROM {{ source('financial_raw', 'company_profiles') }}
),

deduplicated AS (

    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ticker
               ORDER BY ticker
           ) AS rn
    FROM cleaned
)

SELECT
    ticker,
    name,
    exchange,
    finnhubIndustry,
    marketCapitalization

FROM deduplicated
WHERE rn = 1