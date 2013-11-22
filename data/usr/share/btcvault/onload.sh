#!/bin/bash

xdg-mime install /usr/share/btcvault/x-electrum-wallet.xml

ln -s /usr/lib/jdk6 /usr/lib/jvm

for patch in /usr/share/btcvault/patches/*.patch; do
  patch -p1 -d / -f < $patch
done
