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