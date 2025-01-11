#!/bin/bash

echo "Welcome to SCP File/Folder Transfer Script"

# Step 1: Server IP
read -p "Enter the server IP: " server_ip

# Step 2: Server User
read -p "Enter the server user: " server_user

# Step 3: PEM file location
read -p "Enter the PEM file location (path): " pem_file

# Step 4: File or Folder
read -p "Do you want to transfer a file or a folder? (file/folder): " transfer_type

# Step 5: Source location based on file or folder
if [ "$transfer_type" == "file" ]; then
    read -p "Enter the file location on your laptop: " source_path
elif [ "$transfer_type" == "folder" ]; then
    read -p "Enter the folder location on your laptop: " source_path
else
    echo "Invalid choice. Please run the script again and choose 'file' or 'folder'."
    exit 1
fi

# Step 6: Server destination location
read -p "Enter the destination location on the server: " dest_path

# Validate PEM file existence
if [ ! -f "$pem_file" ]; then
    echo "The PEM file does not exist. Please check the path and try again."
    exit 1
fi

# Validate source path existence
if [ ! -e "$source_path" ]; then
    echo "The source path does not exist. Please check the path and try again."
    exit 1
fi

# SCP Command
echo "Starting transfer..."
scp -i "$pem_file" -r "$source_path" "$server_user@$server_ip:$dest_path"

# Transfer status
if [ $? -eq 0 ]; then
    echo "Transfer completed successfully."
else
    echo "Transfer failed. Please check the details and try again."
fi

