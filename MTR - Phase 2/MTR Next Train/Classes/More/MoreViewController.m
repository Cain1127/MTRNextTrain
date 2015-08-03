//
//  MoreViewController.m
//  MTR
//
//  Created by Cheung Jeff on 2011/10/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "UIWebView+Misc.h"

#define POSITION_Y 20
@implementation MoreViewController

@synthesize go_updates_section = _go_updates_section;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _go_updates_section = NO;
        _date_formatter = [[NSDateFormatter alloc] init];
        _locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [_date_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [_date_formatter setLocale:_locale];
    }
    
    
    return self;
}

-(void)dealloc{
    
    if(_locale != nil){
        [_locale release];
        _locale = nil;
    }
    if(_date_formatter != nil){
        [_date_formatter release];
        _date_formatter = nil;
    }
    if(_update_handle != nil){
        _update_handle.delegate = nil;
        [_update_handle release];
        _update_handle = nil;
    }
    if(_request != nil){
		[_request clearDelegatesAndCancel];
		[_request release];
		_request = nil;
	}
    if (updateFrequencyArray != nil)
    {
        [updateFrequencyArray release];
        updateFrequencyArray = nil;
    }
    if (lastFreqIndexPath != nil)
    {
        [lastFreqIndexPath release];
        lastFreqIndexPath = nil;
    }
    
    ReleaseObj(_select_language_view)
    ReleaseObj(_tnc_view)
    ReleaseObj(_updates_view)
    ReleaseObj(_about_view)
    ReleaseObj(_img_background_normal)
    ReleaseObj(_img_background_setting)
    ReleaseObj(_language_button)
    ReleaseObj(_tnc_button)
    ReleaseObj(_updates_button)
    ReleaseObj(_about_button)
    ReleaseObj(_chinese_button)
    ReleaseObj(_english_button)
    ReleaseObj(_check_update_label)
    ReleaseObj(_version_label)
    ReleaseObj(_select_language_label)
    ReleaseObj(tbl_update_frequency)
    ReleaseObj(tbl_language)
    ReleaseObj(lbl_update_frequency)
    ReleaseObj(_tnc_scroll_view)
    ReleaseObj(_tnc_english_image_view)
    ReleaseObj(_tnc_chinese_image_view)
    ReleaseObj(_tnc_webview)
    ReleaseObj(_tnc_aiv)
    ReleaseObj(_title_label)
    ReleaseObj(_in_app_tutorial_button)
    ReleaseObj(_btn_callbackMother)
    
    [_background release];
    [term_of_use release];
    [check_update release];
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
    _background.alpha = 0.2f;

    [[CoreData sharedCoreData].banner_view_controller hide];

    [btn_setting addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
    

    _background.image = [UIImage imageNamed:[NSString stringWithFormat:@"background_%@.png",isFive?@"1136":@"960"]];
    _background.frame = CGRectMake(_background.frame.origin.x, _background.frame.origin.y+POSITION_Y, _background.frame.size.width, isFive?548:460);

    // Do any additional setup after loading the view from its nib.
    if(isFive == NO)
        self.view.frame = CGRectMake(0, 0, 320, 460);
    else{
        self.view.frame = CGRectMake(0, 0, 320, 548);
    
    }
    
    
    //_select_language_view.frame = _tnc_view.frame = _updates_view.frame = _about_view.frame = CGRectMake(0, 118, 320, 227);
    
    if(isFive == NO){
        [_select_language_view setFrame:CGRectMake(0, 61, 450, 290)];
//        [_tnc_view setFrame:CGRectMake(0, 106, 320, 350)];
        [_tnc_view setFrame:CGRectMake(0, 106, 320, 350)];
        [_tnc_webview setFrame:CGRectMake(2, -24, 320, 320)];
        [_in_app_tutorial_button setFrame:CGRectMake(90, 255, 160, 30)];
        tbl_update_frequency.frame = CGRectMake(tbl_update_frequency.frame.origin.x,lbl_update_frequency.frame.origin.y+lbl_update_frequency.frame.size.height,tbl_update_frequency.frame.size.width,tbl_update_frequency.frame.size.height+(8*4)+50);

        if([[[UIDevice currentDevice] systemVersion]doubleValue] >= 7.0){
           
            [_in_app_tutorial_button setFrame:CGRectMake(80, 278, 160, 30)];

        }

        if (isFive == NO && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            tbl_update_frequency.frame = CGRectMake(tbl_update_frequency.frame.origin.x,lbl_update_frequency.frame.origin.y+lbl_update_frequency.frame.size.height+20,tbl_update_frequency.frame.size.width,tbl_update_frequency.frame.size.height+(8*4)+50);

        }
        
        
        [_updates_view setFrame:CGRectMake(0, 106, 320, 290)];
        [_about_view  setFrame:CGRectMake(0, 106, 320, 290)];

    }else{
        
// Alex 
        if(isFive == YES && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [term_of_use setFrame:CGRectMake(0, -22, 320, 25)];
            [check_update setFrame:CGRectMake(0, -22, 320, 25)];
            [_title_trem_of_Use setFrame: CGRectMake(0, -22, 320, 25)];
            [_title_check_Update setFrame: CGRectMake(0, -22, 320, 25)];
            tbl_update_frequency.frame = CGRectMake(tbl_update_frequency.frame.origin.x,lbl_update_frequency.frame.origin.y+lbl_update_frequency.frame.size.height,tbl_update_frequency.frame.size.width,tbl_update_frequency.frame.size.height+(8*4));

        }
        if(isFive == YES && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        {
//            [term_of_use setFrame:CGRectMake(0, -44, 320, 25)];
//            [check_update setFrame:CGRectMake(0, -44, 320, 25)];
//            [_title_trem_of_Use setFrame: CGRectMake(0, -44, 320, 25)];
//            [_title_check_Update setFrame: CGRectMake(0, -44, 320, 25)];
            tbl_update_frequency.frame = CGRectMake(tbl_update_frequency.frame.origin.x,lbl_update_frequency.frame.origin.y+lbl_update_frequency.frame.size.height-20,tbl_update_frequency.frame.size.width,tbl_update_frequency.frame.size.height+(8*4));
            term_of_use.hidden = YES;
            check_update.hidden = YES;
            _title_trem_of_Use.hidden = YES;
            _title_check_Update.hidden = YES;
        
        }

         _select_language_view.frame = _tnc_view.frame = _updates_view.frame = _about_view.frame = CGRectMake(0, 80, 320, 387);
        lbl_update_frequency.center = CGPointMake(lbl_update_frequency.center.x, lbl_update_frequency.center.y+16);
        bv.center = lbl_update_frequency.center ;
//        if([[[UIDevice currentDevice] systemVersion]doubleValue] >= 7.0){
//            lbl_update_frequency.center = CGPointMake(lbl_update_frequency.center.x, lbl_update_frequency.center.y);
//            bv.center = lbl_update_frequency.center ;
//        }
        _in_app_tutorial_button.center = CGPointMake(_in_app_tutorial_button.center.x, _in_app_tutorial_button.center.y);
        tbl_language.frame = CGRectMake(tbl_language.frame.origin.x,tbl_language.frame.origin.y,tbl_language.frame.size.width,tbl_language.frame.size.height+16);
        
//        tbl_update_frequency.frame = CGRectMake(tbl_update_frequency.frame.origin.x,lbl_update_frequency.frame.origin.y+lbl_update_frequency.frame.size.height,tbl_update_frequency.frame.size.width,tbl_update_frequency.frame.size.height+(8*4));
        
        [_moreBkScrollView setFrame:CGRectMake(_moreBkScrollView.frame.origin.x, _moreBkScrollView.frame.origin.y, _moreBkScrollView.frame.size.width, _moreBkScrollView.frame.size.height+10)];
        
        [_moreBkScrollView setContentSize:CGSizeMake(_moreBkScrollView.frame.size.width, tbl_language.frame.size.height+tbl_update_frequency.frame.size.height+lbl_update_frequency.frame.size.height+_pushTitleLabel.frame.size.height)];
       // [_in_app_tutorial_button setFrame:CGRectMake(80, 280, 160, 30)];
        [_tnc_webview setFrame:CGRectMake(2, 5, 320, 430)];

    }
    // frequency
    [self loadSavedUpdateFrequency];
    
    [self handleLocalLanguageSetting];
    
    _update_handle = [[UpdateHandler alloc] init];
    _update_handle.delegate = self;
    
    //language view
    if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
        _english_button.selected = YES;
        _chinese_button.selected = NO;
    }
    else{
        _english_button.selected = NO;
        _chinese_button.selected = YES;
    }
    
    if(_go_updates_section){
        [self clickUpdatesButton:nil];
    }
    else{
        [self clickLanguageButton:nil];
    }
    
    [self handleCallbackMotherButton];
    
    

    // ios7
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]autorelease];
        
        view.backgroundColor=[UIColor colorWithRed:213/255.0 green:215/255.0 blue:219/255.0 alpha:1];
        
        [self.view addSubview:view];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
    
    if (self.isShowingTNC) {
        _language_button.selected = _updates_button.selected = _about_button.selected = NO;
        _tnc_button.selected = YES;
        _select_language_view.alpha = 0;
        _tnc_view.alpha = 1;
        _updates_view.alpha = 0;
        _about_view.alpha = 0;
        _img_background_normal.alpha = 1;
        _img_background_setting.alpha = 0;
    }
    
    if (self.isShowingCheckUpdate) {
        _language_button.selected = _tnc_button.selected = _updates_button.selected = NO;
        _about_button.selected = YES;
        
        _select_language_view.alpha = 0;
        _tnc_view.alpha = 0;
        _updates_view.alpha = 0;
        _about_view.alpha = 1;
        _img_background_normal.alpha = 1;
        _img_background_setting.alpha = 0;
    }
}

- (void)viewDidUnload
{
    [_background release];
    _background = nil;
    [term_of_use release];
    term_of_use = nil;
    [check_update release];
    check_update = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];

//    [tbl_update_frequency reloadData];
    //[_tnc_webview reload];

}

// Alex
-(void)reloadData{

//    if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
//        _db_lang = [@"EN" retain];
//    }
//    else{
//        _db_lang = [@"TC" retain];
//    }
    
//  Setupdate mode
    [_title_label setText:NSLocalizedString(([NSString stringWithFormat:@"set_update_frequency_%@", [CoreData sharedCoreData].lang]), nil)];

    DEBUGMSG(@"UpdateFreq %@", ([NSString stringWithFormat:@"%@%@", updateFrequencyArray, [CoreData sharedCoreData].lang]));
    [tbl_update_frequency reloadData];
    [tbl_language reloadData];
    
//  Terms of use
    _title_trem_of_Use.text = NSLocalizedString(([NSString stringWithFormat:@"slideTittle_Terms_%@", [CoreData sharedCoreData].lang]), nil);
    if([self hasNetwork]==YES){
        NSURL *urlTNC=[NSURL URLWithString:[NSString stringWithFormat:@"%@/MTR_NT_TC_%@.html",TandCAPI,[[CoreData sharedCoreData].lang isEqualToString:@"en"]== YES ? @"ENG" : @"CHT"  ]];
        
        
        _request = [[ASIHTTPRequest alloc] initWithURL:urlTNC];
        [_request setCompletionBlock:^{
            
            NSString * _web_view_tnc;
            NSString *correctString = [NSString stringWithCString:[[_request responseString] cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
            
        DEBUGMSG(@"CorrectString: %@",correctString
                     );
            
            // Use when fetching text data
//            NSString *responseString = [_request responseString];
//            DEBUGMSG(@"ResponseString: %@",responseString
//                     );

//Alex
            _web_view_tnc =  [correctString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
            [_tnc_webview loadHTMLString:_web_view_tnc baseURL:Nil];

            // Use when fetching binary data
//            NSData *responseData = [_request responseData];
        }];
        [_request setFailedBlock:^{
//            NSError *error = [_request error];
        }];
        
        [_request startAsynchronous];
    
                    
//        NSURLRequest *request=[NSURLRequest requestWithURL:urlTNC];
//        
//        [_tnc_webview loadRequest:request];
        DEBUGMSG(@"URL: %@",_request.url
                 );
        
    }else{
        
        NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"tnc_%@", [CoreData sharedCoreData].lang ] ofType:@"html"];
        
        NSString *htmlString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
        
        [_tnc_webview loadHTMLString:htmlString baseURL:nil];
//
    }
    

// Check Update
    
    
    [_title_check_Update setText:NSLocalizedString(([NSString stringWithFormat:@"slideTittle_CheckUpdate_%@", [CoreData sharedCoreData].lang]), nil)];

    _check_update_label.text = NSLocalizedString(([NSString stringWithFormat:@"more_check_update_%@", [CoreData sharedCoreData].lang]), nil);

    
    NSArray *array = [[CoreData sharedCoreData].app_version componentsSeparatedByString:@"_"];
    if(array != nil && [array count] > 1){
        _version_label.text = [NSString stringWithFormat:@"%@%@.%@", NSLocalizedString(([NSString stringWithFormat:@"more_version_%@", [CoreData sharedCoreData].lang]), nil), [array objectAtIndex:0], [array objectAtIndex:1]];
        [_version_label setTextColor:[UIColor colorWithRed:33/255.0 green:62/255.0 blue:107/255.0 alpha:1]];
//        [_version_label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        
    }
    _last_check_time_label.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(([NSString stringWithFormat:@"more_last_checking_time_%@", [CoreData sharedCoreData].lang]), nil), [[NSUserDefaults standardUserDefaults] objectForKey:@"LastCheckTime"]];

    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self showInAppTutorial];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
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

#pragma mark - Core

-(void)handleLocalLanguageSetting{
        [[NSUserDefaults standardUserDefaults] setObject:[CoreData sharedCoreData].lang forKey:@"lang"];
    if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-Hant", nil] forKey:@"AppleLanguages"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    _title_label.text = NSLocalizedString(([NSString stringWithFormat:@"more_%@", [CoreData sharedCoreData].lang]), nil);
//Alex
    
    _title_label.text = NSLocalizedString(([NSString stringWithFormat:@"set_update_frequency_%@", [CoreData sharedCoreData].lang]), nil);
    
    _title_trem_of_Use.text = NSLocalizedString(([NSString stringWithFormat:@"slideTittle_Terms_%@", [CoreData sharedCoreData].lang]), nil);
    
    _title_check_Update.text = NSLocalizedString(([NSString stringWithFormat:@"more_check_update_%@", [CoreData sharedCoreData].lang]), nil);
    
    [_language_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"more_tap_settings_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    [_language_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"more_tap_settings_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
    [_tnc_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"more_tap_tnc_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    [_tnc_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"more_tap_tnc_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
//    [lbl_update_frequency setText:NSLocalizedString(([NSString stringWithFormat:@"set_update_frequency_%@", [CoreData sharedCoreData].lang]), nil)];

    
   
    /*
    [_updates_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tap_more_updates_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    [_updates_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tap_more_updates_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    */
    [_about_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"more_tap_about_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    [_about_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"more_tap_about_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
    
    /*
    _select_language_label.text = NSLocalizedString(([NSString stringWithFormat:@"more_select_language_%@", [CoreData sharedCoreData].lang]), nil);
    */
    
//    _tnc_scroll_view.contentOffset = CGPointMake(0, 0);
//    if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
//        _tnc_scroll_view.contentSize = CGSizeMake(320, 5577);
//        _tnc_english_image_view.hidden = NO;
//        _tnc_chinese_image_view.hidden = YES;
//    }
//    else{
//        _tnc_scroll_view.contentSize = CGSizeMake(320, 3710);
//        _tnc_english_image_view.hidden = YES;
//        _tnc_chinese_image_view.hidden = NO;
//    }
    
    [_tnc_webview removeBackground];
    
    
    if([self hasNetwork]==YES){
        NSURL *urlTNC=[NSURL URLWithString:[NSString stringWithFormat:@"%@/MTR_NT_TC_%@.html",TandCAPI,[[CoreData sharedCoreData].lang isEqualToString:@"en"]== YES ? @"ENG" : @"CHT"  ]];
        
        NSURLRequest *request=[NSURLRequest requestWithURL:urlTNC];
        
        [_tnc_webview loadRequest:request];
        
        DEBUGMSG(@"URL: %@", request.URL);
    }else{
        
        NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"tnc_%@", [CoreData sharedCoreData].lang ] ofType:@"html"];
        
        NSString *htmlString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
        
        [_tnc_webview loadHTMLString:htmlString baseURL:nil];
        
    }
    
    
    [_tnc_aiv startAnimating];
    _tnc_aiv.hidden = NO;
    
    NSArray *array = [[CoreData sharedCoreData].app_version componentsSeparatedByString:@"_"];
    if(array != nil && [array count] > 1){
        _version_label.text = [NSString stringWithFormat:@"%@%@.%@", NSLocalizedString(([NSString stringWithFormat:@"more_version_%@", [CoreData sharedCoreData].lang]), nil), [array objectAtIndex:0], [array objectAtIndex:1]];
        [_version_label setTextColor:[UIColor colorWithRed:33/255.0 green:62/255.0 blue:107/255.0 alpha:1]];
//        [_version_label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];

    }
    
    _check_update_label.text = NSLocalizedString(([NSString stringWithFormat:@"more_check_update_%@", [CoreData sharedCoreData].lang]), nil);
    
    [_in_app_tutorial_button setTitle:NSLocalizedString(([NSString stringWithFormat:@"in_app_tutorial_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal]; 
    
    if(_locale != nil){
        [_locale release];
        _locale = nil;
    }
    
    // frequency
    [tbl_update_frequency reloadData];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"LastCheckTime"]) {
        [[NSUserDefaults standardUserDefaults] setObject: [_date_formatter stringFromDate:[NSDate date]] forKey:@"LastCheckTime"];
    }
    
    
    _last_check_time_label.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(([NSString stringWithFormat:@"more_last_checking_time_%@", [CoreData sharedCoreData].lang]), nil), [[NSUserDefaults standardUserDefaults] objectForKey:@"LastCheckTime"]];
//    [_last_check_time_label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    
    
}

-(void)handleGlobalLanguagSetting{
    [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) handleTabBarLanguage];
    [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) handleAppUpdatePopUpLanguage];
    [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) handleBannerLanguage];
    [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) sendPushNotificationTokenToServer];
}

-(void)loadSavedUpdateFrequency
{
    
    // frequency
    if (updateFrequencyArray != nil)
    {
        [updateFrequencyArray release];
        updateFrequencyArray = nil;
    }
    
    updateFrequencyArray = [[NSArray arrayWithObjects:
                             @"15_sec_", 
                             @"20_sec_", 
                             @"30_sec_", 
                             @"update_manually_", nil] retain];
    
    if (lastFreqIndexPath != nil)
    {
        [lastFreqIndexPath release];
        lastFreqIndexPath = nil;
    }
    
    lastFreqIndexPath = [[NSIndexPath indexPathForRow:[CoreData sharedCoreData].nextTrainUpdateFrequency inSection:0] retain];
    
    [tbl_update_frequency reloadData];
}

#pragma mark - ASIHTTPRequestDelegate

-(void)requestChineseFinished:(ASIHTTPRequest *)request{
//    _chinese_button.selected = YES;
//    _english_button.selected = NO;
//    [CoreData sharedCoreData].lang = @"zh_TW";
//    [self handleLocalLanguageSetting];
//    [self handleGlobalLanguagSetting];
    if(_request != nil){
        [_request release];
        _request = nil;
    }
    DEBUGMSG(@"requestChineseFinished");
}

-(void)requestChineseFailed:(ASIHTTPRequest *)request{
    if(_request != nil){
        [_request release];
        _request = nil;
    }
    DEBUGMSG(@"requestChineseFailed");
}

-(void)requestEnglishFinished:(ASIHTTPRequest *)request{
//    _chinese_button.selected = NO;
//    _english_button.selected = YES;
//    [CoreData sharedCoreData].lang = @"en";
//    [self handleLocalLanguageSetting];
//    [self handleGlobalLanguagSetting];
    if(_request != nil){
        [_request release];
        _request = nil;
    }
    DEBUGMSG(@"requestEnglishFinished");
}

-(void)requestEnglishFailed:(ASIHTTPRequest *)request{
    if(_request != nil){
        [_request release];
        _request = nil;
    }
    DEBUGMSG(@"requestEnglishFailed");
}

#pragma mark - Handle Click Button Events

-(IBAction)clickCheckUpdateButton:(UIButton*)button{
    [_update_handle checkUpdate];
}

-(IBAction)clickChineseButton:(UIButton*)button{    
    /*
    if(_request == nil){
        _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@UDID=%@&dt=%@&lang=%@", [CoreData sharedCoreData].server_url, changeLangaugeAPI, [CoreData sharedCoreData].udid, [CoreData sharedCoreData].device, @"zh_TW"]]];
        [_request setDidFinishSelector:@selector(requestChineseFinished:)];
        [_request setDidFailSelector:@selector(requestChineseFailed:)];
        _request.delegate = self;
        [[CoreData sharedCoreData].common_queue addOperation:_request];
        //DEBUGMSG(@"%@", _request.url);
    }
     */
    _chinese_button.selected = YES;
    _english_button.selected = NO;
    [CoreData sharedCoreData].lang = @"zh_TW";
    [self handleLocalLanguageSetting];
    [self handleGlobalLanguagSetting];
}

-(IBAction)clickEnglishButton:(UIButton*)button{
    /*
    if(_request == nil){
        _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@UDID=%@&dt=%@&lang=%@", [CoreData sharedCoreData].server_url, changeLangaugeAPI, [CoreData sharedCoreData].udid, [CoreData sharedCoreData].device, @"en_US"]]];
        [_request setDidFinishSelector:@selector(requestEnglishFinished:)];
        [_request setDidFailSelector:@selector(requestEnglishFailed:)];
        _request.delegate = self;
        [[CoreData sharedCoreData].common_queue addOperation:_request];
        //DEBUGMSG(@"%@", _request.url);
    }
     */
    _chinese_button.selected = NO;
    _english_button.selected = YES;
    [CoreData sharedCoreData].lang = @"en";
    [self handleLocalLanguageSetting];
    [self handleGlobalLanguagSetting];
}

-(IBAction)clickLanguageButton:(UIButton*)button{
    _tnc_button.selected = _updates_button.selected = _about_button.selected = NO;
    _language_button.selected = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _select_language_view.alpha = 1;
    _tnc_view.alpha = 0;
    _updates_view.alpha = 0;
    _about_view.alpha = 0;
    _img_background_normal.alpha = 0;
    _img_background_setting.alpha = 1;
    [UIView commitAnimations];
}

-(IBAction)clickUpdatesButton:(UIButton*)button{
    _language_button.selected = _tnc_button.selected = _about_button.selected = NO;
    _updates_button.selected = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _select_language_view.alpha = 0;
    _tnc_view.alpha = 0;
    _updates_view.alpha = 1;
    _about_view.alpha = 0;
    _img_background_normal.alpha = 1;
    _img_background_setting.alpha = 0;
    
    [UIView commitAnimations];
}


-(IBAction)handleLocalLanguageSetting:(UIButton*)button{
    _language_button.selected = _updates_button.selected = _about_button.selected = NO;
    _tnc_button.selected = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _select_language_view.alpha = 0;
    _tnc_view.alpha = 1;
    _updates_view.alpha = 0;
    _about_view.alpha = 0;
    _img_background_normal.alpha = 1;
    _img_background_setting.alpha = 0;
    [UIView commitAnimations];
}



-(IBAction)clickAboutButton:(UIButton*)button{
    _language_button.selected = _tnc_button.selected = _updates_button.selected = NO;
    _about_button.selected = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _select_language_view.alpha = 0;
    _tnc_view.alpha = 0;
    _updates_view.alpha = 0;
    _about_view.alpha = 1;
    _img_background_normal.alpha = 1;
    _img_background_setting.alpha = 0;
    [UIView commitAnimations];
}

-(IBAction)clickInAppTutorialButton:(UIButton*)button
{
    [self showInAppTutorialAll];
}


- (IBAction)clickSlideMenuButton:(id)sender {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.navigationController.view.frame.origin.x==0) {
            self.navigationController.view.frame = CGRectMake(275, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
        } else {
            self.navigationController.view.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
        }
        
    } completion:nil];

}

#pragma mark - Control Functions


-(void)showInAppTutorialAll
{
    if (isShowingInAppTutorialAll)
        return;
    
    TutorialAllViewController *tutorial = [[[TutorialAllViewController alloc] initWithNibName:@"TutorialAllViewController" bundle:nil] autorelease];
    tutorial.parent = self;
    [self.navigationController presentModalViewController:tutorial animated:YES];
    
    isShowingInAppTutorialAll = YES;
    [[(NextTrainAppDelegate *)[[UIApplication sharedApplication] delegate] tab_bar_bg_view] setHidden:YES];

}

-(void)hideInAppTutorialAll
{
    if (isShowingInAppTutorialAll)
    {
        [self.navigationController dismissModalViewControllerAnimated:YES];
        
        isShowingInAppTutorialAll = NO;
    }
    
    [[(NextTrainAppDelegate *)[[UIApplication sharedApplication] delegate] tab_bar_bg_view] setHidden:NO];

}

#pragma mark - x-callback functions
-(void)handleCallbackMotherButton
{
    if ([CoreData shouldShowCallBackMotherButton])
    {
        _btn_callbackMother.hidden = NO;
    }
    else {
        _btn_callbackMother.hidden = YES;
    }
}

-(IBAction)clickCallbackMotherButton:(UIButton*)button
{
    DEBUGLog
    [CoreData callbackMother];
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 43;
    if(isFive==true)
        return 50;
    else
        return 37;
}
/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(([NSString stringWithFormat:@"set_update_frequency_%@", [CoreData sharedCoreData].lang]), nil);
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tbl_language)
    {
        return 2;
    }
    else if (tableView == tbl_update_frequency)
    {
        return [updateFrequencyArray count];
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbl_language)
    {
        static NSString *CellIdentifier = @"Language";
        
        SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        if (indexPath.row == 0)
        {
            cell.lbl_station_name.text = @"English";
            
            if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
            {
                //cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [cell setChecked:YES];
            }
            else
            {
                //cell.accessoryType = UITableViewCellAccessoryNone;
                [cell setChecked:NO];
            }
        }
        else 
        {
            cell.lbl_station_name.text = @"中文";
            
            if ([[CoreData sharedCoreData].lang isEqualToString:@"zh_TW"])
            {
                //cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [cell setChecked:YES];
            }
            else
            {
                //cell.accessoryType = UITableViewCellAccessoryNone;
                [cell setChecked:NO];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (tableView == tbl_update_frequency)
    {
        static NSString *CellIdentifier = @"UpdateFreq";
        
        SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        //cell.textLabel.text = NSLocalizedString(([NSString stringWithFormat:@"%@%@", [updateFrequencyArray objectAtIndex:indexPath.row], [CoreData sharedCoreData].lang]), nil);
        cell.lbl_station_name.text = NSLocalizedString(([NSString stringWithFormat:@"%@%@", [updateFrequencyArray objectAtIndex:indexPath.row], [CoreData sharedCoreData].lang]), nil);
        
        DEBUGMSG(@"UpdateFreq %@", ([NSString stringWithFormat:@"%@%@", [updateFrequencyArray objectAtIndex:indexPath.row], [CoreData sharedCoreData].lang]));
        
        if (lastFreqIndexPath.row == indexPath.row)
        {
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [cell setChecked:YES];
        }
        else
        {
            //cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setChecked:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DEBUGMSG(@"didSelectRowAtIndexPath");
    
    if (tableView == tbl_language)
    {
        if (indexPath.row == 0)
        {
            [self clickEnglishButton:nil];
        }
        else
        {
            [self clickChineseButton:nil];
        }
        
        [tbl_language reloadData];
    }
    else if (tableView == tbl_update_frequency)
    {
        SettingsCell* newCell = (SettingsCell*)[tableView cellForRowAtIndexPath:indexPath]; 
        int newRow = [indexPath row]; 
        int oldRow = (lastFreqIndexPath != nil) ? [lastFreqIndexPath row] : -1; 
            
        if(newRow != oldRow) 
        { 
            //newCell.accessoryType = UITableViewCellAccessoryCheckmark; 
            [newCell setChecked:YES];
            SettingsCell* oldCell = (SettingsCell*)[tableView cellForRowAtIndexPath:lastFreqIndexPath]; 
            //oldCell.accessoryType = UITableViewCellAccessoryNone;
            [oldCell setChecked:NO];
            lastFreqIndexPath = [[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] retain]; 
            
            [[CoreData sharedCoreData] saveNextTrainUpdateFrequency:newRow];
        } 
    }
}

#pragma mark - UpdateHandlerDelegate
-(void)updateHandlerBeginCheckUpdate
{
    [[CoreData sharedCoreData].mask showMask];
}

-(void)updateHandlerFinishCheckUpdate
{
    [[CoreData sharedCoreData].mask hiddenMask];
    
    [[NSUserDefaults standardUserDefaults] setObject: [_date_formatter stringFromDate:[NSDate date]] forKey:@"LastCheckTime"];
        
    _last_check_time_label.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(([NSString stringWithFormat:@"more_last_checking_time_%@", [CoreData sharedCoreData].lang]), nil), [[NSUserDefaults standardUserDefaults] objectForKey:@"LastCheckTime"]];
\
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == _tnc_webview)
    {
        [_tnc_aiv stopAnimating];
        _tnc_aiv.hidden = YES;
    }
}


@end
