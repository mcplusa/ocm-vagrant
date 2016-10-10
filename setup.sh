#variables
DBNAME=cms
DBUSERNAME=cms-user
DBPASSWORD=cms123

echo "updating package manager"
sudo yum update > /dev/null
sudo yum upgrade > /dev/null
echo "installing packaages..."
echo "installing php"
sudo yum -y install php > /dev/null
echo "installing httpd"
sudo yum -y install httpd > /dev/null
echo "installing mod_ssl"
sudo yum -y install mod_ssl > /dev/null
echo "installing php-mysql"
sudo yum -y install php-mysql > /dev/null
echo "installing php-cli" 
sudo yum -y install php-cli > /dev/null
echo "installing php-xml"
sudo yum -y install php-xml > /dev/null
echo "installing php-mcrypt"
sudo yum -y install php-mcrypt > /dev/null
echo "installing php-mbstring"
sudo yum -y install php-mbstring > /dev/null
echo "installing php-soap"
sudo yum -y install php-soap > /dev/null
echo "installing wget"
sudo yum -y install wget > /dev/null
echo "installing zip"
sudo yum -y install zip > /dev/null
echo "installing unzip"
sudo yum -y install unzip > /dev/null
#Add the MySql package
#sudo rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
#Install the MySql package
echo "installing mysql"
sudo cp /vagrant/install/mariadb.repo /etc/yum.repos.d/
sudo yum -y update > /dev/null
sudo yum -y install mariadb-server
sudo yum -y install  MariaDB-client
echo "starting services"
sudo systemctl start mariadb
#Todo mysql_secure_installation
echo "creating database $DBNAME"
sudo mysql -e "CREATE DATABASE $DBNAME;"
echo "granting rights to $DBNAME to $DBUSERNAME"
sudo mysql -e "grant all privileges on $DBNAME.* to '$DBUSERNAME'@'localhost' identified by '$DBPASSWORD';"
cd /var/www/html/
echo "fetching ocm from github"
sudo wget https://github.com/michaelcizmar/ocm/archive/master.zip
echo "unzipping ocm"
sudo unzip master.zip
cd ocm-master
echo "moving cms to www root"
sudo mv cms /var/www/html/
echo "moving cms-customer to www root"
sudo mv cms-custom /var/www/html/
echo "removing ocm download"
sudo rm -rf ocm-master
echo "running new_install.sql"
sudo mysql cms < /var/www/html/cms/app/sql/install/new_install.sql
echo "restarting services"
sudo systemctl start httpd
sudo systemctl start mariadb
sudo mysql -e "use cms; update users set username='admin', password=MD5('admin');"