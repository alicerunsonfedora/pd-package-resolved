#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "boxes.h"
#include "fonts.h"
#include "gameloop.h"
#include "images.h"
#include "movement.h"
#include "palette.h"
#include "pd_api.h"
#include "player.h"
#include "text.h"
#include "vector.h"

#include "kdl/common.h"
#include "kdl/kdl.h"

static int update(void *userdata);

// MARK: Font Setup
LCDFont *font = NULL;
int fontSize;

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
        fontset styled = styledFont(BOLD, pd);
        font = styled.font;
        fontSize = styled.size;
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
#define PALETTE_COUNT 2
#define X_INSET 32

const inset walls = {CHARLIE_HEIGHT + 8, X_INSET, X_INSET, 32};

int frame = 0;
int boxframe = 0;
bool frameUpdated = false;
bool initializedGameLoop = false;

player currentPlayer = {NULL, NULL, {0.0f, 24.0f}, {CHARLIE_WIDTH, CHARLIE_HEIGHT}};
vec2f screenBounds = {0.0f, 0.0f};
LCDBitmapTable *table;
LCDBitmapTable *boxTable;

LCDBitmap *boxOnFrame;
LCDBitmap *boxOffFrame;

LCDBitmap *paletteImage;

palette palettes[PALETTE_COUNT];

vec2f boxes[BOXES_COUNT];
int boxesCollected = 0;
char *counterMessage;

int timeRemaning = 60;

static int setup(PlaydateAPI *pd) {
    screenBounds.x = (float)pd->display->getWidth();
    screenBounds.y = (float)pd->display->getHeight();

    pd->graphics->clear(kColorWhite);
    pd->graphics->setFont(font);

    const vec2f playerPos = {0.0f, 24.0f};
    const vec2i playerSize = {CHARLIE_WIDTH, CHARLIE_HEIGHT};
    currentPlayer = createPlayer(playerPos, playerSize, pd, &table);
    if (currentPlayer.sprite == NULL)
        return 0;

    currentPlayer.position.x = screenBounds.x / 2;
    movePlayer(currentPlayer, currentPlayer.position, pd);
    pd->sprite->updateAndDrawSprites();

    // Palette setup
    paletteImage = loadBitmap("Images/palette", pd);
    if (paletteImage == NULL) {
        pd->system->error("Couldn't load palette image.");
        return 0;
    }
    fillPalettes(palettes, 2, screenBounds, walls, paletteImage, pd);

    // Box setup
    int ret = loadBoxTable(pd, &boxTable, &boxOnFrame, &boxOffFrame);
    if (ret != 0)
        return 0;

    fillBoxes(boxes, 6, screenBounds, walls);
    counterMessage = "Boxes collected: 0";

    pd->system->resetElapsedTime();
    return 1;
}

static int update(void *userdata) {
    PlaydateAPI *pd = userdata;

    // Initial setup.
    if (!initializedGameLoop) {
        int drawForSetup = setup(pd);
        initializedGameLoop = true;
        return drawForSetup;
    }

    if (timeRemaning <= 0)
        return 0;

    // Draw to screen
    updatePlayer(&currentPlayer, pd, &table, frame);
    for (int i = 0; i < PALETTE_COUNT; i++) {
        palette current = palettes[i];
        pd->sprite->setImage(current.sprite, paletteImage, kBitmapUnflipped);
        pd->sprite->moveTo(current.sprite, current.position.x, current.position.y);
        pd->sprite->markDirty(current.sprite);

        // TODO: Add collision detection code here!
    }

    pd->sprite->updateAndDrawSprites();

    // Boxes
    int currentBoxesCollectedInFrame = boxesCollected;
    boxframe = (frame > 2) ? 1 : 0;
    for (int i = 0; i < BOXES_COUNT; i++) {
        drawBox(i, boxes, boxframe, boxOnFrame, boxOffFrame, pd);
        boxes[i] =
            shiftBox(boxes[i], -CHARLIE_HEIGHT, i, screenBounds, BOXES_COUNT, walls);

        float distanceToPlayer = vec2fDistance(currentPlayer.position, boxes[i]);
        if (distanceToPlayer < 32) {
            boxes[i].x = -CHARLIE_HEIGHT;
            boxesCollected++;
        }
    }

    if (boxesCollected > currentBoxesCollectedInFrame)
        pd->system->formatString(&counterMessage, "Boxes collected: %i", boxesCollected);

    const vec2i boxTextPosition = {8, (int)screenBounds.y - fontSize - 8};
    drawASCIIText(pd, counterMessage, boxTextPosition);

    // Actions
    int timeSinceReset = (int)pd->system->getElapsedTime();
    timeRemaning = 60 - timeSinceReset;

    char *timerMessage;
    pd->system->formatString(&timerMessage, "%i", timeRemaning);

    const vec2i timerPosition = {(int)screenBounds.x - fontSize - 12,
                                 (int)screenBounds.y - fontSize - 8};
    drawASCIIText(pd, timerMessage, timerPosition);

    cycleFrames(&frame, &frameUpdated);
    float crankPosition = pd->system->getCrankAngle();
    if (!pd->system->isCrankDocked())
        currentPlayer.position =
            getTranslatedMovement(currentPlayer.position, crankPosition, screenBounds);
    return 1; // Always update the display.
}