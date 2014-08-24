#!/bin/bash

set -e

PO6_PACKAGE=libpo6-0.5.2
E_PACKAGE=libe-0.8.1
BUSYBEE_PACKAGE=busybee-0.5.2
HYPERLEVELDB_PACKAGE=hyperleveldb-1.2.1
REPLICANT_PACKAGE=replicant-0.6.4
HYPERDEX_PACKAGE=hyperdex-1.4.3

BASE_URL=http://hyperdex.org/src

POPT_PACKAGE=popt-1.16
POPT_URL=http://rpm5.org/files/popt/${POPT_PACKAGE}.tar.gz

GLOG_PACKAGE=glog-0.3.3
GLOG_URL=https://google-glog.googlecode.com/files/${GLOG_PACKAGE}.tar.gz

JSONC_PACKAGE="json-c-0.11-20130402"
JSONC_URL="https://github.com/json-c/json-c/archive/${JSONC_PACKAGE}.tar.gz"

cat > /tmp/hyperdex.sha1 << EOF
dcbce34fe3f1032381e125204168dac71d159ec3  libpo6-0.5.2.tar.gz
95c42531d4834b5eb801694b6929f831b76a24f0  libe-0.8.1.tar.gz
e50b4a679791195f079e775ca06bf728711d0d72  busybee-0.5.2.tar.gz
fc43412dbc2cafc7cee8fd47b3e12a84c2833ec4  hyperleveldb-1.2.1.tar.gz
cfe94a15a2404db85858a81ff8de27c8ff3e235e  popt-1.16.tar.gz
ed40c26ecffc5ad47c618684415799ebaaa30d65  glog-0.3.3.tar.gz
bc2527c31ef4671859926fc31b6eb80b9011026e  replicant-0.6.4.tar.gz
1910e10ea57a743ec576688700df4a0cabbe64ba  json-c-0.11-20130402.tar.gz
5b8e90563a2320b3031a0ac89fcc5f91644ddd41  hyperdex-1.4.3.tar.gz
EOF

OUTPUT=/root/"${HYPERDEX_PACKAGE}"-linux-amd64.tar.gz

# Nothing to configure below this point

cd /tmp

wget "${BASE_URL}/${PO6_PACKAGE}.tar.gz"
wget "${BASE_URL}/${E_PACKAGE}.tar.gz"
wget "${BASE_URL}/${BUSYBEE_PACKAGE}.tar.gz"
wget "${BASE_URL}/${HYPERLEVELDB_PACKAGE}.tar.gz"
wget "${BASE_URL}/${REPLICANT_PACKAGE}.tar.gz"
wget "${BASE_URL}/${HYPERDEX_PACKAGE}.tar.gz"
wget "${POPT_URL}"
wget --no-check-certificate "${GLOG_URL}"
wget --no-check-certificate "${JSONC_URL}"
# --no-check-certificate is safe because we check sha1s on the downloads

sha1sum -c hyperdex.sha1

export CUSTOM_PREFIX=/usr/local/hyperdex
export CUSTOM_CPPFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_CFLAGS="-fPIC -fpic -O2"
export CUSTOM_CXXFLAGS="-fPIC -fpic -O2"
export CUSTOM_LDFLAGS="-L${CUSTOM_PREFIX}/lib -fPIC -fpic"
export CUSTOM_PO6_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_PO6_LIBS="-L${CUSTOM_PREFIX}/lib"
export CUSTOM_E_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_E_LIBS="-L${CUSTOM_PREFIX}/lib /usr/local/hyperdex/lib/libe.a"
export CUSTOM_BUSYBEE_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_BUSYBEE_LIBS="-L${CUSTOM_PREFIX}/lib /usr/local/hyperdex/lib/libbusybee.a"
export CUSTOM_HYPERLEVELDB_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_HYPERLEVELDB_LIBS="-L${CUSTOM_PREFIX}/lib /usr/local/hyperdex/lib/libhyperleveldb.a"
export CUSTOM_REPLICANT_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_REPLICANT_LIBS="-L${CUSTOM_PREFIX}/lib /usr/local/hyperdex/lib/libreplicant.a"

# build po6
cd /tmp
tar xzvf "${PO6_PACKAGE}.tar.gz"
cd "/tmp/${PO6_PACKAGE}"
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --prefix=${CUSTOM_PREFIX}
make
make install

# build e
cd /tmp
tar xzvf "${E_PACKAGE}.tar.gz"
cd "/tmp/${E_PACKAGE}"
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    PO6_CFLAGS="${CUSTOM_PO6_CFLAGS}" \
    PO6_LIBS="${CUSTOM_PO6_LIBS}" \
    --prefix=${CUSTOM_PREFIX}
make
make install

# build BusyBee
cd /tmp
tar xzvf "${BUSYBEE_PACKAGE}.tar.gz"
cd "/tmp/${BUSYBEE_PACKAGE}"
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    PO6_CFLAGS="${CUSTOM_PO6_CFLAGS}" \
    PO6_LIBS="${CUSTOM_PO6_LIBS}" \
    E_CFLAGS="${CUSTOM_E_CFLAGS}" \
    E_LIBS="${CUSTOM_E_LIBS}" \
    --prefix=${CUSTOM_PREFIX}
make
make install

# build HyperLevelDB
cd /tmp
tar xzvf "${HYPERLEVELDB_PACKAGE}.tar.gz"
cd "/tmp/${HYPERLEVELDB_PACKAGE}"
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --prefix=${CUSTOM_PREFIX}
make
make install

# build popt
cd /tmp
tar xzvf "${POPT_PACKAGE}.tar.gz"
cd "/tmp/${POPT_PACKAGE}"
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --disable-nls \
    --prefix=${CUSTOM_PREFIX}
make
make install

# build glog
cd /tmp
tar xzvf "${GLOG_PACKAGE}.tar.gz"
cd "/tmp/${GLOG_PACKAGE}"
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --prefix=${CUSTOM_PREFIX}
make
make install

# build Replicant
cd /tmp
tar xzvf "${REPLICANT_PACKAGE}.tar.gz"
cd "/tmp/${REPLICANT_PACKAGE}"
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    PO6_CFLAGS="${CUSTOM_PO6_CFLAGS}" \
    PO6_LIBS="${CUSTOM_PO6_LIBS}" \
    E_CFLAGS="${CUSTOM_E_CFLAGS}" \
    E_LIBS="${CUSTOM_E_LIBS} -lrt" \
    BUSYBEE_CFLAGS="${CUSTOM_BUSYBEE_CFLAGS}" \
    BUSYBEE_LIBS="${CUSTOM_BUSYBEE_LIBS}" \
    HYPERLEVELDB_CFLAGS="${CUSTOM_HYPERLEVELDB_CFLAGS}" \
    HYPERLEVELDB_LIBS="${CUSTOM_HYPERLEVELDB_LIBS}" \
    --prefix=${CUSTOM_PREFIX}
patch Makefile < /root/replicant-makefile.patch
make
make install

# build json-c
cd /tmp
tar xzvf "${JSONC_PACKAGE}.tar.gz"
cd "/tmp/json-c-${JSONC_PACKAGE}"
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --prefix=${CUSTOM_PREFIX}
make
make install
chrpath -r '$ORIGIN/../lib' "${CUSTOM_PREFIX}/libexec/${REPLICANT_PACKAGE}/replicant-daemon"

# build HyperDex
cd /tmp
tar xzvf "${HYPERDEX_PACKAGE}.tar.gz"
cd "/tmp/${HYPERDEX_PACKAGE}"
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    PO6_CFLAGS="${CUSTOM_PO6_CFLAGS}" \
    PO6_LIBS="${CUSTOM_PO6_LIBS}" \
    E_CFLAGS="${CUSTOM_E_CFLAGS}" \
    E_LIBS="${CUSTOM_E_LIBS}" \
    BUSYBEE_CFLAGS="${CUSTOM_BUSYBEE_CFLAGS}" \
    BUSYBEE_LIBS="${CUSTOM_BUSYBEE_LIBS}" \
    HYPERLEVELDB_CFLAGS="${CUSTOM_HYPERLEVELDB_CFLAGS}" \
    HYPERLEVELDB_LIBS="${CUSTOM_HYPERLEVELDB_LIBS}" \
    REPLICANT_CFLAGS="${CUSTOM_REPLICANT_CFLAGS}" \
    REPLICANT_LIBS="${CUSTOM_REPLICANT_LIBS}" \
    --prefix=${CUSTOM_PREFIX}
patch Makefile < /root/hyperdex-makefile.patch
make
make install

# cleanup and generate the tarball
rm -r "${CUSTOM_PREFIX}/include"
rm -r "${CUSTOM_PREFIX}/lib/pkgconfig"
rm "${CUSTOM_PREFIX}"/lib/libbusybee.*
rm "${CUSTOM_PREFIX}"/lib/libe.*
rm "${CUSTOM_PREFIX}"/lib/libglog.*
rm "${CUSTOM_PREFIX}"/lib/libhyperdex-admin.*
rm "${CUSTOM_PREFIX}"/lib/libhyperdex-client.*
rm "${CUSTOM_PREFIX}"/lib/libhyperleveldb.*
rm "${CUSTOM_PREFIX}"/lib/libjson*
rm "${CUSTOM_PREFIX}"/lib/libpopt.*
rm "${CUSTOM_PREFIX}"/lib/libreplicant.*
rm "${CUSTOM_PREFIX}"/share/man/man3/popt.3
rm "${CUSTOM_PREFIX}"/libexec/"${HYPERDEX_PACKAGE}"/libhyperdex-coordinator.a
rm "${CUSTOM_PREFIX}"/libexec/"${HYPERDEX_PACKAGE}"/libhyperdex-coordinator.la
rmdir "${CUSTOM_PREFIX}"/share/java

tar czvf ${OUTPUT} -C /usr/local hyperdex/

# report

echo ================================================================================
echo Report on the various files shipped in the tarball, and what they link
echo ================================================================================

find "${CUSTOM_PREFIX}" -print0 \
| xargs -0 ldd 2>/dev/null \
| grep -v 'not a dynamic executable' \
| grep -v 'linux-vdso.so.1 =>' \
| grep -v 'libpthread.so.0 =>' \
| grep -v 'librt.so.1 =>' \
| grep -v 'libstdc++.so.6 =>' \
| grep -v 'libm.so.6 =>' \
| grep -v 'libgcc_s.so.1 =>' \
| grep -v 'libc.so.6 =>' \
| grep -v '/lib64/ld-linux-x86-64.so.2'

echo ================================================================================
echo SUCCESS
echo The built binaries are available at ${OUTPUT}
echo ================================================================================
