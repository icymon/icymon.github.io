## Debian 11 安装MySQL 8

### 下载捆绑包

``` shell
wget https://cdn.mysql.com/archives/mysql-8.0/mysql-server_8.0.30-1debian10_amd64.deb-bundle.tar
```

### 按照顺序执行如下deb包文件

``` shell
sudo dpkg -i mysql-common_8.0.30-1debian10_amd64.deb
sudo dpkg -i mysql-community-client-plugins_8.0.30-1debian10_amd64.deb
sudo dpkg -i libmysqlclient21_8.0.30-1debian10_amd64.deb 
sudo dpkg -i libmysqlclient-dev_8.0.30-1debian10_amd64.deb
```

* 如果遇到依赖问题，执行
``` shell
sudo apt-get -f -y install
```

``` shell
sudo dpkg -i mysql-community-client-core_8.0.30-1debian10_amd64.deb
sudo dpkg -i mysql-community-client_8.0.30-1debian10_amd64.deb
sudo dpkg -i mysql-client_8.0.30-1debian10_amd64.deb
sudo dpkg -i mysql-community-server-core_8.0.30-1debian10_amd64.deb
sudo dpkg -i mysql-community-server_8.0.30-1debian10_amd64.deb
sudo dpkg -i mysql-server_8.0.30-1debian10_amd64.deb
```


### 删除mysql

``` shell
# sudo apt-get remove --purge mysql*
# sudo rm -rf /etc/mysql/
# sudo rm -rf /var/lib/mysql
```

### Ubuntu2204安装mysql
``` shell
$ wget https://cdn.mysql.com/archives/mysql-5.7/mysql-server_5.7.27-1ubuntu19.04_amd64.deb-bundle.tar
$ sudo dpkg -i mysql-common_5.7.27-1ubuntu19.04_amd64.deb
$ sudo apt install libaio1
$ sudo dpkg -i mysql-community-client_5.7.27-1ubuntu19.04_amd64.deb
$ sudo dpkg -i libmysqlclient20_5.7.27-1ubuntu19.04_amd64.deb
$ sudo dpkg -i libmysqlclient-dev_5.7.27-1ubuntu19.04_amd64.deb
$ sudo dpkg -i libmysqld-dev_5.7.27-1ubuntu19.04_amd64.deb
$ sudo dpkg -i mysql-client_5.7.27-1ubuntu19.04_amd64.deb
$ sudo apt install libmecab2
$ sudo dpkg -i mysql-community-server_5.7.27-1ubuntu19.04_amd64.deb
$ sudo dpkg -i mysql-server_5.7.27-1ubuntu19.04_amd64.deb
$ systemctl status mysql
```