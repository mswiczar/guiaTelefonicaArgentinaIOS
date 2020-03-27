//
//  NtabView.h
//
//  Created by macmini on 03/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MyPeoplePickerNavigationController.h"
#import "numeriVerdiAppDelegate.h"

@implementation MyPeoplePickerNavigationController

@synthesize stringtocall ,stringoriginal;


- (id)init
{
	if (self = [super init]) 
	{
		// Initialize your view controller.
		UIImageView*	imagetop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
		self.navigationItem.titleView = imagetop;
 
		self.addressBook = ABAddressBookCreate();
		self.peoplePickerDelegate = self;
		myABPersonView = nil;
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
	[myABPersonView release];
	[super dealloc];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
		shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	if (myABPersonView == nil)
	{
		myABPersonView = [[ABPersonViewController alloc] init];
		myABPersonView.title = NSLocalizedString(@"Selecciona un telefono", @"");
		UIBarButtonItem *myEditButton = [myABPersonView editButtonItem];
		myEditButton.target = self;
		myEditButton.action = @selector(editButtonAction:);
		myABPersonView.allowsEditing = NO;
		myABPersonView.personViewDelegate = self;
	}
	
	myABPersonView.displayedPerson = person;
	[peoplePicker pushViewController:myABPersonView animated:YES];
	
	return NO;
}
- (void)editButtonAction:(id)sender
{	
	if (myABPersonView.editing)
	{
		[myABPersonView setEditing:NO animated:YES];
	}
	else
	{
		[myABPersonView setEditing:YES animated:YES];
	}
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
		shouldContinueAfterSelectingPerson:(ABRecordRef)person
		property:(ABPropertyID)property 
		identifier:(ABMultiValueIdentifier)identifier
{
	
	if (property == kABPersonPhoneProperty) 
	{
		
		ABMultiValueRef multi = ABRecordCopyValue(person, property);
		NSArray *theArray = [(id)ABMultiValueCopyArrayOfAllValues(multi) autorelease];
		
		stringtocall = [NSMutableString stringWithFormat:@"%@",[theArray objectAtIndex:identifier]];
		
		[stringtocall replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringtocall  length])];
		[stringtocall replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringtocall  length])];
		[stringtocall replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringtocall  length])];
		[stringtocall replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringtocall  length])];
		
		self.stringoriginal = [NSString stringWithFormat:@"%@",stringtocall];
		numeriVerdiAppDelegate *appDelegate = (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.tel = self.stringoriginal ;
		[myABPersonView  dismissModalViewControllerAnimated:YES];
		
		return NO;
	}
	
	return NO;
}

// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	[peoplePicker dismissModalViewControllerAnimated:YES];
//	[peoplePicker popViewControllerAnimated:YES];
}

#pragma mark ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController 
					shouldPerformDefaultActionForPerson:(ABRecordRef)person 
					property:(ABPropertyID)property
					identifier:(ABMultiValueIdentifier)identifierForValue
{
	
	if (property == kABPersonPhoneProperty) 
	{
		
		ABMultiValueRef multi = ABRecordCopyValue(person, property);
		NSArray *theArray = [(id)ABMultiValueCopyArrayOfAllValues(multi) autorelease];
		
		stringtocall = [NSMutableString stringWithFormat:@"%@",[theArray objectAtIndex:identifierForValue]];
		
		[stringtocall replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringtocall  length])];
		[stringtocall replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringtocall  length])];
		[stringtocall replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringtocall  length])];
		[stringtocall replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringtocall  length])];
		
		self.stringoriginal = [NSString stringWithFormat:@"%@",stringtocall];
		numeriVerdiAppDelegate *appDelegate = (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.tel = self.stringoriginal ;
		[myABPersonView  dismissModalViewControllerAnimated:YES];

		
		return NO;
	}
	
	return NO;
}


@end
