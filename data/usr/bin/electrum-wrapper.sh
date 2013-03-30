#!/bin/bash
action="${1:-open}"
path="${2:-/media}"
walletpath="$(kdialog --get${action}filename $path '*.wallet electrum.dat|Electrum bitcoin wallet')"
if ! [ "$walletpath" == "" ]; then
  electrum -w "$walletpath"
fi