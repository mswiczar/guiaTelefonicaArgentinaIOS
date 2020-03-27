//
//  NtabView.h
//
//  Created by macmini on 03/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AppendContact.h"
#import "numeriVerdiAppDelegate.h"
#import "UContact.h"
@implementation AppendContact

@synthesize stringtocall ,stringoriginal,thedetailStore;


- (id)init
{
	if (self = [super init]) 
	{
		// Initialize your view controller.
		//UIImageView*	imagetop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
		//self.navigationItem.titleView = imagetop;
		self.title  =@"Guía Telefónica";
 		self.addressBook = ABAddressBookCreate();
		self.peoplePickerDelegate = self;
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview.
	// Release anything that's not essential, such as cached data.
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
		shouldContinueAfterSelectingPerson:(ABRecordRef)person
{

	[UContact AppendContact:person thebook:self.addressBook theobj:thedetailStore];
	
	[peoplePicker dismissModalViewControllerAnimated:YES];

	return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
		shouldContinueAfterSelectingPerson:(ABRecordRef)person
		property:(ABPropertyID)property 
		identifier:(ABMultiValueIdentifier)identifier
{
	
	[peoplePicker dismissModalViewControllerAnimated:YES];
	return NO;
}

// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	
	[peoplePicker dismissModalViewControllerAnimated:YES];
}

@end