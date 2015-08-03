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

#define ORIGIN_Y_SHOW 350 //377
#define ORIGIN_Y_HIDE 425

#define ORIGIN_Y_SHOW_5 458
#define ORIGIN_Y_HIDE_5 513

#define ASIHTTPREQUEST_TAG_IMAGE 9999

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _banner_list = [NSMutableArray new];
		_banner_index = 0;
        _next_banner_index = 0;
        isShowing = NO;
        
        _reload_timer = nil;
        _banner_timer = nil;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if (isFive == YES) {
        [closeBtn setHidden:YES];
    }else{
        
    }
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
#pragma mark Timer functions
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


#pragma mark -
#pragma mark common functions

-(void)prepare_image
{
    DEBUGMSG(@"current: %i next: %i", _banner_index, _next_banner_index)
    
    if(_banner_list != nil || [_banner_list count] > 0)
	{
        UIWebView *preloadWebview = nil;
        
        if (_webview_on_top == 1)
        {
            preloadWebview = _webview_image_2;
        }
        else if (_webview_on_top == 2)
        {
            preloadWebview = _webview_image_1;
        }
        else {
            preloadWebview = _webview_image_1;
        }
        
        [self loadImageInWebview:preloadWebview withBannerIndex:_next_banner_index];
    }
}

-(void)loadImageInWebview:(UIWebView*)webview withBannerIndex:(int)bannerIndex
{
    DEBUGMSG(@"index: %i", bannerIndex)
    
    if (webview == nil)
        return;
    
    NSString *key = @"";
    if (webview == _webview_image_1)
        key = [NSString stringWithFormat:@"Webview1: index %i", bannerIndex];
    else if (webview == _webview_image_2)
        key = [NSString stringWithFormat:@"Webview2: index %i", bannerIndex];
    
    DEBUGMSG(@"%@", key)
    
    if (bannerIndex >= 0 && bannerIndex < [_banner_list count])
    {
        NSString *imageURL = [[_banner_list objectAtIndex:bannerIndex] objectForKey:@"image"];
        NSString *imagePath = [self pathOfImageFileWithURL:[NSURL URLWithString:imageURL]];
        
        DEBUGMSG(@"index: %i imagePath: %@", bannerIndex, imagePath)
        
        if (imagePath != nil && [[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        {
            NSString *imageFileName = [imagePath lastPathComponent];
            NSString *imageBasePath = [imagePath stringByReplacingOccurrencesOfString:imageFileName withString:@""];

            DEBUGMSG(@"imagePath Split: \n[%@]\n[%@]", imageBasePath, imageFileName)
            
            //NSString *htmlString = [NSString stringWithFormat:@"<html><header><meta name=\"viewport\" content=\"width=640, initial-scale=0.5, maximum-scale=1\"></header><body leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\"><img src='%@'/></body></html>", imageURL]; //imageFileName];
            NSString *htmlString = [NSString stringWithFormat:@"<html><header><meta name=\"viewport\" content=\"width=320\"></header><body leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\"><img src='%@' width=320 height=50 /></body></html>", imageURL]; //imageFileName];
            
            DEBUGMSG(@"HTML: %@", htmlString)
            
            [webview loadHTMLString:htmlString baseURL:nil];//  [NSURL fileURLWithPath:imageBasePath]];
        }
        else {
            //NSString *htmlString = [NSString stringWithFormat:@"<html><header><meta name=\"viewport\" content=\"width=640, initial-scale=0.5, maximum-scale=1\"></header><body leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\"></body></html>"];
            NSString *htmlString = [NSString stringWithFormat:@"<html><header><meta name=\"viewport\" content=\"width=320\"></header><body leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\"></body></html>"];
            [webview loadHTMLString:htmlString baseURL:nil];
        }
    }
}

-(void)show_image {
    DEBUGLog
    
	if(_banner_list != nil || [_banner_list count] > 0)
	{
        // swap webview to show next image
        if (_webview_on_top == 1)
        {
            [vw_images bringSubviewToFront:_webview_image_2];
            _webview_on_top = 2;
        }
        else if (_webview_on_top == 2) 
        {
            [vw_images bringSubviewToFront:_webview_image_1];
            _webview_on_top = 1;
        }
        else {
            [vw_images bringSubviewToFront:_webview_image_1];
            _webview_on_top = 1;
        }
        
        _banner_index = _next_banner_index;
        _next_banner_index = _banner_index + 1;
        
        if (_next_banner_index >= [_banner_list count]) {
            _next_banner_index = 0;
        }
        
        [self prepare_image];
	}
}

-(void)send_request{
    
    if (_banner_request != nil)
    {
        [_banner_request clearDelegatesAndCancel];
        [_banner_request release];
        _banner_request = nil;
    }
    
    [self resetBannerList];
    
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

-(void)resetBannerList
{
    [_banner_list removeAllObjects];
    
    _banner_index = 0;
    _next_banner_index = 0;
    _webview_on_top = 0;
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
    
    if (_webview_image_1 != nil)
    {
        [_webview_image_1 release];
        _webview_image_1 = nil;
    }
    if (_webview_image_2 != nil)
    {
        [_webview_image_2 release];
        _webview_image_2 = nil;
    }
}


#pragma mark -
#pragma mark Show/Hide functions

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
    if(isFive == NO)
        frame.origin.y = ORIGIN_Y_HIDE;
    else
        frame.origin.y = ORIGIN_Y_HIDE_5;
    self.view.frame = frame;
    
    self.view.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];

    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    frame.origin.y = screenBound.size.height - frame.size.height - 55;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        frame.origin.y -=20;
    }
    
    self.view.frame = frame;
    
    [UIView commitAnimations];
    
    isShowing = YES;
    if(isFive == NO)
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
        if(isFive==NO)
            frame.origin.y = ORIGIN_Y_HIDE;
        else
            frame.origin.y = ORIGIN_Y_HIDE_5;
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


#pragma mark - cache

-(void)loadImageFileWithURL:(NSURL*)imageURL
{
    if (imageURL == nil)
        return;
    
    NSString *imagePath = [self pathOfImageFileWithURL:imageURL];
    if (imagePath == nil)
        return;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        ASIHTTPRequest *newImageRequest = [[ASIHTTPRequest alloc] initWithURL:imageURL];
        newImageRequest.delegate = self;
        newImageRequest.tag = ASIHTTPREQUEST_TAG_IMAGE;
        [[CoreData sharedCoreData].graphic_queue addOperation:newImageRequest];
    }
}

-(void)cacheImageFileWithData:(NSData*)imageData url:(NSURL*)imageURL
{
    if (imageData == nil)
        return;
    
    NSString *imagePath = [self pathOfImageFileWithURL:imageURL];
    
    if (imagePath == nil)
        return;
    
    [imageData writeToFile:imagePath atomically:YES];
}

-(void)clearCachedImageFiles
{
    NSString *basePath = [self basePathOfImageFile];
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
	NSArray *file_list = [file_manager contentsOfDirectoryAtPath:basePath error:nil];
	for (int i=0; i<[file_list count]; i++) {
		NSString *filename = [NSString stringWithFormat:@"%@/%@",basePath,[file_list objectAtIndex:i]];
		[file_manager removeItemAtPath:filename error:nil];
	}
}

-(NSString*)basePathOfImageFile
{
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE) objectAtIndex:0];
    
    if (basePath == nil)
        return nil;
    
    basePath = [basePath stringByAppendingPathComponent:@"banners"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:basePath])
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil])
            return nil;
    }
    
    return basePath;
}

-(NSString*)pathOfImageFileWithURL:(NSURL*)imageURL
{
    if (imageURL == nil || imageURL.absoluteString == nil)
        return nil;
    
    NSString *basePath = [self basePathOfImageFile];
    if (basePath == nil)
        return nil;
    
    return [NSString stringWithFormat:@"%@/%@", basePath, [imageURL.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate
-(void) requestFinished:(ASIHTTPRequest *)request {
    
    if (request.tag == ASIHTTPREQUEST_TAG_IMAGE)
    {
        if (request.responseStatusCode == 200)
        {
            [self cacheImageFileWithData:request.responseData url:request.url];
            
            [self prepare_image];
        }
        
        if (request != nil)
        {
            [request release];
            request = nil;
        }
    }
    else if (request == _banner_request)
    {
        DEBUGMSG(@"BANNER: %@", [request responseString]);
        //[_banner_list removeAllObjects];
        
        [self resetBannerList];
        
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
        
        [self clearCachedImageFiles];
        
        for(int k = 0; k < [_banner_list count]; k++)
        {
            [self loadImageFileWithURL:[NSURL URLWithString:[[_banner_list objectAtIndex:k] objectForKey:@"image"]]];
        }
        
        [self prepare_image];
        
        // wait for next show() to show
        //[self show_image];
    }
}

-(void) requestFailed:(ASIHTTPRequest *)request {
    
    if (request.tag == ASIHTTPREQUEST_TAG_IMAGE)
    {
        if (request != nil)
        {
            [request release];
            request = nil;
        }
    }
    else if (request == _banner_request)
    {
        if(_banner_request != nil){
            [_banner_request release];
            _banner_request = nil;
        }
        
        //[self send_request];    
        [self startTimerToReload];
    }
}

#pragma mark -
#pragma mark handle button events

-(IBAction)click_banner_button:(UIButton *)button{
    DEBUGLog
    
	if (_banner_list == nil || [_banner_list count] == 0) {
		return;
	}
	
    if (_banner_index < [_banner_list count]) {
        
		NSString *link = [[_banner_list objectAtIndex:_banner_index] objectForKey:@"link"];
        
        if (link != nil)
        {
            if ([link  hasPrefix:@"https://itunes.apple.com"]) {
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: link]];
            }
            else if(link != nil && [link length] > 0){
//            BannerDetailsViewController *bannerDetailsViewController = [[BannerDetailsViewController alloc] initWithNibName:@"BannerDetailsViewController" bundle:nil];
//                bannerDetailsViewController._url_path = link;
//                [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate).navigation_controller presentModalViewController:bannerDetailsViewController animated:YES];
//                [bannerDetailsViewController release];
              [[UIApplication sharedApplication] openURL: [NSURL URLWithString: link]];

            }
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

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    DEBUGLog
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    DEBUGLog
}

@end
