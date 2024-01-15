add_executable(test_app
    test.c
)

target_link_libraries(test_app PUBLIC munit)
target_link_libraries(test_app PUBLIC charolette)
target_include_directories(test_app PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          "${PROJECT_SOURCE_DIR}/charolette"
                          )

add_test(test test_app)

