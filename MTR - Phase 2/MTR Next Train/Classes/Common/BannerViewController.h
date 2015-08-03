//
//  BannerViewController.h
//  ;
//
//  Created by Jeff Cheung on 10年12月16日.
//  Copyright 2010 MTel Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "CoreData.h"
#import "XPathQuery.h"
#import "CachedImageView.h"
#import "BannerDetailsViewController.h"
#import "NextTrainAppDelegate.h"
#import "NextTrainViewController.h"

//#define adlistAPI @"java/MTRNextTrain/adlist.api?"
#define timeIntervalForBanner 4.0
#define timeIntervalForReload 10.0
#define CachedImageViewBaseTag 1000

@interface BannerViewController : UIViewController <ASIHTTPRequestDelegate, CachedImageViewDelegate, UIWebViewDelegate>{
	IBOutlet UIButton *_banner_button,*closeBtn;
    IBOutlet UIView *vw_images;
    
    NSMutableArray *_banner_list;
    
    IBOutlet UIWebView *_webview_image_1, *_webview_image_2;
    int _webview_on_top;
	int _banner_index, _next_banner_index;
    
	NSTimer *_banner_timer, *_reload_timer;
	ASIHTTPRequest *_banner_request;
    
    BOOL isShowing;
}

@property (nonatomic, assign) NSTimeInterval rollTiming;

#pragma mark -
#pragma mark Timer functions

-(void)startTimerToHideBanner;
-(void)stopTimerToHideBanner;
-(void)startTimerToReload;
-(void)stopTimerToReload;

#pragma mark -
#pragma mark common functions

-(void)prepare_image;
-(void)show_image;
-(void)send_request;
-(void)resetBannerList;
-(void)terminate;

#pragma mark -
#pragma mark Show/Hide functions

-(void)show;
-(void)hide;
-(void)didHidden;

#pragma mark - cache
-(void)loadImageFileWithURL:(NSURL*)imageURL;
-(void)cacheImageFileWithData:(NSData*)imageData url:(NSURL*)imageURL;
-(void)clearCachedImageFiles;
-(NSString*)basePathOfImageFile;
-(NSString*)pathOfImageFileWithURL:(NSURL*)imageURL;

#pragma mark -
#pragma mark handle button events

-(IBAction)click_banner_button:(UIButton *)button;
-(IBAction)clickHideButton:(UIButton *)button;

@end
