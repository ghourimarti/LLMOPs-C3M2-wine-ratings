
#!/bin/bash
# This script installs Apache Airflow on a Windows machine using WSL (Windows Subsystem for Linux) and Ubuntu.
# It sets up a virtual environment, installs necessary packages, and initializes the Airflow database.
# It also creates a user with admin privileges and starts the Airflow web server.

# step 1: Install WSL
echo "<----------------------------- WSL --------------------------->"
echo "Installing WSL..."
echo "<----------------------------- WSL --------------------------->"

# Check if WSL is already installed
if ! wsl --list > /dev/null 2>&1; then
    echo "WSL is not installed. Installing WSL..."
    # Install WSL
    wsl --install
else
    echo "WSL is already installed."
fi


# step 2: Install Ubuntu
echo "<----------------------------- Ubuntu --------------------------->"
echo "Installing Ubuntu..."
echo "<----------------------------- Ubuntu --------------------------->"
# Check if Ubuntu is already installed
sudo apt update && sudo apt upgrade -y
sudo apt install python3-pip python3-venv libpq-dev -y

# step 3: create a virtual environment
echo "<----------------------------- Virtual Environment --------------------------->"
echo "Creating a virtual environment..."
echo "<----------------------------- Virtual Environment --------------------------->"
python3 -m venv .pipeline
source .pipeline/bin/activate

# step 4: Install additional packages
echo "<----------------------------- Additional Packages --------------------------->"
echo "Installing additional packages..."
echo "<----------------------------- Additional Packages --------------------------->"
pip install --upgrade pip setuptools wheel

# step 5: Install Apache Airflow
echo "<----------------------------- Apache Airflow --------------------------->"
echo "Installing Apache Airflow..."
echo "<----------------------------- Apache Airflow --------------------------->"
export AIRFLOW_VERSION=2.10.5
export PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
export CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
echo "Using constraint URL:"
echo "${CONSTRAINT_URL}"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# step 7: Initialize the database
echo "<----------------------------- Database Initialization --------------------------->"
echo "Initializing the database..."
echo "<----------------------------- Database Initialization --------------------------->"
airflow db init

# step 8: Create a user, Create a user with the following details:
echo "<----------------------------- User Creation --------------------------->"
echo "Creating a user..."
echo "<----------------------------- User Creation --------------------------->"
username: admin
firstname: Admin
lastname: User
role: Admin
email: ghourimarti@gmail.com
password: admin
port=8080

airflow users create \
    --username $username \
    --firstname  $firstname\
    --lastname  $lastname\
    --role  $role\
    --email $email
    --password $password

# step 9: Start the web server
echo "Starting the web server..."
airflow webserver --port $port --daemon
echo "Airflow web server started on port $port"
echo "You can access the web interface at http://localhost:$port"


# <----------------------------- New Terminal -------------------------->
# step 10: Start the scheduler
# airflow scheduler --daemon

# # step 12: Stop the web server and scheduler
# airflow webserver --stop
# airflow scheduler --stop

# # step 13: Deactivate the virtual environment
# deactivate

# # step 14: Remove the virtual environment
# rm -rf .airflow_venv 


