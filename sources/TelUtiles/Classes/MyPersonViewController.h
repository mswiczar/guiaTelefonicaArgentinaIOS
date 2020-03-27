//
//  NtabView.h
//
//  Created by macmini on 03/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/ABPersonViewController.h>

@interface MyPersonViewController : ABPersonViewController <ABPersonViewControllerDelegate>
{
	BOOL myIsEditing;
}
- (id)initWithPerson:(ABRecordRef)person allowsEditing:(BOOL)allowsEditing;
@end
