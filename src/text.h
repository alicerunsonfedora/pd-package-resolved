#ifndef TEXT_H
#define TEXT_H

#include "pd_api.h"
#include "vector.h"

/**
 * Draws a string onto the screen using the ASCII encoding.
 *
 * @param pd        The Playdate API object that will draw text to the screen.
 * @param text      The text to be rendered onto the screen.
 * @param position  The position that the text should be rendered ad.
 */
void drawASCIIText(PlaydateAPI *pd, const char *text, vec2i position);

#endif