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
#endif