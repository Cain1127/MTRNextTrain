//
//  StationFacilitiesViewController.m
//  MTR
//
//  Created by Jeff Cheung on 11年11月8日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectStationViewController.h"
#import "Flurry.h"

@interface SelectStationViewController ()<LocationOperatorDelegate>

@property(nonatomic, strong) UIButton *openSideMenu;

@end

@implementation SelectStationViewController

@synthesize launch_line_code, launch_station_code;

#define TAG_SELECT_STATION_AUTO_POP_SCHEDULE 101
#define TAG_SELECT_STATION_NO_POP_SCHEDULE 102

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
            _db_lang = [@"EN" retain];
        }
        else{
            _db_lang = [@"TC" retain];
        }
    }
    return self;
}

-(void)dealloc{
    DEBUGLog
    
    [vw_backgroundMask removeFromSuperview];
    [self unloadNextTrainViewController];
    [self unloadMapSearchViewController];
    
    if (selectLineView != nil)
    {
        [selectLineView clearDelegatesAndCancel];
        [selectLineView release];
        selectLineView = nil;
    }
    
    
    if(_facility_array != nil){
        [_facility_array release];
        _facility_array = nil;
    }
    if(_line_list != nil){
        [_line_list removeAllObjects];
        [_line_list release];
        _line_list = nil;
    }
    if (_line_records_with_line_as_key != nil)
    {
        [_line_records_with_line_as_key removeAllObjects];
        [_line_records_with_line_as_key release];
        _line_records_with_line_as_key = nil;
    }
    //    if(_facility_3d_view != nil){
    //        [_facility_3d_view removeFromSuperview];
    //        [_facility_3d_view release];
    //        _facility_3d_view = nil;
    //    }
    if(_station_records != nil){
        [_station_records removeAllObjects];
        [_station_records release];
        _station_records = nil;
    }
    if (_station_records_with_station_as_key != nil)
    {
        [_station_records_with_station_as_key removeAllObjects];
        [_station_records_with_station_as_key release];
        _station_records_with_station_as_key = nil;
    }
    if(_db_lang != nil){
        [_db_lang release];
        _db_lang = nil;
    }
    // close location manager
    [[LocationOperator sharedOperator] close];
    
    ReleaseObj(_view_by_stations_button)
    ReleaseObj(_view_by_types_button)
    ReleaseObj(_view_by_station_bg_view)
    ReleaseObj(_line_table_view)
    ReleaseObj(_line_shadow_table_view)
    ReleaseObj(_station_table_view)
    ReleaseObj(_station_shadow_table_view)
    ReleaseObj(_select_image_view)
    ReleaseObj(_middle_image_view)
    ReleaseObj(_yellow_dot_image_view)
    ReleaseObj(_title_label)
    ReleaseObj(btn_nearby)
    ReleaseObj(btn_mapSearch)
    ReleaseObj(vw_backgroundMask)
    ReleaseObj(_btn_callbackMother)
    
    [_clickSettingButton release];
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
    DEBUGLog
    
    [super viewDidLoad];
    
    if(isFive == YES){
        
        [btn_nearby setFrame:CGRectMake(8, 410, 50, 50)];
        [btn_mapSearch setFrame:CGRectMake(66, 390, 31, 31)];
    }
    
    _title_label.text = NSLocalizedString(([NSString stringWithFormat:@"select_station_%@", [CoreData sharedCoreData].lang]), nil);
    
    _line_table_view.decelerationRate = _station_table_view.decelerationRate = UIScrollViewDecelerationRateFast;
    
    [_view_by_stations_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tap_facilities_stations_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    
    [_view_by_stations_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tap_facilities_stations_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
    [_view_by_types_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tap_facilities_types_off_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    
    [_view_by_types_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tap_facilities_types_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
    
    _station_records = [NSMutableDictionary new];
    _station_records_with_station_as_key = [NSMutableDictionary new];
    _line_records_with_line_as_key = [NSMutableDictionary new];
    
    _line_index = 3;
    _station_index = 3;
    
    // Do any additional setup after loading the view from its nib.
    //    [[FacilitySQLOperator sharedOperator] openDatabase];
    
    
    [[FacilitySQLOperator sharedOperator] openDatabase];
    _line_list = [[NSMutableArray alloc] initWithArray:[[FacilitySQLOperator sharedOperator] selectALLFromLine]];
    [_line_list insertObject:@"" atIndex:0];
    [_line_list insertObject:@"" atIndex:0];
    [_line_list insertObject:@"" atIndex:0];
    [_line_list addObject:@""];
    [_line_list addObject:@""];
    [_line_list addObject:@""];
    //DEBUGMSG(@"line list: %@", _line_list);
    _facility_array = [[[FacilitySQLOperator sharedOperator] selectALLFromFacilities] retain];
    //    DEBUGMSG(@"Facility array: %@", _facility_array);
    [[FacilitySQLOperator sharedOperator] closeDatabase];
    
    [self constructStationRecord];
    
    //    _facility_3d_view = [[Facility3DView alloc] initWithFrame:CGRectMake(0, 105, 320, 240)];
    //    [_facility_3d_view construct];
    //    _facility_3d_view.alpha = 0;
    //    [self.view addSubview:_facility_3d_view];
    
    [_line_table_view reloadData];
    [_line_shadow_table_view reloadData];
    [_station_table_view reloadData];
    [_station_shadow_table_view reloadData];
    
    [self lineTableViewPaging];
    [self stationTableViewPaging];
    
    // x-callback
    [self handleCallbackMotherButton];
    
    [self.view addSubview:vw_backgroundMask];
    [self hideBackgroundMask];
    [self loadMapSearchViewController];
//    [self loadNextTrainViewController];
    [self clickSettingButton];
    
    //    UIImage *setting = [UIImage imageNamed:@"btn_setting"];
    //    NSParameterAssert(setting);
    //
    //    self.openSideMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.openSideMenu.frame = CGRectMake(5, -5, 42, 46);
    //   [self.openSideMenu setImage:setting forState:UIControlStateNormal];
    //    [self.openSideMenu addTarget:self action:@selector(clickSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [self.view addSubview:self.openSideMenu];
    
    [btn_setting addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if(nextTrainViewController){
        [nextTrainViewController didHidden];
    }
    [Flurry logEvent:@"MainPage"];
    
    [self reloadData];
    // load timetable immediately if specified station from other page
    // ios 7 statusbar
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        
        view.backgroundColor=[UIColor colorWithRed:213/255.0 green:215/255.0 blue:219/255.0 alpha:1];
        
        [self.view addSubview:view];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
}

-(void)reloadData{
    if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
        _db_lang = [@"EN" retain];
    }
    else{
        _db_lang = [@"TC" retain];
    }
    
    _title_label.text = NSLocalizedString(([NSString stringWithFormat:@"select_station_%@", [CoreData sharedCoreData].lang]), nil);
    
    
    [[FacilitySQLOperator sharedOperator] openDatabase];
    
    _line_list = [[NSMutableArray alloc] initWithArray:[[FacilitySQLOperator sharedOperator] selectALLFromLine]];
    [_line_list insertObject:@"" atIndex:0];
    [_line_list insertObject:@"" atIndex:0];
    [_line_list insertObject:@"" atIndex:0];
    [_line_list addObject:@""];
    [_line_list addObject:@""];
    [_line_list addObject:@""];
    DEBUGMSG(@"line list: %@", _line_list);
    _facility_array = [[[FacilitySQLOperator sharedOperator] selectALLFromFacilities] retain];
    //DEBUGMSG(@"Facility array: %@", _facility_array);
    [[FacilitySQLOperator sharedOperator] closeDatabase];
    [_line_table_view reloadData];
    [_line_shadow_table_view reloadData];
    [_station_table_view reloadData];
    [_station_shadow_table_view reloadData];
    
    if (launch_line_code != nil && launch_station_code != nil)
    {
        [self selectStationWithLineCode:launch_line_code stationCode:launch_station_code popSchedule:YES];
    }
    else
    {
        if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
            [self highlightStationNoAnimatedWithLineIndex:4 stationIndex:3];
        }else{
            [self highlightStationNoAnimatedWithLineIndex:5 stationIndex:3];
        }
    }
    
    if (nextTrainViewController) {
        [nextTrainViewController reloadData];
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    // stop updating location
    [[LocationOperator sharedOperator] stopUpdatingLocation];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.routemap) {
        [self clickMapSearchButton:nil];
    }
    
    [self showInAppTutorial];
}

- (void)viewDidUnload
{
    [self setClickSettingButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Main Function

-(void)handleLineColor{
    if(![[_line_list objectAtIndex:_line_index] isKindOfClass:[NSString class]]){
        NSString *line = [[_line_list objectAtIndex:_line_index] objectForKey:@"LINE"];
        if(line != nil){
            if([line isEqualToString:@"AEL"]){
                _select_image_view.image = [UIImage imageNamed:@"next_train_select_station_picker_arrow_airport_express.png"];
                _middle_image_view.image = [UIImage imageNamed:@"next_train_select_station_line_airport_express.png"];
                _yellow_dot_image_view.image = [UIImage imageNamed:@"next_train_select_station_point_airport_express.png"];
            }
            
            else if([line isEqualToString:@"TKL"]){
                _select_image_view.image = [UIImage imageNamed:@"next_train_select_station_picker_arrow_TKL"];
                _middle_image_view.image = [UIImage imageNamed:@"next_train_select_station_line_TKO.png"];
                _yellow_dot_image_view.image = [UIImage imageNamed:@"next_train_select_station_point_TKL.png"];
            }
            
            else if([line isEqualToString:@"TCL"]){
                _select_image_view.image = [UIImage imageNamed:@"next_train_select_station_picker_arrow_tung_chung.png"];
                _middle_image_view.image = [UIImage imageNamed:@"next_train_select_station_line_tung_chung.png"];
                _yellow_dot_image_view.image = [UIImage imageNamed:@"next_train_select_station_point_tung_chung.png"];
            }
            
            else if([line isEqualToString:@"WRL"]){
                _select_image_view.image = [UIImage imageNamed:@"next_train_select_station_picker_arrow_west_rail.png"];
                _middle_image_view.image = [UIImage imageNamed:@"next_train_select_station_line_west_rail.png"];
                _yellow_dot_image_view.image = [UIImage imageNamed:@"next_train_select_station_point_west_rail.png"];
            }
            
            
        }
    }
    
}


#pragma mark -
#pragma mark Gesture recognizer



-(void)lineTableViewPaging{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showYellowDot)];
    _line_index = round(_line_table_view.contentOffset.y / 48);
	_line_table_view.contentOffset = CGPointMake(0, _line_index * 48);
    _line_index += 3;
	[UIView commitAnimations];
    [_station_table_view reloadData];
    [_station_shadow_table_view reloadData];
    _station_table_view.contentOffset = CGPointMake(0, 0);
    _station_shadow_table_view.contentOffset = CGPointMake(0, 0);
    [self handleLineColor];
}


-(void)stationTableViewPaging{
    
    _station_index = round(_station_table_view.contentOffset.y / 48);
    
    DEBUGMSG(@"%d %d", _line_index, _station_index);
    float offset = 0;
    if (([[CoreData sharedCoreData].lang isEqualToString:@"en"] && _line_index==4) || ([[CoreData sharedCoreData].lang isEqualToString:@"zh_TW"] && _line_index==5)) {
        if (_station_index==5 || _station_index==6) { //LHP Selected
            louhasParkStationSelected = YES;
        } else {
            louhasParkStationSelected = NO;
        }
        if (_station_index>6) {
            offset = 48;
//            _station_index--;
        }
        if (_station_index>=6) {
//            offset = 48;
            _station_index--;
        }
    }
    [_station_table_view reloadData];
    [_station_shadow_table_view reloadData];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showYellowDot)];
    
	_station_table_view.contentOffset = CGPointMake(0, _station_index * 48 + offset);
    _station_index += 3;
	[UIView commitAnimations];
    

}



-(void)showYellowDot{
    
    /*
     SelectStationStationCell *cell,*cell2;
     for(NSIndexPath *idx in [_station_table_view indexPathsForVisibleRows]){
     if (idx.row == _station_index){
     cell = (SelectStationStationCell*)[_station_shadow_table_view cellForRowAtIndexPath:idx];
     cell2 = (SelectStationStationCell*)[_station_table_view cellForRowAtIndexPath:idx];
     
     }
     
     }
     if(cell !=nil && cell.value_label !=nil){
     if(cell.value_label.text.length>12){
     CGPoint originC = cell.value_label.center;
     
     [UIView animateWithDuration:4.0
     animations:^{
     [cell.value_label setCenter:CGPointMake(originC.x-80,cell.value_label.center.y)];
     [cell2.value_label setCenter:CGPointMake(originC.x-80,cell.value_label.center.y)];
     }
     completion:^(BOOL finished){
     // [cell.value_label setCenter:CGPointMake(originC.x+160,cell.value_label.center.y)];
     //   [cell2.value_label setCenter:CGPointMake(originC.x+160,cell.value_label.center.y)];
     
     [UIView animateWithDuration:4.0
     animations:^{
     [cell.value_label setCenter:originC];
     [cell2.value_label setCenter:originC];
     
     }];
     }];
     
     
     
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:0.5];
     [UIView setAnimationDelegate:self];
     //[UIView setAnimationRepeatAutoreverses:YES];
     // [UIView setAnimationRepeatCount:0];
     // [UIView setAnimationDidStopSelector:@selector(showYellowDot)];
     [cell.value_label setCenter:CGPointMake(cell.value_label.center.x-100,cell.value_label.center.y)];
     [cell.value_label setCenter:CGPointMake(cell.value_label.center.x+100,cell.value_label.center.y)];
     
     [UIView commitAnimations];
     
     }
     }
     */
    
    if(!_view_by_types_button.selected)
        _yellow_dot_image_view.alpha = 1;
}


#pragma mark - Construct Functions

-(void)loadNextTrainViewController
{
    // prepare next train schedule that is hidden
    [self unloadNextTrainViewController];
    
    if(!nextTrainViewController){
        nextTrainViewController = [[NextTrainViewController alloc] initWithNibName:@"NextTrainViewController" bundle:nil];
        nextTrainViewController.btn_left.hidden =TRUE;
        nextTrainViewController.btn_right.hidden = TRUE;
        nextTrainViewController.parentViewController = self;
    }
    [self.view addSubview:nextTrainViewController.view];
    [nextTrainViewController didHidden];
    
    
}

-(void)hideNextTrainViewController{
    if(nextTrainViewController)
        [nextTrainViewController didHidden];
}

-(void)unloadNextTrainViewController
{
    if (nextTrainViewController != nil)
    {
        
        //        nextTrainViewController.parentViewController = nil;
        DEBUGMSG(@"remove nextTrainViewController");
        [nextTrainViewController.view removeFromSuperview];
        DEBUGMSG(@"release nextTrainViewController");
        //        [nextTrainViewController releaseObjects];
        //        [nextTrainViewController release];
        //        nextTrainViewController = nil;
        DEBUGMSG(@"released nextTrainViewController");
    }
    
}

-(void)loadMapSearchViewController
{
    if(!mapSearchViewController){
        mapSearchViewController = [[MapSearchViewController alloc] initWithNibName:@"MapSearchViewController" bundle:nil];
        mapSearchViewController.delegate = self;
        
        //        CGRect screenBound = [[UIScreen mainScreen] bounds];
        //        float adjustHeight = 568 - screenBound.size.height;
        //
        //
        //        CGRect frame  = mapSearchViewController.view.frame;
        //        if(screenBound.size.height >480)
        //            frame.origin.y -=60;
        //
        //        frame.size.height -=adjustHeight;
        //
        //        mapSearchViewController.view.frame = frame;
        
    }
    [mapSearchViewController reloadData];
    [self.view addSubview:mapSearchViewController.view];
    mapSearchViewController.view.alpha = 0;
    
}

-(void)unloadMapSearchViewController
{
    if (mapSearchViewController != nil)
    {
        //        mapSearchViewController.delegate = nil;
        [mapSearchViewController.view removeFromSuperview];
        //        [mapSearchViewController release];
        //        mapSearchViewController = nil;
    }
}

-(void)constructStationRecord{
    
    for(int x = 0; _line_list != nil && x < [_line_list count]; x++){
        if([[_line_list objectAtIndex:x] isKindOfClass:[NSString class]])
            continue;
        
        NSMutableArray *station_list = [NSMutableArray new];
        NSString *line_line = [[_line_list objectAtIndex:x] objectForKey:@"LINE"];
        
        if (line_line != nil)
        {
            // line list with line as key ETHAN
            [_line_records_with_line_as_key setObject:[_line_list objectAtIndex:x] forKey:line_line];
        }
        
        
        for(int y = 0; _facility_array != nil && y < [_facility_array count]; y++){
            NSString *station_line = [[_facility_array objectAtIndex:y] objectForKey:@"LINE"];
            if(line_line != nil && station_line != nil && [line_line isEqualToString:station_line]){
                // station list
                [station_list addObject:[_facility_array objectAtIndex:y]];
                
                // another list using line-station as key
                NSString *station_code = [[_facility_array objectAtIndex:y] objectForKey:@"STATION_CODE"];
                if (station_code != nil)
                {
                    NSString *line_station_key = [NSString stringWithFormat:@"%@-%@", line_line, station_code];
                    [_station_records_with_station_as_key setObject:[_facility_array objectAtIndex:y] forKey:line_station_key];
                }
            }
            
        }
        
        if([station_list count] > 0 && line_line != nil){
            [station_list insertObject:@"" atIndex:0];
            [station_list insertObject:@"" atIndex:0];
            [station_list insertObject:@"" atIndex:0];
            [station_list addObject:@""];
            [station_list addObject:@""];
            [station_list addObject:@""];
            [_station_records setObject:station_list forKey:line_line];
            
        }
        [station_list release];
    }


    DEBUGMSG(@"%@",_station_records);
    //    DEBUGMSG(@"%@",_facility_array);
    DEBUGMSG(@"%@",_station_records_with_station_as_key);
    DEBUGMSG(@"%@",_line_records_with_line_as_key);
    
}

#pragma mark - Control Functions

-(void)showNextTrainWithLineIndex:(int)lineIndex stationIndex:(int)stationIndex
{
    DEBUGMSG(@"showNextTrainWithStation");
    [Flurry logEvent:@"RealTimeSchedule"];
    
    //  Cancel Alex
    //    [self hideMapSearchView];
    
    if (nextTrainViewController != nil)
    {
        NSString *line = [[_line_list objectAtIndex:lineIndex] objectForKey:@"LINE"];
        
        nextTrainViewController.station_record = [[_station_records objectForKey:line] objectAtIndex:stationIndex];
        nextTrainViewController.station_records = _station_records;
        nextTrainViewController.station_records_with_station_as_key = _station_records_with_station_as_key;
        
        nextTrainViewController.isReloading = NO;
        
        DEBUGMSG(@"lineIndex:%d satInd:%d , line:%@ , record: %@ adsva: %@",lineIndex,stationIndex,line,_line_records_with_line_as_key,_station_records);
        
        nextTrainViewController.line_records_with_line_as_key = _line_records_with_line_as_key;
        
        [nextTrainViewController reloadGetSchedule];
        [nextTrainViewController showSchedule];
        
        if (![nextTrainViewController isShowing])
        {
            nextTrainViewController.btn_left.hidden =TRUE;
            nextTrainViewController.btn_right.hidden = TRUE;
            [nextTrainViewController show];
        }
        
    }
}

-(void)hideNextTrain
{
    if (nextTrainViewController != nil)
    {
        if ([nextTrainViewController isShowing])
        {
            [nextTrainViewController hide];
        }
    }
}

-(void)highlightStationWithLineIndex:(int)lineIndex stationIndex:(int)stationIndex
{
    [UIView beginAnimations:nil context:nil];
    
    [self highlightStationNoAnimatedWithLineIndex:lineIndex stationIndex:stationIndex];
    
    [UIView commitAnimations];
}

-(void)highlightStationNoAnimatedWithLineIndex:(int)lineIndex stationIndex:(int)stationIndex
{
    _line_table_view.contentOffset = CGPointMake(0, 48 * (lineIndex - 3));
    _line_index = round((48 * (lineIndex - 3)) / 48);
    _line_index += 3;
    
    [self handleLineColor];
    
    [_station_table_view reloadData];
    [_station_shadow_table_view reloadData];
    _station_table_view.contentOffset = CGPointMake(0, 0);
    _station_shadow_table_view.contentOffset = CGPointMake(0, 0);
    
    _station_table_view.contentOffset = CGPointMake(0, 48 * (stationIndex-3));
    _station_index = round((48 * (stationIndex-3)) / 48);
    _station_index += 3;
    
    [self showYellowDot];
}

-(void)selectStationWithStationCode:(NSString*)stationCode
{
    [self selectStationWithStationCode:stationCode popSchedule:YES];
}

-(void)selectStationWithStationCode:(NSString*)stationCode popSchedule:(BOOL)popSchedule
{
    if (stationCode == nil)
        return;
    
    [[CoreData sharedCoreData].mask showMask];
    
    NSMutableArray *station_options = [[NSMutableArray new] autorelease];
    
    // search index for station code
    for (int l=0; l<[_line_list count]; l++)
    {
        if([[_line_list objectAtIndex:l] isKindOfClass:[NSString class]])
            continue;
        
        NSString *line = [[_line_list objectAtIndex:l] objectForKey:@"LINE"];
        
        NSArray *line_station_array = [_station_records objectForKey:line];
        DEBUGMSG(@"_station_records: %@", _station_records);
        for (int s=0; s<[line_station_array count]; s++)
        {
            if([[line_station_array objectAtIndex:s] isKindOfClass:[NSString class]])
                continue;
            
            NSMutableDictionary *station = [line_station_array objectAtIndex:s];
            DEBUGMSG(@"compare: [%@] [%@]", stationCode, [station objectForKey:@"STATION_CODE"]);
            if ([stationCode isEqualToString:[station objectForKey:@"STATION_CODE"]])
            {
                
                DEBUGMSG(@"XXXXX stationCode: %@", stationCode);
                
                StationOption *station_option = [[StationOption alloc] init];
                station_option.line_code = line;
                station_option.line_index = l;
                station_option.station_code = stationCode;
                station_option.station_index = s;
                if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
                {
                    station_option.station_name = [[_line_list objectAtIndex:station_option.line_index] objectForKey:@"LINE_EN"];
                }
                else if ([[CoreData sharedCoreData].lang isEqualToString:@"zh_TW"])
                {
                    station_option.station_name = [[_line_list objectAtIndex:station_option.line_index] objectForKey:@"LINE_TC"];
                }
                [station_options addObject:station_option];
                [station_option release];
            }
        }
    }
    
    [[CoreData sharedCoreData].mask hiddenMask];
    
    // show options
    if ([station_options count] == 0)
    {
        return;
    }
    else if ([station_options count] == 1)
    {
        StationOption *station_option = [station_options objectAtIndex:0];
        [self doSelectStationWithLineIndex:station_option.line_index stationIndex:station_option.station_index popSchedule:popSchedule];
    }
    else
    {
        // allow user to choose for multiple choice
        [self showStationOptions:station_options popSchedule:popSchedule];
    }
}

-(void)selectStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode popSchedule:(BOOL)popSchedule
{
    if (lineCode == nil || stationCode == nil)
        return;
    
    // search index for station code
    for (int l=0; l<[_line_list count]; l++)
    {
        if([[_line_list objectAtIndex:l] isKindOfClass:[NSString class]])
            continue;
        
        NSString *line = [[_line_list objectAtIndex:l] objectForKey:@"LINE"];
        
        if (![line isEqualToString:lineCode])
            continue;
        
        NSArray *line_station_array = [_station_records objectForKey:line];
        
        for (int s=0; s<[line_station_array count]; s++)
        {
            if([[line_station_array objectAtIndex:s] isKindOfClass:[NSString class]])
                continue;
            
            NSMutableDictionary *station = [line_station_array objectAtIndex:s];
            
            if ([stationCode isEqualToString:[station objectForKey:@"STATION_CODE"]])
            {
                // found
                [self doSelectStationWithLineIndex:l stationIndex:s popSchedule:popSchedule];
            }
        }
    }
}

-(void)showStationOptions:(NSMutableArray*)stationOptions popSchedule:(BOOL)popSchedule
{
    DEBUGLog
    
    if ([stationOptions count] == 0)
        return;
    
    if (selectLineView != nil)
    {
        [selectLineView clearDelegatesAndCancel];
        [selectLineView release];
        selectLineView = nil;
    }
    
    selectLineView = [[SelectLineView alloc] init];
    selectLineView.delegate = self;
    selectLineView.isAutoPopSchedule = popSchedule;
    selectLineView.stationOptions = stationOptions;
    
    [selectLineView show];
}

-(void)doSelectStationWithLineIndex:(int)lineIndex stationIndex:(int)stationIndex popSchedule:(BOOL)popSchedule
{
    DEBUGMSG(@"Select line: %i station: %i", lineIndex, stationIndex);
    
    if (!(lineIndex == _line_index && _station_index == stationIndex))
    {
        [self highlightStationWithLineIndex:lineIndex stationIndex:stationIndex];
    }
    
    if (popSchedule)
    {
        [self showNextTrainWithLineIndex:lineIndex stationIndex:stationIndex];
    }
}


-(void)hideBackgroundMask
{
    DEBUGLog
    vw_backgroundMask.alpha = 0.0f;
}

-(void)showBackgroundMask
{
    DEBUGLog
    vw_backgroundMask.alpha = 0.7;
}

-(void)showInAppTutorial
{
    
    if ([TutorialHandler shouldShowTutorialForViewController:self])
    {
        /*
         TutorialViewController *tutorial = [[TutorialViewController alloc] initWithParent:self];
         [tutorial show];
         [tutorial release];
         */
        [self showInAppTutorialAll];
        
        [TutorialHandler didReadTutorialForViewController:self];
    }
    
}

-(void)showInAppTutorialAll
{
    if (isShowingInAppTutorialAll)
        return;
    
    TutorialAllViewController *tutorial = [[[TutorialAllViewController alloc] initWithNibName:@"TutorialAllViewController" bundle:nil] autorelease];
    tutorial.parent = self;
    [self.navigationController presentModalViewController:tutorial animated:YES];
    
    isShowingInAppTutorialAll = YES;
}

-(void)hideInAppTutorialAll
{
    if (isShowingInAppTutorialAll)
    {
        [self.navigationController dismissModalViewControllerAnimated:YES];
        
        isShowingInAppTutorialAll = NO;
    }
}

#pragma mark - Map Search

-(void)showMapSearchView
{
    mapSearchViewController.view.alpha = 0 ;
    [mapSearchViewController reloadData];
    if (mapSearchViewController.view.alpha == 0)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self showBackgroundMask];
            mapSearchViewController.view.alpha = 1;
            //            [mapSearchViewController.scroll_view setContentOffset:CGPointMake(0,0)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)hideMapSearchView
{
    if (mapSearchViewController.view.alpha == 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self hideBackgroundMask];
            mapSearchViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            //            [mapSearchViewController.scroll_view setContentOffset:CGPointMake(0,0)];
        }];
    }
}

-(void)mapSearchViewControllerDidSelectStationWithStationCode:(NSString *)stationsCode
{
    DEBUGMSG(@"mapSearchViewControllerDidSelectStationWithStationCode: %@", stationsCode);
    
    if (stationsCode == nil)
    {
        [self hideMapSearchView];
    }
    else if ([stationsCode isEqualToString:@"OpenSystemMap"])
    {
        [self openSystemMap];
    }
    else
    {
        [self selectStationWithStationCode:stationsCode];
    }
}

-(IBAction)clickMapSearchButton:(id)button
{
    [self showMapSearchView];
    [Flurry logEvent:@"Map Search"];
}

-(void)openSystemMap
{
    if (isShowingSystemMap == NO)
    {
        [[CoreData sharedCoreData].banner_view_controller hide];
        
        SystemMapViewController *systemMapViewController = [[[SystemMapViewController alloc] initWithNibName:@"SystemMapViewController" bundle:nil] autorelease];
        systemMapViewController.parent = self;
        [self.navigationController pushViewController:systemMapViewController animated:YES];
        
        isShowingSystemMap = YES;
    }
}

-(void)closeSystemMap
{
    if (isShowingSystemMap)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        isShowingSystemMap = NO;
    }
}

#pragma mark - Handle Click Button Events

-(IBAction)clickViewByStationsButton:(UIButton*)button{
    _yellow_dot_image_view.alpha = 1;
    _view_by_stations_button.selected = YES;
    _view_by_types_button.selected = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _view_by_station_bg_view.alpha = 1;
    //    _facility_3d_view.alpha = 0;
    [UIView commitAnimations];
}

-(IBAction)clickViewByTypesButton:(UIButton*)button{
    _yellow_dot_image_view.alpha = 0;
    _view_by_stations_button.selected = NO;
    _view_by_types_button.selected = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _view_by_station_bg_view.alpha = 0;
    //    _facility_3d_view.alpha = 1;
    [UIView commitAnimations];
}

-(IBAction)clickNearbyButton:(UIButton*)button
{
    [self startLocatingStation];
}

-(IBAction)clickHideScheduleButton:(UIButton*)button
{
    if (nextTrainViewController != nil)
    {
        [nextTrainViewController clickHideButton:nil];
    }
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


#pragma mark - Location Functions
-(void)startLocatingStation
{
    
    [[CoreData sharedCoreData].mask showMask];
    
    waitingForLocation = YES;
    
    [LocationOperator sharedOperator].delegate = self;
    [LocationOperator sharedOperator].stopOnceFoundLocaton = YES;
    [LocationOperator sharedOperator].timeout = 5;
    [[LocationOperator sharedOperator] startUpdatingLocation];
    
}

-(void) locationOperatorDidUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!waitingForLocation)
        return;
    
    waitingForLocation = NO;
    
    DEBUGMSG(@"didUpdateToLocation");
    
    [[CoreData sharedCoreData].mask hiddenMask];
    
    // calculate distance between current location and stations
    
    //Alex setGPS
//        CLLocation *new =   [[[CLLocation alloc] initWithLatitude:22.337020 longitude:114.174890] autorelease];
//        [self findClosestStationFromCurrentLocation:new];
    [self findClosestStationFromCurrentLocation:newLocation];
}

-(void) locationOperatorDidFailWithError:(NSError *)error
{
    if (!waitingForLocation)
        return;
    
    waitingForLocation = NO;
    
    DEBUGMSG(@"didFailWithError");
    
    [[CoreData sharedCoreData].mask hiddenMask];
    
    // prompt user error message
    CustomAlertView *alert = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"please_enable_location_base_services_%@", [CoreData sharedCoreData].lang]), nil)];
    [alert show];
    [alert release];
}

-(void)findClosestStationFromCurrentLocation:(CLLocation*)currentLocation
{
    DEBUGLog
    
    if (currentLocation == nil)
    {
        return;
    }
    
    DEBUGMSG(@"Lat: %f, Long: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    [[CoreData sharedCoreData].mask showMask];
    
    NSString *closestStationLine = nil;
    int closestStationLineIndex = -1;
    int closestStationIndex = -1;
    CLLocationDistance shortestDistance = -1;
    
    DEBUGMSG(@"LINE LIST: %@", _line_list);
    
    for (int l=0; l<[_line_list count]; l++)
    {
        if([[_line_list objectAtIndex:l] isKindOfClass:[NSString class]])
            continue;
        
        NSString *line = [[_line_list objectAtIndex:l] objectForKey:@"LINE"];
        
        NSArray *line_station_array = [_station_records objectForKey:line];
        DEBUGMSG(@"_station_records_%@",_station_records)


        for (int s=0; s<[line_station_array count]; s++)
        {
            if([[line_station_array objectAtIndex:s] isKindOfClass:[NSString class]])
                continue;
            
            // compare distance
            NSMutableDictionary *station = [line_station_array objectAtIndex:s];
            
            CLLocation *location = [LocationOperator locationForLatitude:[station objectForKey:@"LATITUDE"] longitude:[station objectForKey:@"LONGITUDE"]];
            
            DEBUGMSG(@"%@:%@", [station objectForKey:@"LATITUDE"], [station objectForKey:@"LONGITUDE"]);
            
            CLLocationDistance distance = [currentLocation distanceFromLocation:location];
            
            if (shortestDistance == -1 || distance < shortestDistance)
            {
                closestStationLine = [NSString stringWithString:line];
                closestStationLineIndex = l;
                closestStationIndex = s;
                shortestDistance = distance;
            }
        }
    }
    
    [[CoreData sharedCoreData].mask hiddenMask];
    
    if (shortestDistance != -1)
    {
        // highlight the nearest station
        [self selectStationWithStationCode:[[[_station_records objectForKey:closestStationLine] objectAtIndex:closestStationIndex] objectForKey:@"STATION_CODE"] popSchedule:NO];
        
        // click on the nearest station
        //        [self showNextTrainWithLineIndex:closestStationLineIndex stationIndex:closestStationIndex];
    }
    else
    {
        // prompt user error message
        CustomAlertView *alert = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"please_enable_location_base_services_%@", [CoreData sharedCoreData].lang]), nil)];
        [alert show];
        [alert release];
    }
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



#pragma mark -
#pragma mark UITableViewDataSource

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!louhasParkStationSelected && (tableView == _station_table_view || tableView == _station_shadow_table_view)){
        if (![[_line_list objectAtIndex:_line_index] isKindOfClass:[NSString class]]) {
            NSString *line = [[_line_list objectAtIndex:_line_index] objectForKey:@"LINE"];
            if (![[[_station_records objectForKey:line] objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
                if ([[[[_station_records objectForKey:line] objectAtIndex:indexPath.row] objectForKey:@"STATION_CODE"] isEqualToString:@"LHP"]) {
                    return 96;
                }
            }
        }
    }
	return 48;
    
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if((tableView == _line_table_view || tableView == _line_shadow_table_view))
        return [_line_list count];
    
    //for safety
    if([[_line_list objectAtIndex:_line_index] isKindOfClass:[NSString class]])
        return 0;
    NSString *line = [[_line_list objectAtIndex:_line_index] objectForKey:@"LINE"];
	return [[_station_records objectForKey:line] count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(tableView == _line_table_view || tableView == _line_shadow_table_view){
        NSString *identifier = @"SelectStationLineCell";
        SelectStationLineCell *cell = (SelectStationLineCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            cell = [[[SelectStationLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        }
        
        [cell reset];
        
        
        if((tableView == _line_table_view || tableView == _line_shadow_table_view) && ![[_line_list objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
            cell.value_label.text = [[_line_list objectAtIndex:indexPath.row] objectForKey:[NSString stringWithFormat:@"LINE_%@", _db_lang]];
            
            if(tableView == _line_table_view){
                NSString *line = [[_line_list objectAtIndex:indexPath.row] objectForKey:@"LINE"];
                
                if([line isEqualToString:@"AEL"]){
                    cell.value_label.textColor = [UIColor colorWithRed:28.0/255.0 green:118.0/255.0 blue:112.0/255.0 alpha:1];
                }
                else if([line isEqualToString:@"TCL"]){
                    cell.value_label.textColor = [UIColor colorWithRed:254.0/255.0 green:127.0/255.0 blue:29.0/255.0 alpha:1];
                }
                else if([line isEqualToString:@"TKL"]){
                    cell.value_label.textColor = [UIColor colorWithRed:100/255.0 green:10.0/255.0 blue:103.0/255.0 alpha:1];
                }
                
                else if([line isEqualToString:@"WRL"]){
                    cell.value_label.textColor = [UIColor colorWithRed:158/255.0 green:52/255.0 blue:144/255.0 alpha:1];
                }
                
            }
            else if(tableView == _line_shadow_table_view){
                cell.value_label.textColor = [UIColor whiteColor];
            }
        }
        
        return cell;
    }
    
    
    if(tableView == _station_table_view || tableView == _station_shadow_table_view){
        
        if(![[_line_list objectAtIndex:_line_index] isKindOfClass:[NSString class]]){ //For LHP station
            NSString *line = [[_line_list objectAtIndex:_line_index] objectForKey:@"LINE"];
            if (![[[_station_records objectForKey:line] objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] && [[[[_station_records objectForKey:line] objectAtIndex:indexPath.row] objectForKey:@"STATION_CODE"]isEqualToString:@"LHP"]) {
                NSString *identifier = @"SelectStationStationLHPCell";
                SelectStationStationLHPCell *cell = (SelectStationStationLHPCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil){
                    cell = [[[SelectStationStationLHPCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                }
                [cell reset];
                if (louhasParkStationSelected) {
                    [cell setSize:NO animated:YES];
                } else {
                    [cell setSize:YES animated:YES];
                }
                if (tableView==_station_shadow_table_view) {
                    cell.louhasParkStation.hidden = YES;
                }
                if(tableView == _station_table_view)
                    cell.value_label.textColor = [UIColor grayColor];
                else if(tableView == _station_shadow_table_view)
                    cell.value_label.textColor = [UIColor whiteColor];

                cell.value_label.text = [[[_station_records objectForKey:line] objectAtIndex:indexPath.row] objectForKey:[NSString stringWithFormat:@"STATION_NAME_%@", _db_lang]];
                return cell;
            }
        }
        NSString *identifier = @"SelectStationStationCell";
        SelectStationStationCell *cell = (SelectStationStationCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            cell = [[[SelectStationStationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        }
        
        [cell reset];
        
        if(tableView == _station_table_view)
            cell.value_label.textColor = [UIColor grayColor];
        else if(tableView == _station_shadow_table_view)
            cell.value_label.textColor = [UIColor whiteColor];
        
        if(![[_line_list objectAtIndex:_line_index] isKindOfClass:[NSString class]]){
            NSString *line = [[_line_list objectAtIndex:_line_index] objectForKey:@"LINE"];
            if(![[[_station_records objectForKey:line] objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
                
                if(tableView == _station_table_view){
                    cell.dot_image_view.image = [UIImage imageNamed:@"next_train_select_station_point_normal.png"];
                }
                
                cell.value_label.text = [[[_station_records objectForKey:line] objectAtIndex:indexPath.row] objectForKey:[NSString stringWithFormat:@"STATION_NAME_%@", _db_lang]];
                //cell.dot_image_view.hidden = NO;
                
            } else {
                
            }
            
        }
        
        return cell;
        
    }
    
    return nil;
    
}


#pragma mark -
#pragma mark UITableViewDelegate


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //DEBUGMSG(@"select %@", _station_table_view);
    if((tableView == _station_table_view) && ![[_line_list objectAtIndex:_line_index] isKindOfClass:[NSString class]]){
        
        
        NSString *line = [[_line_list objectAtIndex:_line_index] objectForKey:@"LINE"];
        
        //DEBUGMSG(@"lineline %@ " , line);
        if(![[[_station_records objectForKey:line] objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
            if(_station_index == indexPath.row)
            {
                [self showNextTrainWithLineIndex:_line_index stationIndex:indexPath.row];
            }
            else{
                _yellow_dot_image_view.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    float offset = 0;
                    if (([[CoreData sharedCoreData].lang isEqualToString:@"en"] && _line_index==4) || ([[CoreData sharedCoreData].lang isEqualToString:@"zh_TW"] && _line_index==5)) {
                        if (indexPath.row==8) {
                            louhasParkStationSelected = YES;
                        } else {
                            louhasParkStationSelected = NO;
                        }
                        if (indexPath.row>8) { //LHP Selected
                            offset = 48;
                        }
                    }
                    _station_table_view.contentOffset = CGPointMake(0, 48 * (indexPath.row - 3) + offset);
                    _station_index = indexPath.row;
                    [_station_table_view reloadData];
                    [_station_shadow_table_view reloadData];
                } completion:^(BOOL finished) {
                    [self showYellowDot];
                    //[self stationTableViewPaging];
                }];
            }
        }
        //[self stationTableViewPaging];

    }
    else if((tableView == _line_table_view) && ![[_line_list objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
    {
        
        
        if (_line_index != indexPath.row)
        {
            _yellow_dot_image_view.alpha = 0;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.8];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(showYellowDot)];
            _line_table_view.contentOffset = CGPointMake(0, 48 * (indexPath.row - 3));
            _line_index = round((48 * (indexPath.row - 3)) / 48);
            _line_index += 3;
            [UIView commitAnimations];
            [_station_table_view reloadData];
            [_station_shadow_table_view reloadData];
            _station_table_view.contentOffset = CGPointMake(0, 0);
            _station_shadow_table_view.contentOffset = CGPointMake(0, 0);
            [self handleLineColor];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _line_table_view){
        _line_shadow_table_view.contentOffset = CGPointMake(_line_table_view.contentOffset.x, _line_table_view.contentOffset.y);
    }
    else if(scrollView == _station_table_view){
        _station_shadow_table_view.contentOffset = CGPointMake(_station_table_view.contentOffset.x, _station_table_view.contentOffset.y);
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    louhasParkStationSelected = NO;
    [_station_table_view reloadData];
    [_station_shadow_table_view reloadData];
    _yellow_dot_image_view.alpha = 0;
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView == _line_table_view)
        [self lineTableViewPaging];
    else if(scrollView == _station_table_view)
        [self stationTableViewPaging];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(!decelerate){
        if(scrollView == _line_table_view)
            [self lineTableViewPaging];
        else if(scrollView == _station_table_view)
            [self stationTableViewPaging];
	}
    
}

#pragma mark - SelectLineViewDelegate
-(void)SelectLineView:(SelectLineView *)currentSelectLineView didDismissWithButtonIndex:(int)buttonIndex autoPopSchedule:(BOOL)autoPopSchedule
{
    [currentSelectLineView retain];
    
    DEBUGMSG(@"BUTTON: %i, AUTO POP: %i", buttonIndex, autoPopSchedule);
    
    int clickedLineIndex = buttonIndex - 1;
    
    if (clickedLineIndex >= 0 && clickedLineIndex < [currentSelectLineView.stationOptions count])
    {
        StationOption *option = [currentSelectLineView.stationOptions objectAtIndex:clickedLineIndex];
        
        [self doSelectStationWithLineIndex:option.line_index stationIndex:option.station_index popSchedule:autoPopSchedule];
        
    }
    
    [currentSelectLineView release];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    DEBUGLog
}

@end
