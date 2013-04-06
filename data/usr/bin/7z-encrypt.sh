#!/bin/bash

SRC="$1"
DST="$SRC.7z"

if ! [ -f "$SRC" ]; then
  kdialog --title 'File encryption' --error "File \"$SRC\" does not exist"
  exit 1
fi

if [ -f "$DST" ]; then
  kdialog --title 'File encryption' --error "File \"$DST\" already exists"
  exit 1
fi

PASS1=$(kdialog --title 'File encryption' --password 'Please enter the encryption password.')
if [ -z "$PASS1" ]; then
  exit 2
fi

PASS2=$(kdialog --title 'File encryption' --password 'Please repeat the encryption password.')
if [ -z "$PASS1" ]; then
  exit 2
fi

if [ "$PASS1" != "$PASS2" ]; then
  kdialog --title 'File encryption' --error 'Passwords do not match.'
fi

if 7z -p"$PASS1" a "$DST" "$SRC"; then
  kdialog --title 'File encryption' --msgbox 'File has been encrypted.'
else
  kdialog --title 'File encryption' --error 'Something went wrong'
fi