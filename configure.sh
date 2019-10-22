#!/usr/bin/bash

# Will exit the Bash script the moment any command will itself exit with a non-zero status, thus an error.
set -e

EXTRACT_PATH=$1
BUILD_PATH=$2
INSTALL_PATH=${REZ_BUILD_INSTALL_PATH}
OPENVDB_AX_VERSION=${REZ_BUILD_PROJECT_VERSION}

# We print the arguments passed to the Bash script.
echo -e "\n"
echo -e "================="
echo -e "=== CONFIGURE ==="
echo -e "================="
echo -e "\n"

echo -e "[CONFIGURE][ARGS] EXTRACT PATH: ${EXTRACT_PATH}"
echo -e "[CONFIGURE][ARGS] BUILD PATH: ${BUILD_PATH}"
echo -e "[CONFIGURE][ARGS] INSTALL PATH: ${INSTALL_PATH}"
echo -e "[CONFIGURE][ARGS] OpenVDB-AX VERSION: ${OPENVDB_AX_VERSION}"

# We check if the arguments variables we need are correctly set.
# If not, we abort the process.
if [[ -z ${EXTRACT_PATH} || -z ${BUILD_PATH} || -z ${INSTALL_PATH} || -z ${OPENVDB_AX_VERSION} ]]; then
    echo -e "\n"
    echo -e "[CONFIGURE][ARGS] One or more of the argument variables are empty. Aborting..."
    echo -e "\n"

    exit 1
fi

# We run the configuration script of OpenVDB-AX.
echo -e "\n"
echo -e "[CONFIGURE] Running the configuration script from OpenVDB-AX-${OPENVDB_AX_VERSION}..."
echo -e "\n"

mkdir -p ${BUILD_PATH}
cd ${BUILD_PATH}

# We modify the FindOpenVDB CMake script in order for it to be able to locate the "pyopenvdb.h" header.
sed "s|PATH_SUFFIXES include include/openvdb include/openvdb/python|PATH_SUFFIXES include include/openvdb include/openvdb/python include/python|1" --in-place ${BUILD_PATH}/../cmake/backports/FindOpenVDB.cmake

# We use the OpenVDB ABI 5, i.e. Houdini 17 and later. Maya should technically be compatible with any OpenVDB ABI.
cmake \
    ${BUILD_PATH}/.. \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} \
    -DCMAKE_C_FLAGS="-fPIC" \
    -DCMAKE_CXX_FLAGS="-fPIC" \
    -DOPENVDB_ABI_VERSION_NUMBER="5" \
    -DOPENVDB_BUILD_AX=ON \
    -DOPENVDB_BUILD_AX_BINARIES=ON \
    -DOPENVDB_BUILD_AX_DOCS=OFF \
    -DOPENVDB_BUILD_AX_HOUDINI_PLUGIN=OFF \
    -DOPENVDB_BUILD_AX_PYTHON_MODULE=ON \
    -DOPENVDB_BUILD_AX_UNITTESTS=OFF \
    -DUSE_CCACHE=ON \
    -DUSE_HOUDINI=OFF \
    -DUSE_SYSTEM_LIBRARY_PATHS=ON \
    -DBLOSC_ROOT=${REZ_BLOSC_ROOT} \
    -DBOOST_ROOT=${REZ_BOOST_ROOT} \
    -DILMBASE_ROOT=${REZ_ILMBASE_ROOT} \
    -DOPENVDB_ROOT=${REZ_OPENVDB_ROOT} \
    -DTBB_ROOT=${REZ_TBB_ROOT} \
    -DZLIB_ROOT=${REZ_ZLIB_ROOT}

echo -e "\n"
echo -e "[CONFIGURE] Finished configuring OpenVDB-AX-${OPENVDB_AX_VERSION}!"
echo -e "\n"
