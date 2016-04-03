#import "Base.h"
#import "String.h"
#import <GL/glew.h>

@interface Texture : Base
{
	GLuint raw;
}
+(id) new: (String*)file_path;
-(void) render: (unsigned)unit;
@end
