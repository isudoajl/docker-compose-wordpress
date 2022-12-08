#!/bin/bash

echo '*** Generating Certs ***'
openssl req -x509 -newkey rsa:2048 -days 365 -keyout wordpress-docker.test-key.pem -nodes -out wordpress-docker.test.pem -subj "/C=PT/ST=SINTRA/L=LISBON/O=PIEDAD/OU=IT DEPT/CN=camaster/emailAddress=xxx@gmail.com" 

mv *.pem nginx/certs

echo '*** Downloading wordpress.org source code ***'
wget http://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rm latest.tar.gz

echo '*** Change directory permission to mysql can access the volume ***'

podman unshare chown -R 27:27 mysql

echo '*** Changing the SELinux context of volumes to container process can access to it ***'
echo '*** Please change variable name ${USER} ***'

sudo semanage fcontext -a -t container_file_t "/home/${USER}/docker-compose-wordpress/mysql(/.*)?"
sudo semanage fcontext -a -t container_file_t "/home/${USER}/docker-compose-wordpress/wordpress(/.*)?"

echo '*** Aplying restorecon ***'

sudo restorecon -RFvv /home/${USER}/docker-compose-wordpress/mysql
sudo restorecon -RFvv /home/${USER}/docker-compose-wordpress/wordpress
