#include "vector.h"
#include <stdlib.h>
#include <stdio.h>

vec2f get_translated_movement(vec2f original, float crankAngle, vec2f bounds) {
    // TODO: Correctly calculate the delta here!
    float delta = original.x - crankAngle;
    struct vec2f newVector = {crankAngle, original.y};
    if (newVector.x > bounds.x)
        newVector.x = 0.0f;
    if (newVector.y > bounds.y)
        newVector.y = 0.0f;
    return newVector;
}