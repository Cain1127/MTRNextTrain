//
//  RootViewController.m
//  MTR
//
//  Created by Jeff Cheung on 11年10月25日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "UIWebView+Misc.h"
#import "NextTrainAppDelegate.h"

@implementation RootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    ReleaseObj(_scroll_view)
    ReleaseObj(_disclaimer_image_view)
    ReleaseObj(_disclaimer_bottom_image_view)
    ReleaseObj(_disclaimer_webview)
    ReleaseObj(_check_box_agree_image_view)
    ReleaseObj(_check_box_agree_button)
    ReleaseObj(_cancel_and_quit_app_button)
    ReleaseObj(_next_button)
    ReleaseObj(_aiv)

    [_background release];
    [super dealloc];
}

-(BOOL)hasNetwork{
    Reachability *internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    if (internetStatus == NotReachable){
        [internetReachable release];
        return NO;
    }
    [internetReachable release];
    return YES;
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
    
    _background.image = [UIImage imageNamed:[NSString stringWithFormat:@"background_%@.png",isFive?@"1136":@"disclaimer"]];


    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    //
    //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    //
    //        view.backgroundColor=[UIColor blackColor];
    //
    //        [self.view addSubview:view];
    //
    //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"LANG: %@",language);
    if([language isEqualToString:@"zh-Hant"]){
        [CoreData sharedCoreData].lang = @"zh_TW";
    }else {
        [CoreData sharedCoreData].lang =@"en";
    }
    
    //Originally in viewDidLoad
    
    _next_button.userInteractionEnabled = NO;
    if(isFive == NO){
        self.view.frame = CGRectMake(0, 0, 320, 480);
        _scroll_view.frame = CGRectMake(0, 0, 320, 370);
    }else{
        self.view.frame = CGRectMake(0, 0, 320, 568);
        _scroll_view.frame = CGRectMake(0, 0, 320, 458);
        
    }
    
//    if ([[[UIDevice currentDevice] systemVersion]floatValue] <7.0 ) {
//        self.view.frame = CGRectMake(0, 0, 320, 568);
//
//    }
    NSLog(@"%@", [CoreData sharedCoreData].lang);
    
    if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
        //        _scroll_view.contentSize = CGSizeMake(320, 5577);
        //
        //        _disclaimer_image_view.frame = CGRectMake(0, 0, 320, 5577);
        //        _disclaimer_image_view.image = [UIImage imageNamed:@"disclaimer_en.png"];
        _disclaimer_bottom_image_view.image = [UIImage imageNamed:@"disclaimer_bottom_agree_en.png"];
        //        _check_box_agree_button.frame = CGRectMake(22, 1, 278, 40);
    }
    else{
        //        _scroll_view.contentSize = CGSizeMake(320, 3710);
        //
        //        _disclaimer_image_view.frame = CGRectMake(0, 0, 320, 3710);
        //        _disclaimer_image_view.image = [UIImage imageNamed:@"disclaimer_zh_TW.png"];
        _disclaimer_bottom_image_view.image = [UIImage imageNamed:@"disclaimer_bottom_agree_zh_TW.png"];
        //        _check_box_agree_button.frame = CGRectMake(22, 1, 162, 40);
    }
    
    [_disclaimer_webview removeBackground];
    
    NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"tnc_%@", [CoreData sharedCoreData].lang ] ofType:@"html"];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
    
    
    [_disclaimer_webview loadHTMLString:htmlString baseURL:nil];
    
    [_aiv startAnimating];
    _aiv.hidden = NO;
    
    //[_cancel_and_quit_app_button setTitle:NSLocalizedString(([NSString stringWithFormat:@"cancel_and_quit_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
    // [_cancel_and_quit_app_button setTitle:NSLocalizedString(([NSString stringWithFormat:@"cancel_and_quit_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateSelected];
    
    [_next_button setTitle:NSLocalizedString(([NSString stringWithFormat:@"next_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
    [_next_button setTitle:NSLocalizedString(([NSString stringWithFormat:@"next_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateSelected];
    
}

- (void)viewDidUnload
{
    [_background release];
    _background = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Handle Click Button Events

-(IBAction)clickCheckBoxAgreeButton:(UIButton*)button{
    if(!_next_button.selected){
        _next_button.userInteractionEnabled = YES;
        _check_box_agree_image_view.image = [UIImage imageNamed:@"checkbox_on.png"];
    }
    else{
        _next_button.userInteractionEnabled = NO;
        _check_box_agree_image_view.image = [UIImage imageNamed:@"checkbox_off.png"];
    }
    _next_button.selected = !_next_button.selected;
}

-(IBAction)clickNextButton:(UIButton*)button{
//    _tab_bar_bg_view.hidden = YES;
    [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) makeTabBarDisappear];
    

    NSMutableDictionary *plist_record = [[[NSMutableDictionary alloc] initWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path]  autorelease];
    if([plist_record objectForKey:@"first_time"] == nil || [[plist_record objectForKey:@"first_time"] isEqualToString:@"YES"]){
        //        [CoreData sharedCoreData].connection_failed_view_controller.connection_failed_close_app = NO;
        [CoreData sharedCoreData].isConnectionFailedCloseApp = NO;
        [plist_record setObject:@"NO" forKey:@"first_time"];
        [plist_record writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
//        [plist_record release];
    }
    /*
     ServiceUpdateViewController *temp = [[ServiceUpdateViewController alloc] initWithNibName:@"ServiceUpdateViewController" bundle:nil];
     [self.navigationController pushViewController:temp animated:YES];
     [temp release];
     */
    [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) clickNextTrainButton:nil];
}

-(IBAction)clickCancelAndQuitAppButton:(UIButton*)button{
    exit(0);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return  UIStatusBarStyleLightContent;
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [_aiv stopAnimating];
    _aiv.hidden = YES;
    
    webView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        webView.alpha = 1;
    }];
}

@end
