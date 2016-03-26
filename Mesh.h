#ifndef MESH_H
#define MESH_H

#include <GL/glew.h>
#include "Vector3f.h"

typedef struct
{
	GLuint array_object;
	GLuint buffer_object;
	size_t num_vertices;

} Mesh;

Mesh Mesh_create(Vector3f* vertices, size_t num);
void Mesh_destroy(Mesh* self);

#endif 
