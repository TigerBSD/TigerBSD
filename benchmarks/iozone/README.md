# iozone benchmarks

scbus0 corresponds to the HDD/SSD bay. scbus1 corresponds to the CD/DVD tray.

## Drive info

### Corsair Force LE SSD, S/N 1631801900010416034F

```sh
$ doas camcontrol identify ada0
pass0: <Corsair Force LE SSD SAFC12.2> ACS-2 ATA SATA 3.x device
pass0: 600.000MB/s transfers (SATA 3.x, UDMA5, PIO 8192bytes)

protocol              ATA/ATAPI-9 SATA 3.x
device model          Corsair Force LE SSD
firmware revision     SAFC12.2
serial number         1631801900010416034F
cylinders             16383
heads                 16
sectors/track         63
sector size           logical 512, physical 512, offset 0
LBA supported         268435455 sectors
LBA48 supported       468862128 sectors
PIO supported         PIO4
DMA supported         WDMA2 UDMA6
media RPM             non-rotating

Feature                      Support  Enabled   Value           Vendor
read ahead                     yes	yes
write cache                    yes	yes
flush cache                    yes	yes
overlap                        no
Tagged Command Queuing (TCQ)   no	no
Native Command Queuing (NCQ)   yes		32 tags
NCQ Queue Management           no
NCQ Streaming                  no
Receive & Send FPDMA Queued    no
SMART                          yes	yes
microcode download             yes	yes
security                       yes	no
power management               yes	yes
advanced power management      yes	yes	254/0xFE
automatic acoustic management  no	no
media status notification      no	no
power-up in Standby            no	no
write-read-verify              no	no
unload                         no	no
general purpose logging        yes	yes
free-fall                      no	no
Data Set Management (DSM/TRIM) yes
DSM - max 512byte blocks       yes              8
DSM - deterministic read       yes              zeroed
Host Protected Area (HPA)      yes      no      468862128/468862128
HPA - Security                 no
```

### INTEL SSDSC2BW240A4, S/N CVDA615500SP2403GN

```sh
$ doas camcontrol identify ada1
pass1: <INTEL SSDSC2BW240A4 DC32> ACS-2 ATA SATA 3.x device
pass1: 600.000MB/s transfers (SATA 3.x, UDMA5, PIO 8192bytes)

protocol              ATA/ATAPI-9 SATA 3.x
device model          INTEL SSDSC2BW240A4
firmware revision     DC32
serial number         CVDA615500SP2403GN
WWN                   55cd2e414cb981fb
cylinders             16383
heads                 16
sectors/track         63
sector size           logical 512, physical 512, offset 0
LBA supported         268435455 sectors
LBA48 supported       468862128 sectors
PIO supported         PIO4
DMA supported         WDMA2 UDMA6
media RPM             non-rotating

Feature                      Support  Enabled   Value           Vendor
read ahead                     yes	yes
write cache                    yes	yes
flush cache                    yes	yes
overlap                        no
Tagged Command Queuing (TCQ)   no	no
Native Command Queuing (NCQ)   yes		32 tags
NCQ Queue Management           no
NCQ Streaming                  no
Receive & Send FPDMA Queued    no
SMART                          yes	yes
microcode download             yes	yes
security                       yes	no
power management               yes	yes
advanced power management      yes	yes	254/0xFE
automatic acoustic management  no	no
media status notification      no	no
power-up in Standby            yes	no
write-read-verify              no	no
unload                         yes	yes
general purpose logging        yes	yes
free-fall                      no	no
Data Set Management (DSM/TRIM) yes
DSM - max 512byte blocks       yes              1
DSM - deterministic read       yes              any value
Host Protected Area (HPA)      yes      no      468862128/468862128
HPA - Security                 no
```

## 2016-10-13 Single SSD FDE

For this benchmark, the following configuration was in effect:

* ThinkPad UEFI BIOS SATA Controller Mode Option: Compatibility
* Encrypted ZFS root pool consisting of:
  - ada0p4.eli
* ada0 at ata0 bus 0 scbus0 target 0 lun 0
  - ada0: Corsair Force LE SSD SAFC12.2
* Benchmarking on ZFS filesystem zroot/benchmark

```sh
$ diskinfo -v /dev/ada0
/dev/ada0
	512         	# sectorsize
	240057409536	# mediasize in bytes (224G)
	468862128   	# mediasize in sectors
	0           	# stripesize
	0           	# stripeoffset
	465141      	# Cylinders according to firmware.
	16          	# Heads according to firmware.
	63          	# Sectors according to firmware.
	1631801900010416034F	# Disk ident.
	Not_Zoned   	# Zone Mode
```

```sh
$ diskinfo -v /dev/ada0p4
	512         	# sectorsize
	229318328320	# mediasize in bytes (214G)
	447887360   	# mediasize in sectors
	0           	# stripesize
	2148532224  	# stripeoffset
	444332      	# Cylinders according to firmware.
	16          	# Heads according to firmware.
	63          	# Sectors according to firmware.
	1631801900010416034F	# Disk ident.
```

```sh
$ diskinfo -v /dev/ada0p4.eli
	4096        	# sectorsize
	229318324224	# mediasize in bytes (214G)
	55985919    	# mediasize in sectors
	0           	# stripesize
	0           	# stripeoffset
	55541       	# Cylinders according to firmware.
	16          	# Heads according to firmware.
	63          	# Sectors according to firmware.
	1631801900010416034F	# Disk ident.
```

```sh
$ zfs get all zroot/benchmark
NAME             PROPERTY              VALUE                  SOURCE
zroot/benchmark  type                  filesystem             -
zroot/benchmark  creation              Thu Oct 13  0:33 2016  -
zroot/benchmark  used                  96K                    -
zroot/benchmark  available             108G                   -
zroot/benchmark  referenced            96K                    -
zroot/benchmark  compressratio         1.00x                  -
zroot/benchmark  mounted               yes                    -
zroot/benchmark  quota                 none                   default
zroot/benchmark  reservation           none                   default
zroot/benchmark  recordsize            128K                   default
zroot/benchmark  mountpoint            /benchmark             local
zroot/benchmark  sharenfs              off                    default
zroot/benchmark  checksum              on                     default
zroot/benchmark  compression           lz4                    inherited from zroot
zroot/benchmark  atime                 off                    inherited from zroot
zroot/benchmark  devices               on                     default
zroot/benchmark  exec                  on                     default
zroot/benchmark  setuid                on                     default
zroot/benchmark  readonly              off                    inherited from zroot
zroot/benchmark  jailed                off                    default
zroot/benchmark  snapdir               hidden                 default
zroot/benchmark  aclmode               discard                default
zroot/benchmark  aclinherit            restricted             default
zroot/benchmark  canmount              on                     default
zroot/benchmark  xattr                 off                    temporary
zroot/benchmark  copies                1                      default
zroot/benchmark  version               5                      -
zroot/benchmark  utf8only              off                    -
zroot/benchmark  normalization         none                   -
zroot/benchmark  casesensitivity       sensitive              -
zroot/benchmark  vscan                 off                    default
zroot/benchmark  nbmand                off                    default
zroot/benchmark  sharesmb              off                    default
zroot/benchmark  refquota              none                   default
zroot/benchmark  refreservation        none                   default
zroot/benchmark  primarycache          all                    default
zroot/benchmark  secondarycache        all                    default
zroot/benchmark  usedbysnapshots       0                      -
zroot/benchmark  usedbydataset         96K                    -
zroot/benchmark  usedbychildren        0                      -
zroot/benchmark  usedbyrefreservation  0                      -
zroot/benchmark  logbias               latency                default
zroot/benchmark  dedup                 off                    default
zroot/benchmark  mlslabel                                     -
zroot/benchmark  sync                  standard               default
zroot/benchmark  refcompressratio      1.00x                  -
zroot/benchmark  written               96K                    -
zroot/benchmark  logicalused           40.5K                  -
zroot/benchmark  logicalreferenced     40.5K                  -
zroot/benchmark  volmode               default                default
zroot/benchmark  filesystem_limit      none                   default
zroot/benchmark  snapshot_limit        none                   default
zroot/benchmark  filesystem_count      none                   default
zroot/benchmark  snapshot_count        none                   default
zroot/benchmark  redundant_metadata    all                    default
```

## 2016-10-31 Tray SSD 4k UFS Plain

* ThinkPad UEFI BIOS SATA Controller Mode Option: Compatibility
* Encrypted ZFS root pool consisting of:
  - ada0p4.eli
* ada0 at ata0 bus 0 scbus0 target 0 lun 0
  - ada0: Corsair Force LE SSD SAFC12.2
* ada1 at ata1 bus 0 scbus1 target 0 lun 0
  - ada1: INTEL SSDSC2BW240A4 DC32
* Benchmarking on UFS filesystem /dev/ada1p1

```sh
$ gpart create -s GPT ada1
ada1 created
$ gpart add -t freebsd-ufs -a 4k ada1
ada1p1 added
$ doas newfs -U /dev/ada1p1
[...]
$ doas mount /dev/ada1p1 /benchmark/
```

```sh
$ diskinfo -v /dev/ada1
/dev/ada1
	512         	# sectorsize
	240057409536	# mediasize in bytes (224G)
	468862128   	# mediasize in sectors
	4096        	# stripesize
	0           	# stripeoffset
	465141      	# Cylinders according to firmware.
	16          	# Heads according to firmware.
	63          	# Sectors according to firmware.
	CVDA615500SP2403GN	# Disk ident.
	Not_Zoned   	# Zone Mode
```

```sh
$ diskinfo -v /dev/ada1p1
/dev/ada1p1
	512         	# sectorsize
	240057364480	# mediasize in bytes (224G)
	468862040   	# mediasize in sectors
	4096        	# stripesize
	0           	# stripeoffset
	465140      	# Cylinders according to firmware.
	16          	# Heads according to firmware.
	63          	# Sectors according to firmware.
	CVDA615500SP2403GN	# Disk ident.
```

```sh
$ doas umount /dev/ada1p1
$ gpart delete -i 1 ada1
ada1p1 deleted
$ gpart destroy ada1
ada1 destoyed
```

## 2016-10-31 Tray SSD 1m UFS Plain

* ThinkPad UEFI BIOS SATA Controller Mode Option: Compatibility
* Encrypted ZFS root pool consisting of:
  - ada0p4.eli
* ada0 at ata0 bus 0 scbus0 target 0 lun 0
  - ada0: Corsair Force LE SSD SAFC12.2
* ada1 at ata1 bus 0 scbus1 target 0 lun 0
  - ada1: INTEL SSDSC2BW240A4 DC32
* Benchmarking on UFS filesystem /dev/ada1p1

```sh
$ gpart create -s GPT ada1
ada1 created
$ gpart add -t freebsd-ufs -a 1m ada1
ada1p1 added
$ doas newfs -U /dev/ada1p1
[...]
$ doas mount /dev/ada1p1 /benchmark/
```

```sh
$ diskinfo -v /dev/ada1
/dev/ada1
	512         	# sectorsize
	240057409536	# mediasize in bytes (224G)
	468862128   	# mediasize in sectors
	4096        	# stripesize
	0           	# stripeoffset
	465141      	# Cylinders according to firmware.
	16          	# Heads according to firmware.
	63          	# Sectors according to firmware.
	CVDA615500SP2403GN	# Disk ident.
	Not_Zoned   	# Zone Mode
```

```sh
$ diskinfo -v /dev/ada1p1
/dev/ada1p1
	512         	# sectorsize
	240055746560	# mediasize in bytes (224G)
	468858880   	# mediasize in sectors
	4096        	# stripesize
	0           	# stripeoffset
	465137      	# Cylinders according to firmware.
	16          	# Heads according to firmware.
	63          	# Sectors according to firmware.
	CVDA615500SP2403GN	# Disk ident.
```

```sh
$ doas umount /dev/ada1p1
$ gpart delete -i 1 ada1
ada1p1 deleted
$ gpart destroy ada1
ada1 destoyed
```
