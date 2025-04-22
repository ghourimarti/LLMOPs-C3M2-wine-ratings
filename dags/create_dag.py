import logging
from datetime import datetime, timedelta
from airflow import DAG
from airflow.decorators import task
from airflow.operators.python import PythonVirtualenvOperator, is_venv_installed
log = logging.getLogger(__name__)
with DAG(
    dag_id="A-create-dag",
    schedule=timedelta(days=2),
    start_date=datetime(2025, 4, 1),
    tags=["example"],
) as dag:
    if not is_venv_installed():
        raise RuntimeError("The virtualenv_python example task requires virtualenv, please install it.")
        log.warning("The virtalenv_python example task requires virtualenv, please install it.")
    else:
        @task.virtualenv(
            task_id="virtualenv_python", 
            requirements=["pandas"], 
            system_site_packages=False
        )
        def pandas_head():
            import pandas as pd
            csv_url = "https://raw.githubusercontent.com/patmt/wine-ratings/main/wine-ratings.csv"
            df = pd.read_csv(csv_url, index_col=0)
            head = df.head(10)
            return head.to_csv()
        pandas_task = pandas_head()