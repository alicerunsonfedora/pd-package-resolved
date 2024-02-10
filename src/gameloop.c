#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "boxes.h"
#include "images.h"
#include "pd_api.h"
#include "vector.h"

void drawBox(int index, vec2f boxes[], int boxframe, LCDBitmap *boxOnFrame,
             LCDBitmap *boxOffFrame, PlaydateAPI *pd) {
    vec2f box = boxes[index];
    bool even = index % 2 == 0;
    if (boxframe == 1) {
        if (even) {
            pd->graphics->drawBitmap(boxOnFrame, box.x, box.y, kBitmapUnflipped);
        } else {
            pd->graphics->drawBitmap(boxOffFrame, box.x, box.y, kBitmapUnflipped);
        }
    } else {
        if (!even) {
            pd->graphics->drawBitmap(boxOnFrame, box.x, box.y, kBitmapUnflipped);
        } else {
            pd->graphics->drawBitmap(boxOffFrame, box.x, box.y, kBitmapUnflipped);
        }
    }
}