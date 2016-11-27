#!/bin/bash
set -ex

version=2.2.1

##

tarball=https://registry.npmjs.org/csso/-/csso-${version}.tgz

tmpdir=$(mktemp -d)

pushd ${tmpdir}
curl -O ${tarball}
tar xf csso-${version}.tgz

export npm_config_cache=${tmpdir}/.npm
mkdir ${npm_config_cache}

pushd package
npm install
popd

mv package csso-${version}-all
chmod -R -w csso-${version}-all

# Finish up:
tar cfJ csso-${version}-all.tar.xz csso-${version}-all
popd
mkdir -p dist
cp ${tmpdir}/csso-${version}-all.tar.xz dist

# Cleanup
chmod -R +w ${tmpdir}
rm -rf ${tmpdir}
