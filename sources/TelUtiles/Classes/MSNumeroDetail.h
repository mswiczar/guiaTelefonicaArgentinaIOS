//
//  MSNumeroDetail.h
//  numeriVerdi
//
//  Created by Moises Swiczar on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppendContact.h"

#import <MapKit/MapKit.h>
#import <MapKit/MKGeometry.h>
#import <MapKit/MKMapView.h>
#import <MapKit/MKTypes.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MSNumeroDetail : UIViewController<MFMailComposeViewControllerDelegate,UIActionSheetDelegate> {
	NSMutableDictionary * thedict;
	IBOutlet MKMapView * themap;
	IBOutlet UILabel * labelNombre;
	IBOutlet UILabel * labelTel;
	IBOutlet UILabel * labelDomicilio;
	UIAlertView *theale;
	BOOL calledbyFavorites;
	
	AppendContact * theaddressbook;
	
	
	UIActivityIndicatorView *progressInd;
	UIAlertView             *backAlert;

	CLLocationCoordinate2D location;

}

-(void) show;
-(IBAction) clickShare:(id)aobj;
-(IBAction) clickContacts:(id)aobj;
-(IBAction) clickFav:(id)aobj;






@property (nonatomic,assign) NSMutableDictionary * thedict;
@property BOOL calledbyFavorites;
@end
