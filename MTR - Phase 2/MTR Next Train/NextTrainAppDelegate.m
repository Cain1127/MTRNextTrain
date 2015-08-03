//
//  MTRAppDelegate.m
//  MTR
//
//  Created by Jeff Cheung on 11年10月25日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NextTrainAppDelegate.h"
#import "Flurry.h"
#import "RevealController.h"


@implementation NextTrainAppDelegate{
    SelectStationViewController *stationCTR;
    SelectStationViewController *mapCTR;
    FavoriteViewController *favCTR;
    //    ContactUsViewController *contactCTR;
    
}

@synthesize window = _window;
@synthesize navigation_controller = _navigation_controller;
@synthesize tab_bar_bg_view = _tab_bar_bg_view;
@synthesize next_train_button = _next_train_button, station_facilities_button = _station_facilities_button, favorite_button = _favorite_button, contact_us_button = _contact_us_button, more_button = _more_button, routemap_button = _routemap_button;
@synthesize update_app_bg_view = _update_app_bg_view, update_app_pop_up_view = _update_app_pop_up_view;
@synthesize app_update_content_label = _app_update_content_label, cancel_button = _cancel_button;

//jeff
@synthesize app_update_update_now_button = _app_update_update_now_button;

//alex

-(void)makeTabBarDisappear{
    _tab_bar_bg_view.hidden = YES;
    
}

- (void)dealloc
{
    
    if (customerActionSheet) {
        [customerActionSheet removeFromParentViewController];
        [customerActionSheet.view removeFromSuperview];
        customerActionSheet.delegate = nil;
        [customerActionSheet release];
    }
    
    if (alertInvalidURL != nil)
    {
        alertInvalidURL.delegate = nil;
        [alertInvalidURL release];
        alertInvalidURL = nil;
    }
    
    if (updateHandler != nil)
    {
        updateHandler.delegate = nil;
        [updateHandler release];
        updateHandler = nil;
    }
    
    if(_update_app_pop_up_view != nil){
        [_update_app_pop_up_view release];
        _update_app_pop_up_view = nil;
    }
    if(_update_app_bg_view != nil){
        [_update_app_bg_view removeFromSuperview];
        [_update_app_bg_view release];
        _update_app_bg_view = nil;
    }
    if(_next_train_button != nil){
        [_next_train_button release];
        _next_train_button = nil;
    }
    if(_station_facilities_button != nil){
        [_station_facilities_button release];
        _station_facilities_button = nil;
    }
    if(_favorite_button != nil){
        [_favorite_button release];
        _favorite_button = nil;
    }
    if(_contact_us_button != nil){
        [_contact_us_button release];
        _contact_us_button = nil;
    }
    if(_more_button != nil){
        [_more_button release];
        _more_button = nil;
    }
    if(_app_need_update != nil){
        [_app_need_update release];
        _app_need_update = nil;
    }
    if(_result_record != nil){
        [_result_record removeAllObjects];
        [_result_record release];
        _result_record = nil;
    }
    [[SQLiteOperator sharedOperator] closeDatabase];
    if(_tab_bar_bg_view != nil){
        [_tab_bar_bg_view release];
        _tab_bar_bg_view = nil;
    }
    if(_date_formatter != nil){
		[_date_formatter release];
		_date_formatter = nil;
	}
    if(_banner_view_controller != nil){
		[_banner_view_controller terminate];
        [_banner_view_controller.view removeFromSuperview];
		[_banner_view_controller release];
		_banner_view_controller = nil;
	}
    [_window release];
    _navigation_controller.delegate = nil;
    [_navigation_controller release];
    
    //jeff
    self.app_update_update_now_button = nil;
    [_slideMenuView release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [Flurry startSession:@"HJ4X7X6PB3942VGHQWWZ"];
    screenRect = [[UIScreen mainScreen] applicationFrame];
    if (screenRect.size.height > 500)
    {
        isFive = YES;
        DEBUGMSG(@"is iPhone 5");
    }else{
        isFive = NO;
    }
    [[SQLiteOperator sharedOperator] openDatabase];
    [self setupLang];
    [self handleTabBarLanguage];
    [self handleAppUpdatePopUpLanguage];
    
    _banner_view_controller = [[BannerViewController alloc] initWithNibName:@"BannerViewController" bundle:nil];
    [_banner_view_controller send_request];
    [_banner_view_controller didHidden];
    [_navigation_controller.view addSubview:_banner_view_controller.view];
    [CoreData sharedCoreData].banner_view_controller = _banner_view_controller;
    
    
    map_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@lang=%@",
                                                                            getSystemMapAPI,
                                                                            [CoreData sharedCoreData].lang
                                                                            ]]];
    map_request.delegate = self;
    [[CoreData sharedCoreData].common_queue addOperation:map_request];
    DEBUGMSG(@"System MAP API: %@", map_request.url);
    
    
    /*
     NSMutableDictionary *plist_record = [NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path];
     if(plist_record == nil){
     plist_record = [[NSMutableDictionary new] autorelease];
     }
     else{
     [[plist_record retain] autorelease];
     }
     
     //after update the app, set first_time to YES
     if([plist_record objectForKey:@"app_info"] != nil && [[plist_record objectForKey:@"app_info"] objectForKey:@"app_version"] != nil && [CoreData sharedCoreData].app_version != nil){
     NSArray *plist_app_version_array = [[[plist_record objectForKey:@"app_info"] objectForKey:@"app_version"] componentsSeparatedByString:@"_"];
     NSArray *own_app_version_array = [[CoreData sharedCoreData].app_version componentsSeparatedByString:@"_"];
     if(plist_app_version_array != nil && [plist_app_version_array count] > 1 && plist_app_version_array != nil && [plist_app_version_array count] > 1){
     if([[own_app_version_array objectAtIndex:0] intValue] > [[plist_app_version_array objectAtIndex:0] intValue]){
     [plist_record removeAllObjects];
     [plist_record setObject:@"YES" forKey:@"first_time"];
     [plist_record writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
     }
     else if([[own_app_version_array objectAtIndex:0] intValue] == [[plist_app_version_array objectAtIndex:0] intValue] && [[own_app_version_array objectAtIndex:1] intValue] > [[plist_app_version_array objectAtIndex:1] intValue]){
     [plist_record removeAllObjects];
     [plist_record setObject:@"YES" forKey:@"first_time"];
     [plist_record writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
     }
     }
     }
     
     if([plist_record objectForKey:@"first_time"] == nil || [[plist_record objectForKey:@"first_time"] isEqualToString:@"YES"]){
     NSMutableDictionary *record = [NSMutableDictionary new];
     [record setObject:@"YES" forKey:@"all"];
     [record setObject:@"YES" forKey:@"info"];
     [plist_record setObject:record forKey:@"push"];
     [plist_record writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
     [record release];
     }
     */
    //Alex add slideMenu background
    
    _slideMenuView = [[SlideMenuViewController alloc] initWithNibName:@"SlideMenuViewController" bundle:nil];
    
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    CGRect frame = _tab_bar_bg_view.frame;
    frame.origin.y = screenBound.size.height - frame.size.height;
    _tab_bar_bg_view.frame = frame;
    
    [_navigation_controller.view addSubview:_tab_bar_bg_view];
    [_navigation_controller.view addSubview:_update_app_bg_view];
    
	self.revealController = [[RevealController alloc] initWithFrontViewController:_navigation_controller rearViewController:_slideMenuView];
	_window.rootViewController = self.revealController;
    
    [_slideMenuView.slide_Language_button addTarget:self action:@selector(clickLanguageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_slideMenuView.slide_Update_button addTarget:self action:@selector(clickUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
    [_slideMenuView.slide_Terms_button addTarget:self action:@selector(clickTermsButton:) forControlEvents:UIControlEventTouchUpInside];
    [_slideMenuView.slide_Tutorial_button addTarget:self action:@selector(clickTutorialButton:) forControlEvents:UIControlEventTouchUpInside];
    [_slideMenuView.slide_CheckUpdate_button addTarget:self action:@selector(clickCheckUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //
    
    // loading mask
    [CoreData sharedCoreData].mask = [[MaskViewController alloc] initWithNibName:@"MaskView" bundle:nil];
    
    
    if(isFive == NO)
        [CoreData sharedCoreData].mask.view.frame = CGRectMake(0, 20, 320, 460);
    else
        [CoreData sharedCoreData].mask.view.frame = CGRectMake(0, 40, 320, 548);
    
    
	[_window addSubview:[CoreData sharedCoreData].mask.view];
	[[CoreData sharedCoreData].mask hiddenMask];
    
    [_window makeKeyAndVisible];
    
    //start logic
    //    _isInServiceNoticeSection = YES;
    
    _result_record = [NSMutableDictionary new];
    _date_formatter = [[NSDateFormatter alloc] init];
    [_date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSMutableDictionary *plist_record = [[[self getUpdateHandler] initMtrPlist] retain];
    
    //first time to open app
    if([plist_record objectForKey:@"first_time"] == nil || [[plist_record objectForKey:@"first_time"] isEqualToString:@"YES"]){
        //        [CoreData sharedCoreData].connection_failed_view_controller.connection_failed_close_app = NO;
        [CoreData sharedCoreData].isConnectionFailedCloseApp = NO;
        
        //[self handleFirstTimeToOpenApp];
        [[self getUpdateHandler] handleFirstTimeToOpenApp];
    }
    
    //it is not first time to open app
    else if([plist_record objectForKey:@"first_time"] != nil && [[plist_record objectForKey:@"first_time"] isEqualToString:@"NO"]){
        //        [CoreData sharedCoreData].connection_failed_view_controller.connection_failed_close_app = NO;
        [CoreData sharedCoreData].isConnectionFailedCloseApp = NO;
        
        //[self handleCommonOpenApp];
        [[self getUpdateHandler] handleCommonOpenApp];
        
        [self clickNextTrainButton:nil];
    }
    
    [plist_record release];
    
    
    
    customerActionSheet =[[CustomerActionSheetViewController alloc] initWithNibName:@"CustomerActionSheetViewController" bundle:Nil];
    customerActionSheet.delegate = self;
    [self.window addSubview:customerActionSheet.view];
    
    
    
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DEBUGMSG(@"applicationWillEnterForeground");
    [_result_record removeAllObjects];
    [_date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSMutableDictionary *plist_record = [NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path];
    if(plist_record != nil){
        [[plist_record retain] autorelease];
    }
    
    if([plist_record objectForKey:@"first_time"] == nil || [[plist_record objectForKey:@"first_time"] isEqualToString:@"YES"]){
        //        [CoreData sharedCoreData].connection_failed_view_controller.connection_failed_close_app = NO;
        [CoreData sharedCoreData].isConnectionFailedCloseApp = NO;
        
        //[self handleFirstTimeToOpenApp];
        [[self getUpdateHandler] handleFirstTimeToOpenApp];
    }
    else if([plist_record objectForKey:@"first_time"] != nil && [[plist_record objectForKey:@"first_time"] isEqualToString:@"NO"]){
        //        [CoreData sharedCoreData].connection_failed_view_controller.connection_failed_close_app = NO;
        [CoreData sharedCoreData].isConnectionFailedCloseApp = NO;
        
        //[self handleCommonOpenApp];
        [[self getUpdateHandler] handleCommonOpenApp];
    }
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [CoreData sharedCoreData].x_callback_url_source = nil;
    [CoreData sharedCoreData].x_callback_url_source_name_en = nil;
    [CoreData sharedCoreData].x_callback_url_source_name_zh_HK = nil;
    [CoreData sharedCoreData].x_callback_url_success = nil;
    
    if (!url)
    {
        return NO;
    }
    
    // check whether valid url
    DEBUGMSG(@"URL: %@", [url absoluteString]);
    
    if (0 < [url.absoluteString length])
    {
        NSString *query = url.query;
        
        NSArray *queryArray = [query componentsSeparatedByString:@"&"];
        
        DEBUGMSG(@"%@", queryArray);
        
        for (int i=0; i<[queryArray count]; i++)
        {
            NSArray *keyValue = [[queryArray objectAtIndex:i] componentsSeparatedByString:@"="];
            DEBUGMSG(@"%@", keyValue);
            
            if ([keyValue count] == 2)
            {
                NSString *key = [keyValue objectAtIndex:0];
                NSString *value = [keyValue objectAtIndex:1];
                
                if ([@"x-source" isEqualToString:key])
                {
                    [CoreData sharedCoreData].x_callback_url_source = value;
                }
                else if ([@"x-source-name-zh-HK" isEqualToString:key])
                {
                    [CoreData sharedCoreData].x_callback_url_source_name_zh_HK = value;
                }
                else if ([@"x-source-name-en" isEqualToString:key])
                {
                    [CoreData sharedCoreData].x_callback_url_source_name_en = value;
                }
                else if ([@"x-success" isEqualToString:key])
                {
                    [CoreData sharedCoreData].x_callback_url_success = value;
                }
            }
        }
        
        DEBUGMSG(@"x_callback_url_source: %@", [CoreData sharedCoreData].x_callback_url_source);
        DEBUGMSG(@"x_callback_url_source_name_en: %@", [CoreData sharedCoreData].x_callback_url_source_name_en);
        DEBUGMSG(@"x_callback_url_source_name_zh_HK: %@", [CoreData sharedCoreData].x_callback_url_source_name_zh_HK);
        DEBUGMSG(@"x_callback_url_success: %@", [CoreData sharedCoreData].x_callback_url_success);
        
        if ([_navigation_controller.topViewController respondsToSelector:@selector(handleCallbackMotherButton)])
        {
            UIViewController *topViewController = _navigation_controller.topViewController;
            [topViewController performSelector:@selector(handleCallbackMotherButton)];
        }
        
        return YES;
    }
    
    NSString *message = NSLocalizedString(([NSString stringWithFormat:@"launch_not_authorized_%@", [CoreData sharedCoreData].lang]), nil);
    
    alertInvalidURL = [[CustomAlertView alloc] initWithMessage:message];
    alertInvalidURL.delegate = self;
    [alertInvalidURL show];
    
    return NO;
}

//Algebra
-(void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
    [[NSNotificationCenter defaultCenter] postNotificationName:statusBarChangedNotification object:nil];
    if (self.navigation_controller==nil) {
        return;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue<7) {
        self.navigation_controller.view.frame = CGRectMake(0, 20, self.navigation_controller.view.frame.size.width, self.navigation_controller.view.frame.size.height);
        
    } else {
        self.navigation_controller.view.frame = CGRectMake(0, 0, self.navigation_controller.view.frame.size.width, self.navigation_controller.view.frame.size.height);
    }
}

#pragma mark - Core
//is not for first time to open the app

//TODO
-(void)handleTabBarLanguage{
    [_next_train_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_line_btn_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    [_next_train_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_line_btn_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
    //    [_station_facilities_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_map_btn_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    //    [_station_facilities_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_map_btn_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
    [_routemap_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_map_btn_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    [_routemap_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_map_btn_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
    [_favorite_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_bookmak_btn_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    [_favorite_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_bookmak_btn_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
    [_contact_us_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_contact_btn_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    [_contact_us_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_contact_btn_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
    
    //    [_more_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tapbar_contact_info_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    //    [_more_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tapbar_contact_info_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    //
    
    
    if([[_navigation_controller.visibleViewController class] isEqual:[SelectStationViewController class]]){
        [(SelectStationViewController *)_navigation_controller.visibleViewController reloadData];
    }
    if([[_navigation_controller.visibleViewController class] isEqual:[MoreViewController class]]){
        [(MoreViewController *)_navigation_controller.visibleViewController reloadData];
    }
    if([[_navigation_controller.visibleViewController class] isEqual:[FavoriteViewController class]]){
        [(FavoriteViewController *)_navigation_controller.visibleViewController reloadData];
    }
    if([[_navigation_controller.visibleViewController class] isEqual:[ContactUsViewController class]]){
        [(ContactUsViewController *)_navigation_controller.visibleViewController reloadData];
    }
    if([[_navigation_controller.visibleViewController class] isEqual:[MapSearchViewController class]]){
        [(MapSearchViewController *)_navigation_controller.visibleViewController reloadData];
    }
    if([[_navigation_controller.visibleViewController class] isEqual:[NextTrainViewController class]]){
        [(NextTrainViewController *)_navigation_controller.visibleViewController reloadData];
    }
    
    
}


-(void)promptAppUpdateAlert{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _update_app_bg_view.alpha = 1;
    [UIView commitAnimations];
}



-(UpdateHandler*)getUpdateHandler
{
    if (updateHandler == nil)
    {
        updateHandler = [[UpdateHandler alloc] init];
        //updateHandler.delegate = self;
    }
    
    return updateHandler;
}



-(void)handleAppUpdatePopUpLanguage{
    _app_update_title_label.text = NSLocalizedString(([NSString stringWithFormat:@"app_update_title_%@", [CoreData sharedCoreData].lang]), nil);
    
    _app_update_content_label.text = NSLocalizedString(([NSString stringWithFormat:@"app_update_content_%@", [CoreData sharedCoreData].lang]), nil);
    
    [_app_update_update_now_button setTitle:NSLocalizedString(([NSString stringWithFormat:@"app_update_update_now_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
    
    [_cancel_button setTitle:NSLocalizedString(([NSString stringWithFormat:@"cancel_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
    
    //jeff 20130829
    _cancel_button.hidden = YES;
    _app_update_update_now_button.frame = CGRectMake(_app_update_update_now_button.frame.origin.x, 138.0, _app_update_update_now_button.frame.size.width, _app_update_update_now_button.frame.size.height);
    
    
    
    
    
}

-(void)handleBannerLanguage
{
    [[CoreData sharedCoreData].banner_view_controller send_request];
}

-(void)launchNextTrainWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode
{
    [_navigation_controller popToRootViewControllerAnimated:NO];
    if(!stationCTR){
        stationCTR = [[SelectStationViewController alloc] initWithNibName:@"SelectStationViewController" bundle:nil];
        stationCTR.launch_line_code = lineCode;
        stationCTR.launch_station_code = stationCode;
        [_navigation_controller pushViewController:stationCTR animated:NO];
    }
    
}

-(void)sendPushNotificationTokenToServer
{
    NSString *token = [CoreData sharedCoreData].psuh_token;
    
    if (token != nil)
    {
        ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@UDID=%@&token=%@&cs=%@&dt=%@&lang=%@",
                                                                                             pushNotificationAPI,
                                                                                             [CoreData sharedCoreData].udid,
                                                                                             token,
                                                                                             [CoreData md5:[NSString stringWithFormat:@"%@nexttrainmtrmtel%@", [CoreData sharedCoreData].udid,token]],
                                                                                             [CoreData sharedCoreData].device,
                                                                                             [CoreData sharedCoreData].lang]]] autorelease];
        DEBUGMSG(@"Push URL: %@", request.url);
        [[CoreData sharedCoreData].common_queue addOperation:request];
    }
}

#pragma mark - ASIHTTPRequest Parsing And Handling

/*
 -(BOOL)parseAndHandleUpdateAPIForCommon:(ASIHTTPRequest*)request{
 if([request responseStatusCode] != 200){
 //        [[CoreData sharedCoreData].connection_failed_view_controller showView];
 
 CustomAlertView *alert = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"no_connection_content_%@", [CoreData sharedCoreData].lang]), nil)];
 [alert show];
 [alert release];
 
 return YES;
 }
 
 [_result_record removeAllObjects];
 
 NSArray *item_array = PerformXMLXPathQuery([request responseData], [NSString stringWithFormat:@"//versions/iphone/version[num='%@']", [CoreData sharedCoreData].app_version]);
 
 NSString *app_need_update = nil;
 
 for(int x = 0; item_array != nil && x < [item_array count]; x++){
 NSArray *result_array = [[item_array objectAtIndex:x] objectForKey:@"nodeChildArray"];
 for(int y = 0; result_array != nil && y < [result_array count]; y++){
 if([[result_array objectAtIndex:y] objectForKey:@"nodeName"] != nil && [[[result_array objectAtIndex:y] objectForKey:@"nodeName"] isEqualToString:@"is_upgrade_required"]){
 if([[[result_array objectAtIndex:y] objectForKey:@"nodeChildArray"] count] == 1){
 if([[[[result_array objectAtIndex:y] objectForKey:@"nodeChildArray"] objectAtIndex:0] objectForKey:@"nodeContent"] != nil)
 app_need_update = [[[[[[result_array objectAtIndex:y] objectForKey:@"nodeChildArray"] objectAtIndex:0] objectForKey:@"nodeContent"] retain] autorelease];
 }
 else {
 if([[result_array objectAtIndex:y] objectForKey:@"nodeContent"] != nil)
 app_need_update = [[[[result_array objectAtIndex:y] objectForKey:@"nodeContent"] retain] autorelease];
 }
 }
 if([[result_array objectAtIndex:y] objectForKey:@"nodeName"] != nil && [[[result_array objectAtIndex:y] objectForKey:@"nodeName"] isEqualToString:@"resources"]){
 NSArray *resources_array = [[result_array objectAtIndex:y] objectForKey:@"nodeChildArray"];
 for(int z = 0; resources_array != nil && z < [resources_array count]; z++){
 NSArray *attribute_array = [[resources_array objectAtIndex:z] objectForKey:@"nodeAttributeArray"];
 if(attribute_array != nil){
 [_result_record setObject:attribute_array forKey:[[resources_array objectAtIndex:z] objectForKey:@"nodeName"]];
 }
 }
 }
 }
 }
 
 BOOL go_to_check_has_available_update_found_today = [self handleAppUpdate:app_need_update];
 [self setLatestCheckingDate];
 
 return go_to_check_has_available_update_found_today;
 }
 */

#pragma mark -
#pragma mark Handle Click Button Events

-(IBAction)clickUpdateNowButton:(UIButton*)button{
    //lack of id, can find in itunes connect
    //itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=mt=8
    //    NSMutableDictionary *plist_record = [[[NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path] retain] autorelease];
    //    [plist_record setObject:@"YES" forKey:@"first_time"];
    
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?mt=8"]];
    [[self getUpdateHandler] updateNow];
}

-(IBAction)clickQuitAppButton:(UIButton*)button{
    _update_app_bg_view.alpha = 0;
    // exit(0);
}

-(IBAction)clickNextTrainButton:(UIButton*)button{
    //    [_navigation_controller popToRootViewControllerAnimated:NO];
    
    //    stationCTR = [[SelectStationViewController alloc] initWithNibName:@"SelectStationViewController" bundle:nil];
    //    [_navigation_controller pushViewController:temp animated:NO];
    //    [temp release];
    if(!stationCTR){
        stationCTR = [[SelectStationViewController alloc] initWithNibName:@"SelectStationViewController" bundle:nil];
        
    }else{
        [stationCTR hideNextTrainViewController];
    }
    [_navigation_controller popToRootViewControllerAnimated:NO];
    [_navigation_controller pushViewController:stationCTR animated:NO];
}

-(IBAction)clickStationFacilitiesButton:(UIButton *)button{
    [_navigation_controller popToRootViewControllerAnimated:NO];
    //    StationFacilitiesViewController *temp = [[StationFacilitiesViewController alloc] initWithNibName:@"StationFacilitiesViewController" bundle:nil];
    //    [_navigation_controller pushViewController:temp animated:NO];
    //    [temp release];
}

-(IBAction)clickFavoriteButton:(UIButton *)button{
    [_navigation_controller popToRootViewControllerAnimated:NO];
    
    if(!favCTR)
        favCTR = [[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:nil];
    else{
        [favCTR hideBookMarkViewController];
    }
    [_navigation_controller pushViewController:favCTR animated:NO];
    
    
    
}

-(IBAction)clickContactUsButton:(UIButton*)button{
    [_navigation_controller popToRootViewControllerAnimated:NO];
    ContactUsViewController *temp =[[ContactUsViewController alloc] initWithNibName:@"ContactUsViewController" bundle:Nil];
    [_navigation_controller pushViewController:temp animated:NO];
    [temp release];
}


//-(IBAction)NextTrainViewController:(UIButton*)button{
//    [_navigation_controller popToRootViewControllerAnimated:NO];
//    NextTrainViewController *temp =[[NextTrainViewController alloc] initWithNibName:@"NextTrainViewController" bundle:Nil];
//    [_navigation_controller pushViewController:temp animated:NO];
//    [temp release];
//}



-(IBAction)clickMapSearchButton:(UIButton*)button{
    
    DEBUGLog
    [_navigation_controller popToRootViewControllerAnimated:NO];
    if(!mapCTR){
        mapCTR = [[SelectStationViewController alloc] initWithNibName:@"SelectStationViewController" bundle:nil];
        mapCTR.routemap = YES ;
    }
    [_navigation_controller pushViewController:mapCTR animated:NO];
    
    _routemap_button.selected =  _next_train_button.selected = _station_facilities_button.selected = _favorite_button.selected = _contact_us_button.selected = _more_button.selected = NO;
    _routemap_button.selected = YES;
    
    
    
    UIAlertView * myAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(([NSString stringWithFormat:@"select_StationAlert_%@", [CoreData                                      sharedCoreData].lang]), nil)
                                                     message:@""
                                                    delegate:self 
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil];
    [myAlert show];
    [self performSelector:@selector(dismissAlertView:) withObject:myAlert afterDelay:2];
}


-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

//- (void)dismissAfterDelay
//{
//    [CustomAlertView ]
//}
//- (void)dismissAfterDelay
//{
//    [self dismissWithClickedButtonIndex:0 animated:NO];
//}


- (IBAction)clickLanguageButton:(UIButton *)sender {
    
    //    _next_train_button.selected = YES;
    [customerActionSheet show];
    
    
}


- (IBAction)clickUpdateButton:(UIButton *)sender {
    _next_train_button.selected = YES;
    
    [_navigation_controller popToRootViewControllerAnimated:NO];
    MoreViewController *temp = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    [_navigation_controller pushViewController:temp animated:NO];
    [temp release];
    
    [self.revealController revealToggle:nil];
    
    
    
}

- (IBAction)clickTermsButton:(UIButton *)sender {
    _next_train_button.selected = YES;
    
    [_navigation_controller popToRootViewControllerAnimated:NO];
    MoreViewController *temp = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    [_navigation_controller pushViewController:temp animated:NO];
    
    temp.isShowingTNC =TRUE;
    [temp release];
    
    [self.revealController revealToggle:nil];
    
    
    
}

- (IBAction)clickCheckUpdateButton:(UIButton *)sender {
    
    [_navigation_controller popToRootViewControllerAnimated:NO];
    MoreViewController *temp = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    [_navigation_controller pushViewController:temp animated:NO];
    temp.isShowingCheckUpdate =TRUE;
    [temp release];
    
    [self.revealController revealToggle:nil];
    
}

- (IBAction)clickTutorialButton:(UIButton *)sender {
    if (isShowingInAppTutorialAll)
        return;
    
    TutorialAllViewController *tutorial = [[[TutorialAllViewController alloc] initWithNibName:@"TutorialAllViewController" bundle:nil] autorelease];
    tutorial.parent = self;
    [_navigation_controller presentViewController:tutorial animated:YES completion:nil];
    
    //[_navigation_controller presentModalViewController:tutorial animated:YES];
    
    isShowingInAppTutorialAll = YES;
    
    [[(NextTrainAppDelegate *)[[UIApplication sharedApplication] delegate] tab_bar_bg_view] setHidden:YES];
    
}

-(void)hideInAppTutorialAll
{
    if (isShowingInAppTutorialAll)
    {
        //[_navigation_controller dismissModalViewControllerAnimated:YES];
        [_navigation_controller dismissViewControllerAnimated:YES completion:nil];
        isShowingInAppTutorialAll = NO;
    }
    
    [[(NextTrainAppDelegate *)[[UIApplication sharedApplication] delegate] tab_bar_bg_view] setHidden:NO];
    
}

#pragma mark -
#pragma mark Set Languages



-(void)setupLang{
	NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
	if([user_defaults objectForKey:@"lang"] == nil) {
		NSArray *apple_languages = [user_defaults objectForKey:@"AppleLanguages"];
		NSString *system_language = nil;
        if(apple_languages != nil && [apple_languages count] > 0)
            system_language = [apple_languages objectAtIndex:0];
		if([system_language isEqualToString:@"en"]){
			[user_defaults setObject:@"en" forKey:@"lang"];
		}
		else if([system_language isEqualToString:@"zh-Hant"]){
			[user_defaults setObject:@"zh_TW" forKey:@"lang"];
		}
		else{
			[user_defaults setObject:@"en" forKey:@"lang"];
		}
		[user_defaults synchronize];
	}
	[CoreData sharedCoreData].lang = [user_defaults objectForKey:@"lang"];
}

#pragma mark -
#pragma mark Notification Delegate
-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DEBUGMSG(@"didRegisterForRemoteNotificationsWithDeviceToken");
    
	NSString *token = [[[[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    [CoreData sharedCoreData].psuh_token = token;
    
    [self sendPushNotificationTokenToServer];
}

-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DEBUGMSG(@"didFailToRegisterForRemoteNotificationsWithError");
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    DEBUGMSG(@"didReceiveRemoteNotification");
}

#pragma mark -
#pragma mark Handle UINavigationControllerDelegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    DEBUGLog
    //    _isInServiceNoticeSection = NO;
    _tab_bar_bg_view.hidden = NO;
    
    
    // Alex
	if([[viewController.navigationController.visibleViewController class] isEqual:[RootViewController class]] ||
       [[viewController.navigationController.visibleViewController class] isEqual:[SystemMapViewController class]])
    {
        _routemap_button.selected =  _next_train_button.selected = _station_facilities_button.selected = _favorite_button.selected = _contact_us_button.selected = _more_button.selected = NO;
        
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        
        CGRect frame = _tab_bar_bg_view.frame;
        frame.origin.y = screenBound.size.height - frame.size.height;
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
            frame.origin.y -=20;
        }
        
        //_tab_bar_bg_view.frame = frame;
        if([[viewController.navigationController.visibleViewController class] isEqual:[RootViewController class]]){
            _tab_bar_bg_view.hidden = YES;
        }
        if([[viewController.navigationController.visibleViewController class] isEqual:[SystemMapViewController class]]){
            _tab_bar_bg_view.hidden = YES;
        }
        
		[UIView commitAnimations];
	}
    else{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        
        
        CGRect frame = _tab_bar_bg_view.frame;
        //Algebra
        frame.origin.y = screenBound.size.height - frame.size.height - ([UIApplication sharedApplication].statusBarFrame.size.height - 20);
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
            frame.origin.y -=20;
        }
        
        //_tab_bar_bg_view.frame = frame;
        
		[UIView commitAnimations];
    }
    
    
    if([[viewController.navigationController.visibleViewController class] isEqual:[SelectStationViewController class]]){
        //        _isInServiceNoticeSection = YES;
        
        _routemap_button.selected =  _station_facilities_button.selected = _favorite_button.selected = _contact_us_button.selected = _more_button.selected = NO;
        
        if ([(SelectStationViewController *)viewController.navigationController.visibleViewController routemap]) {
            _more_button.selected = YES;
            _routemap_button.selected = YES;
        }else{
            _next_train_button.selected = YES;
        }
        
    }
    
    else if([[viewController.navigationController.visibleViewController class] isEqual:[FavoriteViewController class]]){
        _routemap_button.selected =  _next_train_button.selected = _station_facilities_button.selected = _contact_us_button.selected = _more_button.selected = NO;
        _favorite_button.selected = YES;
        
    }
    else if([[viewController.navigationController.visibleViewController class] isEqual:[MoreViewController class]]){
        _routemap_button.selected =  _next_train_button.selected = _station_facilities_button.selected = _favorite_button.selected = _contact_us_button.selected = NO;
        _routemap_button.selected = YES;
        
    }
    else if([[viewController.navigationController.visibleViewController class] isEqual:[ContactUsViewController class]]){
        _routemap_button.selected =  _next_train_button.selected = _station_facilities_button.selected = _favorite_button.selected = _more_button.selected = NO;
        _contact_us_button.selected = YES;
        
    }
    
}



#pragma mark - Custom Alert View Delegate

-(void)CustomAlertView:(CustomAlertView *)currentCustomAlertView didDismissWithButtonIndex:(int)buttonIndex
{
    //exit(0);
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
}


-(void)handleGlobalLanguagSetting{
    [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) handleTabBarLanguage];
    [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) handleAppUpdatePopUpLanguage];
    [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) handleBannerLanguage];
    [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) sendPushNotificationTokenToServer];
    
    [_slideMenuView setLang];
}

#pragma mark - CustomerActionSheet Delegte

-(void)CustomerActionSheet:(CustomerActionSheetViewController*)currentCustomAlertView didDismissWithButtonIndex:(int)buttonIndex{
    
    if (buttonIndex == 0 ) {
        [CoreData sharedCoreData].lang = @"zh_TW";
        [self handleLocalLanguageSetting];
        [self handleGlobalLanguagSetting];
    }else if (buttonIndex == 1 ){
        [CoreData sharedCoreData].lang = @"en";
        [self handleLocalLanguageSetting];
        [self handleGlobalLanguagSetting];
    }
    
    [self.revealController revealToggle:nil];
    
    
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

-(void) requestFinished:(ASIHTTPRequest *)request {
    
    [[CoreData sharedCoreData].mask hiddenMask];
    
    DEBUGMSG(@"status code: %i", request.responseStatusCode);
    
    if (request.responseStatusCode == 200)
    {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (defaults != nil ) {
            [defaults setValue:[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"systemmap_version"] ] forKey:@"systemmap_version"];
        }
        [defaults  synchronize];
        [CoreData sharedCoreData].btn_miniMap = [defaults objectForKey:@"systemmap_version"];
        
        DEBUGMSG(@"systemmap_version%@",[CoreData sharedCoreData].btn_miniMap);
        
        // [CoreData sharedCoreData].btn_miniMap = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"systemmap_version"] ];
        // [CoreData sharedCoreData].sv_system_map = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"systemmap_version"] ];
        
    }
    
}

-(void) requestFailed:(ASIHTTPRequest *)request {
    
    [[CoreData sharedCoreData].mask hiddenMask];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [CoreData sharedCoreData].btn_miniMap = [defaults objectForKey:@"systemmap_version"];
    
}

@end
