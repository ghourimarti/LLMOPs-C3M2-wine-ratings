#!/bin/bash
# step 1: Virtual Environment
echo "<----------------------------- Virtual Environment --------------------------->"
echo "Creating a virtual environment..."
echo "<----------------------------- Virtual Environment --------------------------->"
python3 -m venv .pipeline
source .pipeline/bin/activate



# Step 2: Install Apache Airflow
echo "<----------------------------- Apache Airflow --------------------------->"
echo "Installing Apache Airflow..."
echo "<----------------------------- Apache Airflow --------------------------->"
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.10.5/docker-compose.yaml'



# Step 3: Create directories for DAGs, logs, and plugins
echo "<----------------------------- Directories --------------------------->"
echo "Creating directories for DAGs, logs, and plugins..."
echo "<----------------------------- Directories --------------------------->"
mkdir -p ./dags ./logs ./plugins ./config



# step 4: Create a .env file
echo "<----------------------------- .env File --------------------------->"
echo "Creating a .env file..."
echo "<----------------------------- .env File --------------------------->"
# Create a .env file with the following content
echo -e "AIRFLOW_UID=$(id -u)" > .env



# Step 5: Start the Airflow services using Docker Compose
echo "<----------------------------- Docker Compose --------------------------->"
echo "Starting the Airflow services using Docker Compose..."
echo "<----------------------------- Docker Compose --------------------------->"
docker-compose up airflow-init



# Step 6: Docker Compose up
echo "<----------------------------- Docker Compose Up --------------------------->"
echo "Starting the Airflow services..."
echo "<----------------------------- Docker Compose Up --------------------------->"
# Start the Airflow services using Docker Compose
echo "Open your web browser and go to:"
echo "http://localhost:8080"
docker-compose up


# Step 8: Access the Airflow web interface
# Open your web browser and go to http://localhost:8080
# ./doc_airflow.sh


# <------------------------------------------->
# check fro running container
# docker ps
# eg 
# CONTAINER ID   IMAGE                  NAME                 STATUS
# abc123         apache/airflow:2.X    airflow-webserver    Up ...
# def456         apache/airflow:2.X    airflow-scheduler    Up ...
# ...

# docker exec -it abc123 bash  this will enter you in bash of container than 
# we can check the dags status, test them etc

# <------------------------------------------->
# Step 9: Stop the Airflow services
# docker-compose down
# remove all running containers related to airflow
# docker rm -f $(docker ps -aq --filter "name=airflow")
# remove all images related to airflow
# docker rmi -f $(docker images -q --filter "reference=apache/airflow")
# remove all volumes related to airflow
# docker volume rm -f $(docker volume ls -q --filter "name=airflow")
# Step 10: Stop the Airflow services
# docker-compose down
# Remove the virtual environment
# rm -rf .airflow_venv 



