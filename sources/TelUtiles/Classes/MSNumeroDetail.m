//
//  MSNumeroDetail.m
//  numeriVerdi
//
//  Created by Moises Swiczar on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSNumeroDetail.h"

#import "numeriVerdiAppDelegate.h"
#import "MSDBCall.h"
#import "UContact.h"
#import "StorePick.h"

@implementation MSNumeroDetail
@synthesize thedict;
@synthesize calledbyFavorites;


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
	[appDelegate trackpage:@"/Detail"];
}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.title =@"Detalle";
        // Custom initialization
		calledbyFavorites=NO;
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
		
    }
    return self;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void) addressLocation {

	
	
	
	NSString * straux = @"";
	
	NSArray* chunks = [[thedict objectForKey:@"direccion"] componentsSeparatedByString: @"\n"];

	straux = [chunks objectAtIndex:0];
	
	NSMutableString *aux = [[NSMutableString alloc] initWithString:straux];
	[aux replaceOccurrencesOfString:@"LC" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [aux  length])];
	[aux replaceOccurrencesOfString:@"LCL" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [aux  length])];
	[aux replaceOccurrencesOfString:@" PB" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [aux  length])];
	
	
	
	
	NSString* theaxu2 = [NSString stringWithFormat:@"%@ %@",aux,[chunks objectAtIndex:1]];
	
	[aux release];
	
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
						   [theaxu2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//NSLog(@"domicilio :%@",labelDomicilio.text);
	
	
	
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
	
    double latitude = 0.0;
    double longitude = 0.0;
	
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else 
	{
		return;
		//Show error
    }
    location.latitude = latitude;
    location.longitude = longitude;
	
	MKCoordinateRegion region;
	
	MKCoordinateSpan span;
	span.latitudeDelta=0.01;
	span.longitudeDelta=0.01;
	region.span=span;
	
	[themap removeAnnotations:themap.annotations];

	region.center=location;
	[themap setRegion:region animated:YES];
	[themap regionThatFits:region];	
	
	
	StorePick *sp=[[StorePick alloc] initWithCoordinate:location];
	sp.thestore = thedict;
	[themap addAnnotation:sp];	
	
}



- (void)viewDidLoad {
    [super viewDidLoad];

	
	labelNombre.text =[thedict objectForKey:@"nombre"];
	labelTel.text =[thedict objectForKey:@"tel"];
	labelDomicilio.text =[thedict objectForKey:@"direccion"];
	
	numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[appDelegate updateStatus];
	if (appDelegate.internetConnectionStatus==NotReachable)
	{
		[appDelegate  shownotreacheable];
		return;
	}
	
	
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



-(void) atimersearchwie:(id)aobj
{

	[self addressLocation];
	
	[self workOnBackground:NO];
	
	
	
	return;
}

-(void) show
{
	labelNombre.text =[thedict objectForKey:@"nombre"];
	labelTel.text =[thedict objectForKey:@"tel"];
	labelDomicilio.text =[thedict objectForKey:@"direccion"];
	
	numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[appDelegate updateStatus];
	if (appDelegate.internetConnectionStatus==NotReachable)
	{
		[appDelegate  shownotreacheable];
		return;
	}
	
	
	[self workOnBackground:YES];
	NSTimer* thetimer = [NSTimer scheduledTimerWithTimeInterval:	.1		// seconds
												target:		self
											  selector:	@selector (atimersearchwie:)
											  userInfo:	self		
											   repeats:	NO];
	
	
}

-(IBAction) clickShare:(id)aobj
{
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@"Guía Telefónica"];
	NSString *statusString =
	[NSString stringWithFormat:@"Nombre: %@<br>Teléfono: %@<br>Dirección: %@<br>%@%@%@%@",
	 [thedict objectForKey:@"nombre"],
	 [thedict objectForKey:@"tel"],
	 [thedict objectForKey:@"direccion"],

	 @"</b><br>Enviado desde <br>",
	 @"Guía telefónica de la Republica Argentina<br>",
	 @"Puedes descargarlo desde<br>",
	 @"<a href='http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=401885772'>http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=401885772</a>"];
	
	[picker setMessageBody:statusString isHTML:YES];
	
	
	
	
	[self presentModalViewController:picker animated:YES];
	[picker release];

}

-(IBAction) clickContacts:(id)aobj
{

	numeriVerdiAppDelegate *appDelegate = (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	UIActionSheet * theactionSheetContact	 = [[UIActionSheet alloc] initWithTitle:@"Guía Telefónica"
														 delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
												otherButtonTitles:@"Crear nuevo contacto",@"Anexar a contacto", @"Cancelar", nil];
	
	theactionSheetContact.actionSheetStyle = UIBarStyleBlackOpaque;
	theactionSheetContact.cancelButtonIndex=3;
	
	[theactionSheetContact showInView:appDelegate.mytabview.view];
	
}



-(IBAction) clickFav:(id)aobj
{
	if (calledbyFavorites)
	{
		UIAlertView * alr = [[UIAlertView alloc] initWithTitle:@"Guía Telefónica" message:@"Este Registro ya se encuentra en los favoritos" delegate:self cancelButtonTitle:@"Listo" otherButtonTitles:nil];
		[alr show];
		[alr release];
	}
	else 
	{
		UIAlertView * alr = [[UIAlertView alloc] initWithTitle:@"Guía Telefónica" message:@"Desea agregar este registro a sus favoritos?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si",nil];
		[alr show];
		theale =alr;
		[alr release];
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

	numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (theale==alertView)
	{
	
		if(buttonIndex==1)
		{
		
			[MSDBCall insertFav:thedict db:appDelegate.database];
			UIAlertView * alr = [[UIAlertView alloc] initWithTitle:@"Guía Telefónica" message:@"El teléfono ha sido agregado a los favoritos" delegate:self cancelButtonTitle:@"Listo" otherButtonTitles:nil];
			[alr show];
			[alr release];
		}
	
	}
	else 
	{
	}

}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			//		message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			//		message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			//		message.text = @"Result: failed";
			break;
		default:
			//		message.text = @"Result: not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
		
		if (buttonIndex == 0)
		{
			[UContact AddContact:thedict];
		}
		else
		{
			if (buttonIndex == 1)
			{
				
				
				if (theaddressbook==nil)
				{
					theaddressbook = [[AppendContact  alloc]init];
				}
				theaddressbook.thedetailStore = thedict;
				[self.navigationController presentModalViewController:theaddressbook animated:YES];
			}
		}
		
		return;
}






@end
