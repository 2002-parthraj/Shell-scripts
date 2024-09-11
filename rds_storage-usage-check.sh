#!/bin/bash

# RDS Instance Identifier
DB_INSTANCE_ID="psb-opl-db"

# Array to hold month names
MONTHS=("July" "June" "May" "April" "March" "February")

# Check if bc is installed
if ! command -v bc &> /dev/null; then
    echo "bc command not found. Please install bc."
    exit 1
fi

# Get the current date
CURRENT_DATE=$(date -d "$(date +"%Y-%m-01") -1 month" +"%Y-%m-01T00:00:00Z")

# Loop over the last 6 months
for i in {0..5}; do
    # Calculate the end date for the current month
    END_DATE=$(date -d "$CURRENT_DATE" +"%Y-%m-01T00:00:00Z")
    
    # Calculate the start date for the current month
    START_DATE=$(date -d "$END_DATE -1 month" +"%Y-%m-01T00:00:00Z")

    # Fetch free storage space for the start of the month
    START_STORAGE=$(aws cloudwatch get-metric-statistics \
      --namespace "AWS/RDS" \
      --metric-name "FreeStorageSpace" \
      --dimensions Name=DBInstanceIdentifier,Value=$DB_INSTANCE_ID \
      --start-time $START_DATE \
      --end-time $START_DATE \
      --period 86400 \
      --statistics "Average" \
      --query 'Datapoints[0].Average' \
      --output text)

    # Fetch free storage space for the end of the month
    END_STORAGE=$(aws cloudwatch get-metric-statistics \
      --namespace "AWS/RDS" \
      --metric-name "FreeStorageSpace" \
      --dimensions Name=DBInstanceIdentifier,Value=$DB_INSTANCE_ID \
      --start-time $END_DATE \
      --end-time $(date -d "$END_DATE +1 month" +"%Y-%m-01T00:00:00Z") \
      --period 86400 \
      --statistics "Average" \
      --query 'Datapoints[0].Average' \
      --output text)

    # Handle possible empty responses
    START_STORAGE=${START_STORAGE:-0}
    END_STORAGE=${END_STORAGE:-0}

    # Convert to GB using awk
    START_STORAGE_GB=$(awk "BEGIN {print $START_STORAGE / 1024 / 1024 / 1024}")
    END_STORAGE_GB=$(awk "BEGIN {print $END_STORAGE / 1024 / 1024 / 1024}")

    # Calculate storage used
    STORAGE_USED=$(awk "BEGIN {print $START_STORAGE_GB - $END_STORAGE_GB}")

    # Print the result
    echo "${MONTHS[$i]} - ${STORAGE_USED} GB"

    # Set the current date to the start date for the next iteration
    CURRENT_DATE=$START_DATE
done
