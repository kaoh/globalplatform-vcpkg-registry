vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kaoh/globalplatform
    REF packaging
    SHA512 1c164a61905fc12bfb6d87808bb37ff97a8b9d1960c1ad5bdb2da451c93fd587a5205d139d4a7e41ab65e33aa6cc320939039731bc744020cc39f2b53e8ff11e
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

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")

vcpkg_install_copyright(FILE_LIST
    "${SOURCE_PATH}/globalplatform/LICENSE"
    "${SOURCE_PATH}/globalplatform/COPYING"
    "${SOURCE_PATH}/globalplatform/COPYING.LESSER"
)
