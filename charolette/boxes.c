#include "vector.h"
#include <stdio.h>
#include <stdlib.h>

// TODO: Why are we all zero here?
void fill_boxes(vec2f *boxes[], int quantity, vec2f bounds) {
    float step = bounds.y / quantity;
    for (int i = 0; i < quantity; i++) {
        float xpos = (float)rand() / (float)(RAND_MAX / bounds.x);
        vec2f vector = {xpos, step * (float)i};
        boxes[i] = &vector;
    }
}