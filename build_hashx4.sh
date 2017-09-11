#!/bin/bash

# Build SSE-3 optimized C-implementation of DJBX33A hash algorithm
# See also: https://github.com/cleeus/hashx4

HASHX4=hashx4
HASHX4_BUILD_DIR=${HASHX4}

if [ ! -f "${HASHX4_BUILD_DIR}/CMakeFiles/testhx4.dir/src/hx4_djbx33a.c.o" ]; then
    mkdir -p ${HASHX4_BUILD_DIR}
    cd ${HASHX4_BUILD_DIR}
    cmake \
        -DCMAKE_CC_COMPILER=/usr/bin/gcc-7 \
        -DCMAKE_CXX_COMPILER=/usr/bin/g++-7 \
        -DCMAKE_BUILD_TYPE=Release .
    make src/hx4_djbx33a.o
fi
