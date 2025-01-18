#!/bin/bash

echo "Welcome to SCP File/Folder Transfer Script"

# Step 1: Transfer direction
read -p "Do you want to download or send a file/folder? (download/send): " transfer_direction

# Validate transfer direction
if [[ "$transfer_direction" != "download" && "$transfer_direction" != "send" ]]; then
    echo "Invalid choice. Please choose 'download' or 'send'."
    exit 1
fi

# Step 2: Server IP
read -p "Enter the server IP: " server_ip

# Step 3: Server User
read -p "Enter the server user: " server_user

# Step 4: PEM file location
read -p "Enter the PEM file location (path): " pem_file

# Validate PEM file existence
if [ ! -f "$pem_file" ]; then
    echo "The PEM file does not exist. Please check the path and try again."
    exit 1
fi

if [ "$transfer_direction" == "send" ]; then
    # Step 5: File or Folder for sending
    read -p "Do you want to send a file or a folder? (file/folder): " transfer_type

    # Validate choice
    if [ "$transfer_type" != "file" ] && [ "$transfer_type" != "folder" ]; then
        echo "Invalid choice. Please run the script again and choose 'file' or 'folder'."
        exit 1
    fi

    # Step 6: Source location based on file or folder
    read -p "Enter the $transfer_type location on your laptop: " source_path

    # Validate source path existence
    if [ ! -e "$source_path" ]; then
        echo "The source path does not exist. Please check the path and try again."
        exit 1
    fi

    # Step 7: Destination location on the server
    read -p "Enter the destination location on the server: " dest_path

    # SCP Command for sending
    echo "Starting transfer..."
    scp -i "$pem_file" -r "$source_path" "$server_user@$server_ip:$dest_path"

    # Transfer status
    if [ $? -eq 0 ]; then
        echo "Transfer completed successfully."
    else
        echo "Transfer failed. Please check the details and try again."
    fi

elif [ "$transfer_direction" == "download" ]; then
    # Step 5: File or Folder for downloading
    read -p "Do you want to download a file or a folder? (file/folder): " transfer_type

    # Validate choice
    if [ "$transfer_type" != "file" ] && [ "$transfer_type" != "folder" ]; then
        echo "Invalid choice. Please run the script again and choose 'file' or 'folder'."
        exit 1
    fi

    # Step 6: Source location on the server
    read -p "Enter the $transfer_type location on the server: " source_path

    # Step 7: Destination location on your laptop
    read -p "Enter the destination location on your laptop: " dest_path

    # SCP Command for downloading
    echo "Starting transfer..."
    scp -i "$pem_file" -r "$server_user@$server_ip:$source_path" "$dest_path"

    # Transfer status
    if [ $? -eq 0 ]; then
        echo "Download completed successfully."
    else
        echo "Download failed. Please check the details and try again."
    fi
fi

