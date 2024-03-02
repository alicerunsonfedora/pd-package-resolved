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
#include "screen.h"
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

ScreenData screen = {{0.0f, 0.0f}, {CHARLIE_HEIGHT + 8, X_INSET, X_INSET, 32}};

int frame = 0;
int boxframe = 0;
bool frameUpdated = false;
bool initializedGameLoop = false;
bool paletteGracePeriodActive = true;

player currentPlayer = {NULL, NULL, {0.0f, 24.0f}, {CHARLIE_WIDTH, CHARLIE_HEIGHT}};
LCDBitmapTable *table;

LCDBitmap *boxOnFrame;
LCDBitmap *boxOffFrame;

LCDBitmap *paletteImage;

palette palettes[PALETTE_COUNT];

vec2f boxes[BOXES_COUNT];
int boxesCollected = 0;
char *counterMessage = "Boxes collected: 0";
char *timerMessage;

int timeRemaning = 60;

static int setup(PlaydateAPI *pd) {
    screen.bounds.x = (float)pd->display->getWidth();
    screen.bounds.y = (float)pd->display->getHeight();

    pd->graphics->clear(kColorWhite);
    pd->graphics->setFont(font);

    const vec2f playerPos = {0.0f, 24.0f};
    const vec2i playerSize = {CHARLIE_WIDTH, CHARLIE_HEIGHT};
    currentPlayer = createPlayer(playerPos, playerSize, pd, &table);
    if (currentPlayer.sprite == NULL)
        return 0;

    currentPlayer.position.x = screen.bounds.x / 2;
    movePlayer(currentPlayer, currentPlayer.position, pd);
    pd->sprite->updateAndDrawSprites();

    // Palette setup
    paletteImage = loadBitmap("Images/palette", pd);
    if (paletteImage == NULL) {
        pd->system->error("Couldn't load palette image.");
        return 0;
    }

    // Box setup
    LCDBitmapTable *boxTable;
    int ret = loadBoxTable(pd, &boxTable, &boxOnFrame, &boxOffFrame);
    if (ret != 0)
        return 0;

    fillBoxes(boxes, 6, screen);
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

    if (!paletteGracePeriodActive) {
        for (int i = 0; i < PALETTE_COUNT; i++) {
            palette current = palettes[i];
            palettes[i] =
                shiftPalette(current, -CHARLIE_HEIGHT, screen, paletteImage, pd);

            int overlappingCounts;
            pd->sprite->overlappingSprites(current.sprite, &overlappingCounts);

            if (overlappingCounts <= 0)
                continue;
            timeRemaning = 0;
            return 0;
        }
    }

    pd->sprite->updateAndDrawSprites();

    // Boxes
    const int currentBoxesCollectedInFrame = boxesCollected;
    boxframe = (frame > 2) ? 1 : 0;
    for (int i = 0; i < BOXES_COUNT; i++) {
        drawBox(i, boxes, boxframe, boxOnFrame, boxOffFrame, pd);
        boxes[i] = shiftBox(boxes[i], -CHARLIE_HEIGHT, i, screen, BOXES_COUNT);

        float distanceToPlayer = vec2fDistance(currentPlayer.position, boxes[i]);
        if (distanceToPlayer < 32) {
            boxes[i].x = -CHARLIE_HEIGHT;
            boxesCollected++;
        }

        if (i < BOXES_COUNT - 1)
            continue;
        if (!paletteGracePeriodActive)
            continue;
        if (boxes[i].y >= 0)
            continue;
        fillPalettes(palettes, PALETTE_COUNT, screen, paletteImage, pd);
        paletteGracePeriodActive = false;
    }

    if (boxesCollected > currentBoxesCollectedInFrame) {
        pd->system->formatString(&counterMessage, "Boxes collected: %i", boxesCollected);
    }

    const vec2i boxTextPosition = {8, (int)screen.bounds.y - fontSize - 8};
    drawASCIIText(pd, counterMessage, boxTextPosition);

    // Actions
    const int timeSinceReset = (int)pd->system->getElapsedTime();
    const int currentTime = timeRemaning;
    timeRemaning = 60 - timeSinceReset;

    if (timeRemaning < currentTime || timerMessage == NULL)
        pd->system->formatString(&timerMessage, "%i", timeRemaning);

    const vec2i timerPosition = {(int)screen.bounds.x - fontSize - 12,
                                 (int)screen.bounds.y - fontSize - 8};
    drawASCIIText(pd, timerMessage, timerPosition);

    cycleFrames(&frame, &frameUpdated);
    const float crankPosition = pd->system->getCrankAngle();
    if (!pd->system->isCrankDocked())
        currentPlayer.position =
            getTranslatedMovement(currentPlayer.position, crankPosition, screen.bounds);
    return 1; // Always update the display.
}