SET(CMAKE_SYSTEM_NAME Windows)
SET(TOOLCHAIN_PREFIX x86_64-w64-mingw32)

SET(CMAKE_C_COMPILER /usr/bin/${TOOLCHAIN_PREFIX}-gcc)
SET(CMAKE_CXX_COMPILER /usr/bin/${TOOLCHAIN_PREFIX}-g++)
SET(CMAKE_RC_COMPILER /usr/bin/${TOOLCHAIN_PREFIX}-windres)

# This PREFIX_PATH will be specified by -DPREFIX_PATH when invoking cmake
SET(CMAKE_FIND_ROOT_PATH /usr/${TOOLCHAIN_PREFIX}/ ${PREFIX_PATH})

#export LD=/usr/bin/x86_64-w64-mingw32-gcc

# modify default behavior of FIND_XXX() commands
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

SET(PKG_CONFIG_EXECUTABLE /usr/bin/${TOOLCHAIN_PREFIX}-pkg-config)