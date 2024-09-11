#!/bin/bash

yum install dnf-automatic -y 

vim /etc/dnf/automatic.conf

systemctl enable --now dnf-automatic.timer

systemctl enable --now dnf-automatic-notifyonly.timer

systemctl enable --now dnf-automatic-download