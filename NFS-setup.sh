link https://medium.com/@pranaypatel1707/network-file-system-nfs-implementation-8e2dfc5bf1d8 


nfs- server 

sudo apt update
sudo apt install nfs-kernel-server
sudo systemctl status nfs-kernel-server
sudo systemctl enable nfs-kernel-server

#(Create an NFS Export Directory )

sudo mkdir /nfsshare 
sudo chmod 777 -R /nfsshare


#Grant NFS Share Access to Client Systems
sudo vim etc/exports

#To grant access to a single client, use the syntax:
    /nfsshare  client_IP_1 (re,sync,no_root_squash,no_subtree_check)

#For multiple clients, specify each client on a separate line:
    /nfs_share  client_IP_1 (re,sync,no_root_squash,no_subtree_check)
    /nfs_share  client_IP_2 (re,sync,no_root_squash,no_subtree_check)

#example 
    /nfs_share  192.168.67.206 (rw,sync,no_root_squash,no_subtree_check)



#Export the NFS Share Directory
    sudo exportfs -a



sudo systemctl restart nfs-kernel-server


#allow NFS Access through the Firewall
    sudo ufw allow from 192.168.67.206 to any port nfs





nfs-client 

#Install the NFS-Common Package
    apt install nfs-common

#Create an NFS Mount Point on Client
    sudo mkdir /nfs

#Mount NFS Share on Client System
    sudo mount 192.168.69.173:/nfsshare /nfs

#Testing the NFS Share on Client System
    sudo touch /nfs/file

ls nfsshare













#Remove NFS Services from machine
sudo apt-get remove nfs-kernel-server
sudo apt-get remove nfs-common


