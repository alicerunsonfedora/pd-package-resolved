#ifndef BOXES_H
#define BOXES_H

#include "screen.h"
#include "vector.h"

/**
 * Fills an array of boxes with random positions.
 *
 * @param boxes     The array of boxes to fill.
 * @param quantity  The number of boxes to fill in the array.
 * @param screen    Information about the current Playdate screen, such as the dimensions
 *                  and edge insets.
 */
void fillBoxes(vec2f boxes[], int quantity, ScreenData screen);

/**
 * Shifts a box towards the top of the screen, resetting its position if it reaches a
 * threshold value past the screen's top edge.
 *
 * @param box       The position of the box to shift.
 * @param threshold The threshold value for which the box must surpass to be
 *                  repositioned.
 * @param index     The index of the box in its array.
 * @param screen    Information about the current Playdate screen, such as the dimensions
 *                  and edge insets.
 * @param total     The number of boxes that live in the array of this box.
 * @return          The new position of the box.
 */
vec2f shiftBox(vec2f box, float threshold, int index, ScreenData screen, int total);

#endif