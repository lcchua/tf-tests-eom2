#!/bin/bash

# After systemctl start httpd, can see the Apache test page 
# if you enter the EC2 Public IPv4 address in your Internet Browser
# Or else after the EC2 instance is ready, can curl http://localhost:80
# to see the display message below

yum update -y
yum install httpd -y
# yum install docker -y
systemctl start httpd
systemctl enable httpd
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
echo "<h1>Hello World! $(hostname -f)</h1>" > /var/www/html/index.html
reboot
