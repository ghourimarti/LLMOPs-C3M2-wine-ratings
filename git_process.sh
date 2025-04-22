#  Step 1: Initialize Git in Your Local Project Folder
git init

# Step 2: Add Your Project Files to the Staging Area
git add .

# Step 3: Commit Your Changes 
# This command creates a snapshot of your project files in the current state.
git commit -m "Initial commit to dev branch"

# Step 4: Create a New Repository on GitHub
# Go to GitHub and create a new repository. Do not initialize it with a README, .gitignore, or license.

# Step 5: Link Your Local Repository to the GitHub Repository
# Replace <username> and <repository> with your GitHub username and repository name.
git remote add origin https://github.com/ghourimarti/LLMOPs-C3M2-apache-airflow.git

# step 6: Push Your Changes to GitHub
git push -u origin dev



