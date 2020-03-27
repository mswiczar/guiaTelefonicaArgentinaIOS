//
//  Created by Moises Swiczar on 11/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookMarked.h"
#import "WSCall.h"
#import "deAutosAppDelegate.h"

@implementation BookMarked


@synthesize tipo;

- (void)viewWillAppear:(BOOL)animated
{
	self.navigationController.navigationBarHidden=NO;
	switch (self.tipo) {
		case 0:
			self.title = @"Marca";
			labeltitle.text =@"Seleccione la marca a buscar";
			break;
		case 1:
			self.title = @"Modelo";
			labeltitle.text =@"Seleccione un modelo de la marca";

			break;
		case 2:
			self.title = @"Provincia";
			labeltitle.text =@"Seleccione la provincia a buscar";

			break;
		case 3:
			self.title = @"Localidad";
			labeltitle.text =@"Seleccione la localidad del la provincia:";
			break;
			
		case 4:
			self.title = @"Combustible";
			labeltitle.text =@"Seleccione el combustible";
			break;
			
		case 5:
			self.title = @"Año desde";
			labeltitle.text =@"";
			break;
			
		case 6:
			self.title = @"Año hasta";
			labeltitle.text =@"";
			
			break;
		default:
			break;
	}
	
	
}


-(void)workOnBackground:(BOOL)background
{
	self.view.userInteractionEnabled = !background;
	if (background)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	//	[backAlert show];
	//	[progressInd startAnimating];
		
	}
	else
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//	[progressInd stopAnimating];
	//	[backAlert dismissWithClickedButtonIndex:0 animated:YES];
	}
}



-(void) clikoninfobar:(id)aobj
{
//	[self.navigationController popViewControllerAnimated:YES];
	[self.navigationController popToRootViewControllerAnimated:YES];

}



-(void) loaddata:(id)aobj
{
	deAutosAppDelegate *appDelegate = (deAutosAppDelegate *)[[UIApplication sharedApplication] delegate];
	[thearray removeAllObjects];
	
	switch (self.tipo) {
		case 0:
			[WSCall getMarca:thearray];
			break;
		case 1:
			[WSCall getModelo:thearray marca:[appDelegate.dMarca objectForKey:@"clsMarca_Id"]];
			break;
		case 2:
			[WSCall getProvincia:thearray];
			break;
		case 3:
			[WSCall getLocalidad:thearray provincia:[appDelegate.dProvincia objectForKey:@"clsProvincia_Id"]];
			break;
		case 4:
			[WSCall getCombustible:thearray];
			break;
			
		case 5:
			[WSCall getANOD:thearray];
			break;			
			
		case 6:
			if(appDelegate.desdeano !=nil)
			{
				[WSCall getANOH:thearray desde:[appDelegate.desdeano intValue]];
			}
			else
			{
				[WSCall getANOH:thearray desde:1980];
			}
			break;			
			
		default:
			break;
	}
	[thetable reloadData];
	[self workOnBackground:NO];
}

-(void) showalldata
{
	[thearray removeAllObjects];
	[thetable reloadData];

	
	[self workOnBackground:YES];
	atimergetdata = [NSTimer scheduledTimerWithTimeInterval:	0.1		// seconds
													 target:		self
												   selector:	@selector (loaddata:)
												   userInfo:	self		// makes the currently-active audio queue (record or playback) available to the updateBargraph method
													repeats:	NO];
};



-(void) dofill
{
	switch (self.tipo) {
		case 0:
			self.title = @"Marca";
			break;
		case 1:
			self.title = @"Modelo";
			break;
		case 2:
			self.title = @"Provincia";
			break;
		case 3:
			self.title = @"Localidad";

			break;
		case 4:
			self.title = @"Combustible";
			break;
		case 5:
			self.title = @"Año desde";
			break;
		case 6:
			self.title = @"Año desde";
			break;
			
		default:
			break;
	}
	
	[self showalldata];

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		progressInd = [[UIActivityIndicatorView alloc] init];
		progressInd.hidesWhenStopped = YES;
		progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		[progressInd sizeToFit];
		progressInd.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleTopMargin |
										UIViewAutoresizingFlexibleBottomMargin);
		
		backAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", @"")
											   message:NSLocalizedString(@"Cargando datos...\nPor favor aguarde.", @"") //@SK
											  delegate:nil 
									 cancelButtonTitle:nil
									 otherButtonTitles:nil];
		//backAlert.transform = CGAffineTransformTranslate( backAlert.transform, 0.0, -110.0 );//@SK
		progressInd.center = CGPointMake(backAlert.frame.size.width / 2.0, -5.0);
		[backAlert addSubview:progressInd];
		thearray = [[NSMutableArray alloc] init];
		image1 = [UIImage  imageNamed:@"right.png"];
		achoose=nil;

		
    }
    return self;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn addTarget:self action:@selector(clikoninfobar:) forControlEvents:UIControlEventTouchUpInside];
	btn.frame = CGRectMake(0, 0, 50, 20);
	[btn setImage:[UIImage imageNamed:@"Back Inactivo.png"] forState:UIControlStateNormal];
	UIBarButtonItem * theinfobutton = [[UIBarButtonItem alloc] initWithCustomView:btn];
	self.navigationItem.hidesBackButton=YES;
	
	self.navigationItem.leftBarButtonItem = theinfobutton;
	
	
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
	/*
	if (achoose!=nil)
	{
		[achoose release];
	}
	 */
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}





- (void)dealloc {
	
	if (achoose!=nil)
	{
		[achoose release];
	}
	
	if(thearray!=nil)
	{
		[thearray release];
	}
	
	if(image1!=nil)
	{
		[image1 release];
	}
	
	if(progressInd!=nil)
	{
		[progressInd release];
	}
	
	if(backAlert!=nil)
	{
		[backAlert release];
	}
	
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

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	return [thearray count];
}





- (UITableViewCell *)obtainTableCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;
	cell = [thetable dequeueReusableCellWithIdentifier:@""];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@""] autorelease];
		cell.selectionStyle = 	UITableViewCellSelectionStyleGray;
		cell.textLabel.textColor = [UIColor orangeColor];


		
		
	}
	return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{

	NSInteger row = [indexPath row];
	UITableViewCell *cell = [self obtainTableCellForRow:row];
	NSMutableDictionary * thedict = [thearray objectAtIndex:row];
	
	switch (self.tipo) {
		case 0:
			cell.textLabel.text = [thedict objectForKey:@"clsMarca_Nombre"];
			break;
		case 1:
			cell.textLabel.text = [thedict objectForKey:@"clsModelo_Nombre"];
			break;
		case 2:
			cell.textLabel.text = [thedict objectForKey:@"clsProvincia_Nombre"];
			break;
		case 3:
			cell.textLabel.text = [thedict objectForKey:@"clsZona_Nombre"];
			break;
		case 4:
			cell.textLabel.text = [thedict objectForKey:@"Nombre"];
			break;
		case 5:
			cell.textLabel.text = [thearray objectAtIndex:row];
			break;
		case 6:
			cell.textLabel.text = [thearray objectAtIndex:row];
			break;

		default:
			break;
	}
	
	/*
	CGRect arect ;
	arect.origin.x=0;
	arect.origin.y=0;
	arect.size.height = image1.size.height;
	arect.size.width = image1.size.width;
	
	UIImageView* acc = [[UIImageView alloc] initWithFrame:arect];
	switch (self.tipo) 
	{
		case 0:
			
			acc.image = image1;
			cell.accessoryView =acc;
			[acc release];
			break;
		case 2:
			acc.image = image1;
			cell.accessoryView =acc;
			[acc release];
			break;
			
			
		default:
			cell.accessoryView =nil;
	}
*/
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger row = [indexPath row];

	deAutosAppDelegate *appDelegate = (deAutosAppDelegate *)[[UIApplication sharedApplication] delegate];
	switch (self.tipo) {
		case 0:
			appDelegate.dMarca=[thearray objectAtIndex:row];
			appDelegate.dModelo=nil;
			[self.navigationController popToRootViewControllerAnimated:YES];
/*
			if (achoose==nil)
			{
				achoose =  [[BookMarked alloc] initWithNibName:@"BookMarked" bundle:nil];
			}
			((BookMarked*)achoose).tipo = 1;
			[self.navigationController pushViewController:(BookMarked*)achoose animated:YES];
			[((BookMarked*)achoose) dofill];
 */
			break;
			
		case 1:
			
			if(row!=0)
			{
				appDelegate.dModelo=[thearray objectAtIndex:row];
			}
			else
			{
				appDelegate.dModelo=nil;
			}
			[self.navigationController popToRootViewControllerAnimated:YES];
			break;
			
		case 2:
			
			if(row!=0)
			{
				appDelegate.dProvincia=[thearray objectAtIndex:row];
				appDelegate.dLocalidad=nil;
			}
			else
			{	
				appDelegate.dProvincia=nil;
				appDelegate.dLocalidad=nil;
				
			}
			
		
			[self.navigationController popToRootViewControllerAnimated:YES];

/*
			if (achoose==nil)
			{
				achoose =  [[BookMarked alloc] initWithNibName:@"BookMarked" bundle:nil];
			}
			appDelegate.dLocalidad=nil;
			((BookMarked*)achoose).tipo = 3;
			[self.navigationController pushViewController:(BookMarked*)achoose animated:YES];
			[((BookMarked*)achoose) dofill];
 */
			break;
			
		case 3:
			if(row!=0)
			{
				appDelegate.dLocalidad=[thearray objectAtIndex:row];
				
			}
			else
			{	
				
				appDelegate.dLocalidad=nil;
				
			}
			[self.navigationController popToRootViewControllerAnimated:YES];
			break;
			
		case 4:
			appDelegate.dCombustible=[thearray objectAtIndex:row];
			[self.navigationController popToRootViewControllerAnimated:YES];
			break;
		case 5:
			appDelegate.desdeano=[thearray objectAtIndex:row];
			[self.navigationController popToRootViewControllerAnimated:YES];
			break;

		case 6:
			appDelegate.hastaano=[thearray objectAtIndex:row];
			[self.navigationController popToRootViewControllerAnimated:YES];
			break;
			
			
		default:
			break;
	}

	[tv deselectRowAtIndexPath:indexPath	animated:YES];
	
	return indexPath;
}

/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	[tempArray addObject:@"1"];
	[tempArray addObject:@"2"];
	[tempArray addObject:@"2"];
	[tempArray addObject:@"2"];
	[tempArray addObject:@"2"];
	[tempArray addObject:@"2"];
	[tempArray addObject:@"2"];
	[tempArray addObject:@"2"];
	[tempArray addObject:@"2"];
	[tempArray addObject:@"2"];

	return tempArray;

}
*/





@end

