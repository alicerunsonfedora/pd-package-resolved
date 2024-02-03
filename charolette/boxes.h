#ifndef BOXES_H
#define BOXES_H

#include "vector.h"

/// Fills an array of boxes with random positions.
/// - Parameter boxes: The array of boxes to fill.
/// - Parameter quantity: The number of boxes to fill in the array.
/// - Parameter bounds: The maximum boundary for a given position.
void fill_boxes(vec2f boxes[], int quantity, vec2f bounds);

#endif