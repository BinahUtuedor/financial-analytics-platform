from src.extract.alpha_vantage import get_daily_prices


def test_alpha_vantage_extract():

    df = get_daily_prices("AAPL")

    assert not df.empty

    assert "close" in df.columns