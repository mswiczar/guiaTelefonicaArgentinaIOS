//
//  UContact.m
//  AMRO
//
//  Created by Moises Swiczar on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UContact.h"


@implementation UContact



+(void) gettel:(NSString *) thetel1  thetelaux:(NSString**) thetelaux
{

	NSMutableString *aux = [[NSMutableString alloc] initWithString:[thetel1 uppercaseString]];
	
	
	
	
	
	[aux replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [aux  length])];
	
	[aux replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [aux  length])];
	[aux replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [aux  length])];
	[aux replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [aux length])];
	
	*thetelaux = [NSString stringWithFormat: @"%@",aux];
	[aux release];
}





+(BOOL) AppendContact:(ABRecordRef)persona thebook:(ABAddressBookRef)thebook theobj:(NSMutableDictionary*)theobj

{
	
	NSString *stringtoinsert =@"";
	NSString * stringdb = [theobj objectForKey:@"tel"];
	[UContact  gettel:stringdb  thetelaux:&stringtoinsert];
	
	ABMutableMultiValueRef myMultiValueRef = ABRecordCopyValue(persona, kABPersonPhoneProperty);	
	ABMutableMultiValueRef the = ABMultiValueCreateMutableCopy(myMultiValueRef);
    BOOL foundphone=NO;
	
	int i;
	for (i=0; i < ABMultiValueGetCount(myMultiValueRef); ++i)
	{
		NSString *label = (NSString*)ABMultiValueCopyLabelAtIndex(the, i);
		if ( [label compare:@"Tel (Guía Tel)"] == NSOrderedSame )
		{
			foundphone=YES;
			ABMultiValueReplaceValueAtIndex(the, stringtoinsert, i);
			ABRecordSetValue(persona, kABPersonPhoneProperty, the, nil);
			break;
		}
	}
	if (foundphone==NO)
	{
		NSString * atel = [NSString stringWithFormat:@"%@",stringtoinsert];
		NSString * alabel = [NSString stringWithFormat:@"Tel (Guía Tel)"];
		ABMultiValueAddValueAndLabel(the, atel, (CFStringRef)alabel, NULL);
		ABRecordSetValue(persona, kABPersonPhoneProperty, the, nil);
	}
	
	
	
	ABMutableMultiValueRef myMultiValueRef2 = ABRecordCopyValue(persona, kABPersonAddressProperty);	
	ABMutableMultiValueRef the2 = ABMultiValueCreateMutableCopy(myMultiValueRef2);
	foundphone=NO;
	
	for (i=0; i < ABMultiValueGetCount(myMultiValueRef2); ++i)
	{
		NSString *label = (NSString*)ABMultiValueCopyLabelAtIndex(the2, i);
		if ( [label compare:@"Dir (Guía Tel)"] ==  NSOrderedSame )
		{
			foundphone=YES;
			
			NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
			[addressDictionary setObject:[NSString stringWithFormat:@"%@", [theobj objectForKey:@"direccion"]] forKey:(NSString *) kABPersonAddressStreetKey];
			ABMultiValueReplaceValueAtIndex(the2, addressDictionary, i);
			ABRecordSetValue(persona, kABPersonAddressProperty, the2, nil);
			break;
		}
	}
	if (foundphone==NO)
	{
		NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
		[addressDictionary setObject:[NSString stringWithFormat:@"%@", [theobj objectForKey:@"direccion"]] forKey:(NSString *) kABPersonAddressStreetKey];

		[addressDictionary setObject:[NSString stringWithFormat:@"%@",@"ar" ] forKey:(NSString *) kABPersonAddressCountryCodeKey];
		[addressDictionary setObject:[NSString stringWithFormat:@"%@",@"Argentina" ] forKey:(NSString *) kABPersonAddressCountryKey];

		
		
		NSString * alabel = [NSString stringWithFormat:@"Dir (Guía Tel)"];
		ABMultiValueAddValueAndLabel(the2, addressDictionary, (CFStringRef)alabel, NULL);
		ABRecordSetValue(persona, kABPersonAddressProperty, the2, nil);
	}
	
	
	
	
	ABAddressBookSave(thebook, nil);
	
	
	
	UIAlertView *aview= [[UIAlertView alloc] initWithTitle:@"Guía Telefónica" message:@"Contacto agregado." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[aview show];
	[aview release];
	return YES;
	
}






+(BOOL) AddContact:(NSMutableDictionary*)theobj
{
	
	
	ABAddressBookRef m_addressbook = ABAddressBookCreate();
    if (!m_addressbook) {
//        NSLog(@"opening address book");
    }
	
	NSString *stringtoinsert =@"";
	NSString * stringdb = [theobj objectForKey:@"tel"];
	[UContact  gettel:stringdb  thetelaux:&stringtoinsert];
	
	
	// can be cast to NSArray, toll-free
	CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(m_addressbook);
	CFIndex nPeople = ABAddressBookGetPersonCount(m_addressbook);
	
	// CFStrings can be cast to NSString!
	
	for (int i=0;i < nPeople;i++) 
	{ 
		ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
		
		CFStringRef firstName = ABRecordCopyValue(ref, kABPersonOrganizationProperty);
		if (firstName != NULL)
		{
			NSString *contactFirstLast = [NSString stringWithFormat:@"%@",firstName];
			if ( [contactFirstLast isEqualToString:[theobj objectForKey:@"nombre"]])
			{
				
				CFRelease(firstName);
				UIAlertView *aview= [[UIAlertView alloc] initWithTitle:@"Guía Telefónica" message:@"Este contacto existe en la lista de contactos." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[aview show];
				[aview release];				
				return NO;
			}
			CFRelease(firstName);
		}
	}
	
	ABRecordRef persona = ABPersonCreate();
	ABRecordSetValue(persona, kABPersonOrganizationProperty, [theobj objectForKey:@"nombre"], nil);
	ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
	NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
	
	[addressDictionary setObject:[NSString stringWithFormat:@"%@", [theobj objectForKey:@"direccion"]] forKey:(NSString *) kABPersonAddressStreetKey];
	
	[addressDictionary setObject:[NSString stringWithFormat:@"%@",@"ar" ] forKey:(NSString *) kABPersonAddressCountryCodeKey];
	[addressDictionary setObject:[NSString stringWithFormat:@"%@",@"Argentina" ] forKey:(NSString *) kABPersonAddressCountryKey];
	
	
	

	ABMultiValueAddValueAndLabel(multi, addressDictionary, kABWorkLabel, NULL);
	
	
	ABMutableMultiValueRef multi2 = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	ABMultiValueAddValueAndLabel(multi2, stringtoinsert, kABPersonPhoneMainLabel, NULL);
	
	
	
	if(!ABRecordSetValue(persona, kABPersonAddressProperty, multi, nil))
	{
		//NSLog(@"setting value didn't work.");
	}
	
	if(!ABRecordSetValue(persona, kABPersonPhoneProperty, multi2, nil))
	{
	//	NSLog(@"setting value didn't work.");
	}
	
	ABAddressBookAddRecord(m_addressbook, persona, nil);
	ABAddressBookSave(m_addressbook, nil);
	
	CFRelease(persona);	
	
	UIAlertView *aview= [[UIAlertView alloc] initWithTitle:@"Guía Telefónica" message:@"Contacto agregado." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[aview show];
	[aview release];
	
	// now adding the company.
	return YES;
	
	
}

@end
