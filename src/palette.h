#ifndef PALETTE_H
#define PALETTE_H

#include "boxes.h"
#include "images.h"
#include "pd_api.h"
#include "vector.h"

typedef struct palette {
    LCDSprite *sprite;
    vec2f position;
} palette;

palette createPalette(vec2f position, LCDBitmap *image, PlaydateAPI *pd);
void fillPalettes(palette palettes[], int quantity, vec2f bounds, inset insets,
                  LCDBitmap *image, PlaydateAPI *pd);

#endif