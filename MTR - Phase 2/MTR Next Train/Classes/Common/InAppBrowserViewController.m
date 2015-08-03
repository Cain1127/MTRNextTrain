//
//  InAppBrowserViewController.m
//  MTR
//
//  Created by Jeff Cheung on 11年11月11日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "InAppBrowserViewController.h"

@implementation InAppBrowserViewController

@synthesize url_path = _url_path;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
	if(_web_view != nil){
		[_web_view stopLoading];
        [_web_view release];
		_web_view.delegate = nil;
	}
	if(_url_path != nil){
		[_url_path release];
		_url_path = nil;
	}
	if(_web_view_timer != nil){
		[_web_view_timer invalidate];
		_web_view_timer = nil;
	}
    if (_activity_indicator_view != nil)
    {
        [_activity_indicator_view release];
        _activity_indicator_view = nil;
    }
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(_url_path != nil && [_url_path length] > 0){
        NSLog(@"%@", _url_path);
        _activity_indicator_view.hidden = NO;
        [_web_view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url_path]]];
        _web_view_timer = [NSTimer scheduledTimerWithTimeInterval:timeOutInterval target:self selector:@selector(webViewTimeout) userInfo:nil repeats:NO];
        
        //ios 7 Alex
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            
            UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]autorelease];
            
            view.backgroundColor=[UIColor colorWithRed:213/255.0 green:215/255.0 blue:219/255.0 alpha:1];
            
            [self.view addSubview:view];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
        }
        
    }
}



-(void)viewWillDisappear:(BOOL)animated{
	NSHTTPCookie *cookie;
	NSHTTPCookieStorage *cookie_storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for(cookie in [cookie_storage cookies]){
		[cookie_storage deleteCookie:cookie];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Core
-(void)webViewTimeout{
	if(_web_view_timer != nil){
		[_web_view_timer invalidate];
		_web_view_timer = nil;
	}
	if(_web_view != nil){
		[_web_view stopLoading];
		_web_view.delegate = nil;
	}
    _activity_indicator_view.hidden = YES;
    
    //    [[CoreData sharedCoreData].connection_failed_view_controller showView];
    CustomAlertView *alert = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"no_connection_content_%@", [CoreData sharedCoreData].lang]), nil)];
    [alert show];
    [alert release];
}

#pragma -
#pragma Handle Click Button Events

-(IBAction)clickBackButton:(UIButton*)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIWebView delegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
	
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
	if(_web_view_timer != nil){
		[_web_view_timer invalidate];
		_web_view_timer = nil;
	}
    _activity_indicator_view.hidden = YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	if(error != nil && ([error code] == NSURLErrorNotConnectedToInternet || [error code] == NSURLErrorCannotFindHost || [error code] == NSURLErrorCannotConnectToHost)){
		if(_web_view_timer != nil){
			[_web_view_timer invalidate];
			_web_view_timer = nil;
		}
		if(_web_view != nil){
			[_web_view stopLoading];
			_web_view.delegate = nil;
		}
        _activity_indicator_view.hidden = YES;
        //        [[CoreData sharedCoreData].connection_failed_view_controller showView];
        
        CustomAlertView *alert = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"no_connection_content_%@", [CoreData sharedCoreData].lang]), nil)];
        [alert show];
        [alert release];
	}
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL =[ [ request URL ] retain ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ];
    }
    [ requestURL release ];
    return YES;
}

@end
