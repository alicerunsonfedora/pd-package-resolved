#include "munit/munit.h"
#define MUNIT_ENABLE_ASSERT_ALIASES

#define simple_test(name, method)                                                        \
    { (char *)name, method, NULL, NULL, MUNIT_TEST_OPTION_NONE, NULL }
#define test_end                                                                         \
    { NULL, NULL, NULL, NULL, MUNIT_TEST_OPTION_NONE, NULL }

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

// MARK: - Vector Tests

static MunitResult test_vector(const MunitParameter params[], void *data) {
    vec2i vector = {0, 0};
    munit_assert(vector.x == 0);
    munit_assert(vector.y == 0);
    return MUNIT_OK;
}

static MunitResult test_movement(const MunitParameter params[], void *data) {
    vec2f originalPosition = {15.0f, 0.0f};
    vec2f translated = getTranslatedMovement(originalPosition, 15.69, SCREEN_BOUNDS);

    munit_assert_true(isapprox(translated.x, 15.69, 0.001));
    return MUNIT_OK;
}

static MunitResult test_vec2f_distance(const MunitParameter params[], void *data) {
    vec2f one = {1, 0};
    vec2f zero = {0, 0};
    float distance = vec2fDistance(one, zero);
    munit_assert_float(distance, ==, 1.0);

    vec2f two = {2, 2};
    float farther = vec2fDistance(two, zero);
    munit_assert_true(isapprox(farther, sqrtf(8), 0.001));
    return MUNIT_OK;
}

static MunitResult test_vec2f_add(const MunitParameter params[], void *data) {
    vec2f one = {1, 1};
    vec2f added = vec2fAdd(one, one);
    munit_assert_float(added.x, ==, 2.0);
    munit_assert_float(added.y, ==, 2.0);
    return MUNIT_OK;
}

static MunitResult test_vec2f_sub(const MunitParameter params[], void *data) {
    vec2f two = {2, 2};
    vec2f subbed = vec2fSub(two, two);
    munit_assert_float(subbed.x, ==, 0.0);
    munit_assert_float(subbed.y, ==, 0.0);
    return MUNIT_OK;
}

// MARK: - Box Tests

static MunitResult test_box_fill(const MunitParameter params[], void *data) {
    vec2f boxes[3] = {0};
    inset insets = {0, 0, 0, 0};
    fill_boxes(boxes, 3, SCREEN_BOUNDS, insets);

    for (int i = 0; i < 3; i++) {
        munit_assert_float(boxes[i].x, <=, 400.0);
        munit_assert_float(boxes[i].x, !=, 0.0);
        munit_assert_float(boxes[i].y, ==, i * 80);
    }
    return MUNIT_OK;
}

static MunitResult test_box_fill_with_insets(const MunitParameter params[], void *data) {
    vec2f boxes[3] = {0};
    inset insets = {0, 32, 32, 0};
    fill_boxes(boxes, 3, SCREEN_BOUNDS, insets);

    for (int i = 0; i < 3; i++) {
        munit_assert_float(boxes[i].x, <=, 368.0);
        munit_assert_float(boxes[i].x, >=, 32.0);
        munit_assert_float(boxes[i].y, ==, i * 80);
    }
    return MUNIT_OK;
}

static MunitResult test_box_shift(const MunitParameter params[], void *data) {
    inset zero = {0, 0, 0, 0};
    vec2f simpleShift = {300.0f, 40.0f};
    simpleShift = shift_box(simpleShift, 32.0f, 0, SCREEN_BOUNDS, 1, zero);
    munit_assert_float(simpleShift.y, ==, 39.0f);

    vec2f newAssignment = {100.0f, -46.0f};
    simpleShift = shift_box(simpleShift, 32.0f, 0, SCREEN_BOUNDS, 1, zero);
    munit_assert_float(simpleShift.y, >, 0.0f);

    return MUNIT_OK;
}

static MunitResult test_box_shift_with_insets(const MunitParameter params[], void *data) {
    inset insets = {0, 32, 32, 0};

    vec2f simpleShift = {300.0f, 40.0f};
    simpleShift = shift_box(simpleShift, 32.0f, 0, SCREEN_BOUNDS, 1, insets);
    munit_assert_float(simpleShift.y, ==, 39.0f);

    vec2f newAssignment = {100.0f, -46.0f};
    simpleShift = shift_box(simpleShift, 32.0f, 0, SCREEN_BOUNDS, 1, insets);
    munit_assert_float(simpleShift.y, >, 0.0f);
    munit_assert_float(simpleShift.x, >=, 32.0);
    munit_assert_float(simpleShift.x, <=, 368.0);

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
    simple_test("charolette/get_translated_movement", test_movement),
    simple_test("charolette/vec2f_distance", test_vec2f_distance),
    simple_test("charolette/vec2f_add", test_vec2f_add),
    simple_test("charolette/vec2f_sub", test_vec2f_sub),
    simple_test("charolette/fill", test_box_fill),
    simple_test("charolette/fill_with_insets", test_box_fill_with_insets),
    simple_test("charolette/shift", test_box_shift),
    simple_test("charolette/shift_with_insets", test_box_shift_with_insets),

    // Null test to end the array
    test_end};

static const MunitSuite test_suite = {(char *)"/tests", test_suite_tests, NULL,
                                      MUNIT_SUITE_OPTION_NONE};

#include <stdlib.h>

int main(int argc, char *argv[MUNIT_ARRAY_PARAM(argc + 1)]) {
    return munit_suite_main(&test_suite, (void *)"µnit", argc, argv);
}
