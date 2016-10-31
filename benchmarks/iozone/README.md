# iozone benchmarks

scbus0 corresponds to the HDD/SSD bay. scbus1 corresponds to the CD/DVD tray.

## 2016-10-13 Single SSD FDE

For this benchmark, the following configuration was in effect:

* ThinkPad UEFI BIOS SATA Controller Mode Option: Compatibility
* Encrypted ZFS root pool consisting of:
  - ada0p4.eli
* ada0 at ata0 bus 0 scbus0 target 0 lun 0
  - ada0: Corsair Force LE SSD SAFC12.2
* Benchmarking on ZFS filesystem zroot/benchmark

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
$ doas gpart create -s GPT ada1
ada1 created
$ gpart add -t freebsd-ufs -a 4k ada1
ada1p1 added
$ doas newfs -U /dev/ada1p1
[...]
$ doas mount /dev/ada1p1 /benchmark/
```
