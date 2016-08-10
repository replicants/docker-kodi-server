# docker-kodi-server
#
# Setup: Clone repo then checkout appropriate version
#   For jarvis
#     $ git checkout jarvis
#   For Master (Lastest Kodi stable release)
#     $ git checkout master
#
# Create your own Build:
# 	$ docker build --rm=true -t $(whoami)/kodi-server .
#
# Run your build:
#	  $ docker run -d --restart="always" --net=host -v /directory/with/kodidata:/opt/kodi-server/share/kodi/portable_data $(whoami)/kodi-server
#
#
# Greatly inspire by the work of wernerb,
# See https://github.com/wernerb/docker-xbmc-server

from ubuntu:16.10
maintainer celedhrim "celed+git@ielf.org"

# Set Terminal to non interactive
ENV DEBIAN_FRONTEND noninteractive

#Add home for new docker compatibility
ENV HOME=/root

#For home dev speedup ( apt-cacher )
#ENV http_proxy http://10.12.13.1:3142

# Set locale to UTF8
RUN locale-gen --no-purge en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Add headless patch
ADD src/headless.patch /headless.patch

# Install dep , compile , clean

RUN cd /root/ && \
		apt-get update && \
		apt-get -y dist-upgrade && \
		apt-get -y install git make curl g++ uuid-dev autoconf pkg-config libtool autopoint swig openjdk-8-jre-headless libboost-dev python-dev libglew-dev libmysqlclient-dev libass-dev libmpeg2-4-dev libjpeg-dev libvorbis-dev libcurl4-gnutls-dev libbz2-dev libtiff-dev liblzo2-dev libssl-dev libtinyxml-dev libyajl-dev libxml2-dev libxslt1-dev libsqlite3-dev libpcre3-dev libtag1-dev libjasper-dev libmicrohttpd-dev libxrandr-dev libssh-dev libsmbclient-dev libnfs-dev libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev libpostproc-dev libswscale-dev libswresample-dev gawk cmake gperf unzip zip libiso9660-dev iputils-ping libegl1-mesa-dev &&\
		git clone https://github.com/xbmc/xbmc.git -b 17.0a3-Krypton --depth=1 && \
		cd /root/xbmc && \
		mv /headless.patch . && \
		git apply headless.patch && \
		./bootstrap && \
		make -C tools/depends/target/crossguid PREFIX=/usr/local && \
		./configure \
			--enable-nfs \
			--enable-upnp \
			--enable-ssh \
      --with-ffmpeg=shared \
			--disable-libbluray \
			--disable-debug \
			--disable-vdpau \
			--disable-vaapi \
			--disable-crystalhd \
			--disable-vdadecoder \
			--disable-vtbdecoder \
			--disable-openmax \
			--disable-joystick \
			--disable-rsxs \
			--disable-projectm \
			--disable-rtmp \
			--disable-airplay \
			--disable-airtunes \
			--disable-dvdcss \
			--disable-optical-drive \
			--disable-libusb \
			--disable-libcec \
			--disable-libmp3lame \
			--disable-libcap \
			--disable-udev \
			--disable-libvorbisenc \
			--disable-asap-codec \
			--disable-afpclient \
			--disable-goom \
			--disable-fishbmc \
			--disable-spectrum \
			--disable-waveform \
			--disable-avahi \
			--disable-texturepacker \
			--disable-pulse \
			--disable-dbus \
			--disable-alsa \
			--disable-hal \
			--prefix=/opt/kodi-server && \
		make && \
		make install && \
		mkdir -p /opt/kodi-server/share/kodi/portable_data/ && \
		cd /root && \
		mkdir empty && \
		rsync -a --delete empty/ xbmc/ && \
		apt-get purge -y autoconf automake autopoint autotools-dev binutils build-essential bzip2 bzip2-doc ca-certificates ca-certificates-java cmake cmake-data cpp cpp-5 curl dpkg-dev fakeroot g++ g++-5 gawk gcc gcc-5 geoip-database git git-man gperf icu-devtools ifupdown iproute2 isc-dhcp-client isc-dhcp-common java-common less libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libarchive13 libasan2 libass-dev libasyncns0 libatm1 libatomic1 libavcodec-dev libavfilter-dev libavformat-dev libavresample-dev libavutil-dev libboost-dev libboost1.58-dev libbz2-dev libc-dev-bin libc6-dev libcc1-0 libcdio-dev libcdio13 libcilkrts5 libcurl3 libcurl4-gnutls-dev libdns162 libdpkg-perl libdrm-dev liberror-perl libexpat1-dev libfakeroot libfile-fcntllock-perl libflac8 libfontconfig1-dev libfreetype6-dev libfribidi-dev libgcc-5-dev libgcrypt20-dev libgdbm3 libgeoip1 libgl1-mesa-dev libglew-dev libglu1-mesa libglu1-mesa-dev libgmpv4-dev libgmpxxv4-4 libgnutls-dev libgnutls28-dev  libgnutlsxx28 libgpg-error-dev libharfbuzz-dev libharfbuzz-gobject0 libharfbuzz-icu0 libicu-dev libidn11-dev libisc160 libisl15 libiso9660-8 libiso9660-dev libitm1 libjasper-dev libjasper1 libjbig-dev libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev libjson-c3 libjsoncpp1 liblcms2-2 liblsan0 libltdl-dev libltdl7 liblzma-dev liblzo2-dev libmicrohttpd-dev libmpc3 libmpeg2-4 libmpeg2-4-dev libmpfr4 libmpx0 libmysqlclient-dev libnfs-dev libnspr4 libnss3 libogg-dev libp11-kit-dev libpcre16-3 libpcre3-dev libpcre32-3 libpcsclite1 libperl5.22 libpng12-dev libpostproc-dev libpthread-stubs0-dev libpulse0 libpython-dev libpython2.7-dev libquadmath0 libsctp1 libsigsegv2 libsmbclient-dev libsndfile1 libsqlite3-dev libssh-dev libssl-dev libssl-doc libstdc++-5-dev libswresample-dev libswscale-dev libtag1-dev libtasn1-6-dev libtasn1-doc libtiff5-dev libtiffxx5 libtinyxml-dev libtool libtsan0 libubsan0 libvorbis-dev libvorbisfile3 libwrap0 libx11-dev libx11-doc libx11-xcb-dev libxau-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-glx0-dev libxcb-present-dev libxcb-randr0 libxcb-randr0-dev libxcb-render0 libxcb-render0-dev libxcb-shape0 libxcb-shape0-dev libxcb-sync-dev libxcb-xfixes0 libxcb-xfixes0-dev libxcb1-dev libxdamage-dev libxdmcp-dev libxext-dev libxfixes-dev libxml2-dev libxmuu1 libxrandr-dev libxrender-dev libxshmfence-dev libxslt1-dev libxtables11 libxxf86vm-dev libyajl-dev linux-libc-dev m4 make manpages manpages-dev mesa-common-dev netbase nettle-dev openjdk-8-jre-headless openssh-client openssl patch perl perl-modules-5.22 pkg-config python-dev python2.7-dev rename rsync swig swig3.0 tcpd unzip uuid-dev x11proto-core-dev x11proto-damage-dev x11proto-dri2-dev x11proto-fixes-dev x11proto-gl-dev x11proto-input-dev x11proto-kb-dev x11proto-randr-dev x11proto-render-dev x11proto-xext-dev x11proto-xf86vidmode-dev xauth xorg-sgml-doctools xtrans-dev xz-utils zip zlib1g-dev libegl1-mesa-dev libmirclient-dev libmircommon-dev libmircookie-dev libprotobuf-dev libwayland-dev libxkbcommon-dev&& \
		apt-get clean && \
		rm -rf /var/lib/apt/lists /usr/share/man /usr/share/doc

			#Eventserver and webserver respectively.
EXPOSE 9777/udp 8089/tcp

CMD ["/opt/kodi-server/lib/kodi/kodi.bin","--headless","--no-test","--nolirc","-p"]
