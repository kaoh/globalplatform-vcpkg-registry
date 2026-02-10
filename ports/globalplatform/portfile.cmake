vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kaoh/globalplatform
    REF packaging
    SHA512 852bbab7b64b7a26d2cb78e1329a8c11389701345a1d28cce7f7e0260a19cbb83f0c32fee6a826e41bf2583c5cd95bebfeaf5c8e5451fc7648e81a852da0e0e2
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

if(VCPKG_TARGET_IS_WINDOWS)
    foreach(_cfg IN ITEMS "" "debug/")
        foreach(_dll IN ITEMS gppcscconnectionplugin globalplatform)
            set(_src "${CURRENT_PACKAGES_DIR}/${_cfg}lib/${_dll}.dll")
            if(EXISTS "${_src}")
                file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/${_cfg}bin")
                file(COPY "${_src}" DESTINATION "${CURRENT_PACKAGES_DIR}/${_cfg}bin")
                file(REMOVE "${_src}")
            endif()
        endforeach()
    endforeach()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_fixup_pkgconfig()

if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/globalplatform" OR EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/cmake/globalplatform")
  vcpkg_cmake_config_fixup(PACKAGE_NAME globalplatform CONFIG_PATH lib/cmake/globalplatform DO_NOT_DELETE_PARENT_CONFIG_PATH)
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/share/globalplatform" OR EXISTS "${CURRENT_PACKAGES_DIR}/debug/share/globalplatform")
  vcpkg_cmake_config_fixup(PACKAGE_NAME globalplatform CONFIG_PATH share/globalplatform DO_NOT_DELETE_PARENT_CONFIG_PATH)
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/gppcscconnectionplugin" OR EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/cmake/gppcscconnectionplugin")
  vcpkg_cmake_config_fixup(PACKAGE_NAME gppcscconnectionplugin CONFIG_PATH lib/cmake/gppcscconnectionplugin DO_NOT_DELETE_PARENT_CONFIG_PATH)
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/share/gppcscconnectionplugin" OR EXISTS "${CURRENT_PACKAGES_DIR}/debug/share/gppcscconnectionplugin")
  vcpkg_cmake_config_fixup(PACKAGE_NAME gppcscconnectionplugin CONFIG_PATH share/gppcscconnectionplugin DO_NOT_DELETE_PARENT_CONFIG_PATH)
endif()

if(VCPKG_TARGET_IS_WINDOWS)
  foreach(_cfg IN ITEMS "" "debug/")
    set(_targets "${CURRENT_PACKAGES_DIR}/${_cfg}share/gppcscconnectionplugin/gppcscconnectionpluginTargets.cmake")
    if(EXISTS "${_targets}")
      vcpkg_replace_string("${_targets}" "/debug/lib/gppcscconnectionplugin.dll" "/debug/bin/gppcscconnectionplugin.dll")
      vcpkg_replace_string("${_targets}" "/lib/gppcscconnectionplugin.dll" "/bin/gppcscconnectionplugin.dll")
    endif()
  endforeach()
endif()
if(VCPKG_TARGET_IS_WINDOWS)
  foreach(_cfg IN ITEMS "" "debug/")
    set(_targets "${CURRENT_PACKAGES_DIR}/${_cfg}share/globalplatform/globalplatformTargets.cmake")
    if(EXISTS "${_targets}")
      vcpkg_replace_string("${_targets}" "/debug/lib/globalplatform.dll" "/debug/bin/globalplatform.dll")
      vcpkg_replace_string("${_targets}" "/lib/globalplatform.dll" "/bin/globalplatform.dll")
    endif()
  endforeach()
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
