#include "pd_api.h"
#include "vector.h"

#ifndef IMAGES_H
#define IMAGES_H

/**
 * Loads an image in the Playdate bundle at a specified path.
 *
 * @param path      The path to the image in the bundle to load.
 * @param pd        The Playdate API object that will load the image.
 * @return          The image object used to render to the screen, or NULL if the image
 *                  couldn't be found.
 */
LCDBitmap *loadBitmap(const char *path, PlaydateAPI *pd);

/**
 * Loads an image table in the Playdate bundle at a specified path.
 *
 * @param path      The path to the image table in the bundle to load.
 * @param pd        The Playdate API object that will load the table.
 * @return          The table object used to get image frames, or NULL if the table
 * couldn't be loaded.
 */
LCDBitmapTable *loadTable(const char *path, PlaydateAPI *pd);

/**
 * Creates a sprite object based on a given size and image.
 *
 * @param pd        The Playdate API object used to create the sprite.
 * @param size      The sprite's width and height.
 * @param image     The image that the sprite will display.
 * @return          The sprite object from the image, or NULL if the sprite couldn't be
 *                  created.
 */
LCDSprite *imagedSprite(PlaydateAPI *pd, vec2i size, LCDBitmap *image);

#endif