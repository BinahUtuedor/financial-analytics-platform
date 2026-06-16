from src.extract.alpha_vantage import get_daily_prices
from src.extract.finnhub import get_company_profile

from src.utils.validators import validate_dataframe
from src.utils.logger import logger

from src.load.bigquery_loader import load_dataframe

from src.config.settings import (
    GCP_PROJECT_ID,
    BIGQUERY_DATASET
)


def run():

    symbols = ["AAPL", "MSFT", "GOOGL"]

    for symbol in symbols:

        logger.info(f"Extracting {symbol}")

        prices = get_daily_prices(symbol)

        validate_dataframe(prices)

        load_dataframe(
            prices,
            f"{GCP_PROJECT_ID}.{BIGQUERY_DATASET}.stock_prices"
        )

        profile = get_company_profile(symbol)

        validate_dataframe(profile)

        load_dataframe(
            profile,
            f"{GCP_PROJECT_ID}.{BIGQUERY_DATASET}.company_profiles"
        )

        logger.info(f"{symbol} completed")


if __name__ == "__main__":
    run()