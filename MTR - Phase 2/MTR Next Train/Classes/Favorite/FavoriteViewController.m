//
//  FavoriteViewController.m
//  MTR Next Train
//
//  Created by  on 12年2月15日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FavoriteViewController.h"

@implementation FavoriteViewController


#define TAG_SELECT_STATION_AUTO_POP_SCHEDULE 101
#define TAG_SELECT_STATION_NO_POP_SCHEDULE 102
#define POSITION_Y 20

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self unloadNextStationViewController];
    
    if (selectLineView != nil)
    {
        [selectLineView clearDelegatesAndCancel];
        [selectLineView release];
        selectLineView = nil;
    }
    
    if (favorite_station_array != nil)
    {
        [favorite_station_array release];
        favorite_station_array = nil;
    }
    if(_facility_array != nil){
        [_facility_array release];
        _facility_array = nil;
    }
    if(_line_list != nil){
        [_line_list release];
        _line_list = nil;
    }
    if (_station_dictionary != nil)
    {
        [_station_dictionary release];
        _station_dictionary = nil;
    }
    if (_line_dictionary != nil)
    {
        [_line_dictionary release];
        _line_dictionary = nil;
    }
    if (_station_records != nil)
    {
        [_station_records release];
        _station_records = nil;
    }
    
    [_title_label release];
    [tbl_favorite release];
    [btn_edit release];
    [vw_backgroundMask release];
    [_status_label release];
    [panGestureRecognizer release];
    
    [_background release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

        

    [btn_setting addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    panGestureRecognizer= [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    _background.image = [UIImage imageNamed:[NSString stringWithFormat:@"background_%@.png",isFive?@"1136":@"960"]];
    _background.alpha = 0.2f;
    _background.frame = CGRectMake(_background.frame.origin.x, _background.frame.origin.y, _background.frame.size.width, isFive?548:460);
    
    [_title_label setText:NSLocalizedString(([NSString stringWithFormat:@"my_favorite_%@", [CoreData sharedCoreData].lang]), nil)];
    
    [btn_edit setTitle:NSLocalizedString(([NSString stringWithFormat:@"edit_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
    [btn_edit setTitle:NSLocalizedString(([NSString stringWithFormat:@"done_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateSelected];
    
    [_status_label setText:NSLocalizedString(([NSString stringWithFormat:@"no_bookmark_%@", [CoreData sharedCoreData].lang]), nil)];
    
    [self loadFavoriteStationArray];
    
    [self loadLineAndStationArray];
    
    [self constructStationRecord];
    
    // x-callback
    [self handleCallbackMotherButton];
    
    [self loadNextStationViewController];
    
    //ios 7 Alex
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]autorelease];
        
        view.backgroundColor=[UIColor colorWithRed:213/255.0 green:215/255.0 blue:219/255.0 alpha:1];
        
        [self.view addSubview:view];
        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
    
    //    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    //    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    //    [self.view addGestureRecognizer:swipeLeft];
    //
    //    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    //    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    //    [self.view addGestureRecognizer:swipeRight];
}


//- (void)swipe:(UISwipeGestureRecognizer *)swipeRecogniser
//{
//    if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionLeft)
//    {
//        self.pageControl.currentPage -=1;
//    }
//    else if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionRight)
//    {
//        self.pageControl.currentPage +=1;
//    }
//    _dssview.image = [UIImage imageNamed:
//                      [NSString stringWithFormat:@"%d.jpg",self.pageControl.currentPage]];
//}

- (void)viewDidUnload
{
    [_background release];
    _background = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadFavoriteStationArray];
    
    [self loadLineAndStationArray];
    
    [self constructStationRecord];
    
    if(nextTrainViewController){
        [nextTrainViewController didHidden];
    }
    
    [super viewWillAppear:animated];
    [self.view addGestureRecognizer:panGestureRecognizer];
    [self reloadData];
    tbl_favorite.editing = NO;
    [self handleEditButton];

}

-(void)reloadData{
    
    
    if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
        _db_lang = [@"EN" retain];
    }
    else{
        _db_lang = [@"TC" retain];
    }
    [_title_label setText:NSLocalizedString(([NSString stringWithFormat:@"my_favorite_%@", [CoreData sharedCoreData].lang]), nil)];
    
    [btn_edit setTitle:NSLocalizedString(([NSString stringWithFormat:@"edit_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
    [btn_edit setTitle:NSLocalizedString(([NSString stringWithFormat:@"done_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateSelected];
    
    [_status_label setText:NSLocalizedString(([NSString stringWithFormat:@"no_bookmark_%@", [CoreData sharedCoreData].lang]), nil)];
    
    [tbl_favorite reloadData];

}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self showInAppTutorial];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Main functions
-(void)constructStationRecord
{
    if (_station_dictionary != nil)
    {
        [_station_dictionary release];
        _station_dictionary = nil;
    }
    if (_line_dictionary != nil)
    {
        [_line_dictionary release];
        _line_dictionary = nil;
    }
    if (_station_records != nil)
    {
        [_station_records release];
        _station_records = nil;
    }
    
    _station_dictionary = [NSMutableDictionary new];
    _line_dictionary = [NSMutableDictionary new];
    _station_records = [NSMutableDictionary new];
    
    for(int x = 0; _line_list != nil && x < [_line_list count]; x++){
        if([[_line_list objectAtIndex:x] isKindOfClass:[NSString class]])
            continue;
        
        NSMutableArray *station_list = [NSMutableArray new];
        NSString *line_line = [[_line_list objectAtIndex:x] objectForKey:@"LINE"];
        
        if (line_line != nil)
        {
            // add line list with line as key
            [_line_dictionary setObject:[_line_list objectAtIndex:x] forKey:line_line];
        }
        
        for(int y = 0; _facility_array != nil && y < [_facility_array count]; y++){
            NSString *station_line = [[_facility_array objectAtIndex:y] objectForKey:@"LINE"];
            if(line_line != nil && station_line != nil && [line_line isEqualToString:station_line]){
                
                // station list
                [station_list addObject:[_facility_array objectAtIndex:y]];
                
                // add station list with line-station as key
                NSString *station_code = [[_facility_array objectAtIndex:y] objectForKey:@"STATION_CODE"];
                if (station_code != nil)
                {
                    NSString *line_station_key = [NSString stringWithFormat:@"%@-%@", line_line, station_code];
                    [_station_dictionary setObject:[_facility_array objectAtIndex:y] forKey:line_station_key];
                }
            }
        }
        
        if([station_list count] > 0 && line_line != nil){
            [_station_records setObject:station_list forKey:line_line];
        }
        [station_list release];
    }
}

-(void)loadFavoriteStationArray
{
    if (favorite_station_array != nil)
    {
        [favorite_station_array release];
        favorite_station_array = nil;
    }
    
    favorite_station_array = [[[[SQLiteOperator sharedOperator] selectALLFromFavoriteStation] mutableCopy] retain];
    
    if ([favorite_station_array count] == 0) {
        if (tbl_favorite.alpha == 1)
        {
            [UIView animateWithDuration:0.3 animations:^{
                tbl_favorite.alpha = 0;
                _status_label.alpha = 1;
            }];
        }
    }
    else
    {
        if (tbl_favorite.alpha == 0)
        {
            [UIView animateWithDuration:0.3 animations:^{
                tbl_favorite.alpha = 1;
                _status_label.alpha = 0;
            }];
        }
    }
    
}

-(void)loadLineAndStationArray
{
    if(_facility_array != nil){
        [_facility_array release];
        _facility_array = nil;
    }
    if(_line_list != nil){
        [_line_list release];
        _line_list = nil;
    }
    
    [[FacilitySQLOperator sharedOperator] openDatabase];
    
    _line_list = [[[FacilitySQLOperator sharedOperator] selectALLFromLine] retain];
    _facility_array = [[[FacilitySQLOperator sharedOperator] selectALLFromFacilities] retain];
    
    [[FacilitySQLOperator sharedOperator] closeDatabase];
    
}



#pragma mark - Control Functions
-(void)loadNextStationViewController
{
    // prepare next train schedule that is hidden
    [self unloadNextStationViewController];
    
    nextTrainViewController = [[NextTrainViewController alloc] initWithNibName:@"NextTrainViewController" bundle:nil];
    nextTrainViewController.isBookmark = TRUE;
    nextTrainViewController.parentViewController = self;
    [self.view addSubview:vw_backgroundMask];
    [self.view addSubview:nextTrainViewController.view];
    [nextTrainViewController didHidden];
}

-(void)unloadNextStationViewController
{
    
    if (nextTrainViewController != nil)
    {
        DEBUGMSG(@"remove nextTrainViewController");
        nextTrainViewController.parentViewController = nil;
        [nextTrainViewController.view removeFromSuperview];
        [vw_backgroundMask removeFromSuperview];
        DEBUGMSG(@"release nextTrainViewController");
        [nextTrainViewController releaseObjects];
        [nextTrainViewController release];
        nextTrainViewController = nil;
        DEBUGMSG(@"released nextTrainViewController");
    }
}

-(void)selectStationWithStationCode:(NSString*)stationCode
{
    DEBUGLog
    [self selectStationWithStationCode:stationCode popSchedule:YES];
}

-(void)selectStationWithStationCode:(NSString*)stationCode popSchedule:(BOOL)popSchedule
{
    if (stationCode == nil)
        return;
    
    [[CoreData sharedCoreData].mask showMask];
    
    NSMutableArray *station_options = [[NSMutableArray new]autorelease];
    
    // search index for station code
    for (int l=0; l<[_line_list count]; l++)
    {
        if([[_line_list objectAtIndex:l] isKindOfClass:[NSString class]])
            continue;
        
        NSString *line = [[_line_list objectAtIndex:l] objectForKey:@"LINE"];
        
        NSArray *line_station_array = [_station_records objectForKey:line];
        
        for (int s=0; s<[line_station_array count]; s++)
        {
            if([[line_station_array objectAtIndex:s] isKindOfClass:[NSString class]])
                continue;
            
            NSMutableDictionary *station = [line_station_array objectAtIndex:s];
            
            if ([stationCode isEqualToString:[station objectForKey:@"STATION_CODE"]])
            {
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
        [self selectStationWithLineCode:station_option.line_code stationCode:station_option.station_code index:0];
    }
    else
    {
        // allow user to choose for multiple choice
        [self showStationOptions:station_options popSchedule:popSchedule];
    }
    
    // show timetable based on selection (if any)
}


-(void)selectStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode index:(int)index
{
    if (lineCode == nil || stationCode == nil)
        return;
    
    if (nextTrainViewController != nil)
    {
        NSString *line_station_key = [NSString stringWithFormat:@"%@-%@", lineCode, stationCode];
        
        nextTrainViewController.station_record = [_station_dictionary objectForKey:line_station_key];
        nextTrainViewController.station_records_with_station_as_key = _station_dictionary;
        nextTrainViewController.line_records_with_line_as_key = _line_dictionary;
        nextTrainViewController.favorite_station_array = favorite_station_array ;
        nextTrainViewController.index = index ;
        [nextTrainViewController reloadGetSchedule];
        [nextTrainViewController showSchedule];
        
        if (![nextTrainViewController isShowing])
        {
            [nextTrainViewController show];
        }
        [self.view removeGestureRecognizer:panGestureRecognizer];
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

-(void)hideBackgroundMask
{
    DEBUGLog
    vw_backgroundMask.alpha = 0;
}

-(void)showBackgroundMask
{
    DEBUGLog
    vw_backgroundMask.alpha = 0.7;
}

-(void)refreshFavouriteTableView
{
    [self loadFavoriteStationArray];
    
    [tbl_favorite reloadData];
}

-(void)handleEditButton
{
    if (tbl_favorite.editing)
    {
        btn_edit.selected = YES;
        [self.view removeGestureRecognizer:panGestureRecognizer];
    }
    else
    {
        btn_edit.selected = NO;
        [self.view addGestureRecognizer:panGestureRecognizer];

    }
}

/*
 -(void)showInAppTutorial
 {
 if ([TutorialHandler shouldShowTutorialForViewController:self])
 {
 TutorialViewController *tutorial = [[TutorialViewController alloc] initWithParent:self];
 [tutorial show];
 [tutorial release];
 
 [TutorialHandler didReadTutorialForViewController:self];
 }
 }
 */
    #pragma mark - Button functions
-(IBAction)clickEditButton:(id)sender
{
    tbl_favorite.editing = !tbl_favorite.editing;
    
    [self handleEditButton];
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
    return 4.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIView alloc] init] autorelease];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [favorite_station_array count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *favorite_station = [favorite_station_array objectAtIndex:indexPath.row];
    
    NSString *station_code = [favorite_station objectForKey:@"station_code"];
    NSString *line_code = [favorite_station objectForKey:@"line_code"];
    
    //NSString *line_name = @"";
    NSString *station_name = @"";
    
    if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
    {
        //line_name = [[_line_dictionary objectForKey:line_code] objectForKey:@"LINE_EN"];
        station_name = [[_station_dictionary objectForKey:[NSString stringWithFormat:@"%@-%@", line_code, station_code]] objectForKey:@"STATION_NAME_EN"];
    }
    else if ([[CoreData sharedCoreData].lang isEqualToString:@"zh_TW"])
    {
        //line_name = [[_line_dictionary objectForKey:line_code] objectForKey:@"LINE_TC"];
        station_name = [[_station_dictionary objectForKey:[NSString stringWithFormat:@"%@-%@", line_code, station_code]] objectForKey:@"STATION_NAME_TC"];
    }
    
    NSLog(@"stationName.length: %d",station_name.length);
        if(station_name.length>12){
            
            return 51;
        }else{

            return 51;
        }
    }

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    customAlertView = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"no_connection_content_%@", [CoreData sharedCoreData].lang]), nil)];
//    customAlertView.delegate = self;
//    [customAlertView show];
    
    
    return NSLocalizedString(([NSString stringWithFormat:@"remove_%@", [CoreData sharedCoreData].lang]), nil);
    
  

    
    // ios 7 Alex
    if([[[UIDevice currentDevice] systemVersion]doubleValue] >= 7.0)
    {
        //        [tableView setFrame:[[UIScreen mainScreen] bounds]];
        //         [self.navigationController.view addSubview:tableView];
        //        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavoriteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        
    }
    NSMutableDictionary *favorite_station = [favorite_station_array objectAtIndex:indexPath.row];
    
    NSString *station_code = [favorite_station objectForKey:@"station_code"];
    NSString *line_code = [favorite_station objectForKey:@"line_code"];
    
    NSString *line_name = @"";
    NSString *station_name = @"";
    
    if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
    {
        line_name = [[_line_dictionary objectForKey:line_code] objectForKey:@"LINE_EN"];
        station_name = [[_station_dictionary objectForKey:[NSString stringWithFormat:@"%@-%@", line_code, station_code]] objectForKey:@"STATION_NAME_EN"];
    }
    else if ([[CoreData sharedCoreData].lang isEqualToString:@"zh_TW"])
    {
        line_name = [[_line_dictionary objectForKey:line_code] objectForKey:@"LINE_TC"];
        station_name = [[_station_dictionary objectForKey:[NSString stringWithFormat:@"%@-%@", line_code, station_code]] objectForKey:@"STATION_NAME_TC"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", line_name, station_name];
    NSLog(@"CELL HEIGHT: %f",cell.contentView.frame.size.height);
    //    CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    
    cell.textLabel.numberOfLines = 0;
    //This makes your label wrap words as they reach the end of a line
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    //    CGRect xx =cell.img_background.frame;
    //    CGRect qq = cell.lbl_station_name.frame;
    //    xx.size.height = cellRect.size.height;
    //    qq.size.height = cellRect.size.height;
    //    qq.origin.y = 20;
    //    cell.img_background.frame = xx;
    //    cell.lbl_station_name.frame = qq;
    //    [cell.lbl_station_name sizeToFit];
    //    if(qq.size.height >60){
    // [cell.lbl_station_name setNumberOfLines:2];
    //    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
    
}


-(void)hideBookMarkViewController{
    if(nextTrainViewController)
        [nextTrainViewController didHidden];
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
//        NSMutableDictionary *favorite_station = [favorite_station_array objectAtIndex:indexPath.row];
//        
//        NSString *station_code = [favorite_station objectForKey:@"station_code"];
//        NSString *line_code = [favorite_station objectForKey:@"line_code"];
//        
//        
//        [[SQLiteOperator sharedOperator] deleteRecordFromFavoriteStationWithLineCode:line_code stationCode:station_code];
//        [self loadFavoriteStationArray];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        self.index = indexPath.row;
        
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(([NSString stringWithFormat:@"cancel_bookmark_Favoutite_%@", [CoreData                                      sharedCoreData].lang]), nil)
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(([NSString stringWithFormat:@"cancel_%@", [CoreData                                       sharedCoreData].lang]), nil)
                                            otherButtonTitles: NSLocalizedString(([NSString stringWithFormat:@"ok_%@", [CoreData                                       sharedCoreData].lang]), nil),nil];
        
        [alert show];
        alert.tag = CancelBookMark;
        [alert release];

    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSLog(@"Cancel Button");
        
    }
    if (buttonIndex == 1) {
        NSLog(@"OK button click");
        
                NSMutableDictionary *favorite_station = [favorite_station_array objectAtIndex:self.index];
        
        DEBUGMSG(@"index:%@",favorite_station)
        
                NSString *station_code = [favorite_station objectForKey:@"station_code"];
                NSString *line_code = [favorite_station objectForKey:@"line_code"];
                
                
                [[SQLiteOperator sharedOperator] deleteRecordFromFavoriteStationWithLineCode:line_code stationCode:station_code];
                [self loadFavoriteStationArray];
                [tbl_favorite deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
            }


    }


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.row == destinationIndexPath.row)
        return;
    
    DEBUGMSG(@"MOVE from: %i to: %i", sourceIndexPath.row, destinationIndexPath.row);
    DEBUGMSG(@"MOVE ORIGINAL: %@", favorite_station_array);
    
    NSMutableDictionary *favorite_station = [[[favorite_station_array objectAtIndex:sourceIndexPath.row] mutableCopy]autorelease];
    NSString *station_code = [favorite_station objectForKey:@"station_code"];
    NSString *line_code = [favorite_station objectForKey:@"line_code"];
    
    [favorite_station_array removeObjectAtIndex:sourceIndexPath.row];
    [favorite_station_array insertObject:favorite_station atIndex:destinationIndexPath.row];
    
    double lineNumberf;// = [[favorite_station objectForKey:@"line_number"] doubleValue];
    double previousLineNumber;// = lineNumberf;
    double nextLineNumber;// = lineNumberf;
    
    if (destinationIndexPath.row == 0)
    {
        previousLineNumber = 0.0;
    }
    else
    {
        NSMutableDictionary *previous_favorite_station = [favorite_station_array objectAtIndex:destinationIndexPath.row-1];
        if (previous_favorite_station == nil)
        {
            previousLineNumber = 0.0;
        }
        else
        {
            previousLineNumber = [[previous_favorite_station objectForKey:@"line_number"] doubleValue];
        }
    }
    
    if (destinationIndexPath.row == [favorite_station_array count] - 1)
    {
        nextLineNumber = previousLineNumber + 2.0;
    }
    else
    {
        NSMutableDictionary *next_favorite_station = [favorite_station_array objectAtIndex:destinationIndexPath.row+1];
        if (next_favorite_station == nil)
        {
            nextLineNumber = previousLineNumber + 2.0;
        }
        else
        {
            nextLineNumber = [[next_favorite_station objectForKey:@"line_number"] doubleValue];
        }
    }
    DEBUGMSG(@"MOVE LINE NUMBER previous: %f next: %f", previousLineNumber, nextLineNumber);
    
    lineNumberf = (nextLineNumber - previousLineNumber) / 2 + previousLineNumber;
    NSString *line_number = [NSString stringWithFormat:@"%.6f", lineNumberf];
    
    [[SQLiteOperator sharedOperator] updateLineNumber:line_number fromFavoriteStationWithLineCode:line_code stationCode:station_code];
    [favorite_station setObject:line_number forKey:@"line_number"];
    
//    DEBUGMSG(@"MOVE FINAL: %@", favorite_station_array);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *favorite_station = [favorite_station_array objectAtIndex:indexPath.row];
    NSString *station_code = [favorite_station objectForKey:@"station_code"];
    NSString *line_code = [favorite_station objectForKey:@"line_code"];
    
    [self selectStationWithLineCode:line_code stationCode:station_code index:indexPath.row];
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
        
        [self selectStationWithLineCode:option.line_code stationCode:option.station_code index:clickedLineIndex];
    }
    
    [currentSelectLineView release];
}


@end
