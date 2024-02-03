#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "vector.h"

float vec2f_distance(vec2f a, vec2f b) {
    float squaredx = powf(b.x - a.x, 2);
    float squaredy = powf(b.y - a.y, 2);
    return sqrtf(squaredx + squaredy);
}