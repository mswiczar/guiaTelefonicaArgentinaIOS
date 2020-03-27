//
//  NtabView.h
//
//  Created by macmini on 03/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MyPersonViewController.h"

@implementation MyPersonViewController

- (id)initWithPerson:(ABRecordRef)person allowsEditing:(BOOL)allowsEditing
{
	if (self = [super init])
	{
		// Initialize your view controller.
		self.title = NSLocalizedString(@"Seleccione un telefono.", @"");
		self.displayedPerson = person;	
		self.allowsEditing = allowsEditing;
		self.personViewDelegate = self;
		NSNumber *myNumber = [NSNumber numberWithInt: kABPersonPhoneProperty];
		self.displayedProperties = [NSArray arrayWithObject:myNumber];

		myIsEditing = NO;

	}
	return self;
}
- (void)viewWillAppear:(BOOL)animated
{
	
}

// This method is invoked when the dialPad button is touched
- (void)editButtonAction:(id)sender
{	
	myIsEditing = !myIsEditing;
}

- (void)viewWillDisappear:(BOOL)animated
{
	
}

- (void)loadView
{

	[super loadView];

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

#pragma mark ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController 
	shouldPerformDefaultActionForPerson:(ABRecordRef)person 
	property:(ABPropertyID)property
	identifier:(ABMultiValueIdentifier)identifierForValue
{
	// If a phone number is clicked, do something
	if (property == kABPersonPhoneProperty)
	{
		return NO;
	}
	
	// If the user touched something that's not a phone number...
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Guía Telefónica", @"") 
												message:NSLocalizedString(@"Seleccione un telefono.", @"")
												delegate:nil 
												cancelButtonTitle:NSLocalizedString(@"OK", @"")
												otherButtonTitles:nil];
	[alert show];
	[alert release];
	return NO;
}


@end
