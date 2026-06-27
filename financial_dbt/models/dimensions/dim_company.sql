/*
===============================================================================
Dimension: dim_company
===============================================================================

PURPOSE
-------
This dimension stores descriptive information about each company.

A dimension table contains attributes that describe a business entity.
In this project, each row represents one company.

The table is built from the cleaned staging model rather than directly from
the raw source. This ensures only validated and deduplicated data is used.

BUSINESS GRAIN
--------------
One row per company (ticker).

SOURCE
------
stg_company_profiles

USED BY
-------
- fact_stock_performance
- Future dashboards
- Future reporting models

NOTES
-----
Although marketCapitalization changes over time, it is included here for
learning purposes. In larger production systems this attribute is often
derived separately or managed using snapshots.
===============================================================================
*/

SELECT

    -- Unique company identifier
    ticker AS symbol,

    -- Official company name
    name,

    -- Stock exchange where the company is listed
    exchange,

    -- Industry classification supplied by Finnhub
    finnhubIndustry AS industry,

    -- Current market capitalisation
    marketCapitalization AS market_cap

FROM {{ ref('stg_company_profiles') }}