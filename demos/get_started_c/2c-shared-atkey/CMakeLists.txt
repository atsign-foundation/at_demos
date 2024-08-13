cmake_minimum_required(VERSION 3.24)

project(2c-shared-atkey)

include(FetchContent)

FetchContent_Declare(
  atsdk
  URL https://github.com/atsign-foundation/at_c/archive/refs/tags/v0.1.0.tar.gz
  URL_HASH SHA256=7ca4215a473037ca07bef362b852291b0a1cf4e975d24d373d58ae9c1df832bc
)
FetchContent_MakeAvailable(atsdk)

add_executable(main ${CMAKE_CURRENT_LIST_DIR}/main.c)

target_link_libraries(main PRIVATE atclient)
