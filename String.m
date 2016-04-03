#import "String.h"
#import <stdarg.h>
#import <assert.h>
#import <string.h>
#import <stdlib.h>
#import <stdio.h>
#import <ctype.h>

@implementation String
-(unsigned) length
{
	if(buffer)
		return buffer_length;
	return len;
}

-(const char*) get
{
	if(buffer)
		return buffer;
	return c_string;
}

-(int) equal: (String*)string
{
	assert(string);
	if(buffer)
		return !strcpy(buffer, [string get]);
	return !strcmp(c_string, [string get]);
}

-(id) print
{
	if(buffer)
		puts(buffer);
	else
		puts(c_string);
	return self;
}

+(id) new
{
	String* obj = [super new];
	obj->non_literal = 1;
	return obj;
}

+(id) new: (String*)string
{
	String* obj = [super new];
	[obj set: string];
	obj->non_literal = 1;
	return obj;
}

-(void) delete
{
	if(buffer)
		free(buffer);
	if(non_literal)
		[super delete];
	else
		buffer = NULL;
}

-(id) upper
{
	if(buffer)
	{
		for(unsigned i = 0; i < buffer_length; i++)
		{
			buffer[i] = (char)toupper(buffer[i]);
		}
	}
	else
	{
		buffer_length = len;
		buffer = malloc(buffer_length + 1);
		buffer[buffer_length] = '\0';

		for(unsigned i = 0; i < buffer_length; i++)
		{
			buffer[i] = (char)toupper(c_string[i]);
		}
	}
	return self;
}

-(id) lower
{
	if(buffer)
	{
		for(unsigned i = 0; i < buffer_length; i++)
		{
			buffer[i] = (char)tolower(buffer[i]);
		}
	}
	else
	{
		buffer_length = len;
		buffer = malloc(buffer_length + 1);
		buffer[buffer_length] = '\0';

		for(unsigned i = 0; i < buffer_length; i++)
		{
			buffer[i] = (char)tolower(c_string[i]);
		}
	}
	return self;
}

-(id) set: (String*)string
{
	assert(string);
	if(buffer)
	{
		if([string length] > buffer_length)
		{
			buffer_length = [string length];
			buffer = realloc(buffer, buffer_length + 1);
		}
	}
	else
	{
		buffer_length = [string length];
		buffer = malloc(buffer_length + 1);
	}

	strcpy(buffer, [string get]);
	return self;
}

-(id) format: (String*)format, ...
{
	assert(format);
	va_list list_1, list_2;
	va_start(list_1, format);
	va_copy(list_2, list_1);
	int format_len = vsnprintf(NULL, 0, [format get], list_1) - 1;
	if(buffer)
	{
		if((unsigned)format_len > buffer_length)
		{
			buffer_length = (unsigned)format_len;
			buffer = realloc(buffer, buffer_length + 1);
		}
	}
	else
	{
		buffer_length = (unsigned)format_len;
		buffer = malloc(buffer_length + 1);
	}
	vsprintf(buffer, [format get], list_2);
	va_end(list_2);
	va_end(list_1);
	return self;
}

-(id) append: (String*)string
{
	assert(string);
	buffer_length = [self length] + [string length];
	if(buffer)
	{
		buffer = realloc(buffer, buffer_length + 1);
	}
	else
	{
		buffer = malloc(buffer_length + 1);
		strcpy(buffer, c_string);
	}
	strcat(buffer, [string get]);
	return self;
}

-(id) prepend: (String*)string
{
	assert(string);
	buffer_length = [self length] + [string length];
	if(buffer)
	{
		buffer = realloc(buffer, buffer_length + 1);
	}
	else
	{
		buffer = malloc(buffer_length + 1);
	}
	strcpy(buffer, [string get]);
	strcat(buffer, [self get]);
	return self;
}
@end
