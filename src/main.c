#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "images.h"
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
bool initializedGameLoop = false;
vec2f spritePosition = {0.0f, 24.0f};
LCDBitmap *spriteImage;
LCDSprite *sprite;

static int update(void *userdata) {
    PlaydateAPI *pd = userdata;

    vec2f screenBounds = {0.0f, 0.0f};
    screenBounds.x = (float)pd->display->getWidth();
    screenBounds.y = (float)pd->display->getHeight();

    pd->graphics->clear(kColorWhite);
    pd->graphics->setFont(font);

    const char *spritesheet = "Images/charlie";
    spriteImage = loadBitmap(spritesheet, pd);

    if (spriteImage != NULL && sprite == NULL) {
        sprite = pd->sprite->newSprite();
        pd->sprite->setSize(sprite, 32.0f, 64.0f);
        pd->sprite->setImage(sprite, spriteImage, kBitmapUnflipped);
        pd->sprite->addSprite(sprite);
    }
    
    if (!initializedGameLoop) {
        spritePosition.x = screenBounds.x / 2;
        pd->sprite->moveTo(sprite, spritePosition.x, spritePosition.y);
        pd->sprite->updateAndDrawSprites();
        initializedGameLoop = true;
        return 1;
    }

    pd->sprite->moveTo(sprite, spritePosition.x, spritePosition.y);
    pd->sprite->markDirty(sprite);
    pd->sprite->updateAndDrawSprites();

    float crankPosition = pd->system->getCrankAngle();

    if (!pd->system->isCrankDocked())
        spritePosition = get_translated_movement(spritePosition, crankPosition, screenBounds);
    return 1; // Always update the display.
}