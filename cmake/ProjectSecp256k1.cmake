INCLUDE(ExternalProject)

IF (MSVC)
    SET(_only_release_configuration -DCMAKE_CONFIGURATION_TYPES=Release)
    SET(_overwrite_install_command INSTALL_COMMAND cmake --build <BINARY_DIR> --config Release --target install)
ENDIF()

SET(prefix "${CMAKE_BINARY_DIR}/deps")
SET(SECP256K1_LIBRARY "${prefix}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}secp256k1${CMAKE_STATIC_LIBRARY_SUFFIX}")
SET(SECP256K1_INCLUDE_DIR "${prefix}/include")

ExternalProject_Add(
    secp256k1
    PREFIX "${prefix}"
    DOWNLOAD_NAME secp256k1-ac8ccf29.tar.gz
    DOWNLOAD_NO_PROGRESS 1
    URL https://github.com/chfast/secp256k1/archive/ac8ccf29b8c6b2b793bc734661ce43d1f952977a.tar.gz
    URL_HASH SHA256=02f8f05c9e9d2badc91be8e229a07ad5e4984c1e77193d6b00e549df129e7c3a
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_LIST_DIR}/secp256k1/CMakeLists.txt <SOURCE_DIR>
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
               -DCMAKE_POSITION_INDEPENDENT_CODE=${BUILD_SHARED_LIBS}
               -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
               -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
               ${_only_release_configuration}
    LOG_CONFIGURE 1
    BUILD_COMMAND ""
    ${_overwrite_install_command}
    LOG_INSTALL 1
    BUILD_BYPRODUCTS "${SECP256K1_LIBRARY}"
)

# Create imported library
ADD_LIBRARY(Secp256k1 STATIC IMPORTED)
FILE(MAKE_DIRECTORY "${SECP256K1_INCLUDE_DIR}")  # Must exist.
SET_PROPERTY(TARGET Secp256k1 PROPERTY IMPORTED_CONFIGURATIONS Release)
SET_PROPERTY(TARGET Secp256k1 PROPERTY IMPORTED_LOCATION_RELEASE "${SECP256K1_LIBRARY}")
SET_PROPERTY(TARGET Secp256k1 PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${SECP256K1_INCLUDE_DIR}")
ADD_DEPENDENCIES(Secp256k1 secp256k1)
