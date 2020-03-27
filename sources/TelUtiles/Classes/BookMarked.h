//
//  BookMarked.h
//
//  Created by Moises Swiczar on 11/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookMarked : UIViewController {
	IBOutlet UITableView    *thetable;
	NSMutableArray          *thearray;
	UIActivityIndicatorView *progressInd;
	UIAlertView             *backAlert;
	NSTimer	                *atimergetdata;
	NSInteger tipo;
	NSObject* achoose;
	UIImage * image1;
	IBOutlet UILabel * labeltitle;
}

-(void) dofill;


@property(nonatomic) 	NSInteger tipo;




@end
