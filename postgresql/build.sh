#!/bin/bash
set -ex

version=9.6.0

##

tarball=https://ftp.postgresql.org/pub/source/v${version}/postgresql-${version}.tar.gz

tmpdir=$(mktemp -d)

pushd ${tmpdir}
curl -O ${tarball}
tar xf postgresql-${version}.tar.gz
pushd postgresql-${version}

bundledir=${tmpdir}/postgresql-${version}-$(uname -s)-$(uname -m)

./configure --prefix=${bundledir}
make
make install-strip
popd

# Finish up:
tar cfJ postgresql-${version}-$(uname -s)-$(uname -m).tar.xz postgresql-${version}-$(uname -s)-$(uname -m)
popd
mkdir -p dist
cp ${tmpdir}/postgresql-${version}-$(uname -s)-$(uname -m).tar.xz dist

# Clean up:

chmod -R +w ${tmpdir}
rm -rf ${tmpdir}
