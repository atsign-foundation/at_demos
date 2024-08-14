cmake_minimum_required(VERSION 3.24)

project(5a-hooks)

include(FetchContent)

FetchContent_Declare(
  atclient
  URL https://github.com/atsign-foundation/at_c/releases/download/v0.1.0/at_c-v0.1.0.tar.gz
  URL_HASH SHA256=494a4960dedc45484a0078db4c388cd592efdebde45e40bdded5c2b9c587b146
  SOURCE_SUBDIR packages/atclient
)

FetchContent_MakeAvailable(atclient)

add_executable(main ${CMAKE_CURRENT_LIST_DIR}/main.c)

target_link_libraries(main PRIVATE atclient atlogger atchops mbedtls mbedcrypto mbedx509 cjson)
