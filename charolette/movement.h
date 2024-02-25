#include "vector.h"

#ifndef MOVEMENT_H
#define MOVEMENT_H

/**
 * Translates a movement vector according to the crank's position angle.
 *
 * @param original      The original movement vector to translate.
 * @param crankAngle    The current angle the crank is at, if the crank is engaged.
 * @param bounds        The bounds of the screen by which the position cannot translate
 *                      past.
 * @return              A translated vector accounting for the crank's angle.
 */
vec2f getTranslatedMovement(vec2f original, float crankAngle, vec2f bounds);

#endif