SET(sources
    main.cpp)

SET(CMAKE_EXE_LINKER_FLAGS
    "${CMAKE_EXE_LINKER_FLAGS} -w")


add_executable( level ${sources})

target_link_libraries(level
    PUBLIC Beast::Beast ${GSE_BOOST_LIBS} client)
