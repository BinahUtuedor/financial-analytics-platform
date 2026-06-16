from dotenv import load_dotenv
load_dotenv()

from google.cloud import bigquery

client = bigquery.Client()

print("Project:", client.project)

datasets = list(client.list_datasets())

for ds in datasets:
    print(ds.dataset_id)