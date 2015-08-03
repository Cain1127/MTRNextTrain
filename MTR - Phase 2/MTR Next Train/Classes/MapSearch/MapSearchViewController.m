//
//  MapSearchViewController.m
//  MTR Next Train
//
//  Created by Lam Bob on 9/1/13.
//
//

#import "MapSearchViewController.h"
#import "CoreData.h"
#import "LocationOperator.h"
#import "LocationOperatorDelegate.h"
#import "SelectStationViewController.h"



@interface MapSearchViewController () <LocationOperatorDelegate>

@end

@implementation MapSearchViewController

@synthesize delegate = _delegate, wrlStations;
@synthesize scroll_view = _scroll_view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    if(isFive == YES){
        
        [btn_gps setFrame:CGRectMake(8, 438, 50, 50)];
    }
    else{
        [btn_gps setFrame:CGRectMake(5, 353, 50, 50)];
    }
    
    img_user_location.hidden = YES;
    _station_records = [NSMutableDictionary new];
    _station_records_with_station_as_key = [NSMutableDictionary new];
    _line_records_with_line_as_key = [NSMutableDictionary new];
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
    //    DEBUGMSG(@"Facility array: %@", _facility_array);
    [[FacilitySQLOperator sharedOperator] closeDatabase];
    
    [self constructStationRecord];
    
    // Do any additional setup after loading the view from its nib.
//    if(isFive == NO){
//        
//        CGRect frame1 = self.view.frame;
//        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//            frame1.origin.y -=56;
//            
//        }
//        self.view.frame =frame1;
//    }
//    
//    if (IS_IPHONE5 == YES) {
//        CGRect frame1 = self.view.frame;
//        
//        //        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        frame1.origin.y +=56;
//        self.view.frame =frame1;
//        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) {
//            frame1.origin.y -=60;
//            self.view.frame =frame1;
//        }
//    }
    
    view_map.transform = CGAffineTransformMakeScale(1.2, 1.2);
//    view_map.frame = CGRectMake(-270, -82, 806, 520);

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        CGRect frame = btn_miniMap.frame;
        frame.origin.y += -100;
        btn_miniMap.frame =frame;
        
    }else if (IS_IPHONE5 ==YES){
        
        CGRect frame = btn_miniMap.frame;
        frame.origin.y += 2;
        btn_miniMap.frame =frame;
        //[_scroll_view setFrame:CGRectMake(0, 20, 320, 460)];
        
    }
    
    
    //    if(![[CoreData sharedCoreData].lang isEqualToString:@"en"])
    //        [btn_view_system_map setFrame:CGRectMake(btn_view_system_map.frame.origin.x, btn_view_system_map.frame.origin.y, 76, 69)];
    
    
    wrlStations = [[NSMutableArray alloc]initWithObjects:@"HUH",@"ETS",@"AUS",@"MEF",@"TWW",@"KSR",@"YUL",@"LOP",@"TIS",@"SIH",@"TUM",nil];
    [btn_miniMap setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"slide_route_map_view_system_map_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    
    [_scroll_view setContentSize:CGSizeMake(1050 ,620)];

    [self.view setFrame:CGRectMake(self.view.frame.origin.x, ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0)? 20 : 0 , self.view.frame.size.width, IS_IPHONE5?513:428 )];
    [_scroll_view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];

    DEBUGMSG(@"_scroll_view heightheightheight %f" ,  _scroll_view.frame.size.height);
    DEBUGMSG(@" self.view heightheightheight %f" ,  self.view.frame.size.height);

    
    
    
    _line_list = [[NSMutableArray alloc] initWithArray:[[FacilitySQLOperator sharedOperator] selectALLFromLine]];
    [_line_list insertObject:@"" atIndex:0];
    [_line_list insertObject:@"" atIndex:0];
    [_line_list insertObject:@"" atIndex:0];
    [_line_list addObject:@""];
    [_line_list addObject:@""];
    [_line_list addObject:@""];
    DEBUGMSG(@"line list: %@", _line_list);
    
    [self reloadData];
    
    [_scroll_view setContentOffset:CGPointMake(250, 60)];

}

-(void)viewDidAppear:(BOOL)animated{

//    [alert dismissWithClickedButtonIndex:0 animated:YES];
}




-(void) reloadData
{
    [btn_miniMap setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"slide_route_map_view_system_map_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    
    if ([[CoreData sharedCoreData].btn_miniMap isEqualToString:@"2"]) {
        [btn_miniMap setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"route_map_view_system_map_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    }
    if ([[CoreData sharedCoreData].btn_miniMap isEqualToString:@"3"]) {
        [btn_miniMap setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"new_slide_route_map_view_system_map_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    ReleaseObj(btn_view_system_map)
    
    [btn_miniMap release];
    [view_map release];
    [img_user_location release];
    [super dealloc];
}

-(void)clickStationWithStationCode:(NSString*)stationCode
{

    if (_delegate && [_delegate respondsToSelector:@selector(mapSearchViewControllerDidSelectStationWithStationCode:)]) {
        [_delegate mapSearchViewControllerDidSelectStationWithStationCode:stationCode];
    }
}


#pragma mark - Button functions


// Alex map search GPS
-(IBAction)clickGPSButton:(UIButton*)button
{
    [self startLocatingStation];
//    _isGPSpoint.hidden = true;
//    [img_user_location release];
    return;

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

-(void) locationOperatorDidFailWithError:(NSError *)error
{
    if (!waitingForLocation)
        return;
    
    waitingForLocation = NO;
    
    DEBUGMSG(@"didFailWithError");
    
    [[CoreData sharedCoreData].mask hiddenMask];
    
    // prompt user error message
//    CustomAlertView *alert = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"please_enable_location_base_services_%@", [CoreData sharedCoreData].lang]), nil)];
//    [alert show];
//    [alert release];
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
        DEBUGMSG(@"_station_records%@",_station_records)

        
        DEBUGMSG(@"line_station_array%@",line_station_array)
        
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

-(void) locationOperatorDidUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!waitingForLocation)
        return;
    
    waitingForLocation = NO;
    
    DEBUGMSG(@"didUpdateToLocation");
    
    [[CoreData sharedCoreData].mask hiddenMask];
    
    // calculate distance between current location and stations
    
//Alex
    
    
//    CLLocation *new =   [[[CLLocation alloc] initWithLatitude:22.337020 longitude:114.174890] autorelease];
//    [self findClosestStationFromCurrentLocation:new];
    [self findClosestStationFromCurrentLocation:newLocation];
    
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
        DEBUGMSG(@"line_station_array: %@", line_station_array);
        DEBUGMSG(@"line: %@", line);

        for (int s=0; s<[line_station_array count]; s++)
        {
            if([[line_station_array objectAtIndex:s] isKindOfClass:[NSString class]])
                continue;
            
            NSMutableDictionary *station = [line_station_array objectAtIndex:s];
            DEBUGMSG(@"compare: %@ %@", stationCode, [station objectForKey:@"STATION_CODE"]);
            
            
            DEBUGMSG(@"XXXXX stationCode: %@", stationCode);

            
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
                
                
                // show image
                NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"StationCoordinate"
                                                                      ofType:@"plist"];
                NSArray *dict = [[NSArray alloc]
                                 initWithContentsOfFile:plistPath];
                
                DEBUGMSG(@"dict  :  %@ " , dict );

                for (int xx = 0; xx<[dict count];  xx++) {
                    //        NSString *station_code = [[_facility_array objectAtIndex:x] objectForKey:@"STATION_CODE"];
                    DEBUGMSG(@"StationCoordinate  :  %@ isEqualToString %@" , [[dict objectAtIndex:xx] objectForKey:@"station_code"] , stationCode );
                    if ([[[dict objectAtIndex:xx] objectForKey:@"station_code"] isEqualToString:stationCode]) {
                        float point_x = [[[dict objectAtIndex:xx] objectForKey:@"x"] floatValue];
                        float point_y = [[[dict objectAtIndex:xx] objectForKey:@"y"] floatValue];
                        
                        [UIView animateWithDuration:0.5 animations:^{
                            _scroll_view.contentOffset = CGPointMake(point_x-180, point_y-250);
//                            [_scroll_view sizeToFit];
                        }];
                        
                        img_user_location.center = CGPointMake(point_x, point_y);

                        CGAffineTransform t = CGAffineTransformMakeScale(0.01, 0.01);
                        
                        CGPoint center = CGPointMake(point_x, point_y);
                        

                            
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:1.2];
                            [UIView setAnimationRepeatCount:10];
                            img_user_location.transform = CGAffineTransformMakeScale(1, 1);
                            img_user_location.transform = t;
                            img_user_location.hidden = NO;
                            [self.isGPSpoint setCenter:center];
                            [UIView commitAnimations];
                        
                            
//                        [UIImageView animateWithDuration:0.8
//                                                   delay:0
//                                                 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat
//                                                animations:(void (^)(void)) ^{
//                                                    img_user_location.transform = CGAffineTransformMakeScale(1, 1);
//                                                  img_user_location.transform = t;
//                                                  img_user_location.hidden = NO;
//                                                    
////                                                    [UIView setAnimationRepeatCount:10];
//                                              }
//                                              completion:^(BOOL finished){
////                                                  img_user_location.transform = CGAffineTransformMakeScale(1, 1);
////                                                  img_user_location.transform = t;
////                                                  img_user_location.hidden = NO;
//                                                  [UIView setAnimationRepeatCount:10];
//
//                                              }];
//                        [self.isGPSpoint setCenter:center];
                    }
                }
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
        //[self showStationOptions:station_options popSchedule:popSchedule];
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

-(void)doSelectStationWithLineIndex:(int)lineIndex stationIndex:(int)stationIndex popSchedule:(BOOL)popSchedule
{


    DEBUGMSG(@"Select line: %i station: %i station_code: %i", lineIndex, stationIndex, _station_code);
    
    if (!(lineIndex == _line_index && _station_index == stationIndex))
    {
        [self highlightStationWithLineIndex:lineIndex stationIndex:stationIndex];
        
    }
    
    if (popSchedule)
    {
//        [self showNextTrainWithLineIndex:lineIndex stationIndex:stationIndex];
    }
}




-(void)highlightStationWithLineIndex:(int)lineIndex stationIndex:(int)stationIndex
{
    [UIView beginAnimations:nil context:nil];
    
//    [self highlightStationNoAnimatedWithLineIndex:lineIndex stationIndex:stationIndex];
    
    [UIView commitAnimations];
}


-(IBAction)clickCloseButton:(id)sender
{
    [self clickStationWithStationCode:nil];
    
    
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

-(IBAction)clickStation_NOP:(id)sender
{
    [self clickStationWithStationCode:@"NOP"];
}


-(IBAction)clickStation_QUB:(id)sender
{
    [self clickStationWithStationCode:@"QUB"];
}

-(IBAction)clickStation_YAT:(id)sender
{
    [self clickStationWithStationCode:@"YAT"];
}

-(IBAction)clickStation_TLK:(id)sender
{
    [self clickStationWithStationCode:@"TIK"];
}

-(IBAction)clickStation_TKO:(id)sender
{
    [self clickStationWithStationCode:@"TKO"];
}

-(IBAction)clickStation_LHP:(id)sender
{
    [self clickStationWithStationCode:@"LHP"];
}

-(IBAction)clickStation_HAH:(id)sender
{
    [self clickStationWithStationCode:@"HAH"];
}

-(IBAction)clickStation_POA:(id)sender
{
    [self clickStationWithStationCode:@"POA"];
}


-(IBAction)clickOpenSystemMapButton:(UIButton*)button
{
    [self clickStationWithStationCode:@"OpenSystemMap"];
}


- (void)viewDidUnload {
    [btn_miniMap release];
    btn_miniMap = nil;
    [view_map release];
    view_map = nil;
    [img_user_location release];
    img_user_location = nil;
    [super viewDidUnload];
}

//#pragma mark -
//#pragma mark ASIHTTPRequestDelegate
//
//-(void) requestFinished:(ASIHTTPRequest *)request {
//    [request setResponseEncoding:NSUTF8StringEncoding];
//    NSString *responseString = [request responseString];
//    DEBUGMSG(@"response string: %@", responseString);
//    
//    DEBUGMSG(@"status code: %i", request.responseStatusCode);
//    
//    if (request.responseStatusCode == 200)
//    {
//        //        isNoInternet = NO;
//        
//        [self reloadData];
//        
//    }
//    else
//    {
//        [[CoreData sharedCoreData].mask hiddenMask];
//
//    }
//    
//    
//}
//
//-(void) requestFailed:(ASIHTTPRequest *)request {
//    
//    
//    
//}




@end
