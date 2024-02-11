#include "fonts.h"
#include "pd_api.h"
#include <stdlib.h>

const char *sBoldPath = "Fonts/Salmon-Sans-9-Bold-18.pft";
const char *sBoldFallback = "/System/Fonts/Asheville-Sans-14-Bold.pft";

LCDFont *boldStyledFont(PlaydateAPI *pd) {
    LCDFont *font;
    const char *err;
    font = pd->graphics->loadFont(sBoldPath, &err);
    if (font == NULL) {
        font = pd->graphics->loadFont(sBoldFallback, &err);
    }

    if (font == NULL) {
        pd->system->error("Failed to load system font! %s", err);
    }
    return font;
}

fontset styledFont(fstyle style, PlaydateAPI *pd) {
    int fontSize = 0;
    LCDFont *font;
    switch (style) {
    case BOLD:
        font = boldStyledFont(pd);
        break;
    }
    fontSize = pd->graphics->getFontHeight(font);

    fontset set = {font, fontSize};
    return set;
}