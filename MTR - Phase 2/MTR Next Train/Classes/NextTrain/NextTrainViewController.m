//
//  NextTrainViewController.m
//  MTR Next Train
//
//  Created by  on 12年2月9日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.


#import "NextTrainViewController.h"
#import "Flurry.h"

@interface NextTrainViewController ()<CustomAlertViewDelegate>

@property (nonatomic, assign) BOOL bFirstTimeToAddEvent;

@end

@implementation NextTrainViewController

@synthesize station_record =_station_record;
@synthesize station_records =_station_records;
@synthesize station_records_with_station_as_key = _station_records_with_station_as_key;
@synthesize line_records_with_line_as_key = _line_records_with_line_as_key;
@synthesize btn_left, btn_right;
@synthesize isShowing = _isShowing;
@synthesize parentViewController,wrlStations;
@synthesize isReloading = _isReloading;
//@synthesize swipeGestureRecognizerLeft;
//@synthesize swipeGestureRecognizerRight;

#define VIEW_SHOW_ORIGIN_Y 0
#define VIEW_HIDE_ORIGIN_Y 405

#define VIEW_SHOW_ORIGIN_Y_5 0


#define STATION_CODE_TERMINAL_AEL_UP @"AWE"
#define STATION_CODE_TERMINAL_AEL_UP_NAME1 @"AWE"
#define STATION_CODE_TERMINAL_AEL_UP_NAME2 @"AIR"
#define STATION_CODE_TERMINAL_AEL_DOWN @"HOK"
#define STATION_CODE_TERMINAL_TCL_UP @"TUC"
#define STATION_CODE_TERMINAL_TCL_DOWN @"HOK"
#define STATION_CODE_TERMINAL_WRL_UP @"TUM"
#define STATION_CODE_TERMINAL_WRL_DOWN @"HUH"
#define STATION_CODE_AEL_KOW @"KOW"
#define STATION_CODE_AEL_TSY @"TSY"

//Alex
#define STATION_CODE_TERMINAL_TKL_UP @"POA"
#define STATION_CODE_TERMINAL_TKL_UP_NAME1 @"POA"
#define STATION_CODE_TERMINAL_TKL_UP_NAME2 @"LHP"
#define STATION_CODE_TERMINAL_TKL_DOWN @"NOP"



#define VALID_NORMAL_TRAIN @"Y"
#define INVALID_NORMAL_TRAIN @"N"
#define VALID_SPECIAL_TRAIN_NON_AIR @"S"
#define INVALID_SPECIAL_TRAIN_NON_AIR @"I"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        lastUpdateTime = nil;
        self.bFirstTimeToAddEvent = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void)dealloc
{
    DEBUGLog
    
    if (alert_view) {
        [alert_view.view removeFromSuperview];
        [alert_view removeFromParentViewController];
        [alert_view release];
    }
    [self releaseObjects];
    [super dealloc];
    
}

-(void)releaseObjects
{
    isObjectReleased = YES;
    
    [[CoreData sharedCoreData].banner_view_controller hide];
    
    if (_request != nil)
    {
        [_request clearDelegatesAndCancel];
        [_request release];
        _request = nil;
    }
    
    [self stopTimerForUpdateNextTrain];
    
    if (ary_schedule_up != nil)
    {
        [ary_schedule_up release];
        ary_schedule_up = nil;
    }
    if (ary_schedule_down != nil)
    {
        [ary_schedule_down release];
        ary_schedule_down = nil;
    }
    if (redAlertURL != nil)
    {
        [redAlertURL release];
        redAlertURL = nil;
    }
    
    ReleaseObj(_title_label)
    ReleaseObj(tbl_schedule_up)
    ReleaseObj(tbl_schedule_down)
    ReleaseObj(btn_schedule)
    ReleaseObj(btn_route_map)
    ReleaseObj(vw_schedule)
    ReleaseObj(vw_route_map)
    ReleaseObj(vw_schedule_red_alert)
    ReleaseObj(vw_schedule_schedule)
    ReleaseObj(vw_schedule_schedule_up)
    ReleaseObj(vw_schedule_schedule_down)
    ReleaseObj(lbl_line_name)
    ReleaseObj(lbl_line_name_for_test)
    ReleaseObj(lbl_station_name)
    ReleaseObj(lbl_up_terminal)
    ReleaseObj(lbl_down_terminal)
    ReleaseObj(lbl_red_alert_message)
    ReleaseObj(img_up_terminal)
    ReleaseObj(img_down_terminal)
    ReleaseObj(lbl_up_destination)
    ReleaseObj(lbl_up_platform)
    ReleaseObj(lbl_up_time)
    ReleaseObj(lbl_down_destination)
    ReleaseObj(lbl_down_platform)
    ReleaseObj(lbl_down_time)
    ReleaseObj(btn_view_system_map)
    ReleaseObj(lbl_last_update_time)
    ReleaseObj(btn_favorite_station)
    ReleaseObj(vw_no_train_schedule_up)
    ReleaseObj(vw_no_train_schedule_down)
    ReleaseObj(lbl_no_train_schedule_up)
    ReleaseObj(lbl_no_train_schedule_down)
    ReleaseObj(btn_close_system_map)
    ReleaseObj(vw_loading_up)
    ReleaseObj(vw_loading_down)
    ReleaseObj(vw_terminal_background)
    ReleaseObj(img_subtitle_bar_up)
    ReleaseObj(img_subtitle_bar_down)
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    wrlStations = [[NSMutableArray alloc]initWithObjects:@"HUH",@"ETS",@"AUS",@"MEF",@"TWW",@"KSR",@"YUL",@"LOP",@"TIS",@"SIH",@"TUM",nil];
    // Do any additional setup after loading the view from its nib.
    
    
    //[btn_view_system_map setBackgroundImage:[UIImage imageNamed:NSLocalizedString(([NSString stringWithFormat:@"slide_route_map_view_system_map_%@", [CoreData sharedCoreData].lang]), nil)] forState:UIControlStateNormal];
    
    lastUpdateTime = nil;
    [self displayLastUpdateTime];
    
    _isShowing = NO;
    
    vw_schedule.alpha = 1;
    vw_route_map.alpha = 0;
    
    [_scView setContentSize:CGSizeMake(419, 571)];
    [_scView setContentOffset:CGPointMake(23,125)];
    
    [self startTimerForUpdateNextTrain];
    
    // gesture
    UISwipeGestureRecognizer *swipeGestureRecognizerDown =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(clickHideButton:)];
    
    swipeGestureRecognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureRecognizerDown];
    [swipeGestureRecognizerDown release];
    
    swipeGestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeGestureRecognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureRecognizerLeft];
    
    swipeGestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeGestureRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRecognizerRight];
    
}



-(void)reloadData{
    
    if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
        _lang = [@"eng" retain];
    }
    else{
        _lang = [@"chi" retain];
    }
    
    [_title_label setText:NSLocalizedString(([NSString stringWithFormat:@"schedule_%@", [CoreData sharedCoreData].lang]), nil)];

    _title_label.text = NSLocalizedString(([NSString stringWithFormat:@"schedule_%@", [CoreData sharedCoreData].lang]), nil);
    //    _title_label.text = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
    
    [btn_schedule setTitle:NSLocalizedString(([NSString stringWithFormat:@"schedule_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
    [btn_route_map setTitle:NSLocalizedString(([NSString stringWithFormat:@"route_map_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
    
    [lbl_no_train_schedule_down setText:NSLocalizedString(([NSString stringWithFormat:@"train_service_ended_%@", [CoreData sharedCoreData].lang]), nil)];
    [lbl_no_train_schedule_up setText:NSLocalizedString(([NSString stringWithFormat:@"train_service_ended_%@", [CoreData sharedCoreData].lang]), nil)];
    
    [self arrangeScheduleViewForTerminal];
    [self reloadGetSchedule];
    [tbl_schedule_up reloadData];
    [tbl_schedule_down reloadData];
}


- (void)swipeLeft:(UISwipeGestureRecognizer *)gesture
{
    DEBUGMSG(@"Left Swipe received.");
    //(1=right)
    DEBUGMSG(@"Direction is: %i", gesture.direction);
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        //Left swipe gesture.
        
        _index++;
        if (_index >  [self.favorite_station_array count] -1) {
            _index = [self.favorite_station_array count] -1 ;
            return;
        }
        
        DEBUGMSG(@"%@", self.favorite_station_array)
        
        DEBUGLog
        NSMutableDictionary *favorite_station = [self.favorite_station_array objectAtIndex:_index];
        NSString *station_code = [favorite_station objectForKey:@"station_code"];
        NSString *line_code = [favorite_station objectForKey:@"line_code"];
        
        
        NSString *line_station_key = [NSString stringWithFormat:@"%@-%@", line_code, station_code];
        self.station_record = [self.station_records_with_station_as_key objectForKey:line_station_key];
        
        [self reloadGetSchedule];
        [self showSchedule];
    }
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture
{
    DEBUGMSG(@"Right Swipe received.");//Lets you know this method was called by gesture recognizer.
    
    //(2=left)
    
    
    DEBUGMSG(@"Direction is: %i", gesture.direction);
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        //Right swipe gesture.
        
        
        _index--;
        
        if (_index < 0) {
            _index = 0 ;
            return;
            
        }
        //    btn_right.hidden =([self.favorite_station_array count]-1 == _index);
        
        //
        DEBUGLog
        
        
        NSMutableDictionary *favorite_station = [self.favorite_station_array objectAtIndex:_index];
        NSString *station_code = [favorite_station objectForKey:@"station_code"];
        NSString *line_code = [favorite_station objectForKey:@"line_code"];
        
        
        NSString *line_station_key = [NSString stringWithFormat:@"%@-%@", line_code, station_code];
        self.station_record = [self.station_records_with_station_as_key objectForKey:line_station_key];
        
        [self reloadGetSchedule];
        [self showSchedule];

    }
}




-(void)hideBookViewController{
    if(nextTrainViewController)
        [nextTrainViewController didHidden];
    
}

- (void)viewDidUnload
{
    //    [self setClickNextBookMarkButton:nil];
    //    [self setClickNextBookmarkButton:nil];
    //    [self setClickNextBookmarkButton:nil];
    //    [self setClickBackButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// functions will not be triggered
/*
 -(void)viewWillAppear:(BOOL)animated
 {
 DEBUGLog
 [super viewWillAppear:animated];
 }
 
 -(void)viewWillDisappear:(BOOL)animated
 {
 DEBUGLog
 [super viewWillDisappear:animated];
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - main functions
-(void)reloadGetSchedule
{
    if (self.bFirstTimeToAddEvent && [self.station_record objectForKey:@"LINE"] && [self.station_record objectForKey:@"STATION_CODE"]) {
        self.bFirstTimeToAddEvent = NO;
        [Flurry logEvent:[self.station_record objectForKey:@"LINE"]];
        [Flurry logEvent:[NSString stringWithFormat:@"%@-%@", [self.station_record objectForKey:@"LINE"], [self.station_record objectForKey:@"STATION_CODE"]]];
    }
    
    if (isObjectReleased)
        return;
    
//    DEBUGMSG(@"reloadGetSchedule");
    
//    if (isReloading)
//        return;
    
    DEBUGMSG(@"NextTrainViewController Station Record %@: ", _station_record);
//    DEBUGMSG(@"_station_record.....%@",_station_record);
    
    if ([_station_record objectForKey:@"STATION_CODE"] == nil ||
        [_station_record objectForKey:@"LINE"] == nil)
    {
        return;
    }
    
    isReloading = YES;
    
    isRedAlert = NO;
    isNoInternet = NO;
    isNoValidScheduleUp = NO;
    isNoValidScheduleDown = NO;
    isTrainEndedUp = NO;
    isTrainEndedDown = NO;
    
    
    
    [self startFlashingbutton:self.btn_left.imageView];
    [self startFlashingbutton:self.btn_right.imageView];
    //    [self flashOn:btn_right];
    // determine whether is terminal station
    isTerminalUp = [self isTerminalUpForLineCode:[_station_record objectForKey:@"LINE"] stationCode:[_station_record objectForKey:@"STATION_CODE"]];
    isTerminalDown = [self isTerminalDownForLineCode:[_station_record objectForKey:@"LINE"] stationCode:[_station_record objectForKey:@"STATION_CODE"]];
    isNoValidAELDown = [self isNoValidAELDownForLineCode:[_station_record objectForKey:@"LINE"] stationCode:[_station_record objectForKey:@"STATION_CODE"]];
    
    
    // clear schedule before reload
    [self clearSchedule];
    
    // display station names
    NSString *line_name = [self lineNameWithLine:[_station_record objectForKey:@"LINE"]];
    NSString *station_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:[_station_record objectForKey:@"STATION_CODE"]];
    
    [lbl_line_name_for_test setText:[NSString stringWithFormat:@"%@ - ", line_name]];
    [lbl_line_name_for_test sizeToFit];
    [lbl_line_name setText:[NSString stringWithFormat:@"%@ - %@", line_name,station_name]];
    //    CGRect lineFrame = lbl_line_name.frame;
    //    lineFrame.size.width = lbl_line_name_for_test.frame.size.width;
    //    lbl_line_name.frame = lineFrame;
    //    [lbl_station_name setText:[NSString stringWithFormat:@"%@", station_name]];
    //    CGRect stationFrame = lbl_station_name.frame;
    //    stationFrame.origin.x = lbl_line_name.frame.origin.x + lbl_line_name.frame.size.width;
    //    lbl_station_name.frame = stationFrame;
    
    // display terminal names
    //    NSString *up_terminal = nil;
    //    NSString *down_terminal = nil;
    
    // Alex
    NSString *up_terminal_name = @"";
    NSString *down_terminal_name = @"";
    UIColor *color = [UIColor grayColor];
    if([[_station_record objectForKey:@"LINE"] isEqualToString:@"AEL"]){
        color = [UIColor colorWithRed:28.0/255.0 green:118.0/255.0 blue:112.0/255.0 alpha:1];
        
        
    }
    else if([[_station_record objectForKey:@"LINE"] isEqualToString:@"TCL"]){
        color = [UIColor colorWithRed:230.0/255.0 green:151.0/255.0 blue:32.0/255.0 alpha:1];
        
    }
    else if([[_station_record objectForKey:@"LINE"] isEqualToString:@"WRL"]){
        color = [UIColor colorWithRed:158/255.0 green:52/255.0 blue:144/255.0 alpha:1];
        
    }
    
    else if([[_station_record objectForKey:@"LINE"] isEqualToString:@"TKL"]){
        color = [UIColor colorWithRed:100/255.0 green:10.0/255.0 blue:103.0/255.0 alpha:1];
        
    }
    lbl_line_name.textColor =color;
    [img_up_terminal setBackgroundColor:color];
    [img_down_terminal setBackgroundColor:color];
    
    if ([[_station_record objectForKey:@"LINE"] isEqualToString:@"AEL"])
    {
        if ([[_station_record objectForKey:@"STATION_CODE"] isEqualToString:STATION_CODE_TERMINAL_AEL_UP_NAME2])
        {
            // Airport -- Display "AsiaWorld-Expo"
            if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
            {
                up_terminal_name = [NSString stringWithFormat:@"%@ (%@)",
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_AEL_UP_NAME1],
                                    STATION_CODE_TERMINAL_AEL_UP_NAME1];
            }
            else
            {
                up_terminal_name = [NSString stringWithFormat:@"%@",
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_AEL_UP_NAME1]];
            }
        }
        else
        {
            // Others -- Display "Airport / AsiaWorld-Expo"
            if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
            {
                up_terminal_name = [NSString stringWithFormat:@"%@ (%@) / %@ (%@)",
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_AEL_UP_NAME2],
                                    STATION_CODE_TERMINAL_AEL_UP_NAME2,
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_AEL_UP_NAME1],
                                    STATION_CODE_TERMINAL_AEL_UP_NAME1];
            }
            else
            {
                up_terminal_name = [NSString stringWithFormat:@"%@ / %@",
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_AEL_UP_NAME2],
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_AEL_UP_NAME1]];
            }
        }
        
        if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
        {
            down_terminal_name = [NSString stringWithFormat:@"%@ (%@)",
                                  [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_AEL_DOWN],
                                  STATION_CODE_TERMINAL_AEL_DOWN];
        }
        else
        {
            down_terminal_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_AEL_DOWN];
        }
        
        //        [img_up_terminal setImage:[UIImage imageNamed:@"slide_schedule_titlebar_airport_express.png"]];
        //        [img_down_terminal setImage:[UIImage imageNamed:@"slide_schedule_titlebar_airport_express.png"]];
    }
    else if ([[_station_record objectForKey:@"LINE"] isEqualToString:@"TCL"])
    {
        up_terminal_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TCL_UP];
        down_terminal_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TCL_DOWN];
        
        //        [img_up_terminal setImage:[UIImage imageNamed:@"slide_schedule_titlebar_tung_chung_line.png"]];
        //        [img_down_terminal setImage:[UIImage imageNamed:@"slide_schedule_titlebar_tung_chung_line.png"]];
    }
    
    
    else if ([[_station_record objectForKey:@"LINE"] isEqualToString:@"TKL"])
        // Alex
    {
        if ([[_station_record objectForKey:@"STATION_CODE"] isEqualToString:STATION_CODE_TERMINAL_TKL_UP_NAME2]){
            // Airport -- Display "Po Lam"
            if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
            {
                up_terminal_name = [NSString stringWithFormat:@"%@ (%@)",
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME1],
                                    STATION_CODE_TERMINAL_TKL_UP_NAME1];
            }
            else
            {
                up_terminal_name = [NSString stringWithFormat:@"%@",
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME1]];
            }
            
        }
        
        //LOHAS Park station
        if ([[_station_record objectForKey:@"STATION_CODE"] isEqualToString:STATION_CODE_TERMINAL_TKL_UP_NAME1]){
            // Airport -- Display "Po Lam"
            if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
            {
                up_terminal_name = [NSString stringWithFormat:@"%@ (%@)",
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME2],
                                    STATION_CODE_TERMINAL_TKL_UP_NAME1];
                
            }
            else
            {
                up_terminal_name = [NSString stringWithFormat:@"%@",
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME2]];
            }
            
        }
        
        
        else{
            // Others -- Display "Lohas Park / Po Lam"
            if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
            {
                up_terminal_name = [NSString stringWithFormat:@"%@ (%@) / %@ (%@)",
                                     [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME1],
                                    STATION_CODE_TERMINAL_TKL_UP_NAME1,
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME2],
                                     STATION_CODE_TERMINAL_TKL_UP_NAME2];
            }
            else
            {
                up_terminal_name = [NSString stringWithFormat:@"%@ / %@",
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME1],
                                    [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME2]];
            }
            
        }
        if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
        {


            down_terminal_name = [NSString stringWithFormat:@"%@ (%@)",
                                [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_DOWN],
                                STATION_CODE_TERMINAL_TKL_DOWN];


        }
        else
        {
            down_terminal_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_DOWN];
        }
    }
    // Dont Delete
    //    {
    //        up_terminal_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP];
    //        down_terminal_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_DOWN];
    //
    //        //        [img_up_terminal setImage:[UIImage imageNamed:@"slide_schedule_titlebar_tung_chung_line.png"]];
    //        //        [img_down_terminal setImage:[UIImage imageNamed:@"slide_schedule_titlebar_tung_chung_line.png"]];
    //        DEBUGMSG(@"up_terminal_name%@",up_terminal_name)
    //        DEBUGMSG(@"down_terminal_name%@",down_terminal_name)
    //
    //    }
    //
    
    // Louhas Park Station
    if ([[_station_record objectForKey:@"STATION_CODE"] isEqualToString:@"LHP"]){
        
        if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
        {
            up_terminal_name = [NSString stringWithFormat:@"%@ (%@) / %@ (%@)",
                                [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_DOWN],
                                STATION_CODE_TERMINAL_TKL_DOWN,
                                [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME1],
                                STATION_CODE_TERMINAL_TKL_UP_NAME1];        }
        else
        {
            up_terminal_name = [NSString stringWithFormat:@"%@ / %@",
                                [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_DOWN],
                                [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME1]];
            
            
        }

        
    }
    
    //Alex Hang Hau Station
    
    
    if ([[_station_record objectForKey:@"STATION_CODE"] isEqualToString:@"HAH"]){
        if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
        {
            
            up_terminal_name = [NSString stringWithFormat:@"%@ (%@)",
                                  [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME1],
                                  STATION_CODE_TERMINAL_TKL_UP_NAME1];
           
            down_terminal_name = [NSString stringWithFormat:@"%@ (%@) / %@ (%@)",
                                [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_DOWN],
                                STATION_CODE_TERMINAL_TKL_DOWN,
                                [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME2],
                                STATION_CODE_TERMINAL_TKL_UP_NAME2];
    
        }
        
        
        else{
        up_terminal_name = [NSString stringWithFormat:@"%@",
                            [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME1]];
        down_terminal_name = [NSString stringWithFormat:@"%@ / %@",
                              [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_DOWN],
                              [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME2]];
        }
    }
    
    
    // Po Lam Station
    if ([[_station_record objectForKey:@"STATION_CODE"] isEqualToString:@"POA"]){
        if ([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
            
            
            down_terminal_name = [NSString stringWithFormat:@"%@ (%@) / %@ (%@)",
                                  [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_DOWN],
                                  STATION_CODE_TERMINAL_TKL_DOWN,
                                  [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME2],
                                  STATION_CODE_TERMINAL_TKL_UP_NAME2];
            
        }else{
        down_terminal_name = [NSString stringWithFormat:@"%@ / %@",
                              [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_DOWN],
                              [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_TKL_UP_NAME2]];
        }
    }
    
    else if ([[_station_record objectForKey:@"LINE"] isEqualToString:@"WRL"])
    {
        up_terminal_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_WRL_UP];
        down_terminal_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_WRL_DOWN];
        //        [img_up_terminal setImage:[UIImage imageNamed:@"slide_schedule_titlebar_west_rail_line.png"]];
        //        [img_down_terminal setImage:[UIImage imageNamed:@"slide_schedule_titlebar_west_rail_line.png"]];
    }
    
    //    if (up_terminal != nil)
    //    {
    //        up_terminal_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:up_terminal];
    //    }
    //    if (down_terminal != nil)
    //    {
    //        down_terminal_name = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:down_terminal];
    //    }
    
    [lbl_up_terminal setText:[NSString stringWithFormat:@"%@%@", NSLocalizedString(([NSString stringWithFormat:@"to_%@", [CoreData sharedCoreData].lang]), nil), up_terminal_name]];
    [lbl_down_terminal setText:[NSString stringWithFormat:@"%@%@", NSLocalizedString(([NSString stringWithFormat:@"to_%@", [CoreData sharedCoreData].lang]), nil), down_terminal_name]];
    
    // check for favorite
    [self handleFavoriteStation];
    
    UpdateHandler *updateHandler = [[UpdateHandler alloc] init];
    BOOL hasNetwork = [updateHandler hasNetwork];
    [updateHandler release];
    
    if (hasNetwork)
    {
        // request for schedule
        if (_request != nil)
        {
            [_request clearDelegatesAndCancel];
            [_request release];
            _request = nil;
        }
        
        //_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@line=%@&sta=%@&lang=%@", getScheduleAPI, [_station_record objectForKey:@"LINE"], [_station_record objectForKey:@"STATION_CODE"], [CoreData sharedCoreData].lang]]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *requestKeyRaw = [NSString stringWithFormat:@"%@|%@|%@|%@|%@", [_station_record objectForKey:@"LINE"], [_station_record objectForKey:@"STATION_CODE"], [CoreData sharedCoreData].lang, [dateFormatter stringFromDate:[NSDate date]], secretKey];
        DEBUGMSG(@"raw: %@", requestKeyRaw);
        NSString *requestKey = [CoreData digest:requestKeyRaw];
        DEBUGMSG(@"raw2: %@", requestKey);
        
        _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@line=%@&sta=%@&lang=%@&key=%@", getScheduleAPI, [_station_record objectForKey:@"LINE"], [_station_record objectForKey:@"STATION_CODE"], [CoreData sharedCoreData].lang, requestKey]]];
        _request.delegate = self;
        [[CoreData sharedCoreData].common_queue addOperation:_request];
        DEBUGMSG(@"URL: %@", _request.url);
        
        //    [[CoreData sharedCoreData].mask showMask];
    }
    else
    {
        isNoInternet = YES;
        // [self requestFailed:nil];
    }
    
}

-(void)clearSchedule
{
    isRedAlert = NO;
    
    if (ary_schedule_up != nil)
    {
        [ary_schedule_up release];
        ary_schedule_up = nil;
    }
    
    if (ary_schedule_down != nil)
    {
        [ary_schedule_down release];
        ary_schedule_down = nil;
    }
    
    [tbl_schedule_up reloadData];
    [tbl_schedule_down reloadData];
    
    lastUpdateTime = nil;
    [self displayLastUpdateTime];
    
    [self refreshScheduleView];
}

-(void)processScheduleFromResponseString:(NSString*)responseString
{
    // clear schedule before reload
    [self clearSchedule];
    
    SBJSON *json = [[SBJSON alloc] init];
	
	NSDictionary* scheduleDictionary = [json objectWithString:responseString];
    
    DEBUGMSG(@"Schedule JSON: %@", scheduleDictionary);
    
	//id syncData = [[myObj valueForKey:@"d"] valueForKey:@"__sync"];
    
    if (scheduleDictionary == nil)
    {
        DEBUGMSG(@"NO Schedule DATA");
        [json release];
        
        isReloading = NO;
        
        return;
	}
    
    //    lastUpdateTime = nil;
    //NSString *currTime = [scheduleDictionary objectForKey:@"curr_time"];
    NSString *sysTime = [scheduleDictionary objectForKey:@"sys_time"];
    if (sysTime != nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        lastUpdateTime = [dateFormatter dateFromString:sysTime];
    }
    [self displayLastUpdateTime];
    
    NSString *isDelay = [scheduleDictionary objectForKey:@"isdelay"];
    if (isDelay != nil && [@"Y" isEqualToString:isDelay])
    {
        isNoValidScheduleUp = YES;
        isNoValidScheduleDown = YES;
    }
    
    NSString *status = [NSString stringWithFormat:@"%@", [scheduleDictionary objectForKey:@"status"]];
    NSString *message = [scheduleDictionary objectForKey:@"message"];
    
    if (status != nil)
    {
        if ([@"1" isEqualToString:status])
        {
            // status: normal -> OK
        }
        else if ([@"0" isEqualToString:status])
        {
            // status: red alert
            DEBUGMSG(@"Abnormal Status: '%@' / message: %@", status, message);
            isRedAlert = YES;
            
            [lbl_red_alert_message setText: (message != nil) ? message : @""];
            //NSString *redAlertMessage = NSLocalizedString(([NSString stringWithFormat:@"red_alert_message_%@", [CoreData sharedCoreData].lang]), nil);
            //[lbl_red_alert_message setText:redAlertMessage];
            
            if (redAlertURL != nil)
            {
                [redAlertURL release];
                redAlertURL = nil;
            }
            if ([scheduleDictionary objectForKey:@"url"] != nil)
            {
                redAlertURL = [[NSString stringWithString:[scheduleDictionary objectForKey:@"url"]] retain];
            }
            
            [json release];
            
            [self refreshScheduleView];
            
            isReloading = NO;
            
            return;
        }
        else if ([@"-1" isEqualToString:status])
        {
            // status: wrong key
            DEBUGMSG(@"Abnormal Status: '%@' / message: %@", status, message);
            [json release];
            
            isReloading = NO;
            
            return;
        }
        else
        {
            // status: error
            DEBUGMSG(@"Abnormal Status: '%@' / message: %@", status, message);
            [json release];
            
            isReloading = NO;
            
            return;
        }
    }
    
    id data = [scheduleDictionary objectForKey:@"data"];
    
    if (data == nil)
    {
        DEBUGMSG(@"No Data");
        [json release];
        
        isReloading = NO;
        
        return;
    }
    
    NSString *station_key = [NSString stringWithFormat:@"%@-%@", [_station_record objectForKey:@"LINE"], [_station_record objectForKey:@"STATION_CODE"]];
    
    id station_schedule = [data objectForKey:station_key];
    
    if (station_schedule == nil)
    {
        DEBUGMSG(@"No Station Schedule");
        [json release];
        
        isReloading = NO;
        
        return;
    }
    
    DEBUGMSG(@"station_schedule %@", station_schedule);
    
    ary_schedule_up = [[NSMutableArray new] retain];
    ary_schedule_down = [[NSMutableArray new] retain];
    
    id station_schedule_up = [station_schedule objectForKey:@"UP"];
    id station_schedule_down = [station_schedule objectForKey:@"DOWN"];
    
    NSArray *temp_ary_schedule_up = nil;
    NSArray *temp_ary_schedule_down = nil;
    
    if (station_schedule_up != nil && ![station_schedule_up isKindOfClass:[NSNull class]])
    {
        temp_ary_schedule_up = [NSArray arrayWithArray:station_schedule_up];
    }
    if (station_schedule_down != nil && ![station_schedule_down isKindOfClass:[NSNull class]])
    {
        temp_ary_schedule_down = [NSArray arrayWithArray:station_schedule_down];
    }
    
    // check whether schedule is valid
    if (temp_ary_schedule_up != nil)
    {
        if ([temp_ary_schedule_up count] > 0)
        {
            BOOL up_valid = YES;
            
            for (int i=0; i<[temp_ary_schedule_up count]; i++)
            {
                NSMutableDictionary *scheduleItem = [temp_ary_schedule_up objectAtIndex:i];
                if ([scheduleItem objectForKey:@"valid"] == nil ||
                    !([VALID_NORMAL_TRAIN isEqualToString:[scheduleItem objectForKey:@"valid"]] ||
                      [VALID_SPECIAL_TRAIN_NON_AIR isEqualToString:[scheduleItem objectForKey:@"valid"]]))
                {
                    up_valid = NO;
                    
                    if (i==0)
                        isNoValidScheduleUp = YES;
                }
                
                // once a train is not valid, trains afterwards are not valid too
                if (!up_valid)
                    break;
                
                [ary_schedule_up addObject:scheduleItem];
            }
        }
    }
    if (temp_ary_schedule_down != nil)
    {
        if ([temp_ary_schedule_down count] > 0)
        {
            BOOL down_valid = YES;
            
            for (int i=0; i<[temp_ary_schedule_down count]; i++)
            {
                NSMutableDictionary *scheduleItem = [temp_ary_schedule_down objectAtIndex:i];
                if ([scheduleItem objectForKey:@"valid"] == nil ||
                    !([VALID_NORMAL_TRAIN isEqualToString:[scheduleItem objectForKey:@"valid"]] ||
                      [VALID_SPECIAL_TRAIN_NON_AIR isEqualToString:[scheduleItem objectForKey:@"valid"]]))
                {
                    down_valid = NO;
                    
                    if (i==0)
                        isNoValidScheduleDown = YES;
                }
                
                // once a train is not valid, trains afterwards are not valid too
                if (!down_valid)
                    break;
                
                [ary_schedule_down addObject:scheduleItem];
            }
        }
    }
    
    if (!isNoValidScheduleUp && [ary_schedule_up count] == 0)
        isTrainEndedUp = YES;
    
    if (!isNoValidScheduleDown && [ary_schedule_down count] == 0)
        isTrainEndedDown = YES;
    
    DEBUGMSG(@"Schedule up: %@", ary_schedule_up);
    DEBUGMSG(@"Schedule down: %@", ary_schedule_down);
    
    DEBUGMSG(@"isTrainEndedUp up: %@",isTrainEndedUp?@"T":@"F")
    DEBUGMSG(@"isTrainEndedDown up: %@",isTrainEndedDown?@"T":@"F")
    
    // determine whether is terminal station
    isTerminalUp = [self isTerminalUpForLineCode:[_station_record objectForKey:@"LINE"] stationCode:[_station_record objectForKey:@"STATION_CODE"]];
    isTerminalDown = [self isTerminalDownForLineCode:[_station_record objectForKey:@"LINE"] stationCode:[_station_record objectForKey:@"STATION_CODE"]];
    isNoValidAELDown = [self isNoValidAELDownForLineCode:[_station_record objectForKey:@"LINE"] stationCode:[_station_record objectForKey:@"STATION_CODE"]];
    
    DEBUGMSG(@"isTerminalUp %d isTerminalDown %d isNoValidAELDown%d", isTerminalUp, isTerminalDown, isNoValidAELDown);
    
    [json release];
    
    [tbl_schedule_up reloadData];
    [tbl_schedule_down reloadData];
    
    isReloading = NO;
    [self refreshScheduleView];
}


-(void)didReloadGetSchedule
{
    // restart timer
    [self startTimerForUpdateNextTrain];
}

#pragma mark - Control functions
-(void)show
{
    DEBUGMSG(@"Show");
    
    CGRect frame = self.view.frame;
    frame.origin.y = VIEW_HIDE_ORIGIN_Y;
    self.view.frame = frame;
    
    self.view.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didShow)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    frame.origin.y = VIEW_SHOW_ORIGIN_Y;
    
    if(isFive == YES)
        frame.origin.y = VIEW_SHOW_ORIGIN_Y_5;
    self.view.frame = frame;
    
    
    if (parentViewController != nil && [parentViewController respondsToSelector:@selector(showBackgroundMask)])
    {
        [parentViewController performSelector:@selector(showBackgroundMask)];
    }
    
    [UIView commitAnimations];
    
    _isShowing = YES;
}


-(void)didShow
{
    [[CoreData sharedCoreData].banner_view_controller show];
    
    [self showInAppTutorial];
}

-(void)hide
{
    // prevent hide slider if showing full screen system map
    if (isShowingSystemMap)
        return;
    
    DEBUGMSG(@"Hide");
    CGRect frame = self.view.frame;
    frame.origin.y = VIEW_SHOW_ORIGIN_Y;
    if(isFive == YES)
        frame.origin.y = VIEW_SHOW_ORIGIN_Y_5;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didHidden)];
    
    frame.origin.y = VIEW_HIDE_ORIGIN_Y;
    self.view.frame = frame;
    
    if (parentViewController != nil && [parentViewController respondsToSelector:@selector(hideBackgroundMask)])
    {
        [parentViewController performSelector:@selector(hideBackgroundMask)];
    }
    
    [UIView commitAnimations];
    [[CoreData sharedCoreData].banner_view_controller hide];
}


-(void)didHidden
{
    
    DEBUGMSG(@"didHidden");
    self.view.hidden = YES;
    _isShowing = NO;
    
    
    if (parentViewController != nil && [parentViewController respondsToSelector:@selector(hideBackgroundMask)])
    {
        [parentViewController performSelector:@selector(hideBackgroundMask)];
    }
    [self removeFromParentViewController];
    
    [[CoreData sharedCoreData].banner_view_controller hide];
}

-(void)showSchedule
{
    [UIView beginAnimations:nil context:nil];
    vw_schedule.alpha = 1;
    vw_route_map.alpha = 0;
    
    [self refreshScheduleView];
    
    [UIView commitAnimations];
    
    btn_schedule.selected = YES;
    btn_route_map.selected = NO;
    
    
    
    
    
    if (_index == 0) {
        self.btn_left.hidden= YES;
        swipeGestureRecognizerLeft.enabled  = YES;
        swipeGestureRecognizerRight.enabled = NO;
    }else{
        self.btn_left.hidden= NO;
        swipeGestureRecognizerLeft.enabled  = YES;
        swipeGestureRecognizerRight.enabled = YES;
        
    }
    
    if ([self.favorite_station_array count]-1 == _index){
        self.btn_right.hidden =YES;
        swipeGestureRecognizerLeft.enabled  = NO;
        swipeGestureRecognizerRight.enabled = YES;
    }else{
        self.btn_right.hidden =NO;
    }
    
    
    
    
    //    self.btn_left.hidden =( _index == 0);
    //    self.btn_right.hidden =([self.favorite_station_array count]-1 == _index);
    
}


-(void)showRouteMap
{
    [UIView beginAnimations:nil context:nil];
    vw_schedule.alpha = 0;
    vw_route_map.alpha = 1;
    [UIView commitAnimations];
    
    btn_schedule.selected = NO;
    btn_route_map.selected = YES;
}

-(void)refreshScheduleView
{
    [self arrangeScheduleViewForTerminal];
    
    [UIView beginAnimations:nil context:nil];
    
    BOOL isNoTrainUp = ([ary_schedule_up count] == 0) ? YES : NO;
    BOOL isNoTrainDown = ([ary_schedule_down count] == 0) ? YES : NO;
    
    vw_schedule_schedule.alpha = (isRedAlert) ? 0 : 1;
    vw_schedule_red_alert.alpha = (isRedAlert) ? 1 : 0;
    
    if (!isRedAlert)
    {
        tbl_schedule_up.alpha = (isReloading || isNoTrainUp || isNoValidScheduleUp || isTerminalUp || isNoInternet || isTrainEndedUp) ? 0 : 1;
        tbl_schedule_down.alpha = (isReloading || isNoTrainDown || isNoValidScheduleDown || isTerminalDown || isNoInternet || isNoValidAELDown || isTrainEndedDown) ? 0 : 1;
        
        vw_no_train_schedule_up.alpha = (isReloading || isNoTrainUp || isNoValidScheduleUp || isTerminalUp || isNoInternet || isTrainEndedUp) ? 1 : 0;
        vw_no_train_schedule_down.alpha = (isReloading || isNoTrainDown || isNoValidScheduleDown || isTerminalDown || isNoInternet || isNoValidAELDown || isTrainEndedDown) ? 1 : 0;
        
        vw_loading_up.alpha = (isReloading && !isTerminalUp) ? 1 : 0;
        vw_loading_down.alpha = (isReloading && !isTerminalDown && !isNoValidAELDown) ? 1 : 0;
        
        NSString *messageUp = @"";
        NSString *messageDown = @"";
        
        // 2012-05-08 logic changed - Begin
        
        if (isReloading || isTerminalUp)
        {
            messageUp = @"";
        }
        else if (isNoInternet)
        {
            messageUp = NSLocalizedString(([NSString stringWithFormat:@"no_information_available_%@", [CoreData sharedCoreData].lang]), nil);
        }
        else if (isTrainEndedUp) //isNoTrainUp)
        {
            messageUp = NSLocalizedString(([NSString stringWithFormat:@"train_service_ended_%@", [CoreData sharedCoreData].lang]), nil);
        }
        else if (isNoValidScheduleUp)
        {
            messageUp = NSLocalizedString(([NSString stringWithFormat:@"no_information_available_%@", [CoreData sharedCoreData].lang]), nil);
        }
        else if (isNoTrainUp)
        {
            messageUp = NSLocalizedString(([NSString stringWithFormat:@"no_information_available_%@", [CoreData sharedCoreData].lang]), nil);
        }
        lbl_no_train_schedule_up.text = messageUp;
        
        if (isReloading || isTerminalDown)
        {
            messageDown = @"";
        }
        else if (isNoInternet)
        {
            messageDown = NSLocalizedString(([NSString stringWithFormat:@"no_information_available_%@", [CoreData sharedCoreData].lang]), nil);
        }
        else if (isTrainEndedDown) //isNoTrainDown)
        {
            messageDown = NSLocalizedString(([NSString stringWithFormat:@"train_service_ended_%@", [CoreData sharedCoreData].lang]), nil);
        }
        else if (isNoValidAELDown)
        {
            messageDown = NSLocalizedString(([NSString stringWithFormat:@"please_take_tung_chung_line_%@", [CoreData sharedCoreData].lang]), nil);
        }
        else if (isNoValidScheduleDown)
        {
            messageDown = NSLocalizedString(([NSString stringWithFormat:@"no_information_available_%@", [CoreData sharedCoreData].lang]), nil);
        }
        else if (isNoTrainDown)
        {
            messageDown = NSLocalizedString(([NSString stringWithFormat:@"no_information_available_%@", [CoreData sharedCoreData].lang]), nil);
        }
        lbl_no_train_schedule_down.text = messageDown;
        
        // 2012-05-08 logic changed - End
        
        /*
         if (isReloading || isTerminalUp)
         {
         messageUp = @"";
         }
         else if (isNoInternet || isNoValidScheduleUp)
         {
         messageUp = NSLocalizedString(([NSString stringWithFormat:@"no_information_available_%@", [CoreData sharedCoreData].lang]), nil);
         }
         else if (isNoTrainUp)
         {
         messageUp = NSLocalizedString(([NSString stringWithFormat:@"train_service_ended_%@", [CoreData sharedCoreData].lang]), nil);
         }
         lbl_no_train_schedule_up.text = messageUp;
         
         if (isNoValidAELDown)
         {
         messageDown = NSLocalizedString(([NSString stringWithFormat:@"please_take_tung_chung_line_%@", [CoreData sharedCoreData].lang]), nil);
         }
         else if (isReloading || isTerminalDown)
         {
         messageDown = @"";
         }
         else if (isNoInternet || isNoValidScheduleDown)
         {
         messageDown = NSLocalizedString(([NSString stringWithFormat:@"no_information_available_%@", [CoreData sharedCoreData].lang]), nil);
         }
         else if (isNoTrainDown)
         {
         messageDown = NSLocalizedString(([NSString stringWithFormat:@"train_service_ended_%@", [CoreData sharedCoreData].lang]), nil);
         }
         lbl_no_train_schedule_down.text = messageDown;
         */
    }
    
    [UIView commitAnimations];
}

-(void)arrangeScheduleViewForTerminal
{
    
    if ([_station_record objectForKey:@"LINE"] != nil &&
        [_station_record objectForKey:@"STATION_CODE"] != nil)
    {
        isTerminalUp = [self isTerminalUpForLineCode:[_station_record objectForKey:@"LINE"] stationCode:[_station_record objectForKey:@"STATION_CODE"]];
        isTerminalDown = [self isTerminalDownForLineCode:[_station_record objectForKey:@"LINE"] stationCode:[_station_record objectForKey:@"STATION_CODE"]];
    }
    
    
    CGRect upFrame = CGRectMake(0, 30, vw_schedule_schedule_up.frame.size.width, vw_schedule_schedule_up.frame.size.height);
    CGRect downFrame = CGRectMake(0, 176, vw_schedule_schedule_up.frame.size.width, vw_schedule_schedule_up.frame.size.height);
    
    DEBUGMSG(@"isTerminalUp %d isTerminalDown %d", isTerminalUp, isTerminalDown);

    
    if (isTerminalUp)
    {
        vw_schedule_schedule_up.hidden = YES;
        vw_schedule_schedule_down.hidden = NO;
        vw_schedule_schedule_down.frame = upFrame;
        vw_terminal_background.hidden = NO;
    }
    else if (isTerminalDown)
    {
        vw_schedule_schedule_up.hidden = NO;
        vw_schedule_schedule_up.frame = upFrame;
        vw_schedule_schedule_down.hidden = YES;
        vw_terminal_background.hidden = NO;
    }
    else
    {
        vw_schedule_schedule_up.hidden = NO;
        vw_schedule_schedule_up.frame = upFrame;
        vw_schedule_schedule_down.hidden = NO;
        vw_schedule_schedule_down.frame = downFrame;
        vw_terminal_background.hidden = YES;
    }
    
    
    //    if (isTerminalUp || isTerminalDown)
    //    {
    //        [img_subtitle_bar_up setImage:[UIImage imageNamed:[NSString stringWithFormat:@"slide_schedule_subtitlebar_estimated_departure_%@", [CoreData sharedCoreData].lang]]];
    //        [img_subtitle_bar_down setImage:[UIImage imageNamed:[NSString stringWithFormat:@"slide_schedule_subtitlebar_estimated_departure_%@", [CoreData sharedCoreData].lang]]];
    //    }
    //    else
    //    {
    //        [img_subtitle_bar_up setImage:[UIImage imageNamed:[NSString stringWithFormat:@"slide_schedule_subtitlebar_estimated_arrival_%@", [CoreData sharedCoreData].lang]]];
    [img_subtitle_bar_down setImage:[UIImage imageNamed:[NSString stringWithFormat:@"slide_schedule_subtitlebar_estimated_arrival_%@", [CoreData sharedCoreData].lang]]];
    //    }
}

-(void)handleFavoriteStation
{
    //btn_favorite_station.selected = YES;
    NSString *station_code = [_station_record objectForKey:@"STATION_CODE"];
    NSString *line_code = [_station_record objectForKey:@"LINE"];
    
    NSArray *favoriteArray = [[SQLiteOperator sharedOperator] selectRecordFromFavoriteStationWithLineCode:line_code stationCode:station_code];
    
    if ([favoriteArray count] > 0)
    {
        btn_favorite_station.selected = YES;
    }
    else
    {
        btn_favorite_station.selected = NO;
    }
}


-(void)toggleFavoriteStation
{
    
    NSString *station_code = [_station_record objectForKey:@"STATION_CODE"];
    NSString *line_code = [_station_record objectForKey:@"LINE"];
    
    if (btn_favorite_station.selected == YES)
    {
        // remove favorite
        //[[SQLiteOperator sharedOperator] deleteRecordFromFavoriteStationWithLineCode:line_code stationCode:station_code];
        
        //NSLocalizedString(([NSString stringWithFormat:@"bookmark_Favoutite_%@", [CoreData                                      sharedCoreData].lang]), nil)
        
        
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(([NSString stringWithFormat:@"cancel_bookmark_Favoutite_%@", [CoreData                                      sharedCoreData].lang]), nil)
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(([NSString stringWithFormat:@"cancel_%@", [CoreData                                       sharedCoreData].lang]), nil)
                                            otherButtonTitles: NSLocalizedString(([NSString stringWithFormat:@"ok_%@", [CoreData                                       sharedCoreData].lang]), nil),nil];
        
        [alert show];
        alert.tag = CancelBookMark;
        [alert release];
        
    }
    else
    {
        //        NSString *station_name_en = [_station_record objectForKey:@"STATION_NAME_EN"];
        //        // add favorite
        //        double maxLineNumber = [[SQLiteOperator sharedOperator] selectMaxLineNumberFromFavoriteStation];
        //        double newLineNumber = maxLineNumber + 1;
        //        [[SQLiteOperator sharedOperator] insertRecordToFavoriteStationWithLineCode:line_code stationCode:station_code stationEnglishName:station_name_en lineNumber:[NSString stringWithFormat:@"%.6f", newLineNumber]];
        
        // Phase 1 ALEX
        
        
        NSString *station_name_en = [_station_record objectForKey:@"STATION_NAME_EN"];
        // add favorite
        double maxLineNumber = [[SQLiteOperator sharedOperator] selectMaxLineNumberFromFavoriteStation];
        double newLineNumber = maxLineNumber + 1;
        [[SQLiteOperator sharedOperator] insertRecordToFavoriteStationWithLineCode:line_code stationCode:station_code stationEnglishName:station_name_en lineNumber:[NSString stringWithFormat:@"%.6f", newLineNumber]];
        
        [self handleFavoriteStation];
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(([NSString stringWithFormat:@"already_added_bookmark_%@", [CoreData                                      sharedCoreData].lang]), nil)
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(([NSString stringWithFormat:@"ok_%@", [CoreData                                       sharedCoreData].lang]), nil)
                                            otherButtonTitles: nil];
        //        alert.tag = BookMark;
        
        [alert show];
        [alert release];
        
        
        
    }
    
    [self handleFavoriteStation];
    
    if (parentViewController != nil && [parentViewController respondsToSelector:@selector(refreshFavouriteTableView)])
    {
        [parentViewController performSelector:@selector(refreshFavouriteTableView)];
    }
}


-(void)displayLastUpdateTime
{
    _title_label.text = NSLocalizedString(([NSString stringWithFormat:@"schedule_%@", [CoreData sharedCoreData].lang]), nil);
    //    _title_label.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
    if (lastUpdateTime == nil)
    {
        [lbl_last_update_time setText:[NSString stringWithFormat:@"%@:  - ", NSLocalizedString(([NSString stringWithFormat:@"last_update_%@", [CoreData sharedCoreData].lang]), nil)]];
    }
    else
    {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        [lbl_last_update_time setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(([NSString stringWithFormat:@"last_update_%@", [CoreData sharedCoreData].lang]), nil), [dateFormatter stringFromDate:lastUpdateTime]]];
        
        [dateFormatter release];
    }
}

-(void)openSystemMap
{
    if (isShowingSystemMap == NO)
    {
        [[CoreData sharedCoreData].banner_view_controller hide];
        
        SystemMapViewController *systemMapViewController = [[[SystemMapViewController alloc] initWithNibName:@"SystemMapViewController" bundle:nil] autorelease];
        systemMapViewController.parent = self;
        [self.navigationController pushViewController:systemMapViewController animated:YES];
        //[self.navigationController presentModalViewController:systemMapViewController animated:YES];
        //    [systemMapViewController release];
        
        isShowingSystemMap = YES;
    }
}

-(void)closeSystemMap
{
    if (isShowingSystemMap)
    {
        [self.navigationController dismissModalViewControllerAnimated:NO];
        
//        [self.navigationController popViewControllerAnimated:NO];
        
        //        isShowingSystemMap = NO;
    }
}


-(void)showInAppTutorial
{
    /*
     if ([TutorialHandler shouldShowTutorialForViewController:self])
     {
     TutorialViewController *tutorial = [[TutorialViewController alloc] initWithParent:self];
     [tutorial show];
     [tutorial release];
     
     [TutorialHandler didReadTutorialForViewController:self];
     }
     */
}

-(void)showRedAlertURLInBrowser
{
    if (isRedAlert)
    {
        if (redAlertURL != nil && ![@"" isEqualToString:redAlertURL])
        {
            DEBUGMSG(@"Red Alert URL: %@", redAlertURL);
            
            InAppBrowserViewController *inAppBrowserViewController = [[InAppBrowserViewController alloc] initWithNibName:@"InAppBrowserViewController" bundle:nil];
            inAppBrowserViewController.url_path = redAlertURL;
            [self.navigationController pushViewController:inAppBrowserViewController animated:YES];
            [inAppBrowserViewController release];
        }
    }
}


#pragma mark - Button functions

-(IBAction)clickBackButton:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickHideButton:(UIButton*)button
{
    [self hide];
    [_scView setContentOffset:CGPointMake(23,125)];
}

-(IBAction)clickRefreshButton:(UIButton*)button
{
    //    UpdateHandler *updateHandler = [[UpdateHandler alloc] init];
    //    BOOL hasNetwork = [updateHandler hasNetwork];
    //    [updateHandler release];
    //
    //    if (hasNetwork)
    //    {
    //        isNoInternet = NO;
    //    }else{
    //
    //        isNoInternet = YES;
    //    }
    
 

    if (isNoInternet == YES) {
        
        if (alert_view) {
            [alert_view.view removeFromSuperview];
            [alert_view removeFromParentViewController];
            [alert_view release];

        }
        alert_view = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"no_connection_content_%@", [CoreData sharedCoreData].lang]), nil)];
        [alert_view show];
//        [alert release];
        
    }
    else {
        [self arrangeScheduleViewForTerminal];
        [self reloadGetSchedule];
        [tbl_schedule_up reloadData];
        [tbl_schedule_down reloadData];
        [self reloadGetSchedule];
    }
    

}

-(IBAction)clickScheduleButton:(UIButton*)button
{
    [self showSchedule];
}

-(IBAction)clickRouteMapButton:(UIButton*)button
{
    [self showRouteMap];
    [Flurry logEvent:@"Route map"];
}

-(IBAction)clickFavoriteButton:(UIButton*)button
{
    [self toggleFavoriteStation];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DEBUGMSG(@"%d", buttonIndex)
    NSString *station_code = [_station_record objectForKey:@"STATION_CODE"];
    NSString *line_code = [_station_record objectForKey:@"LINE"];
    
    
    
    if (buttonIndex == 0) {
        DEBUGMSG(@"Cancel Button");
        
    }
    if (buttonIndex == 1) {
        DEBUGMSG(@"OK button click");
        
        
        if (CancelBookMark==alertView.tag) {
            [[SQLiteOperator sharedOperator] deleteRecordFromFavoriteStationWithLineCode:line_code stationCode:station_code];
        }else{
            //            NSString *station_name_en = [_station_record objectForKey:@"STATION_NAME_EN"];
            //            // add favorite
            //            double maxLineNumber = [[SQLiteOperator sharedOperator] selectMaxLineNumberFromFavoriteStation];
            //            double newLineNumber = maxLineNumber + 1;
            //            [[SQLiteOperator sharedOperator] insertRecordToFavoriteStationWithLineCode:line_code stationCode:station_code stationEnglishName:station_name_en lineNumber:[NSString stringWithFormat:@"%.6f", newLineNumber]];
            //
            //            [self handleFavoriteStation];
        }
        
    }
    
    [self handleFavoriteStation];
    
    if (parentViewController != nil && [parentViewController respondsToSelector:@selector(refreshFavouriteTableView)])
    {
        [parentViewController performSelector:@selector(refreshFavouriteTableView)];
    }
}


-(IBAction)clickOpenSystemMapButton:(UIButton*)button
{
    [self openSystemMap];
}

-(IBAction)clickCloseSystemMapButton:(UIButton*)button
{
    [self closeSystemMap];
}


- (IBAction)clickPreviousBookmarkButton:(UIButton *)sender {
    
    _index--;
    //    btn_right.hidden =([self.favorite_station_array count]-1 == _index);
    
    //
    DEBUGLog
    NSMutableDictionary *favorite_station = [self.favorite_station_array objectAtIndex:_index];
    NSString *station_code = [favorite_station objectForKey:@"station_code"];
    NSString *line_code = [favorite_station objectForKey:@"line_code"];
    
    
    NSString *line_station_key = [NSString stringWithFormat:@"%@-%@", line_code, station_code];
    self.station_record = [self.station_records_with_station_as_key objectForKey:line_station_key];
    
    [self reloadGetSchedule];
    [self showSchedule];
    
}

- (IBAction)clickNextBookMarkButton:(UIButton *)sender {
    
    _index++;
    
    DEBUGMSG(@"self.favorite_station_array...%@", self.favorite_station_array)
    
    DEBUGLog
    NSMutableDictionary *favorite_station = [self.favorite_station_array objectAtIndex:_index];
    NSString *station_code = [favorite_station objectForKey:@"station_code"];
    NSString *line_code = [favorite_station objectForKey:@"line_code"];
    
    
    NSString *line_station_key = [NSString stringWithFormat:@"%@-%@", line_code, station_code];
    self.station_record = [self.station_records_with_station_as_key objectForKey:line_station_key];
    
    
    
    [self reloadGetSchedule];
    [self showSchedule];
    //    btn_right.hidden =([self.favorite_station_array count]-1 == _index);
    
}

- (IBAction)clickLastPage:(UIButton *)sender {
    DEBUGLog
    
    if (self.isBookmark) {
        //Algebra
        [self hide];
        /*FavoriteViewController *temp = [[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:nil];
         [self.navigationController pushViewController:temp animated:YES];
         [temp release];
         DEBUGMSG(@"%d viewControllers", [self.navigationController.viewControllers count]);*/
        
    }else{
        [self hide];
        NSMutableDictionary *plist_record = [[[NSMutableDictionary alloc] initWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path]  autorelease];
        if([plist_record objectForKey:@"first_time"] == nil || [[plist_record objectForKey:@"first_time"] isEqualToString:@"YES"]){
            
            [CoreData sharedCoreData].isConnectionFailedCloseApp = NO;
            [plist_record setObject:@"NO" forKey:@"first_time"];
            [plist_record writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
        }
        //Algebra
        //[((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate) clickNextTrainButton:nil];
    }
}




#pragma mark -
#pragma mark ASIHTTPRequestDelegate

-(void) requestFinished:(ASIHTTPRequest *)request {
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSString *responseString = [request responseString];
    DEBUGMSG(@"response string: %@", responseString);
    
    DEBUGMSG(@"status code: %i", request.responseStatusCode);
    
    if (request.responseStatusCode == 200)
    {
        //        isNoInternet = NO;
        
        [self processScheduleFromResponseString:responseString];
    }
    else
    {
        DEBUGMSG(@"ERROR: Status code %i", request.responseStatusCode);
        
        isReloading = NO;
        //        isNoInternet = YES;
        isNoValidScheduleUp = YES;
        isNoValidScheduleDown = YES;
        
        [self clearSchedule];
    }
    
    //    [[CoreData sharedCoreData].mask hiddenMask];
    
    [self didReloadGetSchedule];
}

-(void) requestFailed:(ASIHTTPRequest *)request {
    DEBUGMSG(@"requestFailed");
    DEBUGMSG(@"status code: %i", request.responseStatusCode);
    isReloading = NO;
    isNoInternet = YES; // Bob 2012-05-18 Marked as Yes again
    isNoValidScheduleUp = YES;
    isNoValidScheduleDown = YES;
    
    
    
//    CustomAlertView *alert = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"no_server_available_%@", [CoreData sharedCoreData].lang]), nil)];
//    [alert show];
//    [alert release];
    
    [self clearSchedule];
    
    //    [[CoreData sharedCoreData].mask hiddenMask];
    
    [self didReloadGetSchedule];
}


#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)]autorelease];
    
    UILabel *bg = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 23)]autorelease];
    [bg setBackgroundColor:[UIColor grayColor]];
    [header addSubview:bg];
    
    UILabel *lbl_destination = [[[UILabel alloc] initWithFrame:CGRectMake(38, 0, 320, 23)]autorelease];
    lbl_destination.textAlignment = NSTextAlignmentLeft;
    lbl_destination.textColor = [UIColor whiteColor];
    lbl_destination.font = [UIFont boldSystemFontOfSize:15];
    [lbl_destination setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl_platform = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 315, 23)]autorelease];
    lbl_platform.textAlignment = NSTextAlignmentCenter;
    lbl_platform.textColor = [UIColor whiteColor];
    lbl_platform.font = [UIFont boldSystemFontOfSize:15];
    [lbl_platform setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl_time = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 23)]autorelease];
    lbl_time.textAlignment = NSTextAlignmentRight;
    lbl_time.textColor = [UIColor whiteColor];
    lbl_time.font = [UIFont boldSystemFontOfSize:15];
    [lbl_time setBackgroundColor:[UIColor clearColor]];
    

    
    lbl_destination.text = NSLocalizedString(([NSString stringWithFormat:@"destination_%@", [CoreData sharedCoreData].lang]), nil);
    lbl_platform.text = NSLocalizedString(([NSString stringWithFormat:@"platform_%@", [CoreData sharedCoreData].lang]), nil);
    lbl_time.text = NSLocalizedString(([NSString stringWithFormat:@"next_train_%@", [CoreData sharedCoreData].lang]), nil);
    [header addSubview:lbl_destination];
    [header addSubview:lbl_platform];
    [header addSubview:lbl_time];
    
    header.backgroundColor = [UIColor grayColor];
    
    // Alex code
    if ([[CoreData sharedCoreData].lang isEqualToString:@"en"] ){
        //        lbl_destination.text = NSLocalizedString(([NSString stringWithFormat:@"destination_%@", [CoreData sharedCoreData].lang]), nil);
        lbl_destination.frame = CGRectMake(22, 0, 320, 23);
        lbl_time.frame = CGRectMake(-22, 0, 320, 23);
    }
    
    
    
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tbl_schedule_up)
    {
        return 4; //return [ary_schedule_up count];
    }
    else if (tableView == tbl_schedule_down)
    {
        return 4; //return [ary_schedule_down count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbl_schedule_up)
    {
        static NSString *CellIdentifierUp = @"NextTrainUp";
        
        NextTrainScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierUp];
        
        if (cell == nil)
        {
            cell = [[[NextTrainScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierUp] autorelease];
        }
        
        NSString *destination = @"";
        NSString *platform = @"";
        NSString *time = @"";
        
        if (indexPath.row < [ary_schedule_up count])
        {
            DEBUGMSG(@":: %@", [[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"dest"]);
            BOOL isNonStopAIR = NO;
            if ([VALID_SPECIAL_TRAIN_NON_AIR isEqualToString:[[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"valid"]])
            {
                isNonStopAIR = YES;
            }
            
            if ([@"AEL" isEqualToString:[_station_record objectForKey:@"LINE"]])
            {
                if (isNonStopAIR)
                {
                    if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
                    {
                        // AWE(non-stop:AIR)
                        destination = [NSString stringWithFormat:@"%@%@",
                                       [[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"dest"],
                                       NSLocalizedString(([NSString stringWithFormat:@"non_stop_AIR_%@", [CoreData sharedCoreData].lang]), nil)];
                    }
                    else
                    {
                        // 博覽館(不停機場)
                        destination = [NSString stringWithFormat:@"%@%@",
                                       [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:[[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"dest"]],
                                       NSLocalizedString(([NSString stringWithFormat:@"non_stop_AIR_%@", [CoreData sharedCoreData].lang]), nil)];
                    }
                }
                else
                {
                    if ([STATION_CODE_TERMINAL_AEL_UP_NAME2 isEqualToString:[_station_record objectForKey:@"STATION_CODE"]])
                    {
                        // Airport - Display "AsiaWorld-Expo"
                        if ([[CoreData sharedCoreData].lang isEqualToString:@"en"] &&
                            [STATION_CODE_TERMINAL_AEL_UP_NAME1 isEqualToString:[[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"dest"]])
                        {
                            // AWE
                            destination = [NSString stringWithFormat:@"%@", [[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"dest"]];
                        }
                        else
                        {
                            // AsiaWorld-Expo
                            destination = [NSString stringWithFormat:@"%@", [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:[[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"dest"]]];
                        }
                    }
                    else {
                        // Others - Display "Airport / AsiaWorld-Expo"
                        if ([[CoreData sharedCoreData].lang isEqualToString:@"en"] &&
                            [STATION_CODE_TERMINAL_AEL_UP_NAME1 isEqualToString:[[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"dest"]])
                        {
                            // Airport / AWE
                            destination = [NSString stringWithFormat:@"%@ / %@",
                                           [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_AEL_UP_NAME2],
                                           [[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"dest"]];
                        }
                        else
                        {
                            // Airport / AsiaWorld-Expo
                            destination = [NSString stringWithFormat:@"%@ / %@",
                                           [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:STATION_CODE_TERMINAL_AEL_UP_NAME2],
                                           [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:[[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"dest"]]];
                        }
                    }
                }
            }
            else
            {
                destination = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:[[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"dest"]];
            }
            platform = [[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"plat"];
            
            if (isNonStopAIR && [@"AEL" isEqualToString:[_station_record objectForKey:@"LINE"]] && [STATION_CODE_TERMINAL_AEL_UP_NAME2 isEqualToString:[_station_record objectForKey:@"STATION_CODE"]])
            {
                // non-stop AIR
                time = @"N/A";
            }
            else
            {
                // normal
                NSString *ttnt = [[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"ttnt"];
                if (ttnt != nil)
                {
                    if ([@"0" isEqualToString:ttnt])
                    {
                        time = NSLocalizedString(([NSString stringWithFormat:@"departing_%@", [CoreData sharedCoreData].lang]), nil);
                    }
                    else if ([@"1" isEqualToString:ttnt])
                    {
                        if (isTerminalUp || isTerminalDown)
                        {
                            time = NSLocalizedString(([NSString stringWithFormat:@"departing_%@", [CoreData sharedCoreData].lang]), nil);
                        }
                        else
                        {
                            time = NSLocalizedString(([NSString stringWithFormat:@"arriving_%@", [CoreData sharedCoreData].lang]), nil);
                        }
                    }
                    else
                    {
                        time = [self shortTimeFromSystemDate:
                                [[ary_schedule_up objectAtIndex:indexPath.row] objectForKey:@"time"]];
                    }
                }
            }
        }
        
        cell.lbl_destination.text = destination;
        cell.lbl_platform.text = platform;
        cell.lbl_time.text = time;
        [cell setTimeForTerminal:(isTerminalUp || isTerminalDown) language:[CoreData sharedCoreData].lang];
        
        [cell setBackgroundWithRow:indexPath.row];
        
        return cell;
    }
    else if (tableView == tbl_schedule_down)
    {
        static NSString *CellIdentifierDown = @"NextTrainDown";
        
        NextTrainScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDown];
        
        if (cell == nil)
        {
            cell = [[[NextTrainScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDown] autorelease];
        }
        
        NSString *destination = @"";
        NSString *platform = @"";
        NSString *time = @"";
        
        if (indexPath.row < [ary_schedule_down count])
        {
            BOOL isNonStopAIR = NO;
            if ([VALID_SPECIAL_TRAIN_NON_AIR isEqualToString:[[ary_schedule_down objectAtIndex:indexPath.row] objectForKey:@"valid"]])
            {
                isNonStopAIR = YES;
            }
            
            if ([@"AEL" isEqualToString:[_station_record objectForKey:@"LINE"]] &&
                isNonStopAIR)
            {
                if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
                {
                    // HOK(non-stop:AIR)
                    destination = [NSString stringWithFormat:@"%@%@",
                                   [[ary_schedule_down objectAtIndex:indexPath.row] objectForKey:@"dest"],
                                   NSLocalizedString(([NSString stringWithFormat:@"non_stop_AIR_%@", [CoreData sharedCoreData].lang]), nil)];
                }
                else
                {
                    // 香港(不停機場)
                    destination = [NSString stringWithFormat:@"%@%@",
                                   [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:[[ary_schedule_down objectAtIndex:indexPath.row] objectForKey:@"dest"]],
                                   NSLocalizedString(([NSString stringWithFormat:@"non_stop_AIR_%@", [CoreData sharedCoreData].lang]), nil)];
                }
            }
            else
            {
                destination = [self stationNameWithLine:[_station_record objectForKey:@"LINE"] station:[[ary_schedule_down objectAtIndex:indexPath.row] objectForKey:@"dest"]];
            }
            
            platform = [[ary_schedule_down objectAtIndex:indexPath.row] objectForKey:@"plat"];
            
            if (isNonStopAIR && [@"AEL" isEqualToString:[_station_record objectForKey:@"LINE"]] && [STATION_CODE_TERMINAL_AEL_UP_NAME2 isEqualToString:[_station_record objectForKey:@"STATION_CODE"]])
            {
                // non-stop AIR
                time = @"N/A";
            }
            else
            {
                // normal
                NSString *ttnt = [[ary_schedule_down objectAtIndex:indexPath.row] objectForKey:@"ttnt"];
                if (ttnt != nil)
                {
                    if ([@"0" isEqualToString:ttnt])
                    {
                        time = NSLocalizedString(([NSString stringWithFormat:@"departing_%@", [CoreData sharedCoreData].lang]), nil);
                    }
                    else if ([@"1" isEqualToString:ttnt])
                    {
                        if (isTerminalUp || isTerminalDown)
                        {
                            time = NSLocalizedString(([NSString stringWithFormat:@"departing_%@", [CoreData sharedCoreData].lang]), nil);
                        }
                        else
                        {
                            time = NSLocalizedString(([NSString stringWithFormat:@"arriving_%@", [CoreData sharedCoreData].lang]), nil);
                        }
                    }
                    else
                    {
                        time = [self shortTimeFromSystemDate:
                                [[ary_schedule_down objectAtIndex:indexPath.row] objectForKey:@"time"]];
                        
                    }
                }
            }
        }
        
        cell.lbl_destination.text = destination;
        cell.lbl_platform.text = platform;
        cell.lbl_time.text = time;
        [cell setTimeForTerminal:(isTerminalUp || isTerminalDown) language:[CoreData sharedCoreData].lang];
        
        [cell setBackgroundWithRow:indexPath.row];
        
        return cell;
    }
    return nil;
}

#pragma mark - Misc functions
-(NSString*)shortTimeFromSystemDate:(NSString*)systemDate;
{
    if (systemDate == nil)
        return nil;
    
    DEBUGMSG(@"From time: %@", systemDate);
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:systemDate];
    
    if (date != nil)
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        DEBUGMSG(@"To time: %@", [dateFormatter stringFromDate:date]);
        return [dateFormatter stringFromDate:date];
    }
    
    return nil;
}

-(NSString*)stationNameWithLine:(NSString*)line station:(NSString*)station
{
    
    
    if (line == nil || station == nil || [_station_records_with_station_as_key count] == 0)
        return @"";
   
    
    
    NSString *station_key = [NSString stringWithFormat:@"%@-%@", line, station];
    
    NSMutableDictionary *local_station_record = [_station_records_with_station_as_key objectForKey:station_key];
    
    
    if (local_station_record != nil)
    {
        if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
        {
            return [local_station_record objectForKey:@"STATION_NAME_EN"];
        }
        else if ([[CoreData sharedCoreData].lang isEqualToString:@"zh_TW"])
        {
            return [local_station_record objectForKey:@"STATION_NAME_TC"];
        }
    }
    
    return @"";
}

-(NSString*)lineNameWithLine:(NSString*)line
{
    if (line == nil || [_line_records_with_line_as_key count] == 0)
        return @"";
    
    NSMutableDictionary *local_line_record = [_line_records_with_line_as_key objectForKey:line];
    
    if (local_line_record != nil)
    {
        if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
        {
            return [local_line_record objectForKey:@"LINE_EN"];
        }
        else if ([[CoreData sharedCoreData].lang isEqualToString:@"zh_TW"])
        {
            return [local_line_record objectForKey:@"LINE_TC"];
        }
    }
    
    return @"";
}


-(BOOL)isTerminalUpForLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode
{
    
    if (lineCode == nil || stationCode == nil)
        return NO;
    
    if ([@"AEL" isEqualToString:lineCode])
    {
        if ([STATION_CODE_TERMINAL_AEL_UP isEqualToString:stationCode])
        {
            return YES;
        }
    }
    else if ([@"TCL" isEqualToString:lineCode])
    {
        if ([STATION_CODE_TERMINAL_TCL_UP isEqualToString:stationCode])
        {
            return YES;
        }
        
        
    }
    else if ([@"WRL" isEqualToString:lineCode])
    {
        if ([STATION_CODE_TERMINAL_WRL_UP isEqualToString:stationCode])
        {
            return YES;
        }
    }
    else if ([@"TKL" isEqualToString:lineCode])
    {
        if ([STATION_CODE_TERMINAL_TKL_UP isEqualToString:stationCode])
        {
            return YES;
        }
        if ([STATION_CODE_TERMINAL_TKL_UP_NAME2 isEqualToString:stationCode])
        {
            return YES;
            
        }
    }

    return NO;
}

-(BOOL)isTerminalDownForLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode
{
    if (lineCode == nil || stationCode == nil)
        return NO;
    
    if ([@"AEL" isEqualToString:lineCode])
    {
        if ([STATION_CODE_TERMINAL_AEL_DOWN isEqualToString:stationCode])
        {
            return YES;
        }
    }
    else if ([@"TCL" isEqualToString:lineCode])
    {
        if ([STATION_CODE_TERMINAL_TCL_DOWN isEqualToString:stationCode])
        {
            return YES;
        }
    }
    else if ([@"WRL" isEqualToString:lineCode])
    {
        if ([STATION_CODE_TERMINAL_WRL_DOWN isEqualToString:stationCode])
        {
            return YES;
        }
    }
    
    else if ([@"TKL" isEqualToString:lineCode])
    {
        
        if ([STATION_CODE_TERMINAL_TKL_DOWN isEqualToString:stationCode])
        {
            return YES;
            
        }
        

    }
    
//    else if ([@"LHP" isEqualToString:stationCode])
//    {
//        if ([STATION_CODE_TERMINAL_TKL_DOWN isEqualToString:lineCode])
//        {
//            return YES;
//        }
//    }


    
    
    
    DEBUGMSG(@"XXXX%@%@",stationCode,lineCode)
    return NO;
}

-(BOOL)isNoValidAELDownForLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode
{
    if (lineCode == nil || stationCode == nil)
        return NO;
    
    if ([@"AEL" isEqualToString:lineCode])
    {
        if ([STATION_CODE_AEL_KOW isEqualToString:stationCode] ||
            [STATION_CODE_AEL_TSY isEqualToString:stationCode])
        {
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - Route Map Functions

-(void)clickStationWithStationCode:(NSString*)stationCode
{
    [[CoreData sharedCoreData].banner_view_controller show];
    
    if (parentViewController && [parentViewController respondsToSelector:@selector(selectStationWithStationCode:)])
    {
        //jeff
        
        self.bFirstTimeToAddEvent = YES;
        [parentViewController performSelector:@selector(selectStationWithStationCode:) withObject:stationCode];
    }
}

-(IBAction)clickWRLStation:(id)sender{
    [self clickStationWithStationCode:[wrlStations objectAtIndex:((UIButton*)sender).tag]];
    
}


-(IBAction)clickStation_TUC:(id)sender
{
    [self clickStationWithStationCode:@"TUC"];
}
-(IBAction)clickStation_SUN:(id)sender
{
    [self clickStationWithStationCode:@"SUN"];
}
-(IBAction)clickStation_TSY:(id)sender
{
    [self clickStationWithStationCode:@"TSY"];
}
-(IBAction)clickStation_LAK:(id)sender
{
    [self clickStationWithStationCode:@"LAK"];
}
-(IBAction)clickStation_NAC:(id)sender
{
    [self clickStationWithStationCode:@"NAC"];
}
-(IBAction)clickStation_OLY:(id)sender
{
    [self clickStationWithStationCode:@"OLY"];
}
-(IBAction)clickStation_KOW:(id)sender
{
    [self clickStationWithStationCode:@"KOW"];
}
-(IBAction)clickStation_HOK:(id)sender
{
    [self clickStationWithStationCode:@"HOK"];
}
-(IBAction)clickStation_AWE:(id)sender
{
    [self clickStationWithStationCode:@"AWE"];
}
-(IBAction)clickStation_AIR:(id)sender
{
    [self clickStationWithStationCode:@"AIR"];
}


-(IBAction)clickRedAlertURL:(id)sender
{
    [self showRedAlertURLInBrowser];
}


#pragma mark - Timer Functions
-(void)startTimerForUpdateNextTrain
{
    if (isObjectReleased)
        return;
    
    [self stopTimerForUpdateNextTrain];
    
    int updateFrequency = [CoreData sharedCoreData].nextTrainUpdateFrequency;
    int timeInterval = 0;
    switch (updateFrequency) {
        case NextTrainUpdateFrequency_15sec:
            timeInterval = 15;
            break;
        case NextTrainUpdateFrequency_20sec:
            timeInterval = 20;
            break;
        case NextTrainUpdateFrequency_30sec:
            timeInterval = 30;
            break;
        default:
            break;
    }
    if (timeInterval > 0)
    {
        
        DEBUGMSG(@"Start timer with %i sec", timeInterval);
        
        timerUpdateNextTrain = [[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(doUpdateNextTrain) userInfo:nil repeats:YES] retain];
    }
}

-(void)stopTimerForUpdateNextTrain
{
    if (timerUpdateNextTrain != nil)
    {
        DEBUGMSG(@"Stop timer");
        
        if ([timerUpdateNextTrain isValid])
        {
            [timerUpdateNextTrain invalidate];
        }
        [timerUpdateNextTrain release];
        timerUpdateNextTrain = nil;
    }
}

-(void)doUpdateNextTrain
{
    
    
    UpdateHandler *updateHandler = [[UpdateHandler alloc] init];
    BOOL hasNetwork = [updateHandler hasNetwork];
    [updateHandler release];
    
    if (hasNetwork)
    {
        isNoInternet = NO;
    }else{
        
        isNoInternet = YES;
    }
    
    if (isNoInternet == YES) {
        
        if (alert_view) {
            [alert_view.view removeFromSuperview];
            [alert_view removeFromParentViewController];
            [alert_view release];
        }
        
        alert_view = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"no_connection_content_%@", [CoreData sharedCoreData].lang]), nil)];
        [alert_view show];
        
        
    }else if (isNoInternet == NO){
        
        [self arrangeScheduleViewForTerminal];
        [self reloadGetSchedule];
        [tbl_schedule_up reloadData];
        [tbl_schedule_down reloadData];
        [self reloadGetSchedule];
        
    }
    
    // NO Delete
    //    if (_isShowing                  // slider up
    //        //        && btn_schedule.selected    // schedule tab on
    //        && !isReloading             // not currently updating
    //    )
    //    {
    //        [self reloadGetSchedule];
    //    }
    
    
}



-(void) startFlashingbutton:(UIView *)btn
{
    
    if (btn) return;
    btn.alpha = 1.0f;
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionRepeat |
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         btn.alpha = 0.1f;
                     }
                     completion:^(BOOL finished){
                            // Do nothing
    }];
}
@end
