#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "vector.h"

float vec2f_distance(vec2f a, vec2f b) {
    float squaredx = powf(b.x - a.x, 2);
    float squaredy = powf(b.y - a.y, 2);
    return sqrtf(squaredx + squaredy);
}

vec2f vec2f_add(vec2f lhs, vec2f rhs) {
    vec2f new = lhs;
    new.x = new.x + rhs.x;
    new.y = new.y + rhs.y;
    return new;
}

vec2f vec2f_sub(vec2f lhs, vec2f rhs) {
    vec2f new = rhs;
    new.x = new.x - lhs.x;
    new.y = new.y - lhs.x;
    return new;
}
