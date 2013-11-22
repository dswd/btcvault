#!/bin/bash

case "$1" in
  openwallet)
    walletpath="$2"
    ;;
  "" | opendialog)
    path="${2:-/media}"
    walletpath="$(kdialog --getopenfilename $path 'electrum.dat|Electrum bitcoin wallet')"
    ;;
  savedialog)
    path="${2:-/media}"
    walletpath="$(kdialog --getsavefilename $path 'electrum.dat|Electrum bitcoin wallet')"
    ;;
  *)
    path="/media"
    walletpath="$(kdialog --getopenfilename $path 'electrum.dat|Electrum bitcoin wallet')"
    shift 2
    args="$@"
    ;;
esac

if [ "$walletpath" == "" ]; then
  kdialog --error "No wallet selected, aborting."
  exit -1
fi

if ! safe-wallet-location.sh "$walletpath"; then
  if ! kdialog --warningyesno "This wallet location is on a temporary filesystem. Are you sure?"; then
    exit -2
  fi
fi

electrum -w "$walletpath" "$args"

sync #This is important to flush the disk cache and avoid data loss in case of a crash