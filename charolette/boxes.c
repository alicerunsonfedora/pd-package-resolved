#include <stdlib.h>
#include <stdio.h>
#include "vector.h"

void fill_boxes(vec2f *boxes[], int quantity, float randmax) {
    for (int i = 0; i < quantity; i++) {
        float xpos = (float)rand() / (float)RAND_MAX / randmax;
        vec2f vector = { xpos, 0.0f };
        boxes[i] = &vector;
    }
}