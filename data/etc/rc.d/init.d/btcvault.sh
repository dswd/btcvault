#!/bin/bash
case "$1" in
  start)
    for patch in /usr/share/btcvault/patches/*.patch; do
      patch -p1 -d / -f < $patch
    done
    ;;
  stop)
    ;;
  *)
    #ignore unknown command
esac