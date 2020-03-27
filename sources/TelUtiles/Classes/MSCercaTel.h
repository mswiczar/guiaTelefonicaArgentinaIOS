//
//  MSCerca.h
//  numeriVerdi
//
//  Created by Moises Swiczar on 6/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNumeroDetail.h"
#import <StoreKit/StoreKit.h>



@interface MSCercaTel : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver> {

	IBOutlet UIView * viewPurchase;
	IBOutlet UITextField * thetxt1;
	IBOutlet UITextField * thetxt2;
	IBOutlet UITextField * thetxt3;
	
	IBOutlet UITextView * txtResult;
	
	NSMutableArray *  thearray;
	
	NSTimer * thetimer;
	NSString * stringcall;
	UIAlertView* theale;

	UIActivityIndicatorView *progressInd;
	UIAlertView             *backAlert;
	
	MSNumeroDetail* theDetail;

	BOOL Timerrunning;

	BOOL nombre;
	NSMutableDictionary *  thedictsearch;
	IBOutlet UIButton *butonmore;
	BOOL purchased;
	
}


-(IBAction) clickSearch:(id)aobj;
-(IBAction) clickMore:(id)aobj;
-(IBAction) clickHide:(id)aobj;

-(IBAction) clickPurchase:(id)aobj;


@property (nonatomic,copy) NSString * stringcall;



@end

