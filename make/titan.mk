#
# titan
#

ifeq ($(FFMPEG_VER), 3.2.2)
OPENSSL_MAJOR = 1.0.2
else
OPENSSL_MAJOR = 1.1.1
endif

TITAN_VER = 2.05

TITAN_DEPS     = $(D)/bootstrap
TITAN_DEPS    += $(KERNEL)
ifeq ($(whoami), $(filter $(whoami), obi))
#TITAN_DEPS    += $(D)/libopenthreads
endif
TITAN_DEPS    += $(D)/system-tools
TITAN_DEPS    += $(D)/module_init_tools
TITAN_DEPS    += $(LIRC)
TITAN_DEPS    += $(D)/libpng
TITAN_DEPS    += $(D)/freetype
TITAN_DEPS    += $(D)/libjpeg
TITAN_DEPS    += $(D)/zlib
TITAN_DEPS    += $(D)/openssl
TITAN_DEPS    += $(D)/timezone
#TITAN_DEPS    += $(D)/tools-titan-tools
TITAN_DEPS    += $(D)/libcurl
T_CPPFLAGS    += -DSH4
#T_CPPFLAGS    += -DSH4NEW
ifeq ($(OPENSSL_MAJOR), 1.1.1)
T_CPPFLAGS    += -DSSLNEW
endif
T_CPPFLAGS    += -DDDTBUILD
T_CPPFLAGS    += -DDVDPLAYER 
T_CPPFLAGS    += -DCAMSUPP
T_LINKFLAGS    = -lm -lpthread -ldl -lpng -lfreetype -ldreamdvd -ljpeg -lz -lmmeimage -lipkg

ifeq ($(MEDIAFW), eplayer3)
#T_CONFIG_OPTS += --enable-eplayer3
MEDIAFW_DEP   += $(D)/tools-libeplayer3
#MEDIAFW_DEP    += $(D)/tools-exteplayer3
##MEDIAFW_DEP    += $(D)/titan-libeplayer3
endif

ifeq ($(MEDIAFW), gstreamer)
MEDIAFW_DEP    += $(D)/gstreamer $(D)/gst_plugins_base $(D)/gst_plugins_multibox_dvbmediasink
MEDIAFW_DEP    += $(D)/gst_plugins_good $(D)/gst_plugins_bad $(D)/gst_plugins_ugly
endif

#ifeq ($(MEDIAFW), gst-eplayer3-dual)
ifeq ($(MEDIAFW), gst-eplayer3)
MEDIAFW_DEP    += $(D)/gstreamer $(D)/gst_plugins_base $(D)/gst_plugins_multibox_dvbmediasink
MEDIAFW_DEP    += $(D)/gst_plugins_good $(D)/gst_plugins_bad $(D)/gst_plugins_ugly
MEDIAFW_DEP    += $(D)/tools-libeplayer3
#MEDIAFW_DEP    += $(D)/tools-exteplayer3
##MEDIAFW_DEP    += $(D)/titan-libeplayer3

T_CPPFLAGS    += -DEPLAYER3
T_CPPFLAGS    += -DEXTEPLAYER3
T_CPPFLAGS    += -DEPLAYER4
T_CPPFLAGS    += -DEXTGST
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/gstreamer-1.0
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/glib-2.0
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/libxml2
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/lib/glib-2.0/include
#T_CPPFLAGS    += -I$(TOOLS_DIR)/exteplayer3/include
T_CPPFLAGS    += -I$(SOURCE_DIR)/titan/libeplayer3/include
T_LINKFLAGS   += -lssl -leplayer3 -lcrypto -lcurl -lglib-2.0 -lgobject-2.0 -lgio-2.0 -lgstreamer-1.0
#T_LINKFLAGS   = -lglib-2.0 -lgobject-2.0 -lxml2 -lgstreamer-1.0 -leplayer3 -lpthread -ldl -lm -lz -lpng -lfreetype -ldreamdvd -ljpeg -lssl -lcrypto -lcurl -lipkg -lmmeimage
endif

TITAN_DEPS    += $(MEDIAFW_DEP)
TITAN_DEPS    += $(LOCAL_TITAN_DEPS)

ifeq ($(IMAGE), titan-wlandriver)
TITAN_DEPS    += $(D)/wpa_supplicant $(D)/wireless_tools
endif

ifeq ($(EXTERNAL_LCD), graphlcd)
T_CONFIG_OPTS += --with-graphlcd
TITAN_DEPS    += $(D)/graphlcd
endif

ifeq ($(EXTERNAL_LCD), lcd4linux)
T_CONFIG_OPTS += --with-lcd4linux
TITAN_DEPS    += $(D)/lcd4linux
endif

ifeq ($(EXTERNAL_LCD), both)
T_CONFIG_OPTS += --with-graphlcd
TITAN_DEPS    += $(D)/graphlcd
T_CONFIG_OPTS += --with-lcd4linux
TITAN_DEPS    += $(D)/lcd4linux
endif

T_CONFIG_OPTS +=$(LOCAL_TITAN_BUILD_OPTIONS)

T_LINKFLAGS    += -lssl -lcrypto -lcurl -lm -lpthread -ldl -lpng -lfreetype -ldreamdvd -ljpeg -lz -lmmeimage -lipkg

ifeq ($(MEDIAFW), eplayer3)
T_CPPFLAGS    += -DEPLAYER3
T_CPPFLAGS    += -DEXTEPLAYER3
#T_CPPFLAGS    += -I$(TOOLS_DIR)/exteplayer3/include
T_CPPFLAGS    += -I$(SOURCE_DIR)/titan/libeplayer3/include
T_LINKFLAGS   += -leplayer3
endif

ifeq ($(MEDIAFW), gstreamer)
T_CPPFLAGS    += -DEPLAYER4
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/gstreamer-1.0
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/glib-2.0
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/libxml2
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/lib/glib-2.0/include
T_LINKFLAGS   += -lglib-2.0 -lgobject-2.0 -lgio-2.0 -lgstreamer-1.0
endif

ifeq ($(MEDIAFW), gst-explayer3)
T_CPPFLAGS    += -DEPLAYER3
T_CPPFLAGS    += -DEXTEPLAYER3
T_CPPFLAGS    += -DEPLAYER4
T_CPPFLAGS    += -DEXTGST
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/gstreamer-1.0
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/glib-2.0
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/libxml2
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/lib/glib-2.0/include
#T_CPPFLAGS    += -I$(TOOLS_DIR)/exteplayer3/include
T_CPPFLAGS    += -I$(SOURCE_DIR)/titan/libeplayer3/include
T_LINKFLAGS   += -leplayer3 -lglib-2.0 -lgobject-2.0 -lgio-2.0 -lgstreamer-1.0

T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/openssl
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/curl
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/openssl
T_CPPFLAGS    += -I$(SOURCE_DIR)/titan/libeplayer3/include
T_CPPFLAGS    += -I$(SOURCE_DIR)/titan/libdreamdvd
T_CPPFLAGS    += -I$(SOURCE_DIR)/titan/include
T_CPPFLAGS    += -I$(SOURCE_DIR)/titan

T_CPPFLAGS    += -I$(TARGET_DIR)/usr/lib/gstreamer-1.0/include

endif

T_CPPFLAGS    += -Wno-unused-but-set-variable
T_CPPFLAGS    += -I$(DRIVER_DIR)/include
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/freetype2
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/openssl
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/libpng16
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/dreamdvd
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/libipkg
T_CPPFLAGS    += -I$(KERNEL_DIR)/include
T_CPPFLAGS    += -I$(DRIVER_DIR)/bpamem
T_CPPFLAGS    += -I$(APPS_DIR)
T_CPPFLAGS    += -I$(APPS_DIR)/tools/libmme_image
T_CPPFLAGS    += -L$(TARGET_DIR)/usr/lib
T_CPPFLAGS    += -I$(TARGET_DIR)/usr/include/python
T_CPPFLAGS    += -L$(SOURCE_DIR)/titan/libipkg
T_CPPFLAGS    += -I$(SOURCE_DIR)/titan/libdreamdvd

T_CPPFLAGS    += $(LOCAL_TITAN_CPPFLAGS)
T_CPPFLAGS    += $(PLATFORM_CPPFLAGS)
T_CPPFLAGS    += $(TARGET_CPPFLAGS)


#yaud-titan: yaud-none $(D)/lirc

yaud-titan: yaud-none \
	 $(D)/titan $(D)/release_titan
	$(TUXBOX_YAUD_CUSTOMIZE)

#TITAN_DEPS  = bootstrap libcurl curlftpfs rarfs djmount libfreetype libjpeg libpng ffmpeg titan-libdreamdvd $(MEDIAFW_DEP) tuxtxt32bpp tools-libmme_host tools-libmme_image


ifeq ($(whoami), $(filter $(whoami), obi))
# remove djmount not building on linux mint 22.04
TITAN_DEPS  += bootstrap alsa_utils libcurl curlftpfs rarfs freetype libjpeg libpng ffmpeg titan-libipkg titan-libdreamdvd $(MEDIAFW_DEP) tuxtxt32bpp tools-libmme_host tools-libmme_image
else
TITAN_DEPS  += bootstrap alsa_utils libcurl curlftpfs rarfs djmount freetype libjpeg libpng ffmpeg titan-libipkg titan-libdreamdvd $(MEDIAFW_DEP) tuxtxt32bpp tools-libmme_host tools-libmme_image
endif
#librtmpdump

#TITAN_DEPS  = bootstrap libcurl curlftpfs rarfs djmount freetype libjpeg libpng ffmpeg titan-libdreamdvd $(MEDIAFW_DEP) tools-libmme_host tools-libmme_image

# $(D)/titan.do_prepare: | bootstrap libmme_host libmme_image $(EXTERNALLCD_DEP) libdvbsipp libfreetype libjpeg libpng libungif libid3tag libcurl libmad libvorbisidec openssl ffmpeg libopenthreads libusb2 libalsa tuxtxt32bpp titan-libdreamdvd $(MEDIAFW_DEP)

$(D)/titan.do_prepare: | $(TITAN_DEPS)
	[ -d "$(SOURCE_DIR)/titan" ] && \
	(cd $(SOURCE_DIR)/titan; svn up; cd "$(BUILD_TMP)";); \
	[ -d "$(SOURCE_DIR)/titan" ] || \
	svn checkout --username buildbin --password buildbin http://svn.dyndns.tv/svn/titan $(SOURCE_DIR)/titan; \
	COMPRESSBIN=gzip; \
	COMPRESSEXT=gz; \
	[ $(BOXTYPE) == "ufs910" ] && COMPRESSBIN=lzma; \
	[ $(BOXTYPE) == "ufs910" ] && COMPRESSEXT=lzma; \
	[ -d "$(BUILD_TMP)/BUILD" ] && \
	(echo "[titan.mk] Kernel COMPRESSBIN=$$COMPRESSBIN"; echo "[titan.mk] Kernel COMPRESSEXT=$$COMPRESSEXT"; cd "$(BUILD_TMP)/BUILD"; rm -f $(BUILD_TMP)/BUILD/uimage.*; dd if=$(TARGET_DIR)/boot/uImage of=uimage.tmp.$$COMPRESSEXT bs=1 skip=64; $$COMPRESSBIN -d uimage.tmp.$$COMPRESSEXT; str="`strings $(BUILD_TMP)/BUILD/uimage.tmp | grep "Linux version 2.6" | sed 's/Linux version //' | sed 's/(.*)//' | sed 's/  / /'`"; code=`"$(SOURCE_DIR)/titan/titan/tools/gettitancode" "$$str"`; code="$$code"UL; echo "[titan.mk] $$str -> $$code"; sed s/"^#define SYSCODE .*"/"#define SYSCODE $$code"/ -i "$(SOURCE_DIR)/titan/titan/titan.c"); \
	SVNVERSION=`svn info $(SOURCE_DIR)/titan | grep Revision | sed s/'Revision: '//g`; \
	SVNBOX=ufs910; \
	[ $(BOXTYPE) == "ufs910" ] && SVNBOX=ufs910; \
	[ $(BOXTYPE) == "ufs912" ] && SVNBOX=ufs912; \
	[ $(BOXTYPE) == "ufs913" ] && SVNBOX=ufs913; \
	[ $(BOXTYPE) == "ufs922" ] && SVNBOX=ufs922; \
	[ $(BOXTYPE) == "octagon1008" ] && SVNBOX=atevio700; \
	[ $(BOXTYPE) == "fortis_hdbox" ] && SVNBOX=atevio7000; \
	[ $(BOXTYPE) == "atevio7500" ] && SVNBOX=atevio7500; \
	[ $(BOXTYPE) == "atemio510" ] && SVNBOX=atemio510; \
	[ $(BOXTYPE) == "atemio520" ] && SVNBOX=atemio520; \
	[ $(BOXTYPE) == "atemio530" ] && SVNBOX=atemio530; \
#	not used anymore default pfad is /svn/tpk/nightly-$cpu-secret; \
#	TPKDIR="/svn/tpk/"$$SVNBOX"-rev"$$SVNVERSION"-secret/sh4/titan"; \
#	(echo "[titan.mk] tpk SVNVERSION=$$SVNVERSION";echo "[titan.mk] tpk TPKDIR=$$TPKDIR"; sed s!"/svn/tpk/.*"!"$$TPKDIR\", 1, 0);"! -i "$(SOURCE_DIR)/titan/titan/extensions.h"; sed s!"svn/tpk/.*"!"$$TPKDIR\") == 0)"! -i "$(SOURCE_DIR)/titan/titan/tpk.h"; sed s/"^#define PLUGINVERSION .*"/"#define PLUGINVERSION $$SVNVERSION"/ -i "$(SOURCE_DIR)/titan/titan/struct.h"); \
	(echo "[titan.mk] tpk SVNVERSION=$$SVNVERSION"; sed s/"^#define PLUGINVERSION .*"/"#define PLUGINVERSION $$SVNVERSION"/ -i "$(SOURCE_DIR)/titan/titan/struct.h"); \
	echo BOXTYPE=$(BOXTYPE)
	pwd
	cp $(SOURCE_DIR)/titan/titan/Makefile.am.4.3 $(SOURCE_DIR)/titan/titan/Makefile.am; \
	echo >> Makefile.am; \
	echo "titan_LDADD = $(T_LINKFLAGS)" >> $(SOURCE_DIR)/titan/titan/Makefile.am; \
	[ -d "$(SOURCE_DIR)/titan/titan/libdreamdvd" ] || \
	ln -s $(SOURCE_DIR)/titan/libdreamdvd $(SOURCE_DIR)/titan/titan; \
	echo "############################"; \
	echo T_CPPFLAGS: $(T_CPPFLAGS); \
	echo "############################"; \
	echo T_LINKFLAGS: $(T_LINKFLAGS); \
	echo "############################"; \
	echo TITAN_DEPS: $(TITAN_DEPS); \
	echo "############################"; \
	echo T_CONFIG_OPTS: $(T_CONFIG_OPTS); \
	echo "############################"; \
	echo MEDIAFW: $(MEDIAFW); \
	echo "############################"; \
	echo MEDIAFW_DEP: $(MEDIAFW_DEP); \
	echo "############################";
	$(TOUCH)
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
			$(TITAN_OPT_OPTION) \
			PKG_CONFIG=$(PKG_CONFIG) \
			CPPFLAGS="$(T_CPPFLAGS)"
	$(TOUCH)

$(D)/titan.do_compile: $(SOURCE_DIR)/titan/titan/config.status
	cd $(SOURCE_DIR)/titan/titan && \
		$(MAKE) all
	$(TOUCH)

$(D)/titan: titan.do_prepare titan.do_compile
	$(MAKE) -C $(SOURCE_DIR)/titan/titan install DESTDIR=$(TARGET_DIR)
	$(TARGET)-strip $(TARGET_DIR)/usr/local/bin/titan
	$(TOUCH)
	
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
	svn checkout --username buildbin --password buildbin http://svn.dyndns.tv/svn/titan $(SOURCE_DIR)/titan; \
	[ -d "$(SOURCE_DIR)/titan/titan/libdreamdvd" ] || \
	ln -s $(SOURCE_DIR)/titan/libdreamdvd $(SOURCE_DIR)/titan/titan; \
	$(TOUCH)

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
	$(TOUCH)

$(D)/titan-libdreamdvd.do_compile: $(SOURCE_DIR)/titan/libdreamdvd/config.status
	cd $(SOURCE_DIR)/titan/libdreamdvd && \
		$(MAKE)
	$(TOUCH)

$(D)/titan-libdreamdvd: titan-libdreamdvd.do_prepare titan-libdreamdvd.do_compile
	$(MAKE) -C $(SOURCE_DIR)/titan/libdreamdvd install DESTDIR=$(TARGET_DIR)
	$(TOUCH)

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
	svn checkout --username buildbin --password buildbin http://svn.dyndns.tv/svn/titan $(SOURCE_DIR)/titan; \
	[ -d "$(SOURCE_DIR)/titan/titan/libdreamdvd" ] || \
	ln -s $(SOURCE_DIR)/titan/libdreamdvd $(SOURCE_DIR)/titan/titan;
	ln -s $(SOURCE_DIR)/titan/titan $(SOURCE_DIR)/titan/plugins;
	$(TOUCH)

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
	$(TOUCH)

$(D)/titan-plugins.do_compile: $(SOURCE_DIR)/titan/plugins/config.status
	cd $(SOURCE_DIR)/titan/plugins && \
			$(MAKE) -C $(SOURCE_DIR)/titan/plugins all install DESTDIR=$(TARGET_DIR)
	$(TOUCH)

$(D)/titan-plugins: titan-plugins.do_prepare titan-plugins.do_compile
	$(MAKE) -C $(SOURCE_DIR)/titan/plugins all install DESTDIR=$(TARGET_DIR)
	$(TOUCH)

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
	$(TOUCH)

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
	$(TOUCH)

#
# titan-libipkg
#
$(D)/titan-libipkg.do_prepare: | bootstrap libdvdnav
	[ -d "$(SOURCE_DIR)/titan" ] && \
	(cd $(SOURCE_DIR)/titan; svn up; cd "$(BUILD_TMP)";); \
	[ -d "$(SOURCE_DIR)/titan" ] || \
	svn checkout --username buildbin --password buildbin http://svn.dyndns.tv/svn/titan $(SOURCE_DIR)/titan; \
	[ -d "$(SOURCE_DIR)/titan/titan/libipkg" ] || \
	ln -s $(SOURCE_DIR)/titan/libipkg $(SOURCE_DIR)/titan/titan; \
	$(TOUCH)

$(SOURCE_DIR)/titan/libipkg/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(SOURCE_DIR)/titan/libipkg && \
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
	$(TOUCH)

$(D)/titan-libipkg.do_compile: $(SOURCE_DIR)/titan/libipkg/config.status
	cd $(SOURCE_DIR)/titan/libipkg && \
		$(MAKE)
	$(TOUCH)

$(D)/titan-libipkg: titan-libipkg.do_prepare titan-libipkg.do_compile
	$(MAKE) -C $(SOURCE_DIR)/titan/libipkg install DESTDIR=$(TARGET_DIR)
	$(TOUCH)

titan-libipkg-clean:
	rm -f $(D)/titan-libipkg
	cd $(SOURCE_DIR)/titan/libipkg && \
		$(MAKE) clean

titan-libipkg-distclean:
	rm -f $(D)/titan-libipkg*
	rm -rf $(SOURCE_DIR)/titan/libipkg	

