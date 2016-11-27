#!/bin/bash
set -ex

version=6.5.0
postcss_cli_version=2.6.0

##

tarball=https://registry.npmjs.org/postcss-cli/-/postcss-cli-${postcss_cli_version}.tgz

tmpdir=$(mktemp -d)

pushd ${tmpdir}
curl -O ${tarball}
tar xf postcss-cli-${postcss_cli_version}.tgz

export npm_config_cache=${tmpdir}/.npm
mkdir ${npm_config_cache}

pushd package
npm install
npm install autoprefixer@${version}
popd

mv package autoprefixer-${version}-all
chmod -R -w autoprefixer-${version}-all

# Finish up:
tar cfJ autoprefixer-${version}-all.tar.xz autoprefixer-${version}-all
popd
mkdir -p dist
cp ${tmpdir}/autoprefixer-${version}-all.tar.xz dist

# Cleanup
chmod -R +w ${tmpdir}
rm -rf ${tmpdir}
