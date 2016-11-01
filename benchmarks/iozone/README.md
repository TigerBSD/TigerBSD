# iozone benchmarks

ada0 on scbus0 corresponds to the HDD/SSD bay.
ada1 on scbus1 corresponds to the CD/DVD tray adapter bay.

## Table of Contents

* [Drive info](#drive-info)
  - [Corsair Force LE SSD, S/N 1631801900010416034F](#corsair-force-le-ssd-sn-1631801900010416034f)
  - [INTEL SSDSC2BW240A4, S/N CVDA615500SP2403GN](#intel-ssdsc2bw240a4-sn-cvda615500sp2403gn)
* [Benchmark runs](#benchmark-runs)
  - [2016-10-13 Single SSD FDE](#2016-10-13-single-ssd-fde)
  - [2016-10-31 Tray SSD 4k UFS Plain](#2016-10-31-tray-ssd-4k-ufs-plain)
  - [2016-10-31 Tray SSD 1m UFS Plain](#2016-10-31-tray-ssd-1m-ufs-plain)

## Drive info

### Corsair Force LE SSD, S/N 1631801900010416034F

```sh
$ doas camcontrol identify ada0
pass0: <Corsair Force LE SSD SAFC12.2> ACS-2 ATA SATA 3.x device
pass0: 600.000MB/s transfers (SATA 3.x, UDMA5, PIO 8192bytes)
```

Property          | Value
----------------- | -----------------------------------
protocol          | ATA/ATAPI-9 SATA 3.x
device model      | Corsair Force LE SSD
firmware revision | SAFC12.2
serial number     | 1631801900010416034F
cylinders         | 16383
heads             | 16
sectors/track     | 63
sector size       | logical 512, physical 512, offset 0
LBA supported     | 268435455 sectors
LBA48 supported   | 468862128 sectors
PIO supported     | PIO4
DMA supported     | WDMA2 UDMA6
media RPM         | non-rotating

Feature                        | Support | Enabled | Value
------------------------------ | ------- | ------- | -------------------
read ahead                     | yes     | yes     |
write cache                    | yes     | yes     |
flush cache                    | yes     | yes     |
overlap                        | no      |         |
Tagged Command Queuing (TCQ)   | no      | no      |
Native Command Queuing (NCQ)   | yes     |         | 32 tags
NCQ Queue Management           | no      |         |
NCQ Streaming                  | no      |         |
Receive & Send FPDMA Queued    | no      |         |
SMART                          | yes     | yes     |
microcode download             | yes     | yes     |
security                       | yes     | no      |
power management               | yes     | yes     |
advanced power management      | yes     | yes     | 254/0xFE
automatic acoustic management  | no      | no      |
media status notification      | no      | no      |
power-up in Standby            | no      | no      |
write-read-verify              | no      | no      |
unload                         | no      | no      |
general purpose logging        | yes     | yes     |
free-fall                      | no      | no      |
Data Set Management (DSM/TRIM) | yes     |         |
DSM - max 512byte blocks       | yes     |         | 8
DSM - deterministic read       | yes     |         | zeroed
Host Protected Area (HPA)      | yes     | no      | 468862128/468862128
HPA - Security                 | no      |         |

### INTEL SSDSC2BW240A4, S/N CVDA615500SP2403GN

```sh
$ doas camcontrol identify ada1
pass1: <INTEL SSDSC2BW240A4 DC32> ACS-2 ATA SATA 3.x device
pass1: 600.000MB/s transfers (SATA 3.x, UDMA5, PIO 8192bytes)
```

Property          | Value
----------------- | -----------------------------------
protocol          | ATA/ATAPI-9 SATA 3.x
device model      | INTEL SSDSC2BW240A4
firmware revision | DC32
serial number     | CVDA615500SP2403GN
WWN               | 55cd2e414cb981fb
cylinders         | 16383
heads             | 16
sectors/track     | 63
sector size       | logical 512, physical 512, offset 0
LBA supported     | 268435455 sectors
LBA48 supported   | 468862128 sectors
PIO supported     | PIO4
DMA supported     | WDMA2 UDMA6
media RPM         | non-rotating

Feature                        | Support | Enabled | Value
------------------------------ | ------- | ------- | -------------------
read ahead                     | yes     | yes     |
write cache                    | yes     | yes     |
flush cache                    | yes     | yes     |
overlap                        | no      |         |
Tagged Command Queuing (TCQ)   | no      | no      |
Native Command Queuing (NCQ)   | yes     |         | 32 tags
NCQ Queue Management           | no      |         |
NCQ Streaming                  | no      |         |
Receive & Send FPDMA Queued    | no      |         |
SMART                          | yes     | yes     |
microcode download             | yes     | yes     |
security                       | yes     | no      |
power management               | yes     | yes     |
advanced power management      | yes     | yes     | 254/0xFE
automatic acoustic management  | no      | no      |
media status notification      | no      | no      |
power-up in Standby            | yes     | no      |
write-read-verify              | no      | no      |
unload                         | yes     | yes     |
general purpose logging        | yes     | yes     |
free-fall                      | no      | no      |
Data Set Management (DSM/TRIM) | yes     |         |
DSM - max 512byte blocks       | yes     |         | 1
DSM - deterministic read       | yes     |         | any value
Host Protected Area (HPA)      | yes     | no      | 468862128/468862128
HPA - Security                 | no      |         |

## Benchmark runs

### 2016-10-13 Single SSD FDE

For this benchmark run, the following configuration was in effect:

* ThinkPad UEFI BIOS SATA Controller Mode Option: Compatibility
* Encrypted ZFS root pool consisting of:
  - ada0p4.eli
* ada0 at ata0 bus 0 scbus0 target 0 lun 0
  - ada0: Corsair Force LE SSD SAFC12.2
* Benchmarking on ZFS filesystem zroot/benchmark

```sh
$ diskinfo -v /dev/ada0
```

Property                  | Value
------------------------- | --------------------
Sectorsize                | 512
Mediasize in bytes        | 240057409536
Mediasize in sectors      | 468862128
Stripesize                | 0
Stripeoffset              | 0
Cylinders according to fw | 465141
Heads according to fw     | 16
Sectors according to fw   | 63
Disk ident                | 1631801900010416034F
Zone Mode                 | Not\_Zoned

```sh
$ diskinfo -v /dev/ada0p4
```

Property                  | Value
------------------------- | --------------------
Sectorsize                | 512
Mediasize in bytes        | 229318328320
Mediasize in sectors      | 447887360
Stripesize                | 0
Stripeoffset              | 2148532224
Cylinders according to fw | 444332
Heads according to fw     | 16
Sectors according to fw   | 63
Disk ident                | 1631801900010416034F

```sh
$ diskinfo -v /dev/ada0p4.eli
```

Property                  | Value
------------------------- | --------------------
Sectorsize                | 4096
Mediasize in bytes        | 229318324224
Mediasize in sectors      | 55985919
Stripesize                | 0
Stripeoffset              | 0
Cylinders according to fw | 55541
Heads according to fw     | 16
Sectors according to fw   | 63
Disk ident                | 1631801900010416034F

```sh
doas ./invoke_iozone.sh
```

### 2016-10-31 Tray SSD 4k UFS Plain

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
```

Property                  | Value
------------------------- | ------------------
Sectorsize                | 512
Mediasize in bytes        | 240057409536
Mediasize in sectors      | 468862128
Stripesize                | 4096
Stripeoffset              | 0
Cylinders according to fw | 465141
Heads according to fw     | 16
Sectors according to fw   | 63
Disk ident                | CVDA615500SP2403GN
Zone Mode                 | Not\_Zoned

```sh
$ diskinfo -v /dev/ada1p1
```

Property                  | Value
------------------------- | ------------------
Sectorsize                | 512
Mediasize in bytes        | 240057364480
Mediasize in sectors      | 468862040
Stripesize                | 4096
Stripeoffset              | 0
Cylinders according to fw | 465140
Heads according to fw     | 16
Sectors according to fw   | 63
Disk ident                | CVDA615500SP2403GN

```sh
doas ./invoke_iozone.sh
```

```sh
$ doas umount /dev/ada1p1
$ gpart delete -i 1 ada1
ada1p1 deleted
$ gpart destroy ada1
ada1 destoyed
```

### 2016-10-31 Tray SSD 1m UFS Plain

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
```

Property                  | Value
------------------------- | ------------------
Sectorsize                | 512
Mediasize in bytes        | 240057409536
Mediasize in sectors      | 468862128
Stripesize                | 4096
Stripeoffset              | 0
Cylinders according to fw | 465141
Heads according to fw     | 16
Sectors according to fw   | 63
Disk ident                | CVDA615500SP2403GN
Zone Mode                 | Not\_Zoned

```sh
$ diskinfo -v /dev/ada1p1
```

Property                  | Value
------------------------- | ------------------
Sectorsize                | 512
Mediasize in bytes        | 240055746560
Mediasize in sectors      | 468858880
Stripesize                | 4096
Stripeoffset              | 0
Cylinders according to fw | 465137
Heads according to fw     | 16
Sectors according to fw   | 63
Disk ident                | CVDA615500SP2403GN

```sh
doas ./invoke_iozone.sh
```

```sh
$ doas umount /dev/ada1p1
$ gpart delete -i 1 ada1
ada1p1 deleted
$ gpart destroy ada1
ada1 destoyed
```
