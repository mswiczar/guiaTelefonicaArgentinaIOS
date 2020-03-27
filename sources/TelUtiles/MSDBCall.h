//
//  MSDBCall.h
//  numeriVerdi
//
//  Created by Moises Swiczar on 6/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"


@interface MSDBCall : NSObject {

	
}

+ (void)getCategories:(NSMutableArray*) thearray; 
+ (void)getProvinciasBlancas:(NSMutableArray*) thearray; 


+ (void) getFav:(NSMutableArray*) thearray db:(sqlite3 *)database;
+ (void) deletefromFav:(NSMutableDictionary *) thedict  databse:(sqlite3 *)database;
+ (void) insertFav:(NSMutableDictionary *) thedict db:(sqlite3 *)database;



+ (void)getHistory:(NSMutableArray*) thearray db:(sqlite3 *)database;
+(void) deletefromHistory:(NSMutableDictionary *) thedict  databse:(sqlite3 *)database ;
+(void) insertHist:(NSMutableDictionary *) thedict db:(sqlite3 *)database;


+ (void)finalizeStatements;






@end