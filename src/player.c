#include <stdlib.h>

#include "images.h"
#include "pd_api.h"
#include "player.h"
#include "vector.h"

// MARK: - Internal Definitions

/**
 * Loads the player image table into memory, setting the current sprite frame
 * in the process.
 *
 * @param pd              The Playdate API object that will retrieve the image table.
 * @param table           A reference to the image table to load the player images into.
 * @param current         A reference to the player's image to load the current frame
 *                        into.
 * @return                0, if the operation succeeds. 1 otherwise.
 */
int loadPlayerTable(PlaydateAPI *pd, LCDBitmapTable **table, LCDBitmap **current);

// MARK: - Public Implementations

player createPlayer(vec2f position, vec2i size, PlaydateAPI *pd, LCDBitmapTable **table) {
    PDRect rect = {0, 48, size.x, 16};
    player newPlayer = {NULL, NULL, position, size, rect};
    int loadedTable = loadPlayerTable(pd, table, &newPlayer.frame);
    if (loadedTable != 0) {
        pd->system->error("Player table couldn't be loaded, this player is now empty!");
        return newPlayer;
    }

    if (newPlayer.frame != NULL && newPlayer.sprite == NULL) {
        newPlayer.sprite = imagedSprite(pd, size, newPlayer.frame);
    }

    pd->sprite->setCollisionsEnabled(newPlayer.sprite, 1);
    pd->sprite->setCollideRect(newPlayer.sprite, newPlayer.collisionRect);
    return newPlayer;
}

void movePlayer(player player, vec2f newPosition, PlaydateAPI *pd) {
    pd->sprite->moveTo(player.sprite, newPosition.x, newPosition.y);
}

void updatePlayer(player *player, PlaydateAPI *pd, LCDBitmapTable **table, int frame) {
    player->frame = pd->graphics->getTableBitmap(*table, frame);
    pd->sprite->setImage(player->sprite, player->frame, kBitmapUnflipped);
    pd->sprite->moveTo(player->sprite, player->position.x, player->position.y);
    pd->sprite->markDirty(player->sprite);
}

// MARK: - Internal Implementations

int loadPlayerTable(PlaydateAPI *pd, LCDBitmapTable **table, LCDBitmap **current) {
    const char *spritesheet = "Images/charlie";
    LCDBitmapTable *tableStruct = loadTable(spritesheet, pd);
    if (table == NULL) {
        pd->system->error("The table for path %s is missing.", spritesheet);
        return 1;
    }
    *table = tableStruct;
    *current = pd->graphics->getTableBitmap(tableStruct, 0);
    if (current == NULL) {
        pd->system->error("The frame for this table couldn't be loaded.");
        return 1;
    }
    return 0;
}