# install Oracle On CentOS7
## base_setting.sh

``` shell
#! /bin/sh

#setting firewall
systemctl stop firewalld
systemctl disable firewalld

#service iptables
service iptables stop
chkconfig iptables off

#setting selinux
echo "SELINUX=disabled"       >  /etc/selinux/config
echo "SELINUXTYPE=targeted"   >> /etc/selinux/config

#list file opend
yum -y install lsof

#timezone-setting
timedatectl set-timezone Asia/Shanghai

#add user and group(nologin)
groupadd -g 1050 abcuser
useradd -u 1050 -g 1050 abcuser -s /sbin/nologin

#create new directory 
mkdir /etc/abcuser
chown -R abcuser:abcuser /etc/abcuser
chmod 755 /etc/abcuser

mkdir /var/abcuser
chown -R abcuser:abcuser /var/abcuser
chmod 744 /var/abcuser

# setting system maxopenfiles
#echo "fs.file-max=200000"                            >> /etc/sysctl.conf
#echo "fs.nr_open=100000"                             >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 20000 60000"    >> /etc/sysctl.conf
sysctl -p

#setting user maxopenfiles
echo "*              soft       noflie           200000" >> /etc/security/limits.conf 
echo "*              hard       nofile           200000" >> /etc/security/limits.conf

```

## oracle_env.sh

``` shell

#!/bin/bash
# abcuser.com.cn 2016© Dingjinhu
# sed -i '$a bye' ab
# sed 's/'h'/'hello'/g' ab
######oracle setup configuration##################################
# /etc/security/limits.conf
echo 'oracle soft nproc 2047' >> /etc/security/limits.conf 
echo 'oracle hard nproc 16384' >> /etc/security/limits.conf 
echo 'oracle soft nofile 1024' >> /etc/security/limits.conf 
echo 'oracle hard nofile 65536' >> /etc/security/limits.conf 
# /etc/pam.d/login
echo 'session required /lib/security/pam_limits.so' >> /etc/pam.d/login
echo 'session required pam_limits.so' >> /etc/pam.d/login
# /etc/sysctl.conf
echo 'net.ipv4.icmp_echo_ignore_broadcasts = 1' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.rp_filter = 1' >> /etc/sysctl.conf
echo 'fs.file-max = 6815744' >> /etc/sysctl.conf
echo 'fs.aio-max-nr = 1048576' >> /etc/sysctl.conf
echo 'kernel.shmall = 4194304' >> /etc/sysctl.conf
echo 'kernel.shmmax = 17179869184' >> /etc/sysctl.conf
echo 'kernel.shmmni = 4096' >> /etc/sysctl.conf
echo 'kernel.sem = 250 32000 100 128' >> /etc/sysctl.conf
echo 'net.ipv4.ip_local_port_range = 9000 65500' >> /etc/sysctl.conf
echo 'net.core.rmem_default = 4194304' >> /etc/sysctl.conf
echo 'net.core.rmem_max = 4194304' >> /etc/sysctl.conf
echo 'net.core.wmem_default = 262144' >> /etc/sysctl.conf
echo 'net.core.wmem_max = 1048576' >> /etc/sysctl.conf
sysctl -p
# /etc/profile
echo 'if [ $USER = "oracle" ]; then' >> /etc/profile
echo '    if [ $SHELL = "/bin/ksh" ]; then' >> /etc/profile
echo '        ulimit -p 16384' >> /etc/profile
echo '        ulimit -n 65536' >> /etc/profile
echo '    else' >> /etc/profile
echo '        ulimit -u 16384 -n 65536' >> /etc/profile
echo '    fi' >> /etc/profile
echo 'fi' >> /etc/profile
# create user and group
groupadd oinstall
groupadd dba
useradd -g oinstall -G dba -m oracle
passwd oracle
# create the directory for oracle
mkdir -p /var/oracle/app
mkdir -p /var/oracle/app/oracle
mkdir -p /var/oracle/app/oradata
mkdir -p /var/oracle/app/oracle/product
chown -R oracle:oinstall /var/oracle/app
chown -R oracle:oinstall /var/oracle
# /home/oracle/.bash_profile
echo 'export ORACLE_BASE=/var/oracle/app' >> /home/oracle/.bash_profile
echo 'export ORACLE_HOME=$ORACLE_BASE/oracle/product/11.2.0/dbhome_1' >> /home/oracle/.bash_profile
echo 'export ORACLE_SID=orcl' >> /home/oracle/.bash_profile
echo 'export PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin' >> /home/oracle/.bash_profile
echo 'export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib' >> /home/oracle/.bash_profile
# yum install tools for oracle
yum install -y binutils*
yum install -y compat-libstdc*
yum install -y elfutils-libelf*
yum install -y gcc*
yum install -y glibc*
yum install -y libaio*
yum install -y libgcc*
yum install -y libstdc*
yum install -y make*
yum install -y sysstat*
yum install -y libXp*
yum install -y pdksh*
yum install -y unixODBC*
yum install -y glibc-kernheaders
# swap
dd if=/dev/zero of=/var/swapfile bs=1024 count=4194304
mkswap /var/swapfile
chmod 0600 /var/swapfile
swapon /var/swapfile
echo '/var/swapfile           swap                    swap    defaults        0 0' >> /etc/fstab
swapon -s
# reboot
reboot


```