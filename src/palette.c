#include "palette.h"
#include "boxes.h"
#include "images.h"
#include "pd_api.h"
#include "pd_api/pd_api_sprite.h"
#include "vector.h"

#include <math.h>
#include <stdlib.h>

const vec2i paletteSize = {32, 32};

palette createPalette(vec2f position, LCDBitmap *image, PlaydateAPI *pd) {
    LCDSprite *sprite = imagedSprite(pd, paletteSize, image);
    palette generated = {sprite, position};
    return generated;
}

void fillPalettes(palette palettes[], int quantity, vec2f bounds, inset insets,
                  LCDBitmap *image, PlaydateAPI *pd) {
    for (int i = 0; i < quantity; i++) {
        float xpos = (float)rand() / (float)(RAND_MAX / (bounds.x - insets.right));
        if (xpos < insets.left)
            xpos = insets.left;
        float ypos = (float)rand() / (float)(RAND_MAX / (bounds.y - insets.bottom));
        if (xpos < insets.top)
            xpos = insets.top;
        vec2f position = {xpos, ypos};

        palette current = createPalette(position, image, pd);
        pd->sprite->setCollisionsEnabled(current.sprite, 1);

        PDRect collider = {0, 8, paletteSize.x, paletteSize.y - 8};
        pd->sprite->setCollideRect(current.sprite, collider);

        palettes[i] = current;
    }
}