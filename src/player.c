#include <stdlib.h>

#include "gameloop.h"
#include "images.h"
#include "pd_api.h"
#include "player.h"
#include "vector.h"

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