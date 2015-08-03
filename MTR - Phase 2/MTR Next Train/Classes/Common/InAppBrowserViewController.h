//
//  InAppBrowserViewController.h
//  MTR
//
//  Created by Jeff Cheung on 11年11月11日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"
#import "CustomAlertView.h"

#define timeOutInterval 15

@interface InAppBrowserViewController : UIViewController <UIWebViewDelegate>{
    IBOutlet UIWebView *_web_view;
	NSString *_url_path;
    
    IBOutlet UIActivityIndicatorView *_activity_indicator_view;
    NSTimer *_web_view_timer;
    
}

@property (nonatomic, retain) NSString* url_path;

-(IBAction)clickBackButton:(UIButton*)button;
-(void)webViewTimeout;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
