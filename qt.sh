#!/bin/bash

# Mengatur prefix untuk instalasi Qt5
QT5PREFIX="/opt/qt5"

# Langkah 1: Unduh Paket Qt5
echo "Mengunduh Qt5 versi 5.15.5..."
wget -q https://download.qt.io/archive/qt/5.15/5.15.5/single/qt-everywhere-opensource-src-5.15.5.tar.xz
wget -q https://www.linuxfromscratch.org/patches/blfs/11.2/qt-everywhere-opensource-src-5.15.5-kf5-1.patch
# Verifikasi MD5 sum (opsional)
echo "Verifikasi checksum MD5..."
echo "0fbcde36556a366df8ecf24a7ea1f7ec  qt-everywhere-opensource-src-5.15.5.tar.xz" | md5sum -c

# Langkah 2: Ekstrak Paket
echo "Ekstrak paket Qt5..."
tar -xvf qt-everywhere-opensource-src-5.15.5.tar.xz
cd qt-everywhere-opensource-src-5.15.5

# Langkah 3: Terapkan Patch (Jika ada)
echo "Menerapkan patch jika diperlukan..."
patch -Np1 -i ../qt-everywhere-opensource-src-5.15.5-kf5-1.patch

# Langkah 4: Konfigurasi Qt5
echo "Mengonfigurasi Qt5..."
export QT5PREFIX
./configure -prefix $QT5PREFIX \
            -sysconfdir /etc/xdg \
            -confirm-license \
            -opensource \
            -dbus-linked \
            -openssl-linked \
            -system-harfbuzz \
            -system-sqlite \
            -nomake examples \
            -no-rpath \
            -syslog \
            -skip qtwebengine

# Langkah 5: Membangun Qt5
echo "Membangun Qt5..."
make -j4  # Sesuaikan dengan jumlah inti CPU di sistem Anda

# Langkah 6: Instal Qt5
echo "Menginstal Qt5..."
sudo make install

# Langkah 7: Bersihkan File Pustaka yang Tidak Diperlukan
echo "Menghapus referensi ke direktori build lama..."
find $QT5PREFIX/ -name \*.prl -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

# Langkah 8: Menambahkan Qt5 ke PATH dan PKG_CONFIG_PATH
echo "Menambahkan Qt5 ke PATH dan PKG_CONFIG_PATH..."
sudo bash -c 'cat > /etc/profile.d/qt5.sh << "EOF"
# Begin /etc/profile.d/qt5.sh

export QT5DIR=$QT5PREFIX
export PATH=$QT5DIR/bin:$PATH
export PKG_CONFIG_PATH=$QT5DIR/lib/pkgconfig:$PKG_CONFIG_PATH

# End /etc/profile.d/qt5.sh
EOF'

# Memuat ulang konfigurasi
source /etc/profile.d/qt5.sh

# Langkah 9: Install Ikon dan Buat Entri Menu Aplikasi
echo "Menginstal ikon dan membuat entri menu aplikasi..."
QT5BINDIR=$QT5PREFIX/bin
install -v -dm755 /usr/share/pixmaps/

install -v -Dm644 qttools/src/assistant/assistant/images/assistant-128.png /usr/share/pixmaps/assistant-qt5.png
install -v -Dm644 qttools/src/designer/src/designer/images/designer.png /usr/share/pixmaps/designer-qt5.png
install -v -Dm644 qttools/src/linguist/linguist/images/icons/linguist-128-32.png /usr/share/pixmaps/linguist-qt5.png
install -v -Dm644 qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png /usr/share/pixmaps/qdbusviewer-qt5.png

install -dm755 /usr/share/applications

cat > /usr/share/applications/assistant-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Assistant
Comment=Shows Qt5 documentation and examples
Exec=$QT5BINDIR/assistant
Icon=assistant-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Documentation;
EOF

cat > /usr/share/applications/designer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Designer
GenericName=Interface Designer
Comment=Design GUIs for Qt5 applications
Exec=$QT5BINDIR/designer
Icon=designer-qt5.png
MimeType=application/x-designer;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF

# Langkah 10: Membuat Simlink untuk Qt5 Executables (Jika Diperlukan)
echo "Membuat symlink untuk Qt5 executables..."
for file in moc uic rcc qmake lconvert lrelease lupdate; do
  ln -sfrvn $QT5BINDIR/$file /usr/bin/$file-qt5
done

echo "Instalasi Qt5 selesai!"
