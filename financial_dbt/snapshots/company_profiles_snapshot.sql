{% snapshot company_profiles_snapshot %}

-- =========================================================
-- SNAPSHOT CONFIGURATION
-- =========================================================

{{
    config(
        target_schema='snapshots',
        unique_key='ticker',
        strategy='check',
        check_cols=[
            'name',
            'exchange',
            'finnhubIndustry',
            'marketCapitalization'
        ]
    )
}}

-- =========================================================
-- SOURCE DATA (CURRENT STATE)
-- =========================================================

SELECT
    ticker,
    name,
    exchange,
    finnhubIndustry,
    marketCapitalization

FROM {{ source('financial_raw', 'company_profiles') }}

{% endsnapshot %}