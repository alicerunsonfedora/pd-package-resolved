#include "pd_api.h"
#include "vector.h"

LCDBitmap *loadBitmap(const char *path, PlaydateAPI *pd) {
    const char *error = NULL;
    LCDBitmap *bitmap = pd->graphics->loadBitmap(path, &error);
    return bitmap;
}

LCDBitmapTable *loadTable(const char *path, PlaydateAPI *pd) {
    const char *error = NULL;
    LCDBitmapTable *table = pd->graphics->loadBitmapTable(path, &error);
    return table;
}

LCDSprite *imagedSprite(PlaydateAPI *pd, vec2i size, LCDBitmap *image) {
    LCDSprite *sprite = pd->sprite->newSprite();
    pd->sprite->setSize(sprite, size.x, size.y);
    pd->sprite->setImage(sprite, image, kBitmapUnflipped);
    pd->sprite->addSprite(sprite);
    return sprite;
}