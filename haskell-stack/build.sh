#!/bin/bash
set -ex

version=1.2.0

tarball=https://github.com/commercialhaskell/stack/releases/download/v${version}/stack-${version}-linux-x86_64.tar.gz

tmpdir=$(mktemp -d)

pushd ${tmpdir}
curl -L -O ${tarball}
tar xf stack-${version}-linux-x86_64.tar.gz

mv stack-${version}-linux-x86_64 haskell-stack-${version}-$(uname -s)-$(uname -m)
mkdir haskell-stack-${version}-$(uname -s)-$(uname -m)/bin
pushd haskell-stack-${version}-$(uname -s)-$(uname -m)/bin
ln -s ../stack stack
popd

chmod -R -w haskell-stack-${version}-$(uname -s)-$(uname -m)

# Finish up:
tar cfJ haskell-stack-${version}-$(uname -s)-$(uname -m).tar.xz haskell-stack-${version}-$(uname -s)-$(uname -m)
popd
mkdir -p dist
cp ${tmpdir}/haskell-stack-${version}-$(uname -s)-$(uname -m).tar.xz dist

# Cleanup
chmod -R +w ${tmpdir}
rm -rf ${tmpdir}
