//
//  NtabView.h
//
//  Created by macmini on 03/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBookUI/ABPersonViewController.h>


@interface MyPeoplePickerNavigationController : ABPeoplePickerNavigationController <ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate>
{
	ABPersonViewController *myABPersonView;
	NSMutableString* stringtocall;
	NSString *stringoriginal;
	
}
@property (nonatomic,retain) NSMutableString* stringtocall;
@property (nonatomic,retain) NSString *stringoriginal;


@end
