//
//  SimpleWebView.m
//  iNFL
//
//  Created by Moises Swiczar on 12/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleWebView.h"

@implementation SimpleWebView
@synthesize string_web;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"Web";
		self.string_web = @"http://www.guiaoleo.com.ar";
		self.tabBarItem.image = [UIImage imageNamed:@"web.png"];

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

	CGRect frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
	UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
	progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
									 UIViewAutoresizingFlexibleRightMargin |
									 UIViewAutoresizingFlexibleTopMargin |
									 UIViewAutoresizingFlexibleBottomMargin);
	
	UINavigationItem *navItem = self.navigationItem;
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:progressView];
	navItem.rightBarButtonItem = buttonItem;
	// we are done with these since the nav bar retains them:
	[progressView release];
	[buttonItem release];
		

	// start fetching the default web page
	[(UIActivityIndicatorView *)navItem.rightBarButtonItem.customView startAnimating];							
	[self go];
	
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


- (void)dealloc {
    [super dealloc];
}


- (void)stopProgressIndicator
{
	UINavigationItem *navItem = self.navigationItem;
	UIActivityIndicatorView *progView = (UIActivityIndicatorView *)navItem.rightBarButtonItem.customView;
	[progView stopAnimating];
	progView.hidden = YES;
}


-(void)go
{
	UINavigationItem *navItem = self.navigationItem;
	[(UIActivityIndicatorView *)navItem.rightBarButtonItem.customView startAnimating];							
	
	[myview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string_web]]];
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	UINavigationItem *navItem = self.navigationItem;
	
	UIActivityIndicatorView *progView = (UIActivityIndicatorView *)navItem.rightBarButtonItem.customView;
	[progView startAnimating];
	progView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self stopProgressIndicator];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[self stopProgressIndicator];
	//NSString* errorString = [NSString stringWithFormat:@"<html><center><font size=+5 color='red'>Servicio no disponible<br></font></center></html>"];
	//[myWebView loadHTMLString:errorString baseURL:nil];
}






@end
