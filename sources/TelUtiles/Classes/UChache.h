//
//  UChache.h
//  Robtwitter
//
//  Created by Moises Swiczar on (once upon a time).
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UChache : NSObject {

}

+ (NSData*)cachedIconFromURL:(NSString*)imgURL;
+(BOOL) saveImages;

+(BOOL) existincache:(NSString *)imgURL;

+(void) setInCache:(NSData*)adata aurl:(NSString*)aurl;




@end
