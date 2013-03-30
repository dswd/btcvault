SLAX_VERSION=7.0.8
SLAX_ARCH=i486
SLAX_FILE=slax-English-US-$(SLAX_VERSION)-$(SLAX_ARCH).zip
SLAX_MODULES_DOWNLOAD=1188-python 2354-sip 2356-pyqt 473-dbus-python
SLAX_MODULES_DOWNLOAD_FILES=$(foreach mod, $(SLAX_MODULES_DOWNLOAD), build/slax/$(mod).sb)
SLAX_MODULES_BUILD=2692-electrum 9999-btcvault
SLAX_MODULES_BUILD_FILES=$(foreach mod, $(SLAX_MODULES_BUILD), build/slax/$(mod).sb)
SLAX_MODULES_URL=http://www.slax.org/modules/$(SLAX_ARCH)

default: btcvault.iso btcvault.zip

build:
	mkdir -p build

build/$(SLAX_FILE):
	wget -c http://www.slax.org/download/$(SLAX_VERSION)/$(SLAX_FILE) -O build/$(SLAX_FILE)

build/slax: build/$(SLAX_FILE)
	(cd build; unzip -u $(SLAX_FILE))
	md5sum --check --quiet checksums.txt

build/slax/1%.sb:
	wget -c $(SLAX_MODULES_URL)/1/$(notdir $@) -O $@
build/slax/2%.sb:
	wget -c $(SLAX_MODULES_URL)/2/$(notdir $@) -O $@
build/slax/3%.sb:
	wget -c $(SLAX_MODULES_URL)/3/$(notdir $@) -O $@
build/slax/4%.sb:
	wget -c $(SLAX_MODULES_URL)/4/$(notdir $@) -O $@
build/slax/5%.sb:
	wget -c $(SLAX_MODULES_URL)/5/$(notdir $@) -O $@
build/slax/6%.sb:
	wget -c $(SLAX_MODULES_URL)/6/$(notdir $@) -O $@
build/slax/7%.sb:
	wget -c $(SLAX_MODULES_URL)/7/$(notdir $@) -O $@
build/slax/8%.sb:
	wget -c $(SLAX_MODULES_URL)/8/$(notdir $@) -O $@
build/slax/9%.sb:
	wget -c $(SLAX_MODULES_URL)/9/$(notdir $@) -O $@

modules/electrum.sb:
	test -f /usr/share/slax/slaxbuildlib
	(cd modules; ./electrum.SlaxBuild)	

build/slax/2692-electrum.sb:
	cp modules/electrum.sb build/slax/2692-electrum.sb 

modules/btcvault.sb:
	test -f /usr/share/slax/slaxbuildlib
	(cd modules; ./btcvault.SlaxBuild)

build/slax/9999-btcvault.sb:
	cp modules/btcvault.sb build/slax/9999-btcvault.sb 

download: build build/slax $(SLAX_MODULES_DOWNLOAD_FILES)

all-files: download $(SLAX_MODULES_BUILD_FILES)

btcvault.iso: all-files
	mv build/$(SLAX_FILE) $(SLAX_FILE) 
	(cd build; slax/boot/makeiso.sh slax ../btcvault.iso)
	mv $(SLAX_FILE) build/$(SLAX_FILE)

btcvault.zip: all-files
	(cd build; zip -r ../btcvault.zip slax slax.txt)

refresh-checksums: download
	(cd build; find slax -type f -exec md5sum \{\} \; | fgrep -v electrum | fgrep -v btcvault > ../checksums.txt)

clean:
	rm -rf build modules/*-*