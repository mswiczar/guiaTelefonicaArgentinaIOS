//
//  About.m
//  iGPS
//
//  Created by Moises Swiczar on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "About.h"
#import "numeriVerdiAppDelegate.h"

@implementation About

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"Créditos";
		self.tabBarItem.image = [UIImage imageNamed:@"about.png"];

    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
- (void)viewWillAppear:(BOOL)animated
{
	numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate trackpage:@"/About"];
	
}


- (void)dealloc {
    [super dealloc];
}

-(IBAction) clickDona:(id)aobj
{
	NSString *url = [NSString stringWithFormat: @"%@",@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6R7J9JVJG82WE"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];	

	
}
-(IBAction) clickEmail:(id)aobj
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setToRecipients:[NSArray arrayWithObject:@"mswiczar@gmail.com"]];
	[picker setSubject:@"Telefonos utiles."];
	
	
	
	NSString *emailBody = [NSString stringWithFormat:@"%@",@"Deseo ingresar mi número telefónico a este aplicativo.\n\n\nCaracterística interurbana: \nNúmero de telefono: \nDescripción: \nCategoría: \nProvincia: \nCiudad: \nCodigo Postal: \n"];
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
	
	
	
}



-(IBAction) clickURL:(id)aobj
{
	NSString *url = [NSString stringWithFormat: @"%@",@"http://www.mswiczar.com"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];	

}

-(IBAction) clickApp1:(id)aobj
{
	
	
	NSString *url = [NSString stringWithFormat: @"%@",@"http://itunes.apple.com/it/app/apertodomenica/id373620881?mt=8"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];	

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


	
-(IBAction) clickEmailContacto:(id)aobj
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setToRecipients:[NSArray arrayWithObject:@"mswiczar@gmail.com"]];
	[picker setSubject:@"Me gustaria contactarme con el desarrollador"];
	
	
	
	NSString *emailBody = [NSString stringWithFormat:@"%@",@"Hola Sr desarrollador de la guía telefónica, me gustaria contactarme contigo:\nMi nombre es: \nMi telefono es: \nMi celular es: \nEl motivo es: \n"];
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
	

}





@end
