#ifndef PALETTE_H
#define PALETTE_H

#include "boxes.h"
#include "images.h"
#include "pd_api.h"
#include "vector.h"

/**
 * A structure containing information about a palette, a type of obstacle in the game.
 */
typedef struct palette {
    /**
     * A reference to the palette's sprite, which is used to check for collisions and
     * render its image onto the Playdate's screen.
     */
    LCDSprite *sprite;

    /**
     * The position of the sprite on the Playdate's screen.
     */
    vec2f position;
} palette;

/**
 * Generates a palette with a known position and sprite image.
 *
 * @param position  The position of where the palette is located.
 * @param image     A reference to the palette's image from the Playdate API.
 * @param pd        The Playdate API object used to create the palette.
 * @return          The palette containing the sprite and its location.
 */
palette createPalette(vec2f position, LCDBitmap *image, PlaydateAPI *pd);

/**
 * Fills an array of palettes to be rendered onto the Playdate's screen and interacted
 * with.
 *
 * @param palettes  The array of palettes to fill.
 * @param quantity  The number of palettes to fill in the array. Ideally, this should be
 *                  the size of the array.
 * @param bounds    A vector representing the bounds of the screen in width and height.
 * @param insets    The insets by which positions should sit inside of, relative to the
 *                  screen's edges.
 * @param image     The palette image object that will be rendered to the Playdate's
 *                  screen.
 * @param pd        The Playdate API object used to create the sprites.
 */
void fillPalettes(palette palettes[], int quantity, vec2f bounds, inset insets,
                  LCDBitmap *image, PlaydateAPI *pd);

#endif