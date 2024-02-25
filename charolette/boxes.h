#ifndef BOXES_H
#define BOXES_H

#include "vector.h"

/**
 * A structure representing insets of a rectangle.
 *
 * Typically, insets are used to provide padding for a rectangle or bounds by which
 * certain elements or vectors cannot reside in.
 */
typedef struct inset {
    /**
     * The number of pixels or units away from the rectangle's top edge.
     */
    float top;
    /**
     * The number of pixels or units away from the rectangle's left edge.
     */
    float left;
    
    /**
     * The number of pixels or units away from the rectangle's right edge.
     */
    float right;
    
    /**
     * The number of pixels or units away from the rectangle's bottom edge.
     */
    float bottom;
} inset;

/**
 * Fills an array of boxes with random positions.
 *
 * @param boxes     The array of boxes to fill.
 * @param quantity  The number of boxes to fill in the array.
 * @param bounds    The maximum boundary for a given position.
 * @param insets    The insets from the screen edges by which boxes cannot exist in.
 */
void fill_boxes(vec2f boxes[], int quantity, vec2f bounds, inset insets);

/**
 * Shifts a box towards the top of the screen, resetting its position if it reaches a
 * threshold value past the screen's top edge.
 *
 * @param box       The position of the box to shift.
 * @param threshold The threshold value for which the box must surpass to be
 *                  repositioned.
 * @param index     The index of the box in its array.
 * @param bounds    The screen's bounds represented as a vector.
 * @param total     The number of boxes that live in the array of this box.
 * @param insets    The screen edge insets.
 * @return          The new position of the box.
 */
vec2f shift_box(vec2f box, float threshold, int index, vec2f bounds, int total,
                inset insets);

#endif