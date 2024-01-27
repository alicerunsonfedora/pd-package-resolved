#ifndef BOXES_H
#define BOXES_H

#include "vector.h"

/// Fills an array of boxes with random positions.
/// - Parameter boxes: The array of boxes to fill.
/// - Parameter quantity: The number of boxes to fill in the array.
/// - Parameter randmax: The maximum position on the X axis possible.
void fill_boxes(vec2f *boxes[], int quantity, float randmax);

#endif