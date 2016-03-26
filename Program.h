#ifndef SHADER_H
#define SHADER_H

#include <GL/glew.h>

typedef struct
{
	GLuint raw;
	GLuint vertex_shader;
	GLuint fragment_shader;

} Program;

Program Program_create(const char* vertex_path, const char* fragment_path);
void Program_destroy(Program* self);

#endif
