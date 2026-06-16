import requests
import pandas as pd

from src.config.settings import ALPHA_VANTAGE_API_KEY


def get_daily_prices(symbol="AAPL"):

    url = (
        "https://www.alphavantage.co/query"
        f"?function=TIME_SERIES_DAILY"
        f"&symbol={symbol}"
        f"&apikey={ALPHA_VANTAGE_API_KEY}"
    )

    response = requests.get(url)

    response.raise_for_status()

    data = response.json()

    prices = data["Time Series (Daily)"]

    df = pd.DataFrame(prices).T.reset_index()

    df.columns = [
        "date",
        "open",
        "high",
        "low",
        "close",
        "volume"
    ]

    df["symbol"] = symbol

    return df