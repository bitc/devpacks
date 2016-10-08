#!/bin/bash
set -ex

version=1.24.0.0

##

tarball=https://www.haskell.org/cabal/release/cabal-install-${version}/cabal-install-${version}-x86_64-unknown-linux.tar.gz

tmpdir=$(mktemp -d)
pushd ${tmpdir}
curl -O ${tarball}
tar xf cabal-install-${version}-x86_64-unknown-linux.tar.gz

mkdir haskell-cabal-install-${version}-$(uname -s)-$(uname -m)
mkdir haskell-cabal-install-${version}-$(uname -s)-$(uname -m)/bin

mv cabal haskell-cabal-install-${version}-$(uname -s)-$(uname -m)/bin

# Finish up:
tar cfJ haskell-cabal-install-${version}-$(uname -s)-$(uname -m).tar.xz haskell-cabal-install-${version}-$(uname -s)-$(uname -m)
popd
mkdir -p dist
cp ${tmpdir}/haskell-cabal-install-${version}-$(uname -s)-$(uname -m).tar.xz dist

# Cleanup
chmod -R +w ${tmpdir}
rm -rf ${tmpdir}
