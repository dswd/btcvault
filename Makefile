SLAX_VERSION=7.0.8
SLAX_ARCH=i486
SLAX_FILE=slax-English-US-$(SLAX_VERSION)-$(SLAX_ARCH).zip
SLAX_MODULES_DOWNLOAD=1188-python 2354-sip 2356-pyqt 473-dbus-python 2235-p7zip 2993-openjdk6
SLAX_MODULES_DOWNLOAD_FILES=$(foreach mod, $(SLAX_MODULES_DOWNLOAD), build/slax/$(mod).sb)
SLAX_MODULES_BUILD=9997-multibit 9998-electrum 9999-btcvault
SLAX_MODULES_BUILD_FILES=$(foreach mod, $(SLAX_MODULES_BUILD), build/slax/$(mod).sb)
SLAX_MODULES_URL=http://www.slax.org/modules/$(SLAX_ARCH)

default: btcvault.iso btcvault.zip

build:
	mkdir -p build

build/$(SLAX_FILE):
	wget -c http://www.slax.org/download/$(SLAX_VERSION)/$(SLAX_FILE) -O build/$(SLAX_FILE)

build/slax: build/$(SLAX_FILE)
	(cd build; unzip -u $(SLAX_FILE))

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

modules/%.sb: modules/%.SlaxBuild
	test -f /usr/share/slax/slaxbuildlib
	(cd modules; ./$(notdir $<))

build/slax/9998-electrum.sb: modules/electrum.sb
	cp $< $@

build/slax/9997-multibit.sb: modules/multibit.sb
	cp $< $@

build/slax/9999-btcvault.sb: modules/btcvault.sb
	cp $< $@

download: build build/slax $(SLAX_MODULES_DOWNLOAD_FILES)
	(cd build; md5sum --check --quiet ../checksums.txt)

all-files: download $(SLAX_MODULES_BUILD_FILES)

btcvault.iso: all-files
	mv build/$(SLAX_FILE) $(SLAX_FILE) 
	(cd build; slax/boot/makeiso.sh slax ../btcvault.iso)
	mv $(SLAX_FILE) build/$(SLAX_FILE)

btcvault.zip: all-files
	(cd build; zip -r ../btcvault.zip slax slax.txt)

refresh-checksums: download
	(cd build; find slax -type f -exec md5sum \{\} \; | fgrep -v electrum | fgrep -v btcvault | fgrep -v multibit | fgrep -v isolinux.bin > ../checksums.txt)

clean:
	rm -rf build modules/*-*
