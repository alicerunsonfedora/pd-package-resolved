#ifndef FONTS_H
#define FONTS_H

#include "pd_api.h"
#include <stdlib.h>

/// An enum representing the various font styles used in the game.
typedef enum fstyle { BOLD } fstyle;

/// A struct that contains information about a styled font.
typedef struct fontset {
    /// The LCD font to be rendered to the Playdate's screen.
    LCDFont *font;

    /// The size of the font in pixels.
    int size;
} fontset;

/// Retrieves a styled font set based on a specified style.
/// - Parameter style: The style to get the font set of.
/// - Parameter pd:  The Playdate API object to retrieve the fonts with.
fontset styledFont(fstyle style, PlaydateAPI *pd);

#endif