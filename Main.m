#import "Program.h"
#import "Texture.h"
#import "Mesh.h"

int main(void)
{
	id program = [Program new];
	[program 
		create_window: @"Game window"
		w: 800
		h: 600];
	[program 
		load_shaders:@"Vertex.glsl" 
		f:@"Fragment.glsl"];

	id mesh = [Mesh new:(Vector3f[]){
		{-1.0f, 1.0f, 0.0f},
		{-1.0f, -1.0f, 0.0f},
		{0.0f, 0.0f, 0.0f}
	} n:3];

	id texture = [Texture new:@"texture.png"];

	int ticks = 0;
	while([program update])
	{
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT);

		[texture render:0];
		[mesh render];

		static unsigned time;
		if(SDL_GetTicks() / 1000 > time)
		{
			time = SDL_GetTicks() / 1000;
			id string = [String new];
			[string format:@"FPS: %i", ticks];
			SDL_SetWindowTitle([program get_window], [string get]);

			[string delete];
			ticks = 0;
		}

		ticks++;
	}
	[program delete];
}
