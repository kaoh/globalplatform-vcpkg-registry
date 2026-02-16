vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kaoh/globalplatform
    REF 3.0.0-b2
    SHA512 204d74330afb03493269c6fb108108cc08861ffd7d3e85e378da43106c550bcaf7637c36b9f6c0b139872b9a45aff80cae08f2bbfefb128548eca51e80355e8b
)

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
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_fixup_pkgconfig()
#
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/globalplatform" OR EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/cmake/globalplatform")
  vcpkg_cmake_config_fixup(PACKAGE_NAME globalplatform CONFIG_PATH lib/cmake/globalplatform DO_NOT_DELETE_PARENT_CONFIG_PATH)
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/gppcscconnectionplugin" OR EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/cmake/gppcscconnectionplugin")
  vcpkg_cmake_config_fixup(PACKAGE_NAME gppcscconnectionplugin CONFIG_PATH lib/cmake/gppcscconnectionplugin DO_NOT_DELETE_PARENT_CONFIG_PATH)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/cmake")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/cmake")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/doc")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")

vcpkg_install_copyright(FILE_LIST
    "${SOURCE_PATH}/globalplatform/LICENSE"
    "${SOURCE_PATH}/globalplatform/COPYING"
    "${SOURCE_PATH}/globalplatform/COPYING.LESSER"
)
