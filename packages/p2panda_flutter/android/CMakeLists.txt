set(LibraryVersion "p2panda_flutter-v0.1.0") # generated; do not edit

# Unlike the Windows & Linux CMakeLists.txt, this Android equivalent is just
# here to download the Android binaries into src/main/jniLibs/ and does not
# build anything. The binary download/extraction is difficult to do concisely
# in Groovy/Gradle, at least across host platforms, so we are just reusing our
# Linux/Windows logic.

# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause the
# plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

set(LibRoot "${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs")

set(RemoteFromPath "https://github.com/p2panda/meli/raw/main/p2panda/platform-build/android.tar.gz")
set(LocalFromPath "${CMAKE_CURRENT_SOURCE_DIR}/../../../platform-build/android.tar.gz")

set(ToPath "${CMAKE_CURRENT_SOURCE_DIR}/${LibraryVersion}.tar.gz")

if(NOT EXISTS ${ToPath})
  # Check if file exists locally, otherwise download it from the internet
  if(EXISTS ${LocalArchivePath})
    file(COPY_FILE
      ${LocalFromPath}
      ${ToPath}
    )
  else()
    file(DOWNLOAD
      ${RemoteFromPath}
      ${ToPath}
      TLS_VERIFY ON
    )
  endif()
endif()

# Extract the binaries, overriding any already present.
file(REMOVE_RECURSE ${LibRoot})
file(MAKE_DIRECTORY ${LibRoot})
execute_process(
  COMMAND ${CMAKE_COMMAND} -E tar xzf ${ToPath}
  WORKING_DIRECTORY ${LibRoot}
)
