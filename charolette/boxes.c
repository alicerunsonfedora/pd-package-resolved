#include "boxes.h"
#include "screen.h"
#include "vector.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

void fillBoxes(vec2f boxes[], int quantity, ScreenData screen) {
    float step = screen.bounds.y / quantity;
    for (int i = 0; i < quantity; i++) {
        float xpos = (float)rand() /
                     (float)(RAND_MAX / (screen.bounds.x - screen.edgeInsets.right));
        if (xpos < screen.edgeInsets.left)
            xpos = screen.edgeInsets.left;
        float ypos = step * (float)i;
        vec2f vector = {xpos, ypos};
        boxes[i] = vector;
    }
}

vec2f shiftBox(vec2f box, float threshold, int index, ScreenData screen, int total) {
    vec2f transformed = {box.x, box.y};
    float step = screen.bounds.y / total;
    transformed.y--;

    if (transformed.y >= threshold)
        return transformed;

    transformed.x =
        (float)rand() / (float)(RAND_MAX / (screen.bounds.x - screen.edgeInsets.right));
    if (transformed.x < screen.edgeInsets.left)
        transformed.x = screen.edgeInsets.left;
    transformed.y = ((float)index * step) + fabsf(threshold);
    return transformed;
}