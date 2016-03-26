#ifndef WINDOW_H
#define WINDOW_H

#include <SDL2/SDL.h>

typedef struct 
{
	SDL_Window* raw;
	SDL_GLContext context;

} Window;

#endif 
