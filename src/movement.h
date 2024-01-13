#include "vector.h"

#ifndef MOVEMENT_H
#define MOVEMENT_H

// Translates a movement vector according to the crank's position angle.
// - Parameter original: The original movement vector to translate.
// - Parameter crankAngle: The current angle the crank is at, if the crank is
//   engaged.
// - Returns: A translated vector accounting for the crank's angle.
struct vec2f get_translated_movement(struct vec2f original, float crankAngle);

#endif