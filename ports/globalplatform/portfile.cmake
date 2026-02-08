set(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../../globalplatform")

#include("${VCPKG_ROOT_DIR}/scripts/cmake/vcpkg_cmake_configure.cmake")
#include("${VCPKG_ROOT_DIR}/scripts/cmake/vcpkg_cmake_install.cmake")
#include("${VCPKG_ROOT_DIR}/scripts/cmake/vcpkg_cmake_config_fixup.cmake")

message(STATUS "SOURCE_PATH = ${SOURCE_PATH}")

#include("${VCPKG_ROOT_DIR}/scripts/cmake/vcpkg_cmake.cmake")

#vcpkg_from_github(
#    OUT_SOURCE_PATH SOURCE_PATH
#    REPO kaoh/globalplatform
#    REF master
#    SHA512 0
#)

# Map vcpkg linkage -> your STATIC option
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(GP_STATIC ON)
else()
    set(GP_STATIC OFF)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DTOOLS=OFF
        -DSTATIC=${GP_STATIC}
        -DCMAKE_C_FLAGS=${VCPKG_C_FLAGS}\ -DOPGP_STATIC_PCSC
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_fixup_pkgconfig()

if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/globalplatform" OR EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/cmake/globalplatform")
  vcpkg_cmake_config_fixup(PACKAGE_NAME globalplatform CONFIG_PATH lib/cmake/globalplatform DO_NOT_DELETE_PARENT_CONFIG_PATH)
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/gppcscconnectionplugin" OR EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/cmake/gppcscconnectionplugin")
  vcpkg_cmake_config_fixup(PACKAGE_NAME gppcscconnectionplugin CONFIG_PATH lib/cmake/gppcscconnectionplugin DO_NOT_DELETE_PARENT_CONFIG_PATH)
endif()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/cmake")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/cmake")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# vcpkg ports usually don't ship share/doc
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")

vcpkg_install_copyright(FILE_LIST
    "${SOURCE_PATH}/globalplatform/LICENSE"
    "${SOURCE_PATH}/globalplatform/COPYING"
    "${SOURCE_PATH}/globalplatform/COPYING.LESSER"
)
