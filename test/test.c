#include "movement.h"
#include "munit.h"
#include "vector.h"

static MunitResult test_vector(const MunitParameter params[], void *data) {
    vec2i vector = {0, 0};
    munit_assert(vector.x == 0);
    munit_assert(vector.y == 0);
    return MUNIT_OK;
}

static MunitResult test_movement(const MunitParameter params[], void *data) {
    vec2f bounds = {400.0f, 240.0f};
    vec2f originalPosition = {15.0f, 0.0f};
    vec2f translated = get_translated_movement(originalPosition, 15.69, bounds);

    munit_assert_float(translated.x, ==, 15.69);
    return MUNIT_OK;
}

static MunitTest test_suite_tests[] = {
    {
        (char *)"/charolette/vector_init", test_vector,
        NULL, // setup
        NULL, // teardown
        MUNIT_TEST_OPTION_NONE,
        NULL // params
    },

    {(char *)"/charolette/get_translated_movement", test_movement, NULL, NULL,
     MUNIT_TEST_OPTION_NONE, NULL},

    // Null test to end the array
    {NULL, NULL, NULL, NULL, MUNIT_TEST_OPTION_NONE, NULL}};

static const MunitSuite test_suite = {(char *)"/tests", test_suite_tests, NULL,
                                      MUNIT_SUITE_OPTION_NONE};

#include <stdlib.h>

int main(int argc, char *argv[MUNIT_ARRAY_PARAM(argc + 1)]) {
    return munit_suite_main(&test_suite, (void *)"µnit", argc, argv);
}