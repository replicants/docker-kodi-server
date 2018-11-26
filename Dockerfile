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

from base/archlinux
maintainer celedhrim "celed+git@ielf.org"

# Add headless patch
ADD src/headless.patch /headless.patch

# Install dep , compile , clean

RUN cd /root && \
    pacman -Syu --noprogressbar --noconfirm && \
    pacman --noprogressbar --noconfirm -S git make autoconf automake pkg-config jre8-openjdk-headless swig gcc python2 mesa-libgl glu libmariadbclient libass tinyxml yajl libxslt taglib libmicrohttpd libxrandr libssh smbclient libnfs ffmpeg libx264 cmake gperf unzip zip libcdio gtk-update-icon-cache rsync grep sed gettext which patch ghostscript groff rapidjson sudo wget fakeroot && \
	ln -s /usr/bin/python2 /usr/bin/python && \
	ln -s /usr/bin/python2-config /usr/bin/python-config && \
    mkdir /build && \
    groupadd -g 1000 builder && \
    useradd -M -d /build -g 1000 -s /bin/bash -u 1000 builder && \
    chown builder:builder /build && \
    cd /build && \
    sudo -u builder wget https://aur.archlinux.org/cgit/aur.git/snapshot/fmt.tar.gz && \
    sudo -u builder tar -xzf fmt.tar.gz && \
    cd fmt && \
    sudo -u builder makepkg && \
    pacman -U --noconfirm --noprogressbar *.tar.xz && \
    cd /root && \
    rm -rf /build && \
    userdel builder && \
	git clone https://github.com/xbmc/xbmc.git -b 18.0rc1-Leia --depth=1 && \
    cd /root/xbmc && \
	mv /headless.patch . && \
	git apply headless.patch && \
    cmake \
        -DCMAKE_INSTALL_PREFIX=/opt/kodi-server \
        -DENABLE_INTERNAL_FFMPEG=OFF \
        -DWITH_FFMPEG=ON \
        -DENABLE_AIRTUNES=OFF \
        -DENABLE_LIRC=OFF \
        -DENABLE_EVENTCLIENTS=OFF \
        -DENABLE_INTERNAL_CROSSGUID=ON \
        -DENABLE_INTERNAL_RapidJSON=OFF \
        -DENABLE_INTERNAL_FMT=OFF \
        -DENABLE_INTERNAL_FSTRCMP=ON \
        -DENABLE_INTERNAL_FLATBUFFERS=ON \
        -DENABLE_DVDCSS=OFF \
        -DENABLE_ALSA=OFF \
        -DENABLE_AVAHI=OFF \
        -DENABLE_VDPAU=OFF \
        -DENABLE_VAAPI=OFF \
        -DENABLE_UDEV=OFF \
        -DENABLE_PULSEAUDIO=OFF \
        -DENABLE_OPTICAL=OFF \
        -DENABLE_SNDIO=OFF \
        -DENABLE_LCMS2=OFF \
        -DENABLE_DBUS=OFF && \
    make && \
    make install && \
	mkdir -p /opt/kodi-server/share/kodi/portable_data/ && \
	cd /root && \
	mkdir empty && \
	rsync -a --delete empty/ xbmc/ && \
    pacman --noconfirm -Rnsc git make autoconf automake swig jre8-openjdk-headless gcc cmake gperf rsync gtk-update-icon-cache grep gettext which patch sudo wget fakeroot && \
    rm -rf /root/* /usr/lib/python2.7/test /usr/share/doc /usr/share/man /var/cache/pacman/pkg


#Eventserver and webserver respectively.
EXPOSE 9777/udp 8089/tcp
CMD ["/opt/kodi-server/lib64/kodi/kodi-x11","--headless","--no-test","--nolirc","-p"]
