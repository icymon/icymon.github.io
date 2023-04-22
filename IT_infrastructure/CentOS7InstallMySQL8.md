``` shell
#yum localinstall https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm
#rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
#yum install mysql-community-server
# grep "password" /var/log/mysqld.log
# mysql -uroot -p
>ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1111';
>FLUSH PRIVILEGES;
>CREATE USER 'djh'@'10.0.2.2' IDENTIFIED WITH mysql_native_password BY '1111';
>GRANT ALL PRIVILEGES ON *.* TO 'djh'@'10.0.2.2';
>FLUSH PRIVILEGES;
# sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
# sudo firewall-cmd --reload
```