#include "pd_api.h"
#include "vector.h"

#ifndef IMAGES_H
#define IMAGES_H

LCDBitmap *loadBitmap(const char *path, PlaydateAPI *pd);
LCDBitmapTable *loadTable(const char *path, PlaydateAPI *pd);

LCDSprite *imagedSprite(PlaydateAPI *pd, vec2i size, LCDBitmap *image);

#endif