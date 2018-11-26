# docker-kodi-server
#
# Create your own Build:
# 	$ docker build --rm=true -t $(whoami)/kodi-server .
#
# Run your build:
#	  $ docker run -d --restart="always" --net=host -v /directory/with/kodidata:/opt/kodi-server/share/kodi/portable_data $(whoami)/kodi-server
#
# Greatly inspire by the work of wernerb,
# See https://github.com/wernerb/docker-xbmc-server

FROM celedhrim/kodi-server-base-build:leia
maintainer celedhrim "celed+git@ielf.org"

# Clone kodi 
RUN cd / && git clone https://github.com/xbmc/xbmc.git -b 18.0rc1-Leia --depth=1

# Define workdir
WORKDIR /xbmc

# Get patch en apply 
ADD src/headless.patch /xbmc/headless.patch
RUN git apply headless.patch

RUN cmake \
		-DCMAKE_INSTALL_PREFIX=/opt/kodi-server \
        -DENABLE_INTERNAL_FFMPEG=OFF \
        -DWITH_FFMPEG=ON \
        -DENABLE_AIRTUNES=OFF \
        -DENABLE_EVENTCLIENTS=OFF \
        -DENABLE_INTERNAL_CROSSGUID=ON \
        -DENABLE_INTERNAL_RapidJSON=OFF \
        -DENABLE_INTERNAL_FMT=OFF \
        -DENABLE_INTERNAL_FSTRCMP=ON \
        -DENABLE_INTERNAL_FLATBUFFERS=OFF \
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
        -DENABLE_DBUS=OFF \
        -DENABLE_BLURAY=OFF \
        -DENABLE_CAP=OFF

RUN make install

FROM celedhrim/kodi-server-base-run:leia
WORKDIR /opt/
COPY --from=0 /opt .
RUN mkdir -p /opt/kodi-server/share/kodi/portable_data/
EXPOSE 9777/udp 8089/tcp
CMD ["/opt/kodi-server/lib64/kodi/kodi-x11","--no-test","--nolirc","-p"]
