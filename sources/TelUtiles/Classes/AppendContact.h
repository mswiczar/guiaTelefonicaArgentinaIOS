//
//  NtabView.h
//
//  Created by macmini on 03/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBookUI/ABPersonViewController.h>

@interface AppendContact : ABPeoplePickerNavigationController <ABPeoplePickerNavigationControllerDelegate>
{
	NSMutableString* stringtocall;
	NSString *stringoriginal;
	NSMutableDictionary* thedetailStore;
	
}
@property (nonatomic,retain) NSMutableString* stringtocall;
@property (nonatomic,retain) NSString *stringoriginal;
@property (nonatomic,assign) NSMutableDictionary* thedetailStore;


@end
