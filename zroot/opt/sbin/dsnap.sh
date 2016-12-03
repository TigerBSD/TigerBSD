#!/usr/bin/env sh

zfs list -t snapshot | grep bootpool@ | cut -d' ' -f1 \
  | xargs -L1 zfs destroy -r

zfs list -t snapshot | grep zroot@ | cut -d' ' -f1 | xargs -L1 zfs destroy -r
