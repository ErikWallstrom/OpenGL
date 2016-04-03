#import "Base.h"
#import "String.h"

@interface Error : Base
+(void) show: (String*)message;
+(void) log: (String*)message;
@end
