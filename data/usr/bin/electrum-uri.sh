#!/bin/bash
action="open"
path="/media"
walletpath="$(kdialog --get${action}filename $path 'electrum.dat|Electrum bitcoin wallet')"
if ! safe-wallet-location "$walletpath"; then
  kdialog --error "This wallet location is on a temporary filesystem, aborting."
  exit -1
fi
if ! [ "$walletpath" == "" ]; then
  electrum -w "$walletpath" "$@"
fi
