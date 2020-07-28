if(Slicer_USE_CTKAPPLAUNCHER)

  set(proj CTKAPPLAUNCHER)

  # Sanity checks
  if(DEFINED CTKAPPLAUNCHER_DIR AND NOT EXISTS ${CTKAPPLAUNCHER_DIR})
    message(FATAL_ERROR "CTKAPPLAUNCHER_DIR variable is defined but corresponds to nonexistent directory")
  endif()

  # Set dependency list
  set(${proj}_DEPENDENCIES "")
  if(WIN32)
    set(${proj}_DEPENDENCIES CTKResEdit)
  endif()

  # Include dependent projects if any
  ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

  if(Slicer_USE_SYSTEM_${proj})
    message(FATAL_ERROR "Enabling Slicer_USE_SYSTEM_${proj} is not supported !")
  endif()

  if(NOT DEFINED CTKAppLauncher_DIR)
    set(_base_url https://github.com/commontk/AppLauncher/releases/download/v)

    SlicerMacroGetOperatingSystemArchitectureBitness(VAR_PREFIX CTKAPPLAUNCHER)
    set(launcher_version "0.1.27")
    # On windows, use i386 launcher unconditionally
    if("${CTKAPPLAUNCHER_OS}" STREQUAL "win")
      set(CTKAPPLAUNCHER_ARCHITECTURE "i386")
      set(md5 "3f05dcc605ac2144edc69b28c27bb8d1")
    elseif("${CTKAPPLAUNCHER_OS}" STREQUAL "linux")
      if("${CMAKE_HOST_SYSTEM_PROCESSOR}" STREQUAL "aarch64")
        set(_base_url https://github.com/Slicer/AppLauncher/releases/download/v)
        set(md5 "54afe832001fb0c0146c089eeccd2d8f")
      else()
        set(md5 "a9a8aab9c0e91cdd0b5265eb799daf74")
      endif()
    elseif("${CTKAPPLAUNCHER_OS}" STREQUAL "macosx")
      set(md5 "a9de73a1609c988167884efa23819287")
    endif()

    set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj})

    ExternalProject_Add(${proj}
      ${${proj}_EP_ARGS}
      URL ${_base_url}${launcher_version}/CTKAppLauncher-${launcher_version}-${CTKAPPLAUNCHER_OS}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz
      URL_MD5 ${md5}
      DOWNLOAD_DIR ${CMAKE_BINARY_DIR}
      SOURCE_DIR ${EP_BINARY_DIR}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
      DEPENDS
        ${${proj}_DEPENDENCIES}
      )

    ExternalProject_GenerateProjectDescription_Step(${proj}
      VERSION ${launcher_version}
      LICENSE_FILES "https://raw.githubusercontent.com/commontk/AppLauncher/v${launcher_version}/LICENSE_Apache_20"
      )

    set(CTKAppLauncher_DIR ${EP_BINARY_DIR})

  else()
    ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
  endif()

  mark_as_superbuild(
    VARS
      CTKAppLauncher_DIR:PATH
    LABELS "FIND_PACKAGE"
    )

endif()
