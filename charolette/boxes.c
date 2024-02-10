#include "boxes.h"
#include "vector.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

void fill_boxes(vec2f boxes[], int quantity, vec2f bounds, inset insets) {
    float step = bounds.y / quantity;
    for (int i = 0; i < quantity; i++) {
        float xpos = (float)rand() / (float)(RAND_MAX / (bounds.x - insets.right));
        if (xpos < insets.left)
            xpos = insets.left;
        float ypos = step * (float)i + 32;
        vec2f vector = {xpos, ypos};
        boxes[i] = vector;
    }
}

vec2f shift_box(vec2f box, float threshold, int index, vec2f bounds, int total,
                inset insets) {
    vec2f transformed = {box.x, box.y};
    float step = bounds.y / total;
    transformed.y--;

    if (transformed.y >= threshold)
        return transformed;

    transformed.x = (float)rand() / (float)(RAND_MAX / (bounds.x - insets.right));
    if (transformed.x < insets.left)
        transformed.x = insets.left;
    transformed.y = ((float)index * step) + fabsf(threshold);
    return transformed;
}