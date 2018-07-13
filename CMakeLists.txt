cmake_minimum_required(VERSION 3.7.2)
project( js2osc-ardour )

SET(CMAKE_CXX_STANDARD 11)

# cmake --help-module-list
# else add modules to this path:
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

# Liblo dependency
find_package(Liblo REQUIRED)
include_directories(${LIBLO_INCLUDE_DIRS})
set(LIBS ${LIBS} ${LIBLO_LIBRARIES})

find_package(BISON 3.0.4 REQUIRED)
BISON_TARGET(JoystickEventParser ${CMAKE_SOURCE_DIR}/src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)

file(GLOB_RECURSE SOURCES
    src/*.hpp
    src/*.cpp
)

add_executable( js2osc-ardour ${SOURCES} ${BISON_JoystickEventParser_OUTPUTS})
target_link_libraries( js2osc-ardour ${LIBS})

enable_testing()
add_test(NAME SimpleExitSuccess COMMAND ${CMAKE_SOURCE_DIR}/test/success.sh)
add_test(NAME SimpleExitFailure COMMAND ${CMAKE_SOURCE_DIR}/test/fail.sh)
set_tests_properties(SimpleExitFailure PROPERTIES WILL_FAIL true)
