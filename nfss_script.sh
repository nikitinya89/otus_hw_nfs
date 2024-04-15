#!/bin/bash
sudo yum install -y nfs-utils
sudo systemctl enable --now firewalld
sudo firewall-cmd --add-service="nfs3" --add-service="rpc-bind" --add-service="mountd"
sudo firewall-cmd --add-service="nfs3" --add-service="rpc-bind" --add-service="mountd" --permanent
sudo systemctl enable --now nfs
sudo mkdir -p /srv/share/upload
sudo chown -R nfsnobody:nfsnobody /srv/share 
sudo chmod 0777 /srv/share/upload
echo "/srv/share 192.168.111.12(rw,sync,root_squash)" | sudo tee /etc/exports
sudo exportfs -r