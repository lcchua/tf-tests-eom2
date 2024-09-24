# Installing MySQL on Amazon Linux 2023

# Download the RPM file
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm 

# Install RPM file
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y

# You need the public key of mysql to install the software.
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023

# If you need to install mysql client:
sudo dnf install mysql-community-client -y

# To log into the db server from the ec22 server vis the mysql client
# Then to test the db engine is installed and working properly,
# run the SQL statement - SELECT CURRENT_TIMESTAMP;
# or create a demo db using the create_db_school.sql script.
mysql -h <database-endpoint> -P <database-port> -u <db-username> -p


# https://dev.to/aws-builders/installing-mysql-on-amazon-linux-2023-1512
## FYI if need to install mysql server:
##     sudo dnf install mysql-community-server -y