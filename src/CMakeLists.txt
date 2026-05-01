cmake_minimum_required(VERSION 3.26)

add_executable(main main.cpp)
target_link_libraries(main PRIVATE jsonlib)

add_executable(test1 test1.cpp)
target_link_libraries(test1 PRIVATE matlib)

add_subdirectory(http-server)
add_subdirectory(path-tracer)
add_subdirectory(bvh-builder)
