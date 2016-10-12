#!/usr/bin/env sh

# Settings recommended at https://forums.freebsd.org/threads/43358/

time iozone -R -l 4 -u 4 -r 128k -s 24g -+u \
  -F /benchmark/0 /benchmark/1 /benchmark/2 /benchmark/3 2>&1 \
  | tee four-proc-result

time iozone -R -l 1 -u 1 -r 128k -s 24g -+u -F /benchmark/0 2>&1 \
  | tee one-proc-result
