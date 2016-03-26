#include "Error.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <SDL2/SDL.h>

void Error(const char* format, ...)
{
	va_list list_1, list_2;
	va_start(list_1, format);
	va_copy(list_2, list_1);

	int format_size = vsnprintf(NULL, 0, format, list_1);
	char buffer[format_size];
	
	vsnprintf(buffer, sizeof buffer, format,  list_2);
	va_end(list_2);
	va_end(list_1);

	SDL_ShowSimpleMessageBox(
		SDL_MESSAGEBOX_ERROR,
		"Error",
		buffer, NULL);
	exit(EXIT_FAILURE);
}
