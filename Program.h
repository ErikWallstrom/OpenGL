#import "Base.h"
#import "String.h"
#include <SDL2/SDL.h>
#include <GL/glew.h>

@interface Program : Base
{
	SDL_Event event;
	SDL_Window* window;
	SDL_GLContext context;

	GLuint shader_program;
	GLuint vertex_shader;
	GLuint fragment_shader;
}

-(void) create_window: (String*)title 
					w:(int)width 
					h:(int)height;
-(SDL_Window*) get_window;
-(void) load_shaders: (String*)v_path 
				   f: (String*)f_path;
-(int) update;
@end
