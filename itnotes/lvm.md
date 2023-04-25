## LVM 使用

### 安装LVM
``` shell
yum install -y lvm2
```

### 扩容和挂载分区

#### 查看磁盘情况
``` shell
$fdisk -l

磁盘 /dev/sda：21.5 GB, 21474836480 字节，41943040 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：dos
磁盘标识符：0x000b9fbf

   设备 Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200    41943039    19921920   8e  Linux LVM

磁盘 /dev/sdb：1073 MB, 1073741824 字节，2097152 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节


磁盘 /dev/mapper/centos-root：18.2 GB, 18249416704 字节，35643392 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节


磁盘 /dev/mapper/centos-swap：2147 MB, 2147483648 字节，4194304 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
```

#### 使用pvcreate 命令创建PV
``` shell
$pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
# 可以用pvs命令查看系统所有的PV。若想查看PV的详细信息请用pvdisplay 命令
$pvs
  PV         VG     Fmt  Attr PSize   PFree
  /dev/sda2  centos lvm2 a--  <19.00g    0
  /dev/sdb          lvm2 ---    1.00g 1.00g
```

#### 使用vgcreate 命令创建VG
``` shell
$vgcreate vg_centos_01 /dev/sdb
  Volume group "vg_centos_01" successfully created
# 可以用vgs命令查看系统所有的VG。同样，若想查看VG的详细信息请用vgdisplay 命令。
$vgs
  VG           #PV #LV #SN Attr   VSize    VFree
  centos         1   2   0 wz--n-  <19.00g       0
  vg_centos_01   1   0   0 wz--n- 1020.00m 1020.00m
```

#### 使用lvcreate 命令创建LV
``` shell
$lvcreate -L 500M -n lv_centos_01 vg_centos_01
  Logical volume "lv_centos_01" created.
# 可以用lvs命令查看系统所有的LV。若想查看LV的详细信息请用lvdisplay 命令。
$lvs
  LV           VG           Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root         centos       -wi-ao---- <17.00g
  swap         centos       -wi-ao----   2.00g
  lv_centos_01 vg_centos_01 -wi-a----- 500.00m
```

****************************************

#### lvextend 扩容centos（centos是LV名称）

* 首先，确定一下是否有可用的扩容空间，因为空间是从VG里面创建的，并且LV不能跨VG扩容
* lvextend -L +100M  或者lvextend -l +100%free  这里-L -l 需要注意大小写

``` shell
# 删除刚才创建的LV，然后再删除VG，将空间腾出来

$lvremove /dev/vg_centos_01/lv_centos_01
Do you really want to remove active logical volume vg_centos_01/lv_centos_01? [y/n]: y
  Logical volume "lv_centos_01" successfully removed
# 若使用vgreduce命令移除会报错，不能删除LVM卷组中剩余的最后一个物理卷（ Can't remove final physical volume "/dev/sdb" from volume group "vg_centos_01"）
# 改为vgremove
$ vgreduce vg_centos_01 /dev/sdb
  Can't remove final physical volume "/dev/sdb" from volume group "vg_centos_01"
$vgremove vg_centos_01
  Volume group "vg_centos_01" successfully removed
# 扩容卷组
$vgextend centos /dev/sdb
  Volume group "centos" successfully extended
$vgs
  VG     #PV #LV #SN Attr   VSize  VFree
  centos   2   2   0 wz--n- 19.99g 1020.00m
# 进而扩容LV
$lvextend -L +500M /dev/centos/root
  Size of logical volume centos/root changed from <17.00 GiB (4351 extents) to 17.48 GiB (4476 extents).
  Logical volume centos/root successfully resized.

$df -Th
文件系统                类型      容量  已用  可用 已用% 挂载点
devtmpfs                devtmpfs  2.9G     0  2.9G    0% /dev
tmpfs                   tmpfs     2.9G     0  2.9G    0% /dev/shm
tmpfs                   tmpfs     2.9G  8.6M  2.9G    1% /run
tmpfs                   tmpfs     2.9G     0  2.9G    0% /sys/fs/cgroup
/dev/mapper/centos-root xfs        17G  3.5G   14G   21% /
/dev/sda1               xfs      1014M  152M  863M   15% /boot
tmpfs                   tmpfs     581M     0  581M    0% /run/user/0
# lvextend 扩展后只是扩展了lv的大小，而此时文件系统并未感知到，所有还需要使用xfs_growfs、resize2fs等命令来扩展文件系统，xfs_growfs命令是扩展xfs文件系统，resize2fs是扩展ext4文件系统。
$xfs_growfs /dev/centos/root
meta-data=/dev/mapper/centos-root isize=512    agcount=4, agsize=1113856 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=4455424, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 4455424 to 4583424
$df -Th
文件系统                类型      容量  已用  可用 已用% 挂载点
devtmpfs                devtmpfs  2.9G     0  2.9G    0% /dev
tmpfs                   tmpfs     2.9G     0  2.9G    0% /dev/shm
tmpfs                   tmpfs     2.9G  8.6M  2.9G    1% /run
tmpfs                   tmpfs     2.9G     0  2.9G    0% /sys/fs/cgroup
/dev/mapper/centos-root xfs        18G  3.5G   15G   20% /
/dev/sda1               xfs      1014M  152M  863M   15% /boot
tmpfs                   tmpfs     581M     0  581M    0% /run/user/0
```
* lvextend 扩展后只是扩展了lv的大小，而此时文件系统并未感知到，所有还需要使用xfs_growfs、resize2fs等命令来扩展文件系统，xfs_growfs命令是扩展xfs文件系统，resize2fs是扩展ext4文件系统。
****************************************
#### 格式化LV(挂载分区，与扩容不同)

* 注意： ext4可以lvm缩容、扩容；xfs只能lvm扩容，xfs如果需要缩容，需要先格式化。

``` shell
$mkfs.ext4 /dev/vg_centos_01/lv_centos_01
mke2fs 1.42.9 (28-Dec-2013)
文件系统标签=
OS type: Linux
块大小=1024 (log=0)
分块大小=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
128016 inodes, 512000 blocks
25600 blocks (5.00%) reserved for the super user
第一个数据块=1
Maximum filesystem blocks=34078720
63 block groups
8192 blocks per group, 8192 fragments per group
2032 inodes per group
Superblock backups stored on blocks:
        8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409

Allocating group tables: 完成
正在写入inode表: 完成
Creating journal (8192 blocks): 完成
Writing superblocks and filesystem accounting information: 完成
```
#### 创建挂载点，设置开机挂载

``` shell
#创建挂载点为 /test
mkdir /test
#编辑/etc/fstab 文件设置开机自动挂载
vim /etc/fstab
/dev/testvg/testlv /test ext4 defaults 1 2
#挂载/etc/fstab 里面的内容
mount -a 
#测试是否挂载成功
df -hT /test
```
* fstab最后两个数字的含义：

> dump

> 在 Linux 当中，可以利用 dump 这个指令来进行系统的备份的。而 dump 指令则会针对 /etc/fstab 的设定值，去选择是否要将该 partition 进行备份的动作呢！ 0 代表不要做 dump 备份， 1 代表要进行 dump 的动作。 2 也代表要做 dump 备份动作， 不过，该 partition 重要度比 1 小。

> pass

> 开机的过程中，系统预设会以 fsck 检验我们的 partition 内的 filesystem 是否完整 (clean)。 不过，某些 filesystem 是不需要检验的，例如虚拟内存 swap ，或者是特殊档案系统， 例如 /proc 与 /sys 等等。所以，在这个字段中，我们可以设定是否要以 fsck 检验该 filesystem 喔。 0 是不要检验， 1 是要检验， 2 也是要检验，不过 1 会比较早被检验啦！ 一般来说，根目录设定为 1 ，其它的要检验的 filesystem 都设定为 2 就好了。


#### 将/test 文件系统从原来的150M 缩减到100M
``` shell
# 卸载已经挂载的逻辑卷
umount /test
# 缩小文件系统
resize2fs /dev/testvg/testlv 100M
# 缩小LV
lvreduce -L -50M /dev/testvg/testlv
lvs
mount /dev/testvg/testlv /test
df -Th
```




### 参考资料

* [Linux 环境下LVM 逻辑卷的建立、扩容和减容操作](https://cloud.tencent.com/developer/article/1645014)
* [LVM : 简介](https://www.cnblogs.com/sparkdev/p/10130934.html)
* [vgreduce命令 – 删除物理卷](https://www.linuxcool.com/vgreduce)
* [在Linux系统中，删除lv、vg、pv](https://blog.csdn.net/xulin88/article/details/78660419)
* [Linux文件系统扩容](https://www.cnblogs.com/sxFu/p/13426362.html)
* [fstab文件学习](https://blog.csdn.net/farsight2009/article/details/4446338)


































