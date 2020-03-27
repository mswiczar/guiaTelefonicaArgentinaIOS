//
//  UChache.m
//
//  Created by Moises Swiczar on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UChache.h"


@implementation UChache

static NSMutableDictionary *services_images = nil;
static int actuales =0;

+(BOOL) existincache:(NSString *)imgURL
{
	if(!services_images)
	{
		BOOL success;
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"cached.txt"];
		success = [fileManager fileExistsAtPath:writableDBPath];
		if (success) 
		{
			services_images = [[NSMutableDictionary alloc] initWithContentsOfFile:writableDBPath];
			
		}
		else
		{
			services_images = [[NSMutableDictionary alloc] initWithCapacity:1];
		}
	}

	if ([services_images objectForKey:imgURL]!=nil)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}



+(void) setInCache:(NSData*)adata aurl:(NSString*)aurl
{
	if(!services_images)
	{
		BOOL success;
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"cached.txt"];
		success = [fileManager fileExistsAtPath:writableDBPath];
		if (success) 
		{
			services_images = [[NSMutableDictionary alloc] initWithContentsOfFile:writableDBPath];
			
		}
		else
		{
			services_images = [[NSMutableDictionary alloc] initWithCapacity:1];
		}
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *stringtoget=[NSString stringWithFormat:@"%f_%d",[[NSDate date] timeIntervalSince1970],actuales++];
	NSString * writableDBPath = [documentsDirectory stringByAppendingPathComponent:stringtoget];
	[adata writeToFile:writableDBPath atomically:YES];
	[services_images setObject:writableDBPath forKey:aurl];

}




+ (NSData*)cachedIconFromURL:(NSString*)imgURL {
	NSData *d;
	if(!services_images)
	{
		BOOL success;
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"cached.txt"];
		success = [fileManager fileExistsAtPath:writableDBPath];
		if (success) 
		{
			services_images = [[NSMutableDictionary alloc] initWithContentsOfFile:writableDBPath];
			
		}
		else
		{
			services_images = [[NSMutableDictionary alloc] initWithCapacity:1];
		}
	}
	NSString * thefilename;
	if((thefilename = [services_images objectForKey:imgURL]))
	{
		return [[NSData alloc] initWithContentsOfFile:thefilename];
	}
	else
	{
		d = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imgURL]];
		if (d!=nil)
		{
			[UChache setInCache:d aurl:imgURL];
		}
		return d;
	}
}



+(BOOL) saveImages
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"cached.txt"];
	//NSLog(@"%@",writableDBPath);
	
	if ([services_images writeToFile:writableDBPath atomically:YES])
	{
		
	}
	else
	{
		
	}
	return YES;

}


@end
