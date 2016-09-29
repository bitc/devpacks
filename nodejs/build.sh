#!/bin/bash
set -ex

version=6.7.0

##

tarball=https://nodejs.org/dist/v${version}/node-v${version}-linux-x64.tar.xz

tmpdir=$(mktemp -d)

pushd ${tmpdir}
curl -O ${tarball}
tar xf node-v${version}-linux-x64.tar.xz

mv node-v${version}-linux-x64 node-${version}-$(uname -s)-$(uname -m)
chmod -R -w node-${version}-$(uname -s)-$(uname -m)

# Finish up:
tar cfJ node-${version}-$(uname -s)-$(uname -m).tar.xz node-${version}-$(uname -s)-$(uname -m)
popd
mkdir -p dist
cp ${tmpdir}/node-${version}-$(uname -s)-$(uname -m).tar.xz dist

# Cleanup
chmod -R +w ${tmpdir}
rm -rf ${tmpdir}
