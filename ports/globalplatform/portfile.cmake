vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kaoh/globalplatform
    REF packaging
    SHA512 8f17204163757491c5ca614c5199572c6535495cb876463d310d674219e9f2339552412a99fe30598a49ed03f5af5109b2b7f0c7f655de7867ecd6886e451177
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
