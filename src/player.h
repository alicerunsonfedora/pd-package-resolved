#ifndef PLAYER_H
#define PLAYER_H

#include "pd_api.h"
#include "vector.h"

/**
 * A structure representing the main player in the game.
 */
typedef struct player {
    /**
     * The player's sprite used in the Playdate API to calculate collisions and draw
     * its frames to the screen.
     */
    LCDSprite *sprite;

    /**
     * The player's image that is rendered on the Playdate screen through the sprite
     * object.
     */
    LCDBitmap *frame;

    /**
     * The player's position on the screen.
     */
    vec2f position;

    /**
     * The player's dimensions in pixels or units on the screen.
     */
    vec2i size;

    /**
     * The player's collision rectangle.
     */
    PDRect collisionRect;
} player;

/**
 * Creates a player at a given position in space with a specified size.
 *
 * @param position  The initial position that the player should be located at.
 * @param size      The player's sprite size.
 * @param pd        The Playdate API object that will load the player frame data and
 *                  create sprites.
 * @param table     The image table reference to load the player frames into.
 * @return          A new player object at the specified position and size. If the
 *                  Playdate API is unable to load the frame data, both the sprite and
 *                  frame properties will be NULL.
 */
player createPlayer(vec2f position, vec2i size, PlaydateAPI *pd, LCDBitmapTable **table);

#endif