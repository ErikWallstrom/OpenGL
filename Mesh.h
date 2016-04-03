#import "Base.h"
#import "Vector3f.h"
#import <GL/glew.h>

@interface Mesh : Base
{
	enum
	{
		POSITION_INDEX,
		NUM_BUFFERS
	} Constants;

	GLuint array_object;
	GLuint buffer_objects[NUM_BUFFERS];
	size_t num_vertices;
}

+(id) new: (Vector3f*)vertices n: (size_t)num;
-(void) render;
@end
