#include "munit/munit.h"
#define MUNIT_ENABLE_ASSERT_ALIASES

#include "movement.h"
#include "munit.h"
#include "vector.h"
#include "boxes.h"

#include <stdbool.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>

bool isapprox(float a, float b, float prec) {
    float val = fabsf(a - b);
    printf(" Approxing %f and %f (diff: %f)", a, b, val);
    return val <= prec;
}

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

    munit_assert_true(isapprox(translated.x, 15.69, 0.001));
    return MUNIT_OK;
}

static MunitResult test_box_fill(const MunitParameter params[], void *data) {
    vec2f bounds = { 400.0f, 240.f };
    vec2f* boxes[] = { NULL, NULL, NULL };
    fill_boxes(boxes, 3, bounds);
    
    for (int i = 0; i < 3; i++) {
        if ( boxes[i] == NULL )
            return MUNIT_FAIL;
        munit_assert_float(boxes[i]->x, <=, 400.0);
        munit_assert_float(boxes[i]->y, ==, (240.0 / 3)* i);
    }
    
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
     
     {
         (char *)"/charolette/fill",
         test_box_fill,
         NULL,
         NULL,
         MUNIT_TEST_OPTION_NONE,
         NULL
     },

    // Null test to end the array
    {NULL, NULL, NULL, NULL, MUNIT_TEST_OPTION_NONE, NULL}};

static const MunitSuite test_suite = {(char *)"/tests", test_suite_tests, NULL,
                                      MUNIT_SUITE_OPTION_NONE};

#include <stdlib.h>

int main(int argc, char *argv[MUNIT_ARRAY_PARAM(argc + 1)]) {
    return munit_suite_main(&test_suite, (void *)"µnit", argc, argv);
}