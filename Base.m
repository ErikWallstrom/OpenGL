#import "Base.h"
#import <objc/runtime.h>

@implementation Base
+(id) new
{
	id obj = class_createInstance(self, 0);
	object_setClass(obj, self);
	return obj;
}

-(void) delete
{
	object_dispose(self);
}
@end
