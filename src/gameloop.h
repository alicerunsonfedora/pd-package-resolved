#ifndef GAMELOOP_H
#define GAMELOOP_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "boxes.h"
#include "images.h"
#include "pd_api.h"
#include "vector.h"

/**
 * Renders a box onto the screen.
 *
 * @param index           The index of the box in the boxes array.
 * @param boxes           An array of boxes that contain their positions.
 * @param boxframe        The current box frame count.
 * @param boxOnFrame      The image representing the active frame.
 * @param boxOffFrame     The image representing the inactive frame.
 * @param pd              The Playdate API object that will render graphics to the screen.
 */
void drawBox(int index, vec2f boxes[], int boxframe, LCDBitmap *boxOnFrame,
             LCDBitmap *boxOffFrame, PlaydateAPI *pd);

/**
 * Loads the player image table into memory, setting the current sprite frame
 * in the process.
 *
 * @param pd              The Playdate API object that will retrieve the image table.
 * @param table           A reference to the image table to load the player images into.
 * @param current         A reference to the player's image to load the current frame
 *                        into.
 * @return                0, if the operation succeeds. 1 otherwise.
 */
int loadPlayerTable(PlaydateAPI *pd, LCDBitmapTable **table, LCDBitmap **current);

/**
 * Loads the box image table into memory, setting the active and inactive frames
 * in the process.
 *
 * @param pd              The Playdate API object what will retrieve the image table.
 * @param table           A reference to the image table to load the box images into.
 * @param on              A reference to the active frame image to load into.
 * @param off             A reference to the inactive frame image to load into.
 * @return                0 if the operation succeeds, 1 otherwise.
 */
int loadBoxTable(PlaydateAPI *pd, LCDBitmapTable **table, LCDBitmap **on,
                 LCDBitmap **off);

/**
 * Updates the frame counter by one tick cycle.
 *
 * @param frame           A reference to the current frame.
 * @param updated         A reference to whether the frame was updated.
 */
void cycleFrames(int *frame, bool *updated);

#endif