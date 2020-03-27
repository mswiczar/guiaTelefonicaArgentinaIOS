//
//  MSEmergencia.m
//  numeriVerdi
//
//  Created by Moises Swiczar on 6/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSFavorites.h"
#import "MSDBCall.h"
#import "numeriVerdiAppDelegate.h"
#import "UContact.h"

@implementation MSFavorites
@synthesize stringcall;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title = @"Favoritos";
		self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
		self.tabBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
		thearray = [[NSMutableArray alloc]init];
	
		
    }
    return self;
}

-(IBAction)clickAbout:(id)aobj
{
	if (thetable.editing)
	{
		[thetable setEditing:NO];
	}
	else {
		[thetable setEditing:YES];
		
	}

	
}

- (void)viewWillAppear:(BOOL)animated
{
	numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];

	[MSDBCall  getFav:thearray db:appDelegate.database];
	[thetable reloadData];
	[appDelegate trackpage:@"/Favorites"];

}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem * theInfo = [[UIBarButtonItem alloc] initWithTitle:@"Modifica" style:0 target:self action:@selector(clickAbout:)];
	
	
	
	
	
	
	
	self.navigationItem.rightBarButtonItem = theInfo;
	
}






/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

// One row per book, the number of books is the number of rows.
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	
	return [thearray count];	
}

- (UITableViewCell *)obtainTableCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;
	cell = [thetable dequeueReusableCellWithIdentifier:@"UICell1"];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UICell1"] autorelease];
		cell.textLabel.font =[UIFont  boldSystemFontOfSize:11];
		cell.textLabel.numberOfLines=3;
		
		cell.detailTextLabel.font =[UIFont  systemFontOfSize:10];
		cell.detailTextLabel.numberOfLines=2;
		cell.backgroundView.backgroundColor = [UIColor clearColor];
	}
	return cell;
	
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *cell;
	NSInteger row = [indexPath row];
	cell = [self obtainTableCellForRow:row];
	

	NSMutableDictionary * thedi = [thearray objectAtIndex:row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@\nTelefono: %@",
						   [thedi objectForKey:@"nombre"] , [thedi objectForKey:@"tel"]];
	cell.detailTextLabel.text =[NSString stringWithFormat:@"%@", [thedi objectForKey:@"direccion"]];
	cell.selectionStyle = 	UITableViewCellSelectionStyleGray;
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	cell.imageView.image =[UIImage imageNamed:@"book.png"];
	
	
	return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger row = [indexPath row];
	
	[thetable deselectRowAtIndexPath:indexPath	animated:YES];
	numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (!appDelegate.is_ipod)
	{
		
		NSMutableDictionary * thedi = [thearray objectAtIndex:row];
		self.stringcall = [NSString stringWithFormat:@"%@",[thedi objectForKey:@"tel"]];
		UIAlertView * alr = [[UIAlertView alloc] initWithTitle:@"Guía telefónica" message:@"Confirma llamada?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si",nil];
		[alr show];
		[alr release];
	}
	
	return indexPath;
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1)
	{
		if(buttonIndex==1)
		{
			NSString * thestr=@"";
			
			[UContact gettel:self.stringcall thetelaux:&thestr];
			NSString *url = [NSString stringWithFormat: @"tel://%@",thestr];
		//	NSLog(@"url = %@ ",url);

			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];	
		}
		
		
		
	}
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        // Find the book at the deleted row, and remove from application delegate's array.
		numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];

		NSMutableDictionary *aitem = [thearray objectAtIndex:indexPath.row];
		[MSDBCall deletefromFav:aitem databse:appDelegate.database];
		[MSDBCall  getFav:thearray db:appDelegate.database];

		[thetable reloadData];
		
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	NSMutableDictionary * thedi = [thearray objectAtIndex:row];
	if(theDetail==nil)
	{
		theDetail = [[MSNumeroDetail alloc]initWithNibName:@"MSNumeroDetail" bundle:nil];
	}
	theDetail.calledbyFavorites = YES;
	theDetail.thedict = thedi;
	[self.navigationController pushViewController:theDetail animated:YES];
	[theDetail show];
}


@end
