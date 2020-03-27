//
//  numeriVerdiAppDelegate.h
//  numeriVerdi
//
//  Created by Moises Swiczar on 6/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "/usr/include/sqlite3.h"
#import "MyTabBarController.h"
#import <CoreLocation/CoreLocation.h>
#import "UChache.h"

#import "GANTracker.h"

#define TRAKERGOOGLE @"UA-19434553-1"




@interface numeriVerdiAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	sqlite3 *database;
	NetworkStatus internetConnectionStatus;
	MyTabBarController *mytabview;
	BOOL is_ipod;
	BOOL is_simulator;
	UIAlertView * backAlert2; 
	BOOL needConfirma;
	
	NSMutableDictionary *dProvincia;
	NSMutableDictionary *dLocalidad;
	BOOL firsttimeExecution;
	NSMutableArray * thearrayProvincias;
	NSString *tel;
	
	
	
}
@property (nonatomic) BOOL needConfirma;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic) BOOL is_ipod;
@property (nonatomic) BOOL is_simulator;
@property (nonatomic)sqlite3 *database ;
@property NetworkStatus internetConnectionStatus;
@property (nonatomic , readonly) MyTabBarController *mytabview;

@property (nonatomic,assign) NSMutableDictionary *dProvincia;
@property (nonatomic,assign) NSMutableDictionary *dLocalidad;

@property (nonatomic,assign) NSMutableArray * thearrayProvincias;

@property (nonatomic,copy) NSString *tel;


-(void) shownotreacheable;
- (void)updateStatus;


- (void)didStartNetworking;
- (void)didStopNetworking;



-(void) trackpage:(NSString*) thestr;

@end


