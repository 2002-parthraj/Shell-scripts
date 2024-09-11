#!/bin/bash

# Define the S3 bucket
S3_BUCKET="production-nohup-logs"

# Get the current date in dd-mm-yyyy format
current_date=$(date +%d-%m-%Y)

# Function to process nohup.out files in a given directory
process_nohup_files() {
  local base_dir=$1
  local all_files=()

  # Navigate to the base directory
  cd "$base_dir" || return

  # Collect sizes of all nohup.out files
  for dir in */; do
    # Check if nohup.out exists in the directory
    if [ -f "${dir}nohup.out" ]; then
      # Get the size of the nohup.out file in human-readable format
      file_size_hr=$(du -h "${dir}nohup.out" | cut -f1)
      
      # Get the size of the nohup.out file in bytes
      file_size_bytes=$(du -b "${dir}nohup.out" | cut -f1)
      
      # Store the details in the array
      all_files+=("${dir}nohup.out" "$file_size_hr" "$file_size_bytes")
    fi
  done

  echo "Nohup.out file sizes in ${base_dir}:"
  for ((i=0; i<${#all_files[@]}; i+=3)); do
    echo "Size of ${all_files[i]}: ${all_files[i+1]}"
  done

  echo
  echo "------------------------------------------"
  echo
}

# Base directory
base_dir="/apps/services"

# Iterate over all subdirectories in the base directory and collect sizes
for service_dir in "$base_dir"/*/; do
  process_nohup_files "$service_dir"
done

# Ask for confirmation to move files to S3
read -p "Do you want to move files larger than 1GB to S3? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
  # Process each directory again to move the files
  for service_dir in "$base_dir"/*/; do
    cd "$service_dir" || continue

    for dir in */; do
      if [ -f "${dir}nohup.out" ]; then
        # Get the size of the nohup.out file in bytes
        file_size_bytes=$(du -b "${dir}nohup.out" | cut -f1)
        
        # Check if the file size is greater than 1GB (1073741824 bytes)
        if [ "$file_size_bytes" -gt 1073741824 ]; then
          # Define the new filename with the parent directory name
          parent_folder="${dir%/}"
          new_filename="${parent_folder}-nohup.out"
          s3_path="s3://${S3_BUCKET}/prod-oam-logs/${current_date}/${new_filename}"
          
          # Copy the file to S3 with the new filename
          aws s3 cp "${dir}nohup.out" "${s3_path}"
          
          echo "Copied ${dir}nohup.out to ${s3_path}"
          
          # Check if commonStart.sh exists and run it
          if [ -f "${dir}commonStart.sh" ]; then
            bash "${dir}commonStart.sh"
            echo "Ran commonStart.sh in ${dir}"
          else
            echo "commonStart.sh not found in ${dir}"
          fi
        else
          echo "${dir}nohup.out is less than 1GB and was not copied."
        fi
      fi
    done
  done
else
  echo "Files were not moved to S3."
fi
