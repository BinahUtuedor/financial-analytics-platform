import pandas as pd


def validate_dataframe(df: pd.DataFrame):
    """
    Ensure dataframe is not empty.
    """
    if df.empty:
        raise ValueError("Extracted dataframe is empty.")

    return True