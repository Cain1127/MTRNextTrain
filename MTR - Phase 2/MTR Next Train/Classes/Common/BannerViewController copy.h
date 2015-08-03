//
//  BannerViewController.h
//  bochk
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

//#define adlistAPI @"java/MTRNextTrain/adlist.api?"
#define timeIntervalForBanner 4.0
#define timeIntervalForReload 10.0
#define CachedImageViewBaseTag 1000

@interface BannerViewController : UIViewController <ASIHTTPRequestDelegate, CachedImageViewDelegate>{
	IBOutlet UIButton *_banner_button;	
    IBOutlet UIView *vw_images;
    IBOutlet UIWebView *_webview_image;
	NSMutableArray *_banner_list;
	int _banner_index;
	NSTimer *_banner_timer, *_reload_timer;
	ASIHTTPRequest *_banner_request;
    
    BOOL isShowing;
}

@property (nonatomic, assign) NSTimeInterval rollTiming;

#pragma mark -
#pragma mark common functions

-(void)startTimerToHideBanner;
-(void)stopTimerToHideBanner;
-(void)startTimerToReload;
-(void)stopTimerToReload;

-(void)show_image;
-(void)send_request;
-(void)terminate;

-(void)show;
-(void)hide;
-(void)didHidden;

#pragma mark -
#pragma mark handle button events

-(IBAction)click_banner_button:(UIButton *)button;
-(IBAction)clickHideButton:(UIButton *)button;

@end
