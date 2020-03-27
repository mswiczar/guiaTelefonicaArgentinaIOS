//

//  MyTabBarController.m
//  voip
//
//

#import "MyTabBarController.h"
#import "About.h"
#import "MSCerca.h"
#import "MSCercaTel.h"
#import "MSFavorites.h"
#import "MSHistory.h"




@implementation MyTabBarController
@synthesize aroot;
- (id)init
{
	if (self = [super init]) 
	{
		About * aabout = [[About alloc] initWithNibName:@"About" bundle:nil];
		about_nav = [[UINavigationController alloc]initWithRootViewController:aabout];
		about_nav.navigationBar.tintColor = [UIColor blackColor];
		[aabout release];

		MSHistory * ahistory = [[MSHistory alloc] initWithNibName:@"MSHistory" bundle:nil];
		ahistory_nav = [[UINavigationController alloc]initWithRootViewController:ahistory];
		ahistory_nav.navigationBar.tintColor = [UIColor blackColor];
		[ahistory release];
		
		MSCerca * aacerca = [[MSCerca alloc] initWithNibName:@"MSCerca" bundle:nil];
		acerca_nav = [[UINavigationController alloc]initWithRootViewController:aacerca];
		acerca_nav.navigationBar.tintColor = [UIColor blackColor];
		[aacerca release];

		MSCercaTel * aacercaTel = [[MSCercaTel alloc] initWithNibName:@"MSCercaTel" bundle:nil];
		acercaTel_nav = [[UINavigationController alloc]initWithRootViewController:aacercaTel];
		acercaTel_nav.navigationBar.tintColor = [UIColor blackColor];
		[aacercaTel release];
		
		 
		
		
		MSFavorites * aaemer = [[MSFavorites alloc] initWithNibName:@"MSFavorites" bundle:nil];
		aemer_nav = [[UINavigationController alloc]initWithRootViewController:aaemer];
		aemer_nav.navigationBar.tintColor = [UIColor blackColor];
		[aaemer release];
		
		
		
		NSArray *localViewControllersArray = [NSArray arrayWithObjects:acerca_nav,acercaTel_nav,ahistory_nav,aemer_nav,about_nav,nil];

		self.delegate = self;
		self.viewControllers = localViewControllersArray;
		self.selectedIndex = 0;
	}
	return self;
}

- (void)loadView 
{
	// Don't invoke super if you want to create a view hierarchy programmatically
	[super loadView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc
{
	[super dealloc];
}

#pragma UITabBarViewControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController
didEndCustomizingViewControllers:(NSArray *)viewControllers
				 changed:(BOOL)changed
{

}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
	/*
	if (viewController==recordcontroller)
	{
		[playcontroller clickstopmusic:playcontroller];
	
	}
	else
	{
	
		if(viewController==playcontroller)
		{
			[playcontroller clickpause:playcontroller];
			//
		}
		else
		{
			[playcontroller clickstopmusic:playcontroller];

			// this is settings controller
		
		}
	}
	 */
}

@end
