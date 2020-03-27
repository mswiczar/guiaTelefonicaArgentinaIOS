//
//  MSCerca.m
//  numeriVerdi
//
//  Created by Moises Swiczar on 6/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.


#import "MSCerca.h"
#import "MSDBCall.h"
#import "numeriVerdiAppDelegate.h"
#import "MSBlancas.h"
#import "UContact.h"

@implementation MSCerca
@synthesize stringcall;


-(void)workOnBackground:(BOOL)background
{
	self.view.userInteractionEnabled = !background;
	if (background)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[backAlert show];
		[progressInd startAnimating];
	}
	else
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[progressInd stopAnimating];
		[backAlert dismissWithClickedButtonIndex:0 animated:YES];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	
	numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate trackpage:@"/Search"];
}
	 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title = @"Buscar";
		self.tabBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
		theDetail=nil;
		thearray = [[NSMutableArray alloc]init];
		
		progressInd = [[UIActivityIndicatorView alloc] init];
		progressInd.hidesWhenStopped = YES;
		progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		[progressInd sizeToFit];
		progressInd.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleTopMargin |
										UIViewAutoresizingFlexibleBottomMargin);
		
		backAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", @"")
											   message:NSLocalizedString(@"Buscando información.\nPor favor aguarde.", @"") 
											   delegate:nil 
											   cancelButtonTitle:nil
											   otherButtonTitles:nil];
		
		progressInd.center = CGPointMake(backAlert.frame.size.width / 2.0, -5.0);
		[backAlert addSubview:progressInd];
		
		numeriVerdiAppDelegate *appDelegate = (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		
		posicion_default=1;

		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"persiste.txt"];
		BOOL success = [fileManager fileExistsAtPath:writableDBPath];
		if (success) 
		{
			NSMutableDictionary *atemp = [[NSMutableDictionary alloc]initWithContentsOfFile:writableDBPath];
			posicion_default=	[[atemp objectForKey:@"default"] intValue];
			[atemp release];
		}
		
		
		
		
		
		
		thedictSearchProv =  [appDelegate.thearrayProvincias objectAtIndex:posicion_default];
		
		
		
		thedictsearch  = [[NSMutableDictionary alloc] init];

		
    }
    return self;
}



-(void) keyboardWillShow:(NSNotification *) note
{
	CGRect aux = arectOriginal;
	aux.size.height = 160;
	thetable.frame= aux;
}


-(void) keyboardWillHide:(NSNotification *) note
{
	thetable.frame = arectOriginal;
}


-(void) clickPosition:(id)aobj
{
	
	if (Timerrunning) {
		return;
	}
	[thetxt resignFirstResponder];
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationDelegate:self];
	
	
	CGRect arect;
	arect = thepicker.frame;
	arect.origin.y = 160;
	thepicker.frame = arect;
	
	arect = thetool.frame;
	arect.origin.y =120;
	thetool.frame = arect;
	NSInteger component = 0;
	[thepicker selectRow:posicion_default inComponent:component animated:YES];

	[UIView commitAnimations];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	thetable.backgroundColor = [UIColor clearColor];
	arectOriginal = thetable.frame;
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
	[nc addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
	
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn addTarget:self action:@selector(clickPosition:) forControlEvents:UIControlEventTouchUpInside];
	btn.frame = CGRectMake(0, 0, 31, 31);
	[btn setImage:[UIImage imageNamed:@"Compass.png"] forState:UIControlStateNormal];
	thecompass = [[UIBarButtonItem alloc] initWithCustomView:btn];
	self.navigationItem.rightBarButtonItem = thecompass;
	nombre=YES;
	thesegment.selectedSegmentIndex=0;
//	[thetxt becomeFirstResponder];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 75;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	NSInteger salida=0;
	if ([thearray count] >0)
	{
		if (([thearray count] % 10) == 0)
		{
			salida = [thearray count]+1;	
		}
		else 
		{
			salida= [thearray count];
		}

	}
	else 
	{
		salida= [thearray count];
	}
	return salida;
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
		numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (!appDelegate.is_ipod)
		{
			cell.imageView.image =[UIImage imageNamed:@"gp.png"];
		}
	}
	return cell;
}



- (UITableViewCell *)obtainTableCellForRowMore:(NSInteger)row
{
	UITableViewCell *cell = nil;
	cell = [thetable dequeueReusableCellWithIdentifier:@"CellMore"];
	if (cell == nil)
	{
		cell = [[[CellMore alloc] initWithFrame:CGRectZero reuseIdentifier:@"CellMore"] autorelease];
	}
	thecell = (CellMore*)cell;
	return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	NSMutableDictionary * thedi = [thearray objectAtIndex:row];
	thedictionarytosave=[thearray objectAtIndex:row];
	if(theDetail==nil)
	{
		theDetail = [[MSNumeroDetail alloc]initWithNibName:@"MSNumeroDetail" bundle:nil];
	}
	[thetxt resignFirstResponder];
	numeriVerdiAppDelegate *appDelegate = (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];

	[MSDBCall insertHist:thedi db:appDelegate.database];
	theDetail.thedict = thedi;
	[self.navigationController pushViewController:theDetail animated:YES];
	[theDetail show];
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *cell;
	NSInteger row = [indexPath row];
	
	if (row ==[thearray count])
	{
		cell = [self obtainTableCellForRowMore:row];
		cell.selectionStyle = 	UITableViewCellSelectionStyleGray;

	}
	else 
	{
		cell = [self obtainTableCellForRow:row];
		cell.selectionStyle = 	UITableViewCellSelectionStyleGray;

		NSMutableDictionary * thedi = [thearray objectAtIndex:row];
		cell.textLabel.text = [NSString stringWithFormat:@"%@\nTelefono: %@",
							   [thedi objectForKey:@"nombre"] , [thedi objectForKey:@"tel"]];
		cell.detailTextLabel.text =[NSString stringWithFormat:@"%@", [thedi objectForKey:@"direccion"]];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
	}
	return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger row = [indexPath row];
	[thetable deselectRowAtIndexPath:indexPath	animated:YES];
	numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (row ==[thearray count])
	{
		 if (([thearray count] % 10) == 0)
		 {
			 
			 numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
			 [appDelegate updateStatus];
			 if (appDelegate.internetConnectionStatus==NotReachable)
			 {
				 [appDelegate  shownotreacheable];
			 }
			 else 
			 {
				 [thecell  start];
				 self.view.userInteractionEnabled =NO;
				 
				 thetimer = [NSTimer scheduledTimerWithTimeInterval:	.1		// seconds
															 target:		self
														   selector:	@selector (atimersearchwie2:)
														   userInfo:	self		
															repeats:	NO];
				 
			 }
			 
		 }
		 else 
		 {
				
			 numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
			 if (!appDelegate.is_ipod)
			 {
				 NSMutableDictionary * thedi = [thearray objectAtIndex:row];

				 self.stringcall = [NSString stringWithFormat:@"%@",[thedi objectForKey:@"tel"]];
				 UIAlertView * alr = [[UIAlertView alloc] initWithTitle:@"Guía Telefónica" message:@"Confirma llamada?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si",nil];
				[alr show];
				[alr release];
			 }
			
		 }
		
		 
	}
	else 
	{
		numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (!appDelegate.is_ipod)
		{
			
		
			NSMutableDictionary * thedi = [thearray objectAtIndex:row];
			self.stringcall = [NSString stringWithFormat:@"%@",[thedi objectForKey:@"tel"]];
			UIAlertView * alr = [[UIAlertView alloc] initWithTitle:@"Guía Telefónica" message:@"Confirma llamada?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si",nil];
			[alr show];
			[alr release];
		}
	}

	
	return indexPath;
}




-(IBAction) clickcancel:(id)aobj
{
	[thetxt resignFirstResponder];
}

-(void) atimersearchwie:(id)aobj
{
	pagina=1;
	Timerrunning=YES;
	//numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	[thearray removeAllObjects];
						
	[thedictsearch setObject:thetxt.text forKey:@"str"];
	[thedictsearch setObject:[thedictSearchProv objectForKey:@"busqueda"] forKey:@"str_prov"];
	[thedictsearch setObject:[thedictSearchProv objectForKey:@"id"] forKey:@"id_provincia"];
	
	[MSBlancas buscar:thedictsearch thearray:thearray pagina:1];
    
	[self workOnBackground:NO];
	[thetable reloadData];
	Timerrunning=NO;
	
	
	
	return;
}


-(void) atimersearchwie2:(id)aobj
{
	pagina++;
	Timerrunning=YES;

	
	[thedictsearch setObject:thetxt.text forKey:@"str"];
	[thedictsearch setObject:[thedictSearchProv objectForKey:@"busqueda"] forKey:@"str_prov"];
	[thedictsearch setObject:[thedictSearchProv objectForKey:@"id"] forKey:@"id_provincia"];
	
	[MSBlancas buscar:thedictsearch thearray:thearray pagina:pagina];
	[thecell  stop];
	self.view.userInteractionEnabled =YES;

	[thetable reloadData];
	Timerrunning=NO;
	
	
	return;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];

	[appDelegate updateStatus];
	if (appDelegate.internetConnectionStatus==NotReachable)
	{
		[appDelegate  shownotreacheable];
		return YES;
	}
	
	
	[self workOnBackground:YES];
	thetimer = [NSTimer scheduledTimerWithTimeInterval:	.1		// seconds
												target:		self
											  selector:	@selector (atimersearchwie:)
											  userInfo:	self		
											   repeats:	NO];
	
	
	[textField resignFirstResponder];
	return YES;
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	if(theDetail!=nil)
	{
		[theDetail release];
		theDetail=nil;
	}
	
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	if(theDetail!=nil)
	{
		[theDetail release];
		theDetail=nil;
	}
	
    [super dealloc];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	numeriVerdiAppDelegate *appDelegate = (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [appDelegate.thearrayProvincias count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	numeriVerdiAppDelegate *appDelegate = (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	return [[appDelegate.thearrayProvincias objectAtIndex:row] objectForKey:@"desc"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
	
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
{
	if(nombre)
	{
		return [thedictSearchProv objectForKey:@"desc"];
	}
	else 
	{
		return @"";
		
	}
	return @"";

}



-(IBAction) clickHide:(id) aobj
{
	
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationDelegate:self];
	
	
	CGRect arect;
	arect = thepicker.frame;
	arect.origin.y = 524;
	thepicker.frame = arect;
	
	arect = thetool.frame;
	arect.origin.y =480;
	thetool.frame = arect;
	
	[UIView commitAnimations];
	[thearray removeAllObjects];
	[thetable reloadData];
	
	
	numeriVerdiAppDelegate *appDelegate = (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	thedictSearchProv = [appDelegate.thearrayProvincias objectAtIndex:[thepicker selectedRowInComponent:0]] ;
	posicion_default = [thepicker selectedRowInComponent:0];
	
	
	
	NSMutableDictionary * thepersiste =[[NSMutableDictionary alloc]init];
	[thepersiste setObject:[NSString stringWithFormat:@"%d",posicion_default] forKey:@"default"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"persiste.txt"];
	
	if ([thepersiste writeToFile:writableDBPath atomically:YES])
	{
		
	}
	else
	{
		
	}
	[thepersiste release];
	
	
	
	
}

-(IBAction) clickSegment:(id) aobj
{
	if (thesegment.selectedSegmentIndex==0)
	{
		nombre=YES;
		self.navigationItem.rightBarButtonItem = thecompass;

	}
	else 
	{
		nombre=NO;
		self.navigationItem.rightBarButtonItem = nil;
		
	}
	[thearray removeAllObjects];
	[thetable reloadData];

}



-(IBAction) clickcancelPicker:(id)aobj
{
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationDelegate:self];
	
	
	CGRect arect;
	arect = thepicker.frame;
	arect.origin.y = 524;
	thepicker.frame = arect;
	
	arect = thetool.frame;
	arect.origin.y =480;
	thetool.frame = arect;
	
	[UIView commitAnimations];
	[thearray removeAllObjects];
	[thetable reloadData];
	

}



@end
