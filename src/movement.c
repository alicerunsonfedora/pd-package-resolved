#include "vector.h"
#include <stdlib.h>

struct vec2f get_translated_movement(struct vec2f original, float crankAngle,
                                     struct vec2f bounds) {
    struct vec2f newVector = {crankAngle, original.y};
    if (newVector.x > bounds.x)
        newVector.x = 0.0f;
    if (newVector.y > bounds.y)
        newVector.y = 0.0f;
    return newVector;
}