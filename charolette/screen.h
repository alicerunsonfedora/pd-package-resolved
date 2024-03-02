#ifndef SCREEN_H
#define SCREEN_H

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
 * A structure representing information about the screen.
 */
typedef struct ScreenData {
    /**
     * The width and height of the screen, represented as a vector.
     */
    vec2f bounds;
    
    /**
     * The insets set from the edges of the screen's rectangle for suitable drawing.
     */
    inset edgeInsets;
} ScreenData;

/**
 * Shifts a point in space to fit within the screen's safe area.
 *
 * @param position  The position to shift into the safe area.
 * @param screen    The screen data to determine the safe area insets from.
 * @return          A translated vector that is within the safe areas of the screen.
 */
vec2f fenceInside(vec2f position, ScreenData screen);

#endif