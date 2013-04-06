#!/bin/bash
case "$1" in
  start)
    /usr/share/btcvault/onload.sh
    ;;
  stop)
    ;;
  *)
    #ignore unknown command
esac