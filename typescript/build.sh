#!/bin/bash
set -ex

version=2.0.3

##

tarball=https://registry.npmjs.org/typescript/-/typescript-${version}.tgz

tmpdir=$(mktemp -d)

pushd ${tmpdir}
curl -O ${tarball}
tar xf typescript-${version}.tgz

mv package typescript-${version}-all
chmod +x typescript-${version}-all/bin/tsc typescript-${version}-all/bin/tsserver
chmod -R -w typescript-${version}-all

# Finish up:
tar cfJ typescript-${version}-all.tar.xz typescript-${version}-all
popd
mkdir -p dist
cp ${tmpdir}/typescript-${version}-all.tar.xz dist

# Cleanup
chmod -R +w ${tmpdir}
rm -rf ${tmpdir}
