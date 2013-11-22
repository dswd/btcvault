#!/bin/bash

case "$1" in
  openwallet)
    walletpath="$2"
    ;;
  "" | opendialog)
    path="${2:-/media}"
    walletpath="$(kdialog --getexistingdirectory $path)"
    ;;
  savedialog)
    path="${2:-/media}"
    walletpath="$(kdialog --getsavefilename $path '*|Multibit wallet directory')"
    ;;
  *)
    path="/media"
    walletpath="$(kdialog --getexistingdirectory $path)"
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


folder="/root/MultiBit"

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
java -jar /usr/share/multibit/multibit-exe.jar "$args"

# Remove symlink
rm "$folder"

if [ -d "$folder.bckup" ]; then
  # Restore backup of old wallet folder
  mv "$folder.bckup" "$folder"
fi

sync #This is important to flush the disk cache and avoid data loss in case of a crash