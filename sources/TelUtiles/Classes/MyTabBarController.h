//
//  MyTabBarController.h
//  voip
//
//  Created by Alejandro Daher on 5/2/08.
//  Copyright 2008 Creative Coefficient. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyTabBarController : UITabBarController<UITabBarControllerDelegate> 
{

	UINavigationController *about_nav;
	UINavigationController *acerca_nav;
	UINavigationController *acercaTel_nav;
	UINavigationController * averdi_nav;
	UINavigationController * aemer_nav;
	UINavigationController *ahistory_nav;

	
	
	id aroot;
}
@property (nonatomic,assign) id aroot;
@end
