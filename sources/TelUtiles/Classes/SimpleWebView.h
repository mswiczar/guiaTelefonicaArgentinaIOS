//
//  SimpleWebView.h
//  iNFL
//
//  Created by Moises Swiczar on 12/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleWebView : UIViewController {
	IBOutlet UIWebView * myview; 
	NSString *string_web; 
}
@property (nonatomic,copy)  NSString *string_web;
-(void)go;
@end
