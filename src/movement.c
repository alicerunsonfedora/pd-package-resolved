#include "vector.h"
#include <stdlib.h>

#define SCREEN_WIDTH 400.0f
#define SCREEN_HEIGHT 240.0f

struct vec2f get_translated_movement(struct vec2f original, float crankAngle) {
    struct vec2f newVector = {crankAngle, original.y};
    if (newVector.x > SCREEN_WIDTH)
        newVector.x = 0.0f;
    return newVector;
}