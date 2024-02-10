#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "boxes.h"
#include "images.h"
#include "pd_api.h"
#include "pd_api/pd_api_gfx.h"
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

int loadPlayerTable(PlaydateAPI *pd, LCDBitmapTable **table, LCDBitmap **current) {
    const char *spritesheet = "Images/charlie";
    LCDBitmapTable *tableStruct = loadTable(spritesheet, pd);
    if (table == NULL) {
        pd->system->error("The table for path %s is missing.", spritesheet);
        return 1;
    }
    *table = tableStruct;
    *current = pd->graphics->getTableBitmap(tableStruct, 0);
    if (current == NULL) {
        pd->system->error("The frame for this table couldn't be loaded.");
        return 1;
    }
    return 0;
}

int loadBoxTable(PlaydateAPI *pd, LCDBitmapTable **table, LCDBitmap **on,
                 LCDBitmap **off) {
    const char *boxsheet = "Images/box";
    LCDBitmapTable *tableStruct = loadTable(boxsheet, pd);
    if (table == NULL) {
        pd->system->error("The table for path %s is missing.", boxsheet);
        return 1;
    }
    *table = tableStruct;
    *on = pd->graphics->getTableBitmap(tableStruct, 0);
    *off = pd->graphics->getTableBitmap(tableStruct, 1);
    return 0;
}

void cycleFrames(int *frame, bool *updated) {
    if (*updated == true) {
        *updated = false;
        return;
    }
    int newFrame = *frame;
    newFrame++;
    if (newFrame > 5)
        newFrame = 0;
    *frame = newFrame;
    *updated = true;
}