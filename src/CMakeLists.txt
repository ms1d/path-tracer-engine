cmake_minimum_required(VERSION 3.26)

add_executable(main main.cpp)
target_link_libraries(main PRIVATE jsonlib)

add_subdirectory(http-server)
add_subdirectory(path-tracer)
