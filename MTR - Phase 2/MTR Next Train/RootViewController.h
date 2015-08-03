//
//  RootViewController.h
//  MTR
//
//  Created by Jeff Cheung on 11年10月25日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ServiceUpdateViewController.h"
#import "CoreData.h"
#import "RootViewController.h"

@interface RootViewController : UIViewController <UIWebViewDelegate,UIApplicationDelegate> {
    IBOutlet UIImageView *_background;
    
    IBOutlet UIScrollView *_scroll_view;
    IBOutlet UIImageView *_disclaimer_image_view, *_disclaimer_bottom_image_view;
    IBOutlet UIWebView *_disclaimer_webview;
    IBOutlet UIImageView *_check_box_agree_image_view; 
    IBOutlet UIButton *_check_box_agree_button, *_cancel_and_quit_app_button, *_next_button;
    IBOutlet UIActivityIndicatorView *_aiv;
    
    
}

-(IBAction)clickNextButton:(UIButton*)button;
-(IBAction)clickCancelAndQuitAppButton:(UIButton*)button;
-(IBAction)clickCheckBoxAgreeButton:(UIButton*)button;

@end
