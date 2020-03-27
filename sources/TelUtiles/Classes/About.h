//
//  About.h
//  iGPS
//
//  Created by Moises Swiczar on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

	


@interface About : UIViewController <MFMailComposeViewControllerDelegate>{
	
}

-(IBAction) clickDona:(id)aobj;
-(IBAction) clickEmail:(id)aobj;
-(IBAction) clickURL:(id)aobj;
-(IBAction) clickApp1:(id)aobj;


-(IBAction) clickEmailContacto:(id)aobj;


@end
