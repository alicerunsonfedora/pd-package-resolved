#include "munit/munit.h"
#include <sys/_types/_null.h>
#define MUNIT_ENABLE_ASSERT_ALIASES

#include "boxes.h"
#include "movement.h"
#include "munit.h"
#include "vector.h"

#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

const vec2f SCREEN_BOUNDS = {400.0f, 240.f};

bool isapprox(float a, float b, float prec) {
    float val = fabsf(a - b);
    printf("\nApproxing %f and %f (diff: %f)\n", a, b, val);
    return val <= prec;
}

static MunitResult test_vector(const MunitParameter params[], void *data) {
    vec2i vector = {0, 0};
    munit_assert(vector.x == 0);
    munit_assert(vector.y == 0);
    return MUNIT_OK;
}

static MunitResult test_movement(const MunitParameter params[], void *data) {
    vec2f originalPosition = {15.0f, 0.0f};
    vec2f translated = get_translated_movement(originalPosition, 15.69, SCREEN_BOUNDS);

    munit_assert_true(isapprox(translated.x, 15.69, 0.001));
    return MUNIT_OK;
}

static MunitResult test_box_fill(const MunitParameter params[], void *data) {
    vec2f boxes[3] = {0};
    fill_boxes(boxes, 3, SCREEN_BOUNDS);

    for (int i = 0; i < 3; i++) {
        munit_assert_float(boxes[i].x, <=, 400.0);
        munit_assert_float(boxes[i].x, !=, 0.0);
        munit_assert_float(boxes[i].y, ==, i * 80);
    }
    return MUNIT_OK;
}

static MunitResult test_box_shift(const MunitParameter params[], void *data) {
    vec2f simpleShift = {300.0f, 40.0f};
    simpleShift = shift_box(simpleShift, 32.0f, 0, SCREEN_BOUNDS, 1);
    munit_assert_float(simpleShift.y, ==, 39.0f);

    vec2f newAssignment = {100.0f, -46.0f};
    simpleShift = shift_box(simpleShift, 32.0f, 0, SCREEN_BOUNDS, 1);
    munit_assert_float(simpleShift.y, >, 0.0f);

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

    {(char *)"/charolette/fill", test_box_fill, NULL, NULL, MUNIT_TEST_OPTION_NONE, NULL},
    {(char *)"/charolette/shift", test_box_shift, NULL, NULL, MUNIT_TEST_OPTION_NONE,
     NULL},

    // Null test to end the array
    {NULL, NULL, NULL, NULL, MUNIT_TEST_OPTION_NONE, NULL}};

static const MunitSuite test_suite = {(char *)"/tests", test_suite_tests, NULL,
                                      MUNIT_SUITE_OPTION_NONE};

#include <stdlib.h>

int main(int argc, char *argv[MUNIT_ARRAY_PARAM(argc + 1)]) {
    return munit_suite_main(&test_suite, (void *)"µnit", argc, argv);
}