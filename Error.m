#import "Error.h"
#import <SDL2/SDL.h>
#import <stdlib.h>
#import <assert.h>
#import <stdio.h>

@implementation Error
+(void) show: (String*)message
{
	assert(message);
	SDL_ShowSimpleMessageBox(
		SDL_MESSAGEBOX_ERROR,
		"Error",
		[message get], 
		NULL);
	exit(EXIT_FAILURE);
}

+(void) log: (String*)message
{
	FILE* file = fopen("log.txt", "a");
	fputs([message get], file);
	fclose(file);
}
@end
