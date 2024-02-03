#include "vector.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

// TODO: Why are we all zero here?
void fill_boxes(vec2f boxes[], int quantity, vec2f bounds) {
    float step = bounds.y / quantity;
    for (int i = 0; i < quantity; i++) {
        float xpos = (float)rand() / (float)(RAND_MAX / bounds.x);
        float ypos = step * (float)i;
        vec2f vector = {xpos, ypos};
        boxes[i] = vector;
    }
}

vec2f shift_box(vec2f box, float threshold, int index, vec2f bounds, int total) {
    vec2f transformed = {box.x, box.y};
    float step = bounds.y / total;
    transformed.y--;
    if (transformed.y < threshold) {
        transformed.x = (float)rand() / (float)(RAND_MAX / bounds.x);
        transformed.y = ((float)index * step) + fabsf(threshold);
    }
    return transformed;
}