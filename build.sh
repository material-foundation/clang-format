#!/bin/bash
#
# Copyright 2018-present the Material Foundation authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This number is generated by running `clang-format -version` from a local machine
# and extracting the r##### portion of the version. The number represents the
# subversion revision number of clang-format.
REV=352957

if [ ! -d llvm ]; then
  svn co -q https://llvm.org/svn/llvm-project/llvm/trunk llvm -r $REV
else
  cd llvm
  svn update -r $REV
  cd ../
fi

cd llvm/tools
if [ ! -d clang ]; then
  svn co -q https://llvm.org/svn/llvm-project/cfe/trunk clang -r $REV
else
  cd clang
  svn update -r $REV
  cd ../
fi
cd ../..

if [ ! -d build ]; then
  mkdir build
fi

cd build

cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../llvm
make clang-format

bin/clang-format -version

echo "You can now create a new release."
echo "1. Visit https://github.com/material-foundation/clang-format/releases/new"
echo "2. Upload build/bin/clang-format as a binary attachment."
echo "3. Name the release and tag r$REV"
echo "4. Add the following to the release description:"
echo
echo "   SHA256: $(openssl sha -sha256 bin/clang-format)"
