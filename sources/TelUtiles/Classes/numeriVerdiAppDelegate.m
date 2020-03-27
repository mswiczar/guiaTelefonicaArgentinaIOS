//
//  numeriVerdiAppDelegate.m
//  numeriVerdi
//
//  Created by Moises Swiczar on 6/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#define SQLDATABASENAME @"telefonos.sql"

#import "numeriVerdiAppDelegate.h"
#import "MSDBCall.h"

@implementation numeriVerdiAppDelegate

@synthesize window;
@synthesize internetConnectionStatus;
@synthesize database;
@synthesize mytabview;
@synthesize is_ipod,is_simulator;
@synthesize needConfirma;
@synthesize dProvincia, dLocalidad;
@synthesize thearrayProvincias;

@synthesize tel;

- (void)initializeDatabase
{
	 
	 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *documentsDirectory = [paths objectAtIndex:0];
	 NSString *path = [documentsDirectory stringByAppendingPathComponent:SQLDATABASENAME];
	 // Open the database. The database was prepared outside the application.
	 if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) 
	 {
	 } 
	 else 
	 {
	 // Even though the open failed, call close to properly clean up resources.
	 //sqlite3_close(database);
	 NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	 // Additional error handling, as appropriate...
	 }
}



-(void)createEditableCopyOfDatabaseIfNeeded 
{
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:SQLDATABASENAME];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	[self trackpage:@"/FirstInstall"];
	
	self.needConfirma=YES;
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLDATABASENAME];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) 
	{
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

-(void)createCopyOfNewDataIfNeeded 
{
	return;
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"NumeriVerdi.csv"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;

	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NumeriVerdi.csv"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) 
	{
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}






-(void)startdatabase
{
	[self createEditableCopyOfDatabaseIfNeeded];
	[self initializeDatabase];
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	
    [[GANTracker sharedTracker] startTrackerWithAccountID:TRAKERGOOGLE
										   dispatchPeriod:5
												 delegate:nil];
	
	self.needConfirma= [[[NSUserDefaults standardUserDefaults] objectForKey:@"needConfirma"] boolValue];

    [self startdatabase];
	
	thearrayProvincias = [[NSMutableArray alloc]init];
	[MSDBCall getProvinciasBlancas:thearrayProvincias];
	 
	backAlert2 = [[UIAlertView alloc]initWithTitle:@"Guía telefonica Argentina" message:@"No hay conexion a internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	is_ipod =(([[[UIDevice currentDevice]model]isEqualToString:@"iPod touch"]) || ([[[UIDevice currentDevice]model]isEqualToString:@"iPad"]));
	is_simulator = [[[UIDevice currentDevice]model]isEqualToString:@"iPhone Simulator"];
	[[Reachability sharedReachability] setHostName: @"www.apple.com"];
	[[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
	mytabview = [[MyTabBarController alloc] init];
	[window addSubview:[mytabview view]];
    [window makeKeyAndVisible];
	[self trackpage:@"/StartApp"];
	
	[self updateStatus];
	if (internetConnectionStatus==NotReachable)
	{
		[self  shownotreacheable];
	}
	
	

	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	//	[UChache saveImages];
	
	if (self.needConfirma)
	{
		[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"needConfirma"];
	}
	else 
	{
		[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"needConfirma"];
		
	}

	
	[MSDBCall finalizeStatements];
	sqlite3_close(database);

}



- (void)dealloc 
{
	[mytabview release];
    [window release];
    [super dealloc];
}




-(void)updateStatus
{
	self.internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
	
}
- (void)reachabilityChanged:(NSNotification *)note
{
    [self updateStatus];
}



-(void) shownotreacheable
{
	[backAlert2 show];
}




- (void)applicationDidEnterBackground:(UIApplication *)application 
{
	[[GANTracker sharedTracker]stopTracker ];

	if (self.needConfirma)
	{
		[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"needConfirma"];
	}
	else 
	{
		[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"needConfirma"];
		
	}
	
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application 
{
	self.needConfirma= [[[NSUserDefaults standardUserDefaults] objectForKey:@"needConfirma"] boolValue];
	
    [[GANTracker sharedTracker] startTrackerWithAccountID:TRAKERGOOGLE
										   dispatchPeriod:5
												 delegate:nil];
}
+ (numeriVerdiAppDelegate *)sharedAppDelegate
{
    return (numeriVerdiAppDelegate *) [UIApplication sharedApplication].delegate;
}


- (void)didStartNetworking
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didStopNetworking
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void) trackpage:(NSString*) thestr
{
	
	 NSError *error;
	 if (![[GANTracker sharedTracker] trackPageview:thestr
	 withError:&error]) {
	 // Handle error here
	// NSLog(@"Error");
	 



	 }
}

@end
