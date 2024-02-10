#include "pd_api.h"
#include "vector.h"

void drawASCIIText(PlaydateAPI *pd, const char *text, vec2i position) {
    pd->graphics->drawText(text, strlen(text), kASCIIEncoding, position.x, position.y);
}