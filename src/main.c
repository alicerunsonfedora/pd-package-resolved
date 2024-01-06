#include <stdio.h>
#include <stdlib.h>

#include "pd_api.h"

static int update(void * userdata);

// MARK: Font Setup
const char* fontpath = "/System/Fonts/Asheville-Sans-14-Bold.pft";
LCDFont* font = NULL;

#ifdef _WINDLL
__declspec(dllexport)
#endif

// MARK: Event Handler

int eventHandler(PlaydateAPI* pd, PDSystemEvent event, uint32_t arg)
{
    if (event == kEventInit)
    {
        const char* err;
        font = pd->graphics->loadFont(fontpath, &err);
        
        if (font == NULL)
        {
            pd->system->error("Failed to load system font! %s", err);
        }
        
        pd->system->setUpdateCallback(update, pd);
    }
    
    return 0;
}

// MARK: Update Loop

int drawn = 0;

static int update(void* userdata)
{
    if (drawn > 0)
        return 0;
    
    PlaydateAPI* pd = userdata;
    pd->graphics->clear(kColorWhite);
    pd->graphics->setFont(font);
    pd->graphics->drawText("Hello, world!", strlen("Hello, world!"), kASCIIEncoding, 200, 50);
    
    drawn = 1;
    return 1; // Always update the display.
}