//
//  MSCerca.h
//  numeriVerdi
//
//  Created by Moises Swiczar on 6/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNumeroDetail.h"

#import "CellMore.h"


@interface MSCerca : UIViewController {

	IBOutlet UITableView * thetable;
	IBOutlet UITextField * thetxt;
	IBOutlet UISegmentedControl * thesegment;
	NSMutableArray *thearray;
	NSTimer * thetimer;
	NSString * stringcall;
	UIAlertView* theale;
	NSMutableDictionary *  thedictionarytosave;
	CGRect arectOriginal;
	UIActivityIndicatorView *progressInd;
	UIAlertView             *backAlert;
	MSNumeroDetail* theDetail;
	CellMore* thecell;

	BOOL Timerrunning;
	NSMutableDictionary * thedictSearchProv;
	IBOutlet UIPickerView * thepicker;
	IBOutlet UIToolbar * thetool;
	UIBarButtonItem * thecompass ;
	BOOL nombre;
	NSMutableDictionary *  thedictsearch;
	NSInteger pagina;
	NSInteger posicion_default;
}
-(IBAction) clickcancel:(id)aobj;
-(IBAction) clickHide:(id) aobj;

-(IBAction) clickSegment:(id) aobj;


-(IBAction) clickcancelPicker:(id)aobj;



@property (nonatomic,copy) NSString * stringcall;



@end

