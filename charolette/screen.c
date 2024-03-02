#include "screen.h"

vec2f fenceInside(vec2f position, ScreenData screen) {
    vec2f fenced = position;
    // left
    if (fenced.x < screen.edgeInsets.left)
        fenced.x = screen.edgeInsets.left;

    // right
    if (fenced.x > screen.bounds.x - screen.edgeInsets.right)
        fenced.x = screen.bounds.x - screen.edgeInsets.right;

    // top
    if (fenced.y < screen.edgeInsets.top)
        fenced.y = screen.edgeInsets.top;

    // bottom
    if (fenced.y > screen.bounds.y - screen.edgeInsets.bottom)
        fenced.y = screen.bounds.y - screen.edgeInsets.bottom;
    return fenced;
}