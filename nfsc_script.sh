#!/bin/bash
sudo yum install -y nfs-utils
sudo systemctl enable --now firewalld
sudo firewall-cmd --add-service="nfs3" --add-service="rpc-bind" --add-service="mountd"
sudo firewall-cmd --add-service="nfs3" --add-service="rpc-bind" --add-service="mountd" --permanent
echo "192.168.111.11:/srv/share /mnt/ nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload 
sudo systemctl restart remote-fs.target 

