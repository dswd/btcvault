#!/bin/bash
action="open"
path="/media"
walletpath="$(kdialog --get${action}filename $path '*.wallet electrum.dat|Electrum bitcoin wallet')"
if ! [ "$walletpath" == "" ]; then
  electrum -w "$walletpath" "$@"
fi
