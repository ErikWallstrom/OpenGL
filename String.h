#import "Base.h"

@interface String : Base
{
	char* c_string;
	unsigned len;

	int non_literal;
	char* buffer;
	unsigned buffer_length;
}

//Works statically
-(unsigned) length;
-(const char*) get;
-(int) equal: (String*)string;
-(id) print;

//Dynamically allocates memory
+(id) new: (String*)string;
-(id) upper;
-(id) lower;
-(id) set: (String*)string;
-(id) format: (String*)string, ...;
-(id) append: (String*)string;
-(id) prepend: (String*)string;
@end
