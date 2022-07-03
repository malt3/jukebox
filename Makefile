SHAIRPORT_TAR=shairport-sync/shairport-sync.tar

raspbian/image.zip: $(SHAIRPORT_TAR) raspbian/build.sh raspbian/files/config
	cd raspbian && ./build.sh

$(SHAIRPORT_TAR): shairport-sync/Dockerfile shairport-sync/build.sh
	cd shairport-sync && ./build.sh
