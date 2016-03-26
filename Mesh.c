#include "Mesh.h"
#include <assert.h>

Mesh Mesh_create(Vector3f* vertices, size_t num)
{
	assert(vertices);
	Mesh self;
	self.num_vertices = num;

	glGenVertexArrays(1, &self.array_object);
	glBindVertexArray(self.array_object);

	glGenBuffers(1, &self.buffer_object);
	glBindBuffer(GL_ARRAY_BUFFER, self.buffer_object);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Vector3f) * num, vertices, GL_STATIC_DRAW);

	return self;
}

void Mesh_destroy(Mesh* self)
{

}

