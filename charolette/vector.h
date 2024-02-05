#ifndef VECTOR_H
#define VECTOR_H

typedef struct vec2i {
    int x;
    int y;
} vec2i;

typedef struct vec2f {
    float x;
    float y;
} vec2f;

float vec2f_distance(vec2f a, vec2f b);

vec2f vec2f_add(vec2f lhs, vec2f rhs);
vec2f vec2f_sub(vec2f lhs, vec2f rhs);

#endif
