import requests
import pandas as pd

from src.config.settings import FINNHUB_API_KEY


def get_company_profile(symbol="AAPL"):

    url = (
        "https://finnhub.io/api/v1/stock/profile2"
        f"?symbol={symbol}"
        f"&token={FINNHUB_API_KEY}"
    )

    response = requests.get(url)

    response.raise_for_status()

    data = response.json()

    return pd.DataFrame([data])