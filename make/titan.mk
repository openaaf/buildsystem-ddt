#
# titan
#

#yaud-titan: yaud-none $(D)/lirc

yaud-titan: yaud-none \
	 $(D)/titan $(D)/release_titan
	$(TUXBOX_YAUD_CUSTOMIZE)

#TITAN_DEPS  = bootstrap libcurl curlftpfs rarfs djmount libfreetype libjpeg libpng ffmpeg titan-libdreamdvd $(MEDIAFW_DEP) tuxtxt32bpp tools-libmme_host tools-libmme_image
TITAN_DEPS  = bootstrap libcurl curlftpfs rarfs djmount freetype libjpeg libpng ffmpeg titan-libdreamdvd $(MEDIAFW_DEP) tuxtxt32bpp tools-libmme_host tools-libmme_image

#TITAN_DEPS  = bootstrap libcurl curlftpfs rarfs djmount freetype libjpeg libpng ffmpeg titan-libdreamdvd $(MEDIAFW_DEP) tools-libmme_host tools-libmme_image

# $(D)/titan.do_prepare: | bootstrap libmme_host libmme_image $(EXTERNALLCD_DEP) libdvbsipp libfreetype libjpeg libpng libungif libid3tag libcurl libmad libvorbisidec openssl ffmpeg libopenthreads libusb2 libalsa tuxtxt32bpp titan-libdreamdvd $(MEDIAFW_DEP)

$(D)/titan.do_prepare: | $(TITAN_DEPS)
	[ -d "$(SOURCE_DIR)/titan" ] && \
	(cd $(SOURCE_DIR)/titan; svn up; cd "$(BUILD_TMP)";); \
	[ -d "$(SOURCE_DIR)/titan" ] || \
	svn checkout --username public --password public http://svn.dyndns.tv/svn/titan $(SOURCE_DIR)/titan; \
	COMPRESSBIN=gzip; \
	COMPRESSEXT=gz; \
	$(if $(UFS910), COMPRESSBIN=lzma;) \
	$(if $(UFS910), COMPRESSEXT=lzma;) \
	[ -d "$(BUILD_TMP)/BUILD" ] && \
	(echo "[titan.mk] Kernel COMPRESSBIN=$$COMPRESSBIN"; echo "[titan.mk] Kernel COMPRESSEXT=$$COMPRESSEXT"; cd "$(BUILD_TMP)/BUILD"; rm -f $(BUILD_TMP)/BUILD/uimage.*; dd if=$(TARGET_DIR)/boot/uImage of=uimage.tmp.$$COMPRESSEXT bs=1 skip=64; $$COMPRESSBIN -d uimage.tmp.$$COMPRESSEXT; str="`strings $(BUILD_TMP)/BUILD/uimage.tmp | grep "Linux version 2.6" | sed 's/Linux version //' | sed 's/(.*)//' | sed 's/  / /'`"; code=`"$(SOURCE_DIR)/titan/titan/tools/gettitancode" "$$str"`; code="$$code"UL; echo "[titan.mk] $$str -> $$code"; sed s/"^#define SYSCODE .*"/"#define SYSCODE $$code"/ -i "$(SOURCE_DIR)/titan/titan/titan.c"); \
	SVNVERSION=`svn info $(SOURCE_DIR)/titan | grep Revision | sed s/'Revision: '//g`; \
	SVNBOX=ufs910; \
	$(if $(UFS910), SVNBOX=ufs910;) \
	$(if $(UFS912), SVNBOX=ufs912;) \
	$(if $(UFS922), SVNBOX=ufs922;) \
	$(if $(OCTAGON1008), SVNBOX=atevio700;) \
	$(if $(FORTIS_HDBOX), SVNBOX=atevio7000;) \
	$(if $(ATEVIO7500), SVNBOX=atevio7500;) \
	$(if $(ATEMIO510), SVNBOX=atemio510;) \
	$(if $(ATEMIO520), SVNBOX=atemio520;) \
	$(if $(ATEMIO530), SVNBOX=atemio530;) \
	TPKDIR="/svn/tpk/"$$SVNBOX"-rev"$$SVNVERSION"-secret/sh4/titan"; \
	(echo "[titan.mk] tpk SVNVERSION=$$SVNVERSION";echo "[titan.mk] tpk TPKDIR=$$TPKDIR"; sed s!"/svn/tpk/.*"!"$$TPKDIR\", 1, 0);"! -i "$(SOURCE_DIR)/titan/titan/extensions.h"; sed s!"svn/tpk/.*"!"$$TPKDIR\") == 0)"! -i "$(SOURCE_DIR)/titan/titan/tpk.h"; sed s/"^#define PLUGINVERSION .*"/"#define PLUGINVERSION $$SVNVERSION"/ -i "$(SOURCE_DIR)/titan/titan/struct.h"); \
	[ -d "$(SOURCE_DIR)/titan/titan/libdreamdvd" ] || \
	ln -s $(SOURCE_DIR)/titan/libdreamdvd $(SOURCE_DIR)/titan/titan; \
	touch $@
	rm -f $(BUILD_TMP)/BUILD/uimage.*

$(SOURCE_DIR)/titan/titan/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(SOURCE_DIR)/titan/titan && \
		./autogen.sh; \
		libtoolize --force && \
		aclocal -I $(TARGET_DIR)/usr/share/aclocal && \
		autoconf && \
		automake --foreign --add-missing && \
		$(BUILDENV) \
		./configure \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix=/usr/local \
			PKG_CONFIG=$(HOSTPREFIX)/bin/$(TARGET)-pkg-config \
			PKG_CONFIG_PATH=$(TARGET_DIR)/usr/lib/pkgconfig \
			CPPFLAGS="$(N_CPPFLAGS)"
		$(MAKE)
	touch $@

$(D)/titan.do_compile: $(SOURCE_DIR)/titan/titan/config.status
	cd $(SOURCE_DIR)/titan/titan && \
		$(MAKE)
	touch $@

$(D)/titan: titan.do_prepare titan.do_compile
	$(MAKE) -C $(SOURCE_DIR)/titan/titan install DESTDIR=$(TARGET_DIR)
	$(TARGET)-strip $(TARGET_DIR)/usr/local/bin/titan
	touch $@
	
titan-clean:
	rm -f $(BUILD_TMP)/BUILD/uimage.*
	rm -f $(D)/titan
	rm -f $(D)/titan.do_prepare
	cd $(SOURCE_DIR)/titan/titan && \
		$(MAKE) clean

titan-distclean:
	rm -f $(D)/titan*
	rm -rf $(SOURCE_DIR)/titan	

titan-updateyaud: titan-clean titan
	mkdir -p $(prefix)/release/usr/local/bin
	cp $(TARGET_DIR)/usr/local/bin/titan $(prefix)/release_titan/usr/local/bin/

#
# titan-libdreamdvd
#
$(D)/titan-libdreamdvd.do_prepare: | bootstrap libdvdnav
	[ -d "$(SOURCE_DIR)/titan" ] && \
	(cd $(SOURCE_DIR)/titan; svn up; cd "$(BUILD_TMP)";); \
	[ -d "$(SOURCE_DIR)/titan" ] || \
	svn checkout --username public --password public http://svn.dyndns.tv/svn/titan $(SOURCE_DIR)/titan; \
	[ -d "$(SOURCE_DIR)/titan/titan/libdreamdvd" ] || \
	ln -s $(SOURCE_DIR)/titan/libdreamdvd $(SOURCE_DIR)/titan/titan; \
	touch $@

$(SOURCE_DIR)/titan/libdreamdvd/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(SOURCE_DIR)/titan/libdreamdvd && \
		./autogen.sh; \
		libtoolize --force && \
		aclocal -I $(TARGET_DIR)/usr/share/aclocal && \
		autoconf && \
		automake --foreign --add-missing && \
		$(BUILDENV) \
		./configure \
			--build=$(BUILD) \
			--host=$(TARGET) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(D)/titan-libdreamdvd.do_compile: $(SOURCE_DIR)/titan/libdreamdvd/config.status
	cd $(SOURCE_DIR)/titan/libdreamdvd && \
		$(MAKE)
	touch $@

$(D)/titan-libdreamdvd: titan-libdreamdvd.do_prepare titan-libdreamdvd.do_compile
	$(MAKE) -C $(SOURCE_DIR)/titan/libdreamdvd install DESTDIR=$(TARGET_DIR)
	touch $@

titan-libdreamdvd-clean:
	rm -f $(D)/titan-libdreamdvd
	cd $(SOURCE_DIR)/titan/libdreamdvd && \
		$(MAKE) clean

titan-libdreamdvd-distclean:
	rm -f $(D)/titan-libdreamdvd*
	rm -rf $(SOURCE_DIR)/titan/libdreamdvd	

#
# titan-plugins
#

#$(D)/titan-plugins.do_prepare: | libpng libjpeg libfreetype libcurl
$(D)/titan-plugins.do_prepare: | libpng libjpeg freetype libcurl
	[ -d "$(SOURCE_DIR)/titan" ] && \
	(cd $(SOURCE_DIR)/titan; svn up; cd "$(BUILD_TMP)";); \
	[ -d "$(SOURCE_DIR)/titan" ] || \
	svn checkout --username public --password public http://svn.dyndns.tv/svn/titan $(SOURCE_DIR)/titan; \
	[ -d "$(SOURCE_DIR)/titan/titan/libdreamdvd" ] || \
	ln -s $(SOURCE_DIR)/titan/libdreamdvd $(SOURCE_DIR)/titan/titan;
	ln -s $(SOURCE_DIR)/titan/titan $(SOURCE_DIR)/titan/plugins;
	touch $@

$(SOURCE_DIR)/titan/plugins/config.status: titan-libdreamdvd
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(SOURCE_DIR)/titan/plugins && \
	libtoolize --force && \
	aclocal -I $(TARGET_DIR)/usr/share/aclocal && \
	autoconf && \
	automake --foreign --add-missing && \
	$(CONFIGURE) --prefix= \
	$(if $(MULTICOM324), --enable-multicom324) \
	$(if $(EPLAYER3), --enable-eplayer3)
	touch $@

$(D)/titan-plugins.do_compile: $(SOURCE_DIR)/titan/plugins/config.status
	cd $(SOURCE_DIR)/titan/plugins && \
			$(MAKE) -C $(SOURCE_DIR)/titan/plugins all install DESTDIR=$(TARGET_DIR)
#			$(MAKE) -C $(SOURCE_DIR)/titan/plugins all install DESTDIR=$(prefix)/$*cdkroot
	touch $@

$(D)/titan-plugins: titan-plugins.do_prepare titan-plugins.do_compile
	$(MAKE) -C $(SOURCE_DIR)/titan/plugins all install DESTDIR=$(TARGET_DIR)
	touch $@

titan-plugins-clean:
	rm -f $(D)/titan-plugins
	rm -f $(D)/titan-plugins.do_prepare
	-$(MAKE) -C $(SOURCE_DIR)/titan/plugins clean
	
titan-plugins-distclean:
	rm -f $(D)/titan-plugins*
	rm -rf $(SOURCE_DIR)/titan/plugins

#
# tuxtxtlib
#
$(D)/tuxtxtlib: $(D)/bootstrap
	$(REMOVE)/tuxtxtlib
	set -e; if [ -d $(ARCHIVE)/tuxtxt.git ]; \
		then cd $(ARCHIVE)/tuxtxt.git; git pull; \
		else cd $(ARCHIVE); git clone https://github.com/OpenPLi/tuxtxt.git tuxtxt.git; \
		fi
	cp -ra $(ARCHIVE)/tuxtxt.git/libtuxtxt $(BUILD_TMP)/tuxtxtlib
	set -e; cd $(BUILD_TMP)/tuxtxtlib; \
		$(PATCH)/tuxtxtlib-1.0-fix-dbox-headers.patch; \
		aclocal; \
		autoheader; \
		autoconf; \
		libtoolize --force; \
		automake --foreign --add-missing; \
		$(BUILDENV) \
		./configure \
			--build=$(BUILD) \
			--host=$(TARGET) \
			--prefix=/usr \
			--with-boxtype=generic \
			--with-configdir=/etc \
			--with-datadir=/usr/share/tuxtxt \
			--with-fontdir=/usr/share/fonts \
		; \
		$(MAKE) all; \
		$(MAKE) install prefix=/usr DESTDIR=$(TARGET_DIR)
	$(REWRITE_PKGCONF) $(PKG_CONFIG_PATH)/tuxbox-tuxtxt.pc
	$(REWRITE_LIBTOOL)/libtuxtxt.la
	$(REMOVE)/tuxtxtlib
	touch $@

#
# tuxtxt32bpp
#
$(D)/tuxtxt32bpp: $(D)/bootstrap $(D)/tuxtxtlib
	$(REMOVE)/tuxtxt
	cp -ra $(ARCHIVE)/tuxtxt.git/tuxtxt $(BUILD_TMP)/tuxtxt; \
	set -e; cd $(BUILD_TMP)/tuxtxt; \
		$(PATCH)/tuxtxt32bpp-1.0-fix-dbox-headers.patch; \
		aclocal; \
		autoheader; \
		autoconf; \
		libtoolize --force; \
		automake --foreign --add-missing; \
		$(BUILDENV) \
		./configure \
			--build=$(BUILD) \
			--host=$(TARGET) \
			--prefix=/usr \
			--with-fbdev=/dev/fb0 \
			--with-boxtype=generic \
			--with-configdir=/etc \
			--with-datadir=/usr/share/tuxtxt \
			--with-fontdir=/usr/share/fonts \
		; \
		$(MAKE) all; \
		$(MAKE) install prefix=/usr DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libtuxtxt32bpp.la
	$(REMOVE)/tuxtxt
	touch $@


