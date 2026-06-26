# Import extraction functions for market data and company information
from src.extract.alpha_vantage import get_daily_prices
from src.extract.finnhub import get_company_profile

# Import utility functions
from src.utils.validators import validate_dataframe
from src.utils.logger import logger

# Import BigQuery loading function
from src.load.bigquery_loader import load_dataframe

# Import project configuration settings
from src.config.settings import (
    GCP_PROJECT_ID,
    BIGQUERY_DATASET
)


def run():
    """
    Main ETL pipeline.

    For each stock symbol:
    1. Extract daily stock prices from Alpha Vantage.
    2. Validate the returned data.
    3. Load the data into the BigQuery stock_prices table.
    4. Extract company profile data from Finnhub.
    5. Validate the returned data.
    6. Load the data into the BigQuery company_profiles table.

    Any failures during extraction or loading are logged without
    stopping the processing of the remaining symbols.
    """

    # List of stock symbols to process
    symbols = ["AAPL", "MSFT", "GOOGL"]

    # Process each company individually
    for symbol in symbols:

        logger.info(f"Extracting {symbol}")

        # -------------------------
        # Process daily stock prices
        # -------------------------
        try:
            # Extract daily market prices
            prices = get_daily_prices(symbol)

            # Ensure the extracted data meets validation rules
            validate_dataframe(prices)

            # Load validated data into BigQuery
            load_dataframe(
                prices,
                f"{GCP_PROJECT_ID}.{BIGQUERY_DATASET}.stock_prices"
            )

        except Exception:
            # Log the full exception while continuing with the pipeline
            logger.exception(f"Price load failed for {symbol}")

        # -------------------------
        # Process company profile
        # -------------------------
        try:
            # Extract company metadata
            profile = get_company_profile(symbol)

            # Validate extracted profile data
            validate_dataframe(profile)

            # Load validated profile into BigQuery
            load_dataframe(
                profile,
                f"{GCP_PROJECT_ID}.{BIGQUERY_DATASET}.company_profiles"
            )

        except Exception:
            # Log the full exception while continuing with the pipeline
            logger.exception(f"Profile load failed for {symbol}")

        # Log successful completion for the current symbol
        logger.info(f"{symbol} completed")


# Execute the ETL pipeline when this file is run directly
if __name__ == "__main__":
    run()