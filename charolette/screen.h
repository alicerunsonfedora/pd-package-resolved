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

typedef struct ScreenData {
    vec2f bounds;
    inset edgeInsets;
} ScreenData;

#endif