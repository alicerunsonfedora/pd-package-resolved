#include "vector.h"
#include <stdio.h>
#include <stdlib.h>

vec2f getTranslatedMovement(vec2f original, float crankAngle, vec2f bounds) {
    // TODO: Correctly calculate the delta here!
    float delta = original.x - crankAngle;
    struct vec2f newVector = {crankAngle, original.y};
    if (newVector.x > bounds.x)
        newVector.x = 0.0f;
    if (newVector.y > bounds.y)
        newVector.y = 0.0f;
    return newVector;
}