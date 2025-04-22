import logging

from datetime import datetime
from airflow import DAG, Dataset
from airflow.decorators import task
from airflow.operators.python import is_venv_installed

log = logging.getLogger(__name__)

RAW_WINE_DATASET = Dataset("file:///sources/datasets/raw_wine_dataset.csv")

with DAG(
    dag_id="A-wine_dataset_consumer",
    schedule=[RAW_WINE_DATASET],
    start_date=datetime(2025, 1, 1),
    tags=["example"],
) as dag:

    if not is_venv_installed():
        raise RuntimeError("virtualenv is not installed!")
    else:
        @task.virtualenv(
            task_id="virtualenv_python", 
            requirements=["pandas"],
            system_site_packages=False
        )
        def clean_dataset():
            import pandas as pd
            import os

            input_path = "/sources/datasets/raw_wine_dataset.csv"
            output_path = "/sources/datasets/cleaned_dataset.csv"

            df = pd.read_csv(input_path, index_col=0)
            df = df.replace({"\r": ""}, regex=True)
            df = df.replace({"\n": " "}, regex=True)
            df.drop(['grape'], axis=1, inplace=True)
            os.makedirs("/sources/datasets", exist_ok=True)
            df.to_csv(output_path)

        @task.virtualenv(
            task_id="sqlite_persist_wine_data", 
            requirements=["pandas", "sqlalchemy"],
            system_site_packages=False
        )
        def persist_dataset():
            import pandas as pd
            from sqlalchemy import create_engine

            db_path = "/sources/tmp/wine_dataset.db"
            engine = create_engine(f"sqlite:///{db_path}", echo=False)

            df = pd.read_csv("/sources/datasets/cleaned_dataset.csv", index_col=0)
            df.to_sql('wine_dataset', engine, if_exists='replace')

            # Save just the notes column separately if it exists
            if 'notes' in df.columns:
                df[['notes']].to_sql("wine_notes", engine, if_exists='replace')
            
            clean_dataset() >> persist_dataset()



