#*********************1=without export accesskey-secret-key*****************************

#!/bin/bash



echo "Please Input Jar File Full Path:"
echo "+++++++++++++++++++++++++++"
read jarfilepath





if [ -f "/tmp/filename" ];
            then
                            /bin/rm -rf /tmp/filename
                            echo $jarfilepath >> /tmp/filename
                            jar_name=$(/bin/cut -d "/" -f 6 /tmp/filename)
            else
                             echo $jarfilepath >> /tmp/filename
                             jar_name=$(/bin/cut -d "/" -f 6 /tmp/filename)
fi




echo $jar_name



###Upload jar to s3
/bin/aws s3 cp $jarfilepath s3://prod-sidbi-public-image/psbhl/








/bin/aws s3api put-object-acl --bucket prod-sidbi-public-image --key psbhl/$jar_name --acl public-read

echo "Download Link is below"
echo "https://prod-sidbi-public-image.s3.ap-south-1.amazonaws.com/psbhl/"$jar_name






#*********************1=with export accesskey-secret-key*****************************

#!/bin/bash

# Prompt for the JAR file path
echo "Please Input Jar File Full Path:"
echo "+++++++++++++++++++++++++++"
read jarfilepath

# Set AWS credentials
export AWS_ACCESS_KEY_ID="your_access_key_id"
export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
export AWS_DEFAULT_REGION="ap-south-1"  # Set your default region

# Check if the temporary file exists
if [ -f "/tmp/filename" ]; then
    /bin/rm -rf /tmp/filename
    echo $jarfilepath >> /tmp/filename
    jar_name=$(/bin/cut -d "/" -f 6 /tmp/filename)
else
    echo $jarfilepath >> /tmp/filename
    jar_name=$(/bin/cut -d "/" -f 6 /tmp/filename)
fi

# Display the JAR file name
echo $jar_name

# Upload the JAR file to S3
/bin/aws s3 cp $jarfilepath s3://prod-sidbi-public-image/psbhl/

# Set the uploaded JAR file to public-read
/bin/aws s3api put-object-acl --bucket prod-sidbi-public-image --key psbhl/$jar_name --acl public-read

# Display the download link
echo "Download Link is below"
echo "https://prod-sidbi-public-image.s3.ap-south-1.amazonaws.com/psbhl/$jar_name"

# Unset AWS credentials after the operation
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
