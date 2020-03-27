//
//  UContact.h
//  AMRO
//
//  Created by Moises Swiczar on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#include <AddressBook/ABRecord.h>


@interface UContact : NSObject {

	
	
}

+(BOOL) AppendContact:(ABRecordRef)persona thebook:(ABAddressBookRef)thebook theobj:(NSMutableDictionary*)theobj; 

+(BOOL) AddContact:(NSMutableDictionary*)theobj; 
+(void) gettel:(NSString *) thetel1  thetelaux:(NSString**) thetelaux;



@end
