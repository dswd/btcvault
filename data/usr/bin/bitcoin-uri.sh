#!/bin/bash

address="$1"

client="$(kdialog --menu 'Please select a Bitcoin client' electrum 'Electrum Bitcoin client' multibit 'MultiBit Bitcoin client')"

case "$client" in
  electrum)
    electrum-wrapper.sh "$@"
    ;;
  multibit)
    multibit-wrapper.sh "$@"
    ;;
esac