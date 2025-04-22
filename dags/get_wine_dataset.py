import logging

from datetime import datetime
from airflow import DAG, Dataset
from airflow.decorators import task
from airflow.operators.python import is_venv_installed

log = logging.getLogger(__name__)

RAW_WINE_DATASET = Dataset("file://localhost/airflow/datasets/raw_wine_dataset.csv")

with DAG(
    dag_id="A_wine_dataset_get",
    schedule=None,
    start_date=datetime(2025, 1, 1),
    tags=["example"],
) as dag:

    if not is_venv_installed():
        raise RuntimeError("virtualenv is not installed!")
    else:
        @task.virtualenv(
            task_id="virtualenv_python", 
            requirements=["pandas"],
            system_site_packages=False, 
            outlets=[RAW_WINE_DATASET]
        )
        def retrieve_dataset():
            import pandas as pd
            import os
            os.makedirs("/sources/datasets", exist_ok=True)
            df = pd.read_csv("https://raw.githubusercontent.com/paiml/wine-ratings/main/wine-ratings.csv", index_col=0)
            df.to_csv("/sources/datasets/raw_wine_dataset.csv")
        retrieve_dataset()


