from google.cloud import bigquery


def load_dataframe(df, table_id):

    client = bigquery.Client()

    job = client.load_table_from_dataframe(
        df,
        table_id
    )

    job.result()

    print(f"Loaded {len(df)} rows into {table_id}")