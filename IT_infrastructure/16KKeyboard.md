# 蛟龙16K安装Debian12（Linux高版本）键盘失灵
## 修改DSDT表，打补丁覆盖BIOS中DSDT设置

``` shell
cat /sys/firmware/acpi/tables/DSDT > dsdt.dat
apt install acpica-tools
iasl -d dsdt.dat
```

* 修改PS2K设备下的`IRQ（Edge,ActiveLow,Shared,) ` -> `IRQ（Edge,ActiveHigh,Shared,)`
* 修改 `DefinitionBlock （""，"DSDT"，2，` 中最后的步进值+1  `0x01072009`-> `0x0107200A`

>> DefinitionBlock上面的 `OEM Revision	0x0107200A(17244170)` 貌似可以不用管

``` shell 
DefinitionBlock('", "DSDT", 2, "ALASKA", "A M I", 0x0107200A)
```

### 打包补丁并应用
``` shell 
iasl dsdt.dsl
mkdir -p kernel/firmware/acpi
cp dsdt.aml kernel/firmware/acpi/
find kernel | cpio -H newc --create › acpi_override
cp acpi_override /boot/acpi_override
echo "GRUB_EARLY_INITRD_LINUX_CUSTOM=\"acpi_override\"" »/etc/default/grub
sudo update-grub2
```