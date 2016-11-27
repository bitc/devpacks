#!/bin/bash
set -ex

version=3.3.6

##

tmpdir=$(mktemp -d)

pushd ${tmpdir}
git clone --depth 1 --branch 3.3.6 https://github.com/sass/libsass.git
git clone --depth 1 --branch 3.3.6 https://github.com/sass/sassc.git

make -C libsass
SASS_LIBSASS_PATH=`pwd`/libsass make -C sassc

mkdir sassc-${version}-$(uname -s)-$(uname -m)
mkdir sassc-${version}-$(uname -s)-$(uname -m)/bin
cp sassc/bin/sassc sassc-${version}-$(uname -s)-$(uname -m)/bin
strip sassc-${version}-$(uname -s)-$(uname -m)/bin/sassc

# Finish up:
tar cfJ sassc-${version}-$(uname -s)-$(uname -m).tar.xz sassc-${version}-$(uname -s)-$(uname -m)
popd
mkdir -p dist
cp ${tmpdir}/sassc-${version}-$(uname -s)-$(uname -m).tar.xz dist

# Cleanup
chmod -R +w ${tmpdir}
rm -rf ${tmpdir}
