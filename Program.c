#include "Program.h"
#include "Error.h"

#include <stdbool.h>
#include <assert.h>
#include <stdio.h>

static void check_error(GLuint arg, GLuint flag, bool is_shader)
{
	GLint success = 0;
	GLchar buffer[1024];

	if(!is_shader)
		glGetProgramiv(arg, flag, &success);
	else
		glGetShaderiv(arg, flag, &success);

	if(success == GL_FALSE)
	{
		if(!is_shader)
			glGetProgramInfoLog(
				arg, 
				sizeof(buffer), 
				NULL, buffer);
		else
			glGetShaderInfoLog(
				arg, 
				sizeof(buffer), 
				NULL, buffer);
		Error("Error: %s", buffer);
	}
}

static GLuint load_shader(const char* path, GLenum type)
{
	assert(path);
	FILE* file = fopen(path, "r");
	if(!file)
		Error("\"%s\" failed to open\n", path);

	fseek(file, 0, SEEK_END);
	long file_size = ftell(file);
	fseek(file, 0, SEEK_SET);

	GLchar buffer[file_size];
	fread(buffer, 1, (size_t)file_size, file);
	fclose(file);

	GLuint shader = glCreateShader(type);
	if(!shader)
		Error("Unable to create shader");

	const GLchar* strings[1] = {buffer};
	GLint lengths[1] = {(GLint)file_size};
	glShaderSource(
		shader, 1, 
		strings, 
		lengths);
	glCompileShader(shader);
	check_error(shader, GL_COMPILE_STATUS, true);
	return shader;
}

Program Program_create(const char* vertex_path, const char* fragment_path)
{
	assert(vertex_path && fragment_path);
	Program self;
	self.raw = glCreateProgram();
	self.vertex_shader = load_shader(
		vertex_path, 
		GL_VERTEX_SHADER);
	self.fragment_shader = load_shader(
		fragment_path, 
		GL_FRAGMENT_SHADER);

	glAttachShader(self.raw, self.vertex_shader);
	glAttachShader(self.raw, self.fragment_shader);
	glBindAttribLocation(self.raw, 0, "position");

	glLinkProgram(self.raw);
	check_error(self.raw, GL_LINK_STATUS, false);
	
	glValidateProgram(self.raw);
	check_error(self.raw, GL_VALIDATE_STATUS, false);
	return self;
}

void Program_destroy(Program* self)
{
	assert(self);

	glDetachShader(self->raw, self->vertex_shader);
	glDeleteShader(self->vertex_shader);
	glDetachShader(self->raw, self->fragment_shader);
	glDeleteShader(self->fragment_shader);
	glDeleteProgram(self->raw);
}

