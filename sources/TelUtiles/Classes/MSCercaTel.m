//
//  MSCerca.m
//  numeriVerdi
//
//  Created by Moises Swiczar on 6/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.


#import "MSCercaTel.h"
#import "MSDBCall.h"
#import "numeriVerdiAppDelegate.h"
#import "MSBlancas.h"
#import "UContact.h"

@implementation MSCercaTel
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
	
	viewPurchase.alpha =0;
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"purchased"])
	{
		[appDelegate trackpage:@"/SearchTelBought"];
	}
	else
	{
		viewPurchase.alpha =1;
		[appDelegate trackpage:@"/SearchNoTelBought"];
	}
	
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title = @"Buscar x Nro";
//		self.tabBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
		self.tabBarItem.image = [UIImage imageNamed:@"phone.png"];
		theDetail=nil;
		
		progressInd = [[UIActivityIndicatorView alloc] init];
		progressInd.hidesWhenStopped = YES;
		progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		[progressInd sizeToFit];
		progressInd.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleTopMargin |
										UIViewAutoresizingFlexibleBottomMargin);
		
		backAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Guía telefónica", @"")
											   message:NSLocalizedString(@"Buscando información.\nPor favor aguarde.", @"") 
											   delegate:nil 
											   cancelButtonTitle:nil
											   otherButtonTitles:nil];
		
		progressInd.center = CGPointMake(backAlert.frame.size.width / 2.0, -5.0);
		[backAlert addSubview:progressInd];
		
		thearray = [[NSMutableArray alloc] init];
		thedictsearch  = [[NSMutableDictionary alloc] init];

		
    }
    return self;
}



-(void) keyboardWillShow:(NSNotification *) note
{
}


-(void) keyboardWillHide:(NSNotification *) note
{
}

-(IBAction) clickHide:(id)aobj
{

	
	txtResult.text=@"";
	butonmore.alpha=0;
	thetxt1.text =@"";
	thetxt2.text =@"";
	thetxt3.text =@"";
		[thetxt1 resignFirstResponder];
		[thetxt2 resignFirstResponder];
		[thetxt3 resignFirstResponder];
		[txtResult resignFirstResponder];
}



- (void)viewDidLoad {
    [super viewDidLoad];
	txtResult.backgroundColor = [UIColor clearColor];
	butonmore.alpha=0;
}


-(void) atimersearchwie:(id)aobj
{
	
		NSString* strsearch = [NSString stringWithFormat:@"%@-%@-%@",thetxt1.text,thetxt2.text,thetxt3.text];
		[thedictsearch setObject:strsearch forKey:@"telefono"];
	
		[MSBlancas buscarTelefonos:thedictsearch thearray:thearray ];
		[self workOnBackground:NO];
		if ([thearray count]==0)
		{
			butonmore.alpha=0;
			txtResult.text = [NSString stringWithFormat:@"La búsqueda: %@\nNo se encuentro en la guía",strsearch];
		}
		else 
		{
					butonmore.alpha=1;
			NSMutableDictionary * thedi = [thearray objectAtIndex:0];
			txtResult.text = [NSString stringWithFormat:@"La búsqueda: %@\nRetornó:\nNombre: %@\nDomicilio: %@",strsearch,  [thedi objectForKey:@"nombre"],[thedi objectForKey:@"direccion"]];
		}
	
	return;
}



-(IBAction) clickSearch:(id)aobj
{

	[thetxt1 resignFirstResponder];
	[thetxt2 resignFirstResponder];
	[thetxt3 resignFirstResponder];
	[txtResult resignFirstResponder];
	txtResult.text=@"";
	[thearray removeAllObjects];
	
	numeriVerdiAppDelegate * appDelegate= (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[appDelegate updateStatus];
	if (appDelegate.internetConnectionStatus==NotReachable)
	{
		[appDelegate  shownotreacheable];
		return;
	}
	
	
	[self workOnBackground:YES];
	thetimer = [NSTimer scheduledTimerWithTimeInterval:	.1		// seconds
												target:		self
											  selector:	@selector (atimersearchwie:)
											  userInfo:	self		
											   repeats:	NO];
	
}

-(IBAction) clickMore:(id)aobj
{
	[thetxt1 resignFirstResponder];
	[thetxt2 resignFirstResponder];
	[thetxt3 resignFirstResponder];
	[txtResult resignFirstResponder];
	
	if ([thearray count] != 0) 
	{
		NSMutableDictionary * thedi = [thearray objectAtIndex:0];
		if(theDetail==nil)
		{
			theDetail = [[MSNumeroDetail alloc]initWithNibName:@"MSNumeroDetail" bundle:nil];
		}
		numeriVerdiAppDelegate *appDelegate = (numeriVerdiAppDelegate *)[[UIApplication sharedApplication] delegate];
		[MSDBCall insertHist:thedi db:appDelegate.database];
		theDetail.thedict = thedi;
		[self.navigationController pushViewController:theDetail animated:YES];
		[theDetail show];
	}
	
	
	
	
}







-(IBAction) clickcancel:(id)aobj
{
///	[thetxt resignFirstResponder];
}






- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	/*
	 
	 */
	
	return YES;
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if(buttonIndex==1)
	{
		NSString * thestr=@"";
		[UContact gettel:self.stringcall thetelaux:&thestr];
		NSString *url = [NSString stringWithFormat: @"tel://%@",thestr];
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



- (void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] 
								 initWithProductIdentifiers: [NSSet setWithObject: @"com.mswiczar.guiatel.inap1"]];
	request.delegate = self;
	[request start];
}



-(IBAction) clickPurchase:(id)aobj
{
	if([SKPaymentQueue canMakePayments])
	{
		[[SKPaymentQueue defaultQueue]addTransactionObserver:self];
		[self requestProductData];
		
	}
	else 
	{
		purchased=NO;
		UIAlertView * aleert = [[UIAlertView alloc] initWithTitle:@"Lamentablemente esta operacion no esta habilitada" message:@"Para poder utilizar este modulo debera activar (in app purchase)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[aleert show];
		[aleert release];	
	}
	
	
}

-(void)purchaseProduct:(SKProduct *)aProduct
{
	SKPayment *payment = [SKPayment paymentWithProduct:aProduct];
	[[SKPaymentQueue defaultQueue]addPayment:payment];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSLog(@"%@",[response products]);
	SKProduct *product = [[response products] lastObject];
	[self purchaseProduct:product];
}


- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"purchased"];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	viewPurchase.alpha =0;

}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Transaccion: %@",[transaction transactionIdentifier]] message:@"Transaccion sin exito!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alrt show];
		[alrt release];
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
	viewPurchase.alpha =0;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"purchased"];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}



- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for(SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}












@end
