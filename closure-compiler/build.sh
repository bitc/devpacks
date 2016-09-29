#!/bin/bash
set -ex

version=20160208

##

tarball=https://dl.google.com/closure-compiler/compiler-${version}.tar.gz

tmpdir=$(mktemp -d)

pushd ${tmpdir}
curl -O ${tarball}
tar xf compiler-${version}.tar.gz

bundledir=${tmpdir}/closure-compiler-${version}-all

mkdir ${bundledir}
mkdir ${bundledir}/bin

cp compiler.jar COPYING README.md ${bundledir}

echo '#!/bin/bash' > ${bundledir}/bin/closure-compiler
echo 'DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"' >> ${bundledir}/bin/closure-compiler
echo 'java -jar "$DIR"/../compiler.jar "$@"' >> ${bundledir}/bin/closure-compiler
chmod +x ${bundledir}/bin/closure-compiler

chmod -R -w closure-compiler-${version}-all

# Finish up:
tar cfJ closure-compiler-${version}-all.tar.xz closure-compiler-${version}-all
popd
mkdir -p dist
cp ${tmpdir}/closure-compiler-${version}-all.tar.xz dist

# Cleanup
chmod -R +w ${tmpdir}
rm -rf ${tmpdir}
