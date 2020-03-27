//
//  MSEmergencia.h
//  numeriVerdi
//
//  Created by Moises Swiczar on 6/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNumeroDetail.h"

@interface MSFavorites : UIViewController {
	IBOutlet UITableView * thetable;
	NSMutableArray * thearray;
	NSString * stringcall;
	MSNumeroDetail* theDetail;

}
@property (nonatomic,copy) NSString * stringcall;

	

@end
