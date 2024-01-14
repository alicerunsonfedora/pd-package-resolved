#include "pd_api.h"

LCDBitmap *loadBitmap(const char *path, PlaydateAPI *pd) {
    const char *error = NULL;
    LCDBitmap *bitmap = pd->graphics->loadBitmap(path, &error);
    return bitmap;
}