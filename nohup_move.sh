DATE=$(date +%d%m%y)

for i in $(ls -l /apps/services/ | grep '^d' | awk '{print $9}')
do
	for j in $(ls -l /apps/services/$i | grep '^d' | awk '{print $9}')
		do

			cd /apps/services/$i/$j/
                	if [ -f "nohup.out" ];
			then	
				minimumsize=1000000000
				actualsize=$(wc -c < 'nohup.out')
				if [ $actualsize -ge $minimumsize ]; 
				then
					 /bin/tar -cvzf logs-$DATE-$i-$j.tar.gz logs/
             		 /bin/rm -rf logs/
                     /bin/aws s3 cp logs-$DATE-$i-$j.tar.gz s3://prod-ans-data/nohup-files-10-140-4-133/				         	
   					 mv nohup.out nohup.out-$DATE-$i-$j;
					 /bin/sh commonStart.sh
					 du -sh nohup.out-$DATE* >> /tmp/movedfiles.txt
					 /bin/aws s3 cp nohup.out-$DATE* s3://prod-ans-data/nohup-files-10-140-4-133/
					 /bin/rm -rf nohup.out-$DATE-$i-$j
					 /bin/rm -rf logs-$DATE-$i-$j.tar.gz
					 
				else
    					echo size is under control
				fi
				
			else
			echo "File not Available"
			fi
		done
done

#/bin/setfacl -Rm u:sadab.bloch:r-x /apps/services/
#/bin/setfacl -Rm u:maaz.shaikh:r-x /apps/services/


if [ -f "/tmp/movedfiles.txt" ];
	then
		str=`cat /tmp/movedfiles.txt`
		echo "${str}"
		echo "${str}" | mailx -s "List of service logs move from Production-OPL" -S smtp-use-starttls -S ssl-verify=ignore -S smtp-auth=login -S smtp=smtp://smtp-mail.outlook.com:587 -S from="issue@onlinepsbloans.com" -S smtp-auth-user=issue@onlinepsbloans.com -S smtp-auth-password=Password@123 -S nss-config-dir=/root/.certs/ infra.ans@jansamarth.in  jignesh.mirani@onlinepsbloans.com 2>/dev/null
       		 rm -rf /tmp/movedfiles.txt
fi
