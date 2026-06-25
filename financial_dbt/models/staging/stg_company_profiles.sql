SELECT
    ticker,
    name,
    exchange,
    finnhubIndustry,
    marketCapitalization
FROM {{ source('financial_raw', 'company_profiles') }}