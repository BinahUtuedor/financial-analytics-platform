import pandas as pd
import pytest

from src.utils.validators import validate_dataframe


def test_validate_dataframe():

    df = pd.DataFrame({"a": [1]})

    assert validate_dataframe(df)


def test_empty_dataframe():

    with pytest.raises(ValueError):
        validate_dataframe(pd.DataFrame())