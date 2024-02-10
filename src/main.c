#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "boxes.h"
#include "gameloop.h"
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

// - MARK: Update Loop

#define CHARLIE_WIDTH 32
#define CHARLIE_HEIGHT 64
#define BOXES_COUNT 6
#define X_INSET 32

const inset walls = {0, X_INSET, X_INSET, 0};

int frame = 0;
int boxframe = 0;
bool frameUpdated = false;
bool initializedGameLoop = false;
vec2f spritePosition = {0.0f, 24.0f};
vec2i spriteSize = {CHARLIE_WIDTH, CHARLIE_HEIGHT};
vec2f screenBounds = {0.0f, 0.0f};
LCDBitmapTable *table;
LCDBitmapTable *boxTable;

LCDBitmap *spriteImage;
LCDSprite *sprite;

LCDBitmap *boxOnFrame;
LCDBitmap *boxOffFrame;

vec2f boxes[BOXES_COUNT];
int boxesCollected = 0;
char *counterMessage;

static int update(void *userdata) {
    PlaydateAPI *pd = userdata;

    // Initial setup.
    if (!initializedGameLoop) {
        screenBounds.x = (float)pd->display->getWidth();
        screenBounds.y = (float)pd->display->getHeight();

        pd->graphics->clear(kColorWhite);
        pd->graphics->setFont(font);

        int ret = loadPlayerTable(pd, &table, &spriteImage);
        if (ret != 0)
            return 0;

        if (spriteImage != NULL && sprite == NULL) {
            sprite = imagedSprite(pd, spriteSize, spriteImage);
        }

        spritePosition.x = screenBounds.x / 2;
        pd->sprite->moveTo(sprite, spritePosition.x, spritePosition.y);
        pd->sprite->updateAndDrawSprites();

        // Box setup
        ret = loadBoxTable(pd, &boxTable, &boxOnFrame, &boxOffFrame);
        if (ret != 0)
            return 0;

        fill_boxes(boxes, 6, screenBounds, walls);
        counterMessage = "Boxes collected: 0";

        initializedGameLoop = true;
        return 1;
    }

    // Draw to screen
    updatePlayer(pd, &sprite, &table, &spriteImage, spritePosition, frame);

    // Boxes
    int currentBoxesCollectedInFrame = boxesCollected;
    boxframe = (frame > 2) ? 1 : 0;
    for (int i = 0; i < BOXES_COUNT; i++) {
        drawBox(i, boxes, boxframe, boxOnFrame, boxOffFrame, pd);
        boxes[i] =
            shift_box(boxes[i], -CHARLIE_HEIGHT, i, screenBounds, BOXES_COUNT, walls);

        float distanceToPlayer = vec2f_distance(spritePosition, boxes[i]);
        if (distanceToPlayer < 32) {
            boxes[i].x = -CHARLIE_HEIGHT;
            boxesCollected++;
        }
    }

    if (boxesCollected > currentBoxesCollectedInFrame)
        pd->system->formatString(&counterMessage, "Boxes collected: %i", boxesCollected);
    pd->graphics->drawText(counterMessage, strlen(counterMessage), kASCIIEncoding, 8,
                           screenBounds.y - 14 - 8);

    // Actions
    cycleFrames(&frame, &frameUpdated);
    float crankPosition = pd->system->getCrankAngle();
    if (!pd->system->isCrankDocked())
        spritePosition =
            get_translated_movement(spritePosition, crankPosition, screenBounds);
    return 1; // Always update the display.
}