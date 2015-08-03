//
//  BannerViewController.m
//  bochk
//
//  Created by Jeff Cheung on 10年12月16日.
//  Copyright 2010 MTel Limited. All rights reserved.
//

#import "BannerViewController.h"

@implementation BannerViewController

@synthesize rollTiming = _rollTiming;

#define ORIGIN_Y_SHOW 370 //377
#define ORIGIN_Y_HIDE 425

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _banner_list = [NSMutableArray new];
		_banner_index = 0;
        isShowing = NO;
        
        _reload_timer = nil;
        _banner_timer = nil;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {	
	[self terminate];
    [super dealloc];
}
 
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark common functions
-(void)startTimerToHideBanner
{
    DEBUGLog
    if (_banner_timer != nil)
    {
        [self stopTimerToHideBanner];
    }
    
	if(_banner_timer == nil)
    {
		//_banner_timer = [NSTimer scheduledTimerWithTimeInterval:timeIntervalForBanner target:self selector:@selector(show_image) userInfo:nil repeats:YES];
        
        NSTimeInterval timeInterval = self.rollTiming ;
        
        if (timeInterval == 0)
        {
            timeInterval = timeIntervalForBanner;
        }
        
        _banner_timer = [[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(hide) userInfo:nil repeats:NO] retain];
	}
}

-(void)stopTimerToHideBanner
{
    DEBUGLog
	if(_banner_timer != nil){
        if ([_banner_timer isValid])
            [_banner_timer invalidate];
        [_banner_timer release];
		_banner_timer = nil;
	}	
}


-(void)startTimerToReload
{
    DEBUGLog
    if (_reload_timer != nil)
    {
        [self stopTimerToReload];
    }
    
    if (_reload_timer == nil)
    {
        _reload_timer = [[NSTimer scheduledTimerWithTimeInterval:timeIntervalForReload target:self selector:@selector(send_request) userInfo:nil repeats:NO] retain];
    }
}

-(void)stopTimerToReload
{
    DEBUGLog
    if(_reload_timer != nil){
        if ([_reload_timer isValid])
            [_reload_timer invalidate];
        [_reload_timer release];
		_reload_timer = nil;
	}
}


-(void)show_image {
    DEBUGLog
    
	if(_banner_list != nil || [_banner_list count] > 0)
	{
//        NSString *extension = [[[_banner_list objectAtIndex:i] objectForKey:@"image"] pathExtension];
        
        
        UIView *currentImageView = [vw_images viewWithTag:(CachedImageViewBaseTag + _banner_index)];
        if (currentImageView != nil)
        {
            [vw_images bringSubviewToFront:currentImageView];
            _banner_index++;
            if (_banner_index >= [_banner_list count]) {
                _banner_index = 0;
            }
        }
	}
}

-(void)send_request{
    
    if (_banner_request != nil)
    {
        [_banner_request clearDelegatesAndCancel];
        [_banner_request release];
        _banner_request = nil;
    }
    
	if(_banner_request == nil){
		_banner_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@lang=%@", 
																					adlistAPI, 
																					[CoreData sharedCoreData].lang	
																					]]];
		_banner_request.delegate = self;
		[[CoreData sharedCoreData].common_queue addOperation:_banner_request];
		DEBUGMSG(@"Banner API: %@", _banner_request.url);
	}
}

-(void)terminate{
    
	[self stopTimerToHideBanner];
    [self stopTimerToReload];
    
	if(_banner_list != nil){
		[_banner_list removeAllObjects];
	}    
	if(_banner_request != nil){
        [_banner_request clearDelegatesAndCancel];
        [_banner_request release];
        _banner_request = nil;
	}
	for(int k = [[self.view subviews] count] - 1; k >= 0; k--){
		NSObject *obj = [[self.view subviews] objectAtIndex:k];
		if([obj isKindOfClass:[CachedImageView class]]){
			[(CachedImageView*)obj removeFromSuperview];
			obj = nil;
		}
	}
    
    if (_webview_image != nil)
    {
        [_webview_image release];
        _webview_image = nil;
    }
}

-(void)show
{
    if (isShowing)
    {
        DEBUGMSG(@"Currently already showing");
        return;
    }
    
    if ([_banner_list count] == 0)
    {
        DEBUGMSG(@"No banner loaded");
        return;
    }
    
    DEBUGLog
    
    [self show_image];
    
    CGRect frame = self.view.frame;
    frame.origin.y = ORIGIN_Y_HIDE;
    self.view.frame = frame;
    
    self.view.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    
    frame.origin.y = ORIGIN_Y_SHOW;
    self.view.frame = frame;
    
    [UIView commitAnimations];
    
    isShowing = YES;
    
    [self startTimerToHideBanner];
}

-(void)hide
{
    if (!isShowing)
    {
        return;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didHidden)];
    CGRect frame = self.view.frame;
    frame.origin.y = ORIGIN_Y_HIDE;
    self.view.frame = frame;
    [UIView commitAnimations];
    
    [self stopTimerToHideBanner];
    
    isShowing = NO;
}

-(void)didHidden
{
    self.view.hidden = YES;
    
    [self stopTimerToHideBanner];
    
    isShowing = NO;
    
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate
-(void) requestFinished:(ASIHTTPRequest *)request {
    DEBUGMSG(@"BANNER: %@", [request responseString]);
	[_banner_list removeAllObjects];
	NSArray *head_node = PerformXMLXPathQuery([request responseData], @"//items/item");
	for (int i = 0; i < [head_node count]; i++) {
		NSArray *result_node = [[head_node objectAtIndex:i] objectForKey:@"nodeChildArray"];
		NSMutableDictionary *record = [NSMutableDictionary new];
		for (int j = 0; j < [result_node count]; j++){
			if([[[result_node objectAtIndex:j] objectForKey:@"nodeChildArray"] count] == 1){
				if([[[[result_node objectAtIndex:j] objectForKey:@"nodeChildArray"] objectAtIndex:0] objectForKey:@"nodeContent"] != nil)
					[record setObject:[[[[result_node objectAtIndex:j] objectForKey:@"nodeChildArray"] objectAtIndex:0] objectForKey:@"nodeContent"] forKey:[[result_node objectAtIndex:j] objectForKey:@"nodeName"]];
			}
			else {
				if([[result_node objectAtIndex:j] objectForKey:@"nodeContent"] != nil)
					[record setObject:[[result_node objectAtIndex:j] objectForKey:@"nodeContent"] forKey:[[result_node objectAtIndex:j] objectForKey:@"nodeName"]];
			}		
		}
		
		[_banner_list addObject:record];
		
		if(record != nil){
			[record release];
			record = nil;
		}
	}
    
    DEBUGMSG(@"BANNER LIST: %@", _banner_list);
    
    NSArray *rolltiming_node = PerformXMLXPathQuery([request responseData], @"//itemsInfo/rolltiming");
    if (rolltiming_node != nil && [rolltiming_node count] > 0)
    {
        NSString *nodeContent = [[rolltiming_node objectAtIndex:0] objectForKey:@"nodeContent"];
        if (nodeContent != nil)
        {
            NSTimeInterval rolltiming = [nodeContent doubleValue];
            if (rolltiming > 0)
            {
                self.rollTiming = rolltiming / 1000;
            }
        }
    }
    
    DEBUGMSG(@"Roll Timing: %.6f", self.rollTiming)
	
	if(_banner_request != nil){
		[_banner_request release];
		_banner_request = nil;
	}
	
	for(int k = 0; k < [_banner_list count]; k++){
		CachedImageView *cacheImageView = [[CachedImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
		[cacheImageView loadImageWithURL:[[_banner_list objectAtIndex:k] objectForKey:@"image"]];
		cacheImageView.tag = CachedImageViewBaseTag + k;
		cacheImageView.userInteractionEnabled = NO;
		//[self.view addSubview:cacheImageView];
        [vw_images addSubview:cacheImageView];
		if(cacheImageView != nil){
			[cacheImageView release];
			cacheImageView = nil;
		}
	}
	
    // wait for next show() to show
    //[self show_image];
    
}

-(void) requestFailed:(ASIHTTPRequest *)request {
	if(_banner_request != nil){
		[_banner_request release];
		_banner_request = nil;
	}
    
	//[self send_request];    
    [self startTimerToReload];
}

#pragma mark -
#pragma mark handle button events

-(IBAction)click_banner_button:(UIButton *)button{
    DEBUGLog
    
	if (_banner_list == nil || [_banner_list count] == 0) {
		return;
	}
	
	//int showing_banner_index = ((CachedImageView*)[[self.view subviews] objectAtIndex:([[self.view subviews] count] - 1)]).tag - CachedImageViewBaseTag;
    int showing_banner_index = ((CachedImageView*)[[vw_images subviews] objectAtIndex:([[vw_images subviews] count] - 1)]).tag - CachedImageViewBaseTag;

	if(showing_banner_index < [_banner_list count]){
		/*
		if([[_banner_list objectAtIndex:showing_banner_index] objectForKey:@"id"] != nil && [[[_banner_list objectAtIndex:showing_banner_index] objectForKey:@"id"] length] > 0){
		
		}
         */
		NSString *link = [[_banner_list objectAtIndex:showing_banner_index] objectForKey:@"link"];
        
		//if([[_banner_list objectAtIndex:showing_banner_index] objectForKey:@"link"] != nil && [[[_banner_list objectAtIndex:showing_banner_index] objectForKey:@"link"] length] > 0)
        if (link != nil)
        {
			BannerDetailsViewController *bannerDetailsViewController = [[BannerDetailsViewController alloc] initWithNibName:@"BannerDetailsViewController" bundle:nil];
			bannerDetailsViewController._url_path = link;
            [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate).navigation_controller presentModalViewController:bannerDetailsViewController animated:YES];
			[bannerDetailsViewController release];
		}
	}
}

-(IBAction)clickHideButton:(UIButton *)button
{
    [self hide];
}


#pragma mark -
#pragma mark CachedImageView delegate
-(void) imageLoaded:(CachedImageView *)cachedImageView{
	
}

-(void) imageFailed:(CachedImageView *)cachedImageView{
	
}

@end
