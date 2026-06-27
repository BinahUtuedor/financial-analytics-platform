{% snapshot company_profiles_snapshot %}

/*
===============================================================================
Snapshot: company_profiles_snapshot
===============================================================================

PURPOSE
-------
Tracks historical changes to company profile information.

Unlike stock prices, company metadata changes infrequently. Snapshots allow
us to preserve previous versions whenever selected attributes change.

This enables historical reporting and auditing of company information over
time.

SNAPSHOT STRATEGY
-----------------
check

The snapshot compares the configured columns each time dbt runs.

If any monitored column changes, dbt closes the current record and creates
a new version.

UNIQUE KEY
----------
ticker

TRACKED COLUMNS
---------------
- name
- exchange
- finnhubIndustry
- marketCapitalization

SOURCE
------
financial_raw.company_profiles

===============================================================================
*/

{{
    config(

        target_schema='snapshots',

        unique_key='ticker',

        strategy='check',

        check_cols=[

            'name',

            'exchange',

            'finnhubIndustry'

        ]

    )
}}

SELECT

    --------------------------------------------------------------------------
    -- Business key
    --------------------------------------------------------------------------
    ticker,

    --------------------------------------------------------------------------
    -- Company information
    --------------------------------------------------------------------------
    name,

    exchange,

    finnhubIndustry,

    marketCapitalization

FROM {{ source('financial_raw', 'company_profiles') }}

{% endsnapshot %}