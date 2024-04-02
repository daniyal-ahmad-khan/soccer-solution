#!/bin/bash

# Start the React dashboard in the background
cd react-app
npm start &

# Ensure the React server has time to start
sleep 10

# Navigate to the Python script directory and run the Python script
cd ../python-app/Usage/soccer-demo/src
python3 main.py

# Keep the container running (optional, uncomment if needed)
# tail -f /dev/null
