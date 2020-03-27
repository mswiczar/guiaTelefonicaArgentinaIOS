//
//  MSDBCall.m
//  numeriVerdi
//
//  Created by Moises Swiczar on 6/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSDBCall.h"


@implementation MSDBCall


static sqlite3_stmt * stmt_fav=nil;
static sqlite3_stmt * stmt_ins_fav=nil;
static sqlite3_stmt * stmt_del_fav=nil;



static sqlite3_stmt * stmt_hist=nil;
static sqlite3_stmt * stmt_ins_hist=nil;
static sqlite3_stmt * stmt_del_hist=nil;



+ (void)getProvinciasBlancas:(NSMutableArray*) thearray
{

	[thearray removeAllObjects];
	NSError * error;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"provincias" ofType:@"txt"];
	NSString*  myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
	NSMutableString * thestr = [[NSMutableString alloc] initWithFormat:@"%@",myText];
	[thestr replaceOccurrencesOfString:@"\r" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[thestr length]}];
	myText = [NSString stringWithFormat:@"%@",thestr];
	[thestr release];

	NSArray* chunks = [myText componentsSeparatedByString: @"\n"];
	
	NSUInteger total = [chunks count];
	NSUInteger zzz;
	for (zzz=0; zzz<total; zzz++) {
		
		NSString *stre = [chunks objectAtIndex:zzz];
		NSArray* chunks2 = [stre componentsSeparatedByString: @","];
		
		NSMutableDictionary * thedict = [[NSMutableDictionary alloc] init];
		[thedict setObject:[chunks2 objectAtIndex:0] forKey:@"id"];
		[thedict setObject:[chunks2 objectAtIndex:1] forKey:@"desc"];
		[thedict setObject:[NSString stringWithFormat:@"%@-%@", [chunks2 objectAtIndex:2],[chunks2 objectAtIndex:0]] forKey:@"busqueda"];
		[thearray addObject:thedict];
		[thedict release];
		
	}
	
}

+ (void)getCategories:(NSMutableArray*) thearray 
{
	[thearray removeAllObjects];
	NSError * error;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"txt"];
	NSString*  myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
	NSMutableString * thestr = [[NSMutableString alloc] initWithFormat:@"%@",myText];
	[thestr replaceOccurrencesOfString:@"\r" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[thestr length]}];
	myText = [NSString stringWithFormat:@"%@",thestr];
	[thestr release];
	
	
	NSArray* chunks = [myText componentsSeparatedByString: @"\n"];
	
	NSUInteger total = [chunks count];
	NSUInteger zzz;
	for (zzz=0; zzz<total; zzz++) {

		NSString *stre = [chunks objectAtIndex:zzz];
		NSArray* chunks2 = [stre componentsSeparatedByString: @","];

		NSMutableDictionary * thedict = [[NSMutableDictionary alloc] init];
		[thedict setObject:[chunks2 objectAtIndex:0] forKey:@"id"];
		[thedict setObject:[chunks2 objectAtIndex:1] forKey:@"desc"];
		[thedict setObject:[chunks2 objectAtIndex:2] forKey:@"png"];
		[thedict setObject:[chunks2 objectAtIndex:3] forKey:@"subdesc"];
		
		[thearray addObject:thedict];
		[thedict release];
	
	}

}



/*

 CREATE TABLE fav (nombre varchar(128) , direccion varchar(255) , tel varchar(128),latitud varchar(64) , longitud varchar(64));
 CREATE TABLE historico (id integer PRIMARY KEY AUTOINCREMENT ,  nombre varchar(128) , direccion varchar(255) , tel varchar(128),latitud varchar(64) , longitud varchar(64));

 */



+(void) deletefromFav:(NSMutableDictionary *) thedict  databse:(sqlite3 *)database 
{
	if (stmt_del_fav == nil) {
		const char *sql = "delete from  fav where nombre =? and tel =?";
		if (sqlite3_prepare_v2(database, sql, -1, &stmt_del_fav, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	sqlite3_bind_text(stmt_del_fav, 1 , [[thedict objectForKey:@"nombre"]  UTF8String],-1,SQLITE_STATIC);
	sqlite3_bind_text(stmt_del_fav, 2 , [[thedict objectForKey:@"tel"]  UTF8String],-1,SQLITE_STATIC);
	
	sqlite3_step(stmt_del_fav);
	sqlite3_reset(stmt_del_fav);
}




+ (void)getFav:(NSMutableArray*) thearray db:(sqlite3 *)database
{
	[thearray removeAllObjects];
	
	char *str;
	
	if (stmt_fav == nil) {
		const char *sql = "select  nombre ,direccion , tel, latitud , longitud  from fav order by nombre";
		if (sqlite3_prepare_v2(database, sql, -1, &stmt_fav, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	NSMutableDictionary * thedict;
	while (sqlite3_step(stmt_fav) == SQLITE_ROW)
	{
		thedict = [[NSMutableDictionary alloc] init];
		str= (char *)sqlite3_column_text(stmt_fav, 0);
		if (str)
		{
			[thedict setObject:[NSString stringWithUTF8String:str] forKey:@"nombre"];
		}
		else 
		{
			[thedict setObject:@"" forKey:@"nombre"];
		}
		
		str= (char *)sqlite3_column_text(stmt_fav, 1);
		if (str)
		{
			[thedict setObject:[NSString stringWithUTF8String:str] forKey:@"direccion"];
		}
		else 
		{
			[thedict setObject:@"" forKey:@"direccion"];
		}
		
		str= (char *)sqlite3_column_text(stmt_fav, 2);
		if (str)
		{
			[thedict setObject:[NSString stringWithUTF8String:str] forKey:@"tel"];
		}
		else 
		{
			[thedict setObject:@"" forKey:@"tel"];
			
		}
		
		str= (char *)sqlite3_column_text(stmt_fav, 3);
		if (str)
		{
			[thedict setObject:[NSString stringWithUTF8String:str] forKey:@"latitud"];
			
		}
		else 
		{
			[thedict setObject:@"" forKey:@"latitud"];
		}

		str= (char *)sqlite3_column_text(stmt_fav, 4);
		if (str)
		{
			[thedict setObject:[NSString stringWithUTF8String:str] forKey:@"longitud"];
			
		}
		else 
		{
			[thedict setObject:@"" forKey:@"longitud"];
		}
		
		[thearray addObject:thedict];
		[thedict release];
	}
	sqlite3_reset(stmt_fav);	
	
	
	
}

+(void) insertFav:(NSMutableDictionary *) thedict db:(sqlite3 *)database
{

	if (stmt_ins_fav == nil) {
		const char *sql = "insert into fav (nombre ,direccion , tel, latitud , longitud  ) values (?,?,?,?,?)";
		if (sqlite3_prepare_v2(database, sql, -1, &stmt_ins_fav, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
		
	sqlite3_bind_text(stmt_ins_fav, 1 , [[thedict objectForKey:@"nombre"]  UTF8String],-1,SQLITE_STATIC);
	sqlite3_bind_text(stmt_ins_fav, 2 , [[thedict objectForKey:@"direccion"]  UTF8String],-1,SQLITE_STATIC);
	sqlite3_bind_text(stmt_ins_fav, 3 , [[thedict objectForKey:@"tel"]  UTF8String],-1,SQLITE_STATIC);
	sqlite3_bind_text(stmt_ins_fav, 4 , [[thedict objectForKey:@"latitud"]  UTF8String],-1,SQLITE_STATIC);
	sqlite3_bind_text(stmt_ins_fav, 5 , [[thedict objectForKey:@"longitud"]  UTF8String],-1,SQLITE_STATIC);
		
	sqlite3_step(stmt_ins_fav);
	sqlite3_reset(stmt_ins_fav);
		
}



+(void) insertHist:(NSMutableDictionary *) thedict db:(sqlite3 *)database
{
	
	if (stmt_ins_hist == nil) {
		const char *sql = "insert into historico (nombre ,direccion , tel, latitud , longitud  ) values (?,?,?,?,?)";
		if (sqlite3_prepare_v2(database, sql, -1, &stmt_ins_hist, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_text(stmt_ins_hist, 1 , [[thedict objectForKey:@"nombre"]  UTF8String],-1,SQLITE_STATIC);
	sqlite3_bind_text(stmt_ins_hist, 2 , [[thedict objectForKey:@"direccion"]  UTF8String],-1,SQLITE_STATIC);
	sqlite3_bind_text(stmt_ins_hist, 3 , [[thedict objectForKey:@"tel"]  UTF8String],-1,SQLITE_STATIC);
	sqlite3_bind_text(stmt_ins_hist, 4 , [[thedict objectForKey:@"latitud"]  UTF8String],-1,SQLITE_STATIC);
	sqlite3_bind_text(stmt_ins_hist, 5 , [[thedict objectForKey:@"longitud"]  UTF8String],-1,SQLITE_STATIC);
	
	sqlite3_step(stmt_ins_hist);
	sqlite3_reset(stmt_ins_hist);
	
}


+(void) deletefromHistory:(NSMutableDictionary *) thedict  databse:(sqlite3 *)database 
{
	if (stmt_del_hist == nil) {
		const char *sql = "delete from  historico where nombre =? and tel =?";
		if (sqlite3_prepare_v2(database, sql, -1, &stmt_del_hist, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	sqlite3_bind_text(stmt_del_hist, 1 , [[thedict objectForKey:@"nombre"]  UTF8String],-1,SQLITE_STATIC);
	sqlite3_bind_text(stmt_del_hist, 2 , [[thedict objectForKey:@"tel"]  UTF8String],-1,SQLITE_STATIC);
	
	sqlite3_step(stmt_del_hist);
	sqlite3_reset(stmt_del_hist);
}




+ (void)getHistory:(NSMutableArray*) thearray db:(sqlite3 *)database
{
	[thearray removeAllObjects];
	
	char *str;
	
	if (stmt_hist == nil) {
		const char *sql = "select  nombre ,direccion , tel, latitud , longitud  from historico order by id desc LIMIT 100";
		if (sqlite3_prepare_v2(database, sql, -1, &stmt_hist, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	NSMutableDictionary * thedict;
	while (sqlite3_step(stmt_hist) == SQLITE_ROW)
	{
		thedict = [[NSMutableDictionary alloc] init];
		str= (char *)sqlite3_column_text(stmt_hist, 0);
		if (str)
		{
			[thedict setObject:[NSString stringWithUTF8String:str] forKey:@"nombre"];
		}
		else 
		{
			[thedict setObject:@"" forKey:@"nombre"];
		}
		
		str= (char *)sqlite3_column_text(stmt_hist, 1);
		if (str)
		{
			[thedict setObject:[NSString stringWithUTF8String:str] forKey:@"direccion"];
		}
		else 
		{
			[thedict setObject:@"" forKey:@"direccion"];
		}
		
		str= (char *)sqlite3_column_text(stmt_hist, 2);
		if (str)
		{
			[thedict setObject:[NSString stringWithUTF8String:str] forKey:@"tel"];
		}
		else 
		{
			[thedict setObject:@"" forKey:@"tel"];
			
		}
		
		str= (char *)sqlite3_column_text(stmt_hist, 3);
		if (str)
		{
			[thedict setObject:[NSString stringWithUTF8String:str] forKey:@"latitud"];
			
		}
		else 
		{
			[thedict setObject:@"" forKey:@"latitud"];
		}
		
		str= (char *)sqlite3_column_text(stmt_hist, 4);
		if (str)
		{
			[thedict setObject:[NSString stringWithUTF8String:str] forKey:@"longitud"];
			
		}
		else 
		{
			[thedict setObject:@"" forKey:@"longitud"];
		}
		
		[thearray addObject:thedict];
		[thedict release];
	}
	sqlite3_reset(stmt_hist);	
	
}



+ (void)finalizeStatements
{
    if (stmt_fav)		 sqlite3_finalize (stmt_fav);
    if (stmt_ins_fav)    sqlite3_finalize (stmt_ins_fav);
    if (stmt_del_fav)    sqlite3_finalize (stmt_del_fav);

    if (stmt_hist)       sqlite3_finalize (stmt_hist);
    if (stmt_ins_hist)   sqlite3_finalize (stmt_ins_hist);
    if (stmt_del_hist)   sqlite3_finalize (stmt_del_hist);

}


@end
