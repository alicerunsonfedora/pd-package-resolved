#ifndef GAMELOOP_H
#define GAMELOOP_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "boxes.h"
#include "images.h"
#include "pd_api.h"
#include "vector.h"

void drawBox(int index, vec2f boxes[], int boxframe, LCDBitmap *boxOnFrame,
             LCDBitmap *boxOffFrame, PlaydateAPI *pd);

int loadPlayerTable(PlaydateAPI *pd, LCDBitmapTable **table, LCDBitmap **current);
int loadBoxTable(PlaydateAPI *pd, LCDBitmapTable **table, LCDBitmap **on,
                 LCDBitmap **off);

void cycleFrames(int *frame, bool *updated);

#endif