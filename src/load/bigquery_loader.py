import uuid
from google.cloud import bigquery

client = bigquery.Client()


def load_dataframe(df, table_id):
    """
    Load a pandas DataFrame into BigQuery.
    """

    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_APPEND"
    )

    job = client.load_table_from_dataframe(
        df,
        table_id,
        job_config=job_config,
        job_id=f"load_{uuid.uuid4().hex}"
    )

    job.result()

    print(f"Loaded {len(df)} rows into {table_id}")