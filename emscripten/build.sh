#!/bin/bash

# Build script inspired by:
#
#   https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/compilers/emscripten-fastcomp/default.nix
#   https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/compilers/emscripten/default.nix

set -ex

version=1.36.4

##

tmpdir=$(mktemp -d)

pushd ${tmpdir}
git clone --branch ${version} --depth 1 https://github.com/kripken/emscripten.git
git clone --branch ${version} --depth 1 https://github.com/kripken/emscripten-fastcomp.git
git clone --branch ${version} --depth 1 https://github.com/kripken/emscripten-fastcomp-clang.git

bundledir=${tmpdir}/emscripten-${version}-$(uname -s)-$(uname -m)
mkdir ${bundledir}

# Bundle emscripten:

cp -r emscripten/* ${bundledir}
chmod -R +w ${bundledir}

em_config="EM_CONFIG = '''\\n\
EMSCRIPTEN_ROOT = '{0}'\\n\
LLVM_ROOT = '{1}'\\n\
PYTHON = 'python'\\n\
NODE_JS = 'node'\\n\
JS_ENGINES = [NODE_JS]\\n\
COMPILER_ENGINE = NODE_JS\\n\
CLOSURE_COMPILER = '{2}'\\n\
JAVA = 'java'\\n\
'''.format(\\n\
    __rootpath__,\\n\
    os.path.join(__rootpath__, 'emscripten-fastcomp'),\\n\
    os.path.join(__rootpath__, 'third_party/closure-compiler/compiler.jar'))"

sed -i -e "s%EM_CONFIG = '~/.emscripten'%${em_config}%" ${bundledir}/tools/shared.py
mkdir ${bundledir}/bin
pushd ${bundledir}/bin
ln -s ../em++ ../em-config ../emar ../embuilder.py ../emcc ../emcmake ../emconfigure ../emlink.py ../emmake ../emranlib ../emrun ../emscons .
popd

# Build emscripten-fastcomp together with emscripten-fastcomp-clang:

cp -as ${tmpdir}/emscripten-fastcomp ${tmpdir}/src
chmod +w ${tmpdir}/src/tools
cp -as ${tmpdir}/emscripten-fastcomp-clang ${tmpdir}/src/tools/clang

chmod +w ${tmpdir}/src
mkdir ${tmpdir}/src/build
pushd ${tmpdir}/src/build

../configure --enable-optimized --disable-assertions --enable-targets=host,js
make

cp -a Release/bin ${bundledir}/emscripten-fastcomp
popd

# Finish up:
tar cfJ emscripten-${version}-$(uname -s)-$(uname -m).tar.xz emscripten-${version}-$(uname -s)-$(uname -m)
popd
mkdir -p dist
cp ${tmpdir}/emscripten-${version}-$(uname -s)-$(uname -m).tar.xz dist

# Clean up:

chmod -R +w ${tmpdir}
rm -rf ${tmpdir}
