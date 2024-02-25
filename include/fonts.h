#ifndef FONTS_H
#define FONTS_H

#include "pd_api.h"
#include <stdlib.h>

/**
 * An enumeration representing the different font styles the game can offer.
 */
typedef enum fstyle { BOLD } fstyle;

/**
 * A structure that contains information about a font.
 */
typedef struct fontset {
    /**
     * The Playdate LCD font that can be rendered to the screen.
     *
     * Typically, this is used with `pd->graphics->loadFont` to load
     * the font as the current one.
     */
    LCDFont *font;

    /**
     * The height of the font in pixels.
     */
    int size;
} fontset;

/**
 * Retrieves a font set based on specified style parameters.
 *
 * @param style     The font style to get the font set of.
 * @param pd        The Playdate API object used to retrieve fonts.
 * @return          The font set for the specified style.
 */
fontset styledFont(fstyle style, PlaydateAPI *pd);

#endif