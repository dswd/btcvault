#!/bin/bash
action="${1:-open}"
path="${2:-/media}"
if [ "$action" == "open" ]; then
  walletpath="$(kdialog --getexistingdirectory $path)"
else
  walletpath="$(kdialog --getsavefilename $path '*|Multibit wallet directory')"
fi
if ! safe-wallet-location "$walletpath"; then
  kdialog --error "This wallet location is on a temporary filesystem, aborting."
  exit -1
fi
folder="/root/MultiBit"
if ! [ "$walletpath" == "" ]; then
  if [ -d "$folder" ]; then
    # Backup old folder if it exists
    mv "$folder" "$folder.bckup"
  fi
  if ! [ -d "$walletpath" ]; then
    # Create wallet folder for new wallets
    mkdir "$walletpath"
  fi
  # Symlink wallet folder to fixed wallet path
  ln -s "$walletpath" "$folder"
  if ! [ -f "$folder/multibit.spvchain" ]; then
    # Copy initial block chain data to new wallet path
    cp "/usr/share/btcvault/multibit.spvchain" "$folder/multibit.spvchain"
  fi
  # Execute multibit
  java -jar /usr/share/multibit/multibit-exe.jar
  # Remove symlink
  rm "$folder"
  if [ -d "$folder.bckup" ]; then
    # Restore backup of old wallet folder
    mv "$folder.bckup" "$folder"
  fi
fi
