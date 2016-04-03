#import "Program.h"
#import "Error.h"
#import <assert.h>
#import <SDL2/SDL_image.h>

#define ATTRIBUTE_SIZE 8
#define POSITION_INDEX 0

@implementation Program
+(id) new
{
	if(SDL_Init(SDL_INIT_VIDEO))
		[Error show:[@"" format:@"%s", SDL_GetError()]];
	
	if(!IMG_Init(IMG_INIT_PNG))
		[Error show:[@"" format:@"%s", IMG_GetError()]];

	SDL_GL_SetAttribute(SDL_GL_RED_SIZE, ATTRIBUTE_SIZE);
	SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, ATTRIBUTE_SIZE);
	SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, ATTRIBUTE_SIZE);
	SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, ATTRIBUTE_SIZE);
	SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE, ATTRIBUTE_SIZE * 4);

	if(SDL_GL_SetSwapInterval(-1))
		SDL_GL_SetSwapInterval(1);

	return [super new];
}

-(void) delete
{
	if(shader_program)
	{
		glDeleteShader(vertex_shader);
		glDeleteShader(fragment_shader);
		glDeleteProgram(shader_program);
	}
	if(context)
		SDL_GL_DeleteContext(context);
	if(window)
		SDL_DestroyWindow(window);
	SDL_Quit();
	[super delete];
}

-(void) create_window: (String*)title 
					w:(int)width 
					h:(int)height
{
	assert(title);
	window = SDL_CreateWindow(
		[title get], 
		SDL_WINDOWPOS_CENTERED, 
		SDL_WINDOWPOS_CENTERED, 
		width, height,
		SDL_WINDOW_OPENGL);
	if(!window)
		[Error show:[@"" format:@"%s", SDL_GetError()]];

	context = SDL_GL_CreateContext(
		window);
	if(!context)
		[Error show:[@"" format:@"%s", SDL_GetError()]];

	glewExperimental = GL_TRUE;
	if(glewInit())
		[Error show:@"GLEW failed to initialize"];
}

-(SDL_Window*) get_window
{
	return window;
}

-(void) load_shaders: (String*)v_path 
				   f: (String*)f_path
{
	assert(v_path && f_path);
	shader_program = glCreateProgram();
	if(!shader_program)
		[Error show:@"Unable to create shader program"];
	vertex_shader = glCreateShader(GL_VERTEX_SHADER);
	if(!vertex_shader)
		[Error show:@"Unable to create vertex shader"];
	fragment_shader = glCreateShader(GL_FRAGMENT_SHADER);
	if(!fragment_shader)
		[Error show:@"Unable to create fragment shader"];

	//Load vertex
	FILE* file = fopen([v_path get], "r");
	if(!file)
		[Error show:[@"" format:@"Unable to open \"%s\"", [v_path get]]];
	fseek(file, 0, SEEK_END);
	long v_buffer_size = ftell(file);
	fseek(file, 0, SEEK_SET);
	char v_buffer[v_buffer_size];
	fread(v_buffer, 1, (size_t)v_buffer_size, file);
	fclose(file);

	//Load fragment
	file = fopen([f_path get], "r");
	if(!file)
		[Error show:[@"" format:@"Unable to open \"%s\"", [v_path get]]];
	fseek(file, 0, SEEK_END);
	long f_buffer_size = ftell(file);
	fseek(file, 0, SEEK_SET);
	char f_buffer[f_buffer_size];
	fread(f_buffer, 1, (size_t)f_buffer_size, file);
	fclose(file);

	//Compile vertex
	glShaderSource(
		vertex_shader, 1, 
		(const char*[]){v_buffer}, 
		(int[]){(int)v_buffer_size});
	glCompileShader(vertex_shader);
	int log_length;
	glGetShaderiv(vertex_shader, GL_INFO_LOG_LENGTH, &log_length);
	if(log_length > 1)
	{
		char log[log_length];
		glGetShaderInfoLog(vertex_shader, log_length, NULL, log);
		[Error show:[@"" format:@"%s", log]];
	}
	int success;
	glGetShaderiv(vertex_shader, GL_COMPILE_STATUS, &success);
	if(!success)
		[Error show:@"Vertex shader did not compile"];

	//Compile fragment
	glShaderSource(
		fragment_shader, 1, 
		(const char*[]){f_buffer}, 
		(int[]){(int)f_buffer_size});
	glCompileShader(fragment_shader);
	glGetShaderiv(fragment_shader, GL_INFO_LOG_LENGTH, &log_length);
	if(log_length > 1)
	{
		char log[log_length];
		glGetShaderInfoLog(fragment_shader, log_length, NULL, log);
		[Error show:[@"" format:@"%s", log]];
	}
	glGetShaderiv(fragment_shader, GL_COMPILE_STATUS, &success);
	if(!success)
		[Error show:@"Fragment shader did not compile"];

	//Do the rest
	glAttachShader(shader_program, vertex_shader);
	glAttachShader(shader_program, fragment_shader);

	glBindAttribLocation(shader_program, POSITION_INDEX, "position");

	glLinkProgram(shader_program);
	glGetProgramiv(shader_program, GL_LINK_STATUS, &success);
	if(!success)
	{
		glGetProgramiv(shader_program, GL_INFO_LOG_LENGTH, &log_length);
		char log[log_length];

		glGetProgramInfoLog(shader_program, log_length, NULL, log);
		[Error show:[@"" format:@"%s", log]];
	}

	glValidateProgram(shader_program);
	glGetProgramiv(shader_program, GL_VALIDATE_STATUS, &success);
	if(!success)
	{
		glGetProgramiv(shader_program, GL_INFO_LOG_LENGTH, &log_length);
		char log[log_length];

		glGetProgramInfoLog(shader_program, log_length, NULL, log);
		[Error show:[@"" format:@"%s", log]];
	}
}

-(int) update
{
	while(SDL_PollEvent(&event))
		if(event.type == SDL_QUIT)
			return 0;

	glUseProgram(shader_program);
	SDL_GL_SwapWindow(window);
	return 1;
}
@end
