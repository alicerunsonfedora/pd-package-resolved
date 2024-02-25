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
        float xpos = (float)rand() /
                     (float)(RAND_MAX / (screen.bounds.x - screen.edgeInsets.right));
        if (xpos < screen.edgeInsets.left)
            xpos = screen.edgeInsets.left;
        float ypos = (float)rand() /
                     (float)(RAND_MAX / (screen.bounds.y - screen.edgeInsets.bottom));
        if (xpos < screen.edgeInsets.top)
            xpos = screen.edgeInsets.top;
        vec2f position = {xpos, ypos};

        palette current = createPalette(position, image, pd);
        pd->sprite->setCollisionsEnabled(current.sprite, 1);

        PDRect collider = {0, 8, paletteSize.x, paletteSize.y - 8};
        pd->sprite->setCollideRect(current.sprite, collider);

        palettes[i] = current;
    }
}