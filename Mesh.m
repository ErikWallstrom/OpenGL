#import "Mesh.h"

#define NUM_BUFFERS 1

@implementation Mesh
+(id) new: (Vector3f*)vertices n: (size_t)num
{
	Mesh* obj = [super new];
	obj->num_vertices = num;

	glGenVertexArrays(1, &obj->array_object);
	glBindVertexArray(obj->array_object);

	glGenBuffers(NUM_BUFFERS, obj->buffer_objects);
	glBindBuffer(GL_ARRAY_BUFFER, obj->buffer_objects[POSITION_INDEX]);
	glBufferData(
		GL_ARRAY_BUFFER, 
		(int)(sizeof(vertices[0]) * num), 
		vertices, 
		GL_STATIC_DRAW);

	glEnableVertexAttribArray(0);
	glVertexAttribPointer(
		0,
		3,
		GL_FLOAT,
		GL_FALSE,
		0,
		NULL);
	glBindVertexArray(0);
	return obj;
}

-(void) render
{
	glBindVertexArray(array_object);
	glDrawArrays(GL_TRIANGLES, 0, (int)num_vertices);
	glBindVertexArray(0);
}

-(void) delete
{
	glDeleteVertexArrays(1, &array_object);
	[super delete];
}
@end
