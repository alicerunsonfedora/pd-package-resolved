#include "palette.h"
#include "boxes.h"
#include "images.h"
#include "pd_api.h"
#include "screen.h"
#include "vector.h"

#include <math.h>
#include <stdlib.h>

const vec2i paletteSize = {32, 32};

palette createPalette(vec2f position, LCDBitmap *image, PlaydateAPI *pd) {
    LCDSprite *sprite = imagedSprite(pd, paletteSize, image);
    palette generated = {sprite, position};
    return generated;
}

void fillPalettes(palette palettes[], int quantity, ScreenData screen, LCDBitmap *image,
                  PlaydateAPI *pd) {
    for (int i = 0; i < quantity; i++) {
        float xpos = (float)rand() / (float)(RAND_MAX / (screen.bounds.x));
        float ypos = (float)rand() / (float)(RAND_MAX / (screen.bounds.y));
        if (ypos <= 64)
            ypos = ypos + 64;
        vec2f originalPosition = {xpos, ypos};
        vec2f position = fenceInside(originalPosition, screen);

        palette current = createPalette(position, image, pd);
        pd->sprite->setCollisionsEnabled(current.sprite, 1);

        PDRect collider = {0, 8, paletteSize.x, paletteSize.y - 8};
        pd->sprite->setCollideRect(current.sprite, collider);

        palettes[i] = current;
    }
}

palette shiftPalette(palette current, LCDBitmap *image, PlaydateAPI *pd) {
    vec2f transformed = current.position;
    transformed.y--;

    pd->sprite->setImage(current.sprite, image, kBitmapUnflipped);
    pd->sprite->moveTo(current.sprite, current.position.x, current.position.y);
    pd->sprite->markDirty(current.sprite);

    palette updated = {current.sprite, transformed};
    return updated;
}