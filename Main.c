#include <stdio.h>
#include <stdbool.h>

#include <GL/glew.h>
#include <SDL2/SDL.h>

#include "Mesh.h"
#include "Error.h"
#include "Window.h"
#include "Program.h"
#include "Vector3f.h"

#define ATTRIBUTE_SIZE 8

int main(void)
{
	if(SDL_Init(SDL_INIT_VIDEO))
		Error(SDL_GetError());

	SDL_GL_SetAttribute(SDL_GL_RED_SIZE, ATTRIBUTE_SIZE);
	SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, ATTRIBUTE_SIZE);
	SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, ATTRIBUTE_SIZE);
	SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, ATTRIBUTE_SIZE);
	SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE, ATTRIBUTE_SIZE * 4);

	Window window = {
		.raw = SDL_CreateWindow(
			"Test Window",
			SDL_WINDOWPOS_CENTERED,
			SDL_WINDOWPOS_CENTERED,
			800, 600, SDL_WINDOW_OPENGL),
		.context = SDL_GL_CreateContext(
			window.raw)
	};

	if(!window.raw)
		Error(SDL_GetError());

	if(!window.context)
		Error(SDL_GetError());

	SDL_GL_SetSwapInterval(1);
	glewExperimental = GL_TRUE; //Force modern OpenGL functions
	if(glewInit())
		Error("GLEW Failed to initialize");

	Program program = Program_create("Vertex.glsl", "Fragment.glsl");
	Vector3f vectors[] = {
		{-1.0f, -1.0f, 0.0f},
		{-1.0f, 1.0f, 0.0f},
		{0.0f, -1.0f, 0.0f}
	};

	Vector3f triangle[] = {
		{0.0f, 1.0f, 0.0f},
		{1.0f, 0.5f, 0.0f},
		{0.0f, 0.0, 0.0f}
	};

	Mesh mesh = Mesh_create(vectors, sizeof(vectors) / sizeof(vectors[0]));
	Mesh mesh2 = Mesh_create(triangle, sizeof(triangle) / sizeof(triangle[0]));

	bool b = false;
	SDL_Event event;
	bool running = true;
	while(running)
	{
		if(b)
		{
			glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
			b = false;
		}
		else
		{
			glClearColor(0.0f, 0.0f, 1.0f, 1.0f);
			b = true;
		}
		glClear(GL_COLOR_BUFFER_BIT);
		
		while(SDL_PollEvent(&event))
			if(event.type == SDL_QUIT)
				running = false;
		
		glUseProgram(program.raw);
		glEnableVertexAttribArray(0);
		glBindBuffer(GL_ARRAY_BUFFER, mesh.buffer_object);
		glVertexAttribPointer(
			0,
			3,
			GL_FLOAT,
			GL_FALSE,
			0,
			NULL
		);
		glDrawArrays(GL_TRIANGLES, 0, 3);
		glBindBuffer(GL_ARRAY_BUFFER, mesh2.buffer_object);
		glVertexAttribPointer(
			0,
			3,
			GL_FLOAT,
			GL_FALSE,
			0,
			NULL
		);
		glDrawArrays(GL_TRIANGLES, 0, 3);

		glDisableVertexAttribArray(0);
		SDL_GL_SwapWindow(window.raw);

		static Uint32 prev_time = 0;
		static size_t frames = 0;
		if(SDL_GetTicks() / 1000 > prev_time)
		{
			printf("FPS: %zu\n", frames);
			prev_time++;
			frames = 0;
		}
	
		triangle[0].y -= 0.001;
		frames++;
	}
	
	SDL_GL_DeleteContext(window.context);
	SDL_DestroyWindow(window.raw);
	SDL_Quit();
}
