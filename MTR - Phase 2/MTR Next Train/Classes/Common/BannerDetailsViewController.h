//
//  bannerDetailsViewController.h
//  creditGain
//
//  Created by Jeff Cheung on 11年4月18日.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"
#import "NextTrainAppDelegate.h"
//#import "ConnectionFailedViewController.h"
#import "CustomAlertView.h"
#import "CustomAlertViewDelegate.h"

#define time_interval 15

@interface BannerDetailsViewController : UIViewController  <UIWebViewDelegate/*, UIAlertViewDelegate*/, CustomAlertViewDelegate>{
	IBOutlet UIWebView *_web_view;
	NSString *_url_path;
	IBOutlet UIBarButtonItem *_close_button;
	NSTimer *_web_view_timer;

	IBOutlet UIView *_banner_detail_mask_view;
	
//	UIAlertView *_alert;
    
//    ConnectionFailedViewController *_connection_failed_view_controller;
    CustomAlertView *customAlertView;
}

@property (nonatomic, retain) NSString *_url_path;

-(IBAction)click_close_button:(UIBarButtonItem*)button;
-(void)web_view_timeout;

-(void)startWebViewTimeoutTimer;
-(void)stopWebViewTimeoutTimer;

@end
