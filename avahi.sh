#!/bin/bash
wget https://github.com/lathiat/avahi/releases/download/v0.8/avahi-0.8.tar.gz
wget https://www.linuxfromscratch.org/patches/blfs/11.2/avahi-0.8-ipv6_race_condition_fix-1.patch
tar -xf avahi-0.8.tar.gz
cd avahi-0.8
groupadd -fg 84 avahi &&
useradd -c "Avahi Daemon Owner" -d /run/avahi-daemon -u 84 \
        -g avahi -s /bin/false avahi
groupadd -fg 86 netdev
patch -Np1 -i ../avahi-0.8-ipv6_race_condition_fix-1.patch
sed -i '426a if (events & AVAHI_WATCH_HUP) { \
client_free(c); \
return; \
}' avahi-daemon/simple-protocol.c
./configure \
    --prefix=/usr                  \
    --sysconfdir=/etc              \
    --localstatedir=/var           \
    --disable-static               \
    --disable-libevent             \
    --disable-mono                 \
    --disable-monodoc              \
    --disable-python               \
    --disable-qt3                  \
    --disable-qt4                  \
    --enable-core-docs             \
    --with-distro=none             \
    --with-systemdsystemunitdir=no \
    --with-dbus-system-address='unix:path=/run/dbus/system_bus_socket' &&
make -j$(nproc)
make install
