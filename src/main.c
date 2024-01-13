#include <stdio.h>
#include <stdlib.h>

#include "movement.h"
#include "pd_api.h"
#include "vector.h"

static int update(void *userdata);

// MARK: Font Setup
const char *fontpath = "/System/Fonts/Asheville-Sans-14-Bold.pft";
LCDFont *font = NULL;

// clang-format off
// For Windows DLL support
#ifdef _WINDLL
__declspec(dllexport)
#endif

// MARK: Event Handler
int eventHandler(PlaydateAPI *pd, PDSystemEvent event, uint32_t arg) {
    // clang-format on
    if (event == kEventInit) {
        const char *err;
        font = pd->graphics->loadFont(fontpath, &err);

        if (font == NULL) {
            pd->system->error("Failed to load system font! %s", err);
        }

        pd->system->setUpdateCallback(update, pd);
    }

    return 0;
}

// MARK: Update Loop
struct vec2f textPosition = {0.0f, 0.0f};

static int update(void *userdata) {
    PlaydateAPI *pd = userdata;
    pd->graphics->clear(kColorWhite);
    pd->graphics->setFont(font);
    pd->graphics->drawText("@", strlen("@"), kASCIIEncoding, textPosition.x,
                           textPosition.y);

    float crankPosition = pd->system->getCrankAngle();

    if (!pd->system->isCrankDocked())
        textPosition = get_translated_movement(textPosition, crankPosition);
    return 1; // Always update the display.
}