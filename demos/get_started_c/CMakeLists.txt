# Minimum cmake version required by atSDK is 3.24
cmake_minimum_required(VERSION 3.24)

# Setup your cmake project - "my_project" is the name of the project
project(my_project)

# Some additional CMake modules we need
include(FetchContent)
include(GNUInstallDirs)

# Download the atSDK
FetchContent_Declare(
  atsdk
  GIT_REPOSITORY https://github.com/atsign-foundation/at_c.git
  GIT_TAG
    trunk #TODO: it is recommended that you pin this to a particular version
)
# Install the atSDK
FetchContent_MakeAvailable(atsdk)
install(TARGETS atclient atchops atlogger)

set(programs)
foreach(program ${programs})
  add_executable(${program} ${CMAKE_CURRENT_LIST_DIR}/${program}.c)
  target_link_libraries(${program} PRIVATE atsdk::atclient)
endforeach()
