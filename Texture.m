#import "Texture.h"
#import "Error.h"
#import <assert.h>
#import <SDL2/SDL_image.h>

@implementation Texture
+(id) new: (String*)file_path
{
	Texture* obj = [super new];
	SDL_Surface* surface = IMG_Load([file_path get]);
	if(!surface)
		[Error show:[@"" format: @"%s", IMG_GetError()]];

	glGenTextures(1, &obj->raw);
	glBindTexture(GL_TEXTURE_2D, obj->raw);

	glTexImage2D(
		GL_TEXTURE_2D, 
		0, 
		GL_RGBA, 
		surface->w,
		surface->h,
		0,
		GL_RGBA, //GL_RGB?
		GL_UNSIGNED_BYTE,
		surface->pixels);

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	SDL_FreeSurface(surface);
	return obj;
}

-(void) render: (unsigned)unit
{
	assert(unit <= 31);

	glActiveTexture(GL_TEXTURE0 + unit);
	glBindTexture(GL_TEXTURE_2D, raw);
}

-(void) delete
{
	glDeleteTextures(1, &raw);
	[super delete];
}
@end
