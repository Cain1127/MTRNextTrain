 //
//  UpdateHandler.m
//  MTR
//
//  Created by Jeff Cheung on 11年11月28日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UpdateHandler.h"

@implementation UpdateHandler

@synthesize delegate = _delegate;

-(void)dealloc{
    if(_request != nil){
        [_request clearDelegatesAndCancel];
        [_request release];
        _request = nil;
    }
    [super dealloc];
}

#pragma mark - Core

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

-(NSMutableDictionary*)initMtrPlist
{
    DEBUGLog
    
    NSMutableDictionary *plist_record = [NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path];
    if(plist_record == nil){
        [plist_record release];
        plist_record = [[NSMutableDictionary new] autorelease];
    }
    
//    else{
//        [[plist_record retain] autorelease];
//    }
    
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
    DEBUGMSG(@"retain 1 %d", [plist_record retainCount]);
    if([plist_record objectForKey:@"first_time"] == nil || [[plist_record objectForKey:@"first_time"] isEqualToString:@"YES"]){
        NSMutableDictionary *record = [NSMutableDictionary new];
        [record setObject:@"YES" forKey:@"all"];
        [record setObject:@"YES" forKey:@"info"];
        [plist_record setObject:record forKey:@"push"];
        [plist_record writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
        [record release];
    }
    
    return plist_record;
}

-(void)updateNow
{
    NSString *appUpdateLink = [self appUpdateLink];
    
    if (appUpdateLink != nil)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUpdateLink]];
    }
}

#pragma mark - Check Update

-(void)checkUpdate{
    DEBUGLog
    if(![self hasNetwork]){
//        [[CoreData sharedCoreData].connection_failed_view_controller showView];
     
        [self promptNoConnectionAlert];
        return;
    }
    
    if(_request == nil)
    {
        _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:updateAPI]];
        NSLog(@"%@", _request.url);
        _request.delegate = self;
        [_request setDidFinishSelector:@selector(parseAndHandleUpdateAPIForCheckingFinished:)];
        [_request setDidFailSelector:@selector(parseAndHandleUpdateAPIForCheckingFailed:)];
        [[CoreData sharedCoreData].common_queue addOperation:_request];
        
        [self callDelegateBeginCheckUpdate];
    }
}

-(void)checkUpdateSynchronously
{
    DEBUGLog
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:updateAPI]] autorelease];
    NSLog(@"%@", request.url);
    [request startSynchronous];
    NSError *error = [request error];
    if(!error){
        //[self parseAndHandleUpdateAPIForCommon:request];
        [self parseAndHandleUpdateAPI:request];
        int hasAppUpdate = [self hasAppUpdate];
        if(hasAppUpdate>0){
            [self promptAppUpdateAlert:hasAppUpdate];
            return;
        }
    }
    else{
        NSLog(@"error : %@", [error description]);
        //[[CoreData sharedCoreData].connection_failed_view_controller showView];
        [self promptNoConnectionAlert];
    }
}


-(void)handleFirstTimeToOpenApp{
    DEBUGLog
    [self copyDBFilesToLibrary];
    [self saveAppVersion];
    //[self setLatestCheckingDateAndSetAppUpdateToNoNeed];
    
    //[self hasAnyUpdateForApp];
    
    BOOL hasNetwork = [self hasNetwork];
    if(!hasNetwork){
        //        [[CoreData sharedCoreData].connection_failed_view_controller showView];
        [self promptNoConnectionAlert];
    }
    else{
        [self checkUpdateSynchronously];
    }
}

-(void)handleCommonOpenApp{
    DEBUGLog
    
    /*
    BOOL hasAppUpdate = [self hasAppUpdate];
    if(hasAppUpdate){
        [self promptAppUpdateAlert];
        return;
    }
     */
    
    BOOL hasNetwork = [self hasNetwork];
    if(!hasNetwork){
        //        [[CoreData sharedCoreData].connection_failed_view_controller showView];
        [self promptNoConnectionAlert];
    }
    else{
        BOOL loadXML = [self shouldLoadXMLBaseOn3amLogic];
        if(loadXML){
            
            [self checkUpdateSynchronously];
        }
        else{
            NSLog(@"!loadXML");
        }
    }
}


#pragma mark - Check Update ASIHTTPRequestDelegate

-(void)parseAndHandleUpdateAPIForCheckingFinished:(ASIHTTPRequest*)request
{    
    [self parseAndHandleUpdateAPI:request];
    
    if(_request != nil){
        [_request release];
        _request = nil;
    }
    
    [self callDelegateFinishCheckUpdate];
}

-(void)parseAndHandleUpdateAPIForCheckingFailed:(ASIHTTPRequest*)request{
    //[[CoreData sharedCoreData].connection_failed_view_controller showView];
    
    if(_request != nil){
        [_request release];
        _request = nil;
    }
    
    [self promptNoConnectionAlert];
    
    [self callDelegateFinishCheckUpdate];
    
    //[_delegate hiddenDownloadingBgView];
}

-(BOOL)parseAndHandleUpdateAPI:(ASIHTTPRequest*)request
{
    if([request responseStatusCode] != 200)
    {        
        [self promptNoConnectionAlert];
        return NO; //YES;
    }
    
    NSMutableDictionary *result_record = [[NSMutableDictionary new] autorelease];
    
    NSArray *item_array = PerformXMLXPathQuery([request responseData], [NSString stringWithFormat:@"//versions/iphone/version[num='%@']", [CoreData sharedCoreData].app_version]);
    
    NSString *app_need_update = nil;
    NSString *app_soft_update = nil;
    NSString *app_update_link;
    
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
              if([[result_array objectAtIndex:y] objectForKey:@"nodeName"] != nil && [[[result_array objectAtIndex:y] objectForKey:@"nodeName"] isEqualToString:@"soft_upgrade"])
                {
                    if([[[result_array objectAtIndex:y] objectForKey:@"nodeChildArray"] count] == 1){
                        if([[[[result_array objectAtIndex:y] objectForKey:@"nodeChildArray"] objectAtIndex:0] objectForKey:@"nodeContent"] != nil)
                            app_soft_update = [[[[[[result_array objectAtIndex:y] objectForKey:@"nodeChildArray"] objectAtIndex:0] objectForKey:@"nodeContent"] retain] autorelease];
                    }else {
                        if([[result_array objectAtIndex:y] objectForKey:@"nodeContent"] != nil)
                            app_soft_update = [[[[result_array objectAtIndex:y] objectForKey:@"nodeContent"] retain] autorelease];
                    }

                
            
            }
            if([[result_array objectAtIndex:y] objectForKey:@"nodeName"] != nil && [[[result_array objectAtIndex:y] objectForKey:@"nodeName"] isEqualToString:@"resources"]){
                NSArray *resources_array = [[result_array objectAtIndex:y] objectForKey:@"nodeChildArray"];
                for(int z = 0; resources_array != nil && z < [resources_array count]; z++){
                    NSArray *attribute_array = [[resources_array objectAtIndex:z] objectForKey:@"nodeAttributeArray"];
                    if(attribute_array != nil){
                        [result_record setObject:attribute_array forKey:[[resources_array objectAtIndex:z] objectForKey:@"nodeName"]];
                    }
                }
            }
        }
    }
    
    NSArray *linkArray = PerformXMLXPathQuery([request responseData], @"//versions/link");
    {
        NSDictionary *linkDict = [linkArray objectAtIndex:0];
        if ([linkDict objectForKey:@"nodeContent"] != nil)
        {
            app_update_link = [linkDict objectForKey:@"nodeContent"];
        }else{
            return YES;
        }
    }
    
    [self setAppNeedUpdate:app_need_update soft:app_soft_update];
    [self setAppUpdateLink:app_update_link];
    [self setLatestCheckingDate];
    
    BOOL is_need_update = [self hasAppUpdate];
    return is_need_update;
}

#pragma mark - Check Update Core

-(BOOL)hasAppUpdate{
    NSMutableDictionary *plistRecord = [NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path];
    if(!plistRecord){
        return 0;
    }
    
//    [plistRecord retain];
    
    NSString *appUpdate = [[plistRecord objectForKey:@"update_info"] objectForKey:@"app_update"];
    if([appUpdate isEqualToString:forceUpdate]){
        return 2;
    }
    
    if([appUpdate isEqualToString:canUpdate])
        return 1;
    
    return 0;
}

-(void)setAppNeedUpdate:(NSString*)app_need_update soft:(NSString*)soft_update{
    
    DEBUGMSG(@"%@ ,%@", app_need_update,soft_update);
    
    if(app_need_update != nil)
        [[app_need_update retain] autorelease];
    
    NSMutableDictionary *plist_record = [[[NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path] retain] autorelease];
    
    //app don't need to update
    if(app_need_update == nil ||
       (app_need_update != nil && [app_need_update isEqualToString:@"0"])){
        [[plist_record objectForKey:@"update_info"] setObject:noNeedUpdate forKey:@"app_update"];
        [plist_record writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
        
        if(soft_update !=nil && [soft_update isEqualToString:@"1"]){
            [[plist_record objectForKey:@"update_info"]setObject:canUpdate forKey:@"app_update"];
            [plist_record writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
            [self promptAppUpdateAlert:1];
        }
    }
    //app need to update
    else{
        [self promptAppUpdateAlert:2];
        
        [[plist_record objectForKey:@"update_info"] setObject:forceUpdate forKey:@"app_update"];
        [plist_record writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
    }
}

-(NSString*)appUpdateLink {
    
    NSMutableDictionary *plistRecord = [[NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path]autorelease];
    
    if(!plistRecord){
        return nil;
    }
    
    [plistRecord retain];
    
    NSString *appUpdateLink = [[plistRecord objectForKey:@"update_info"] objectForKey:@"app_update_link"];
    if(appUpdateLink != nil){
        return appUpdateLink;
    }
    
    return nil;
}


-(void)setAppUpdateLink:(NSString*)link
{
    if(link != nil)
        [[link retain] autorelease];
    
    NSMutableDictionary *plist_record = [[[NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path] retain] autorelease];
    
    //app don't need to update
    if(link != nil)
    {
        [[plist_record objectForKey:@"update_info"] setObject:link forKey:@"app_update_link"];
        [plist_record writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
    }
}

/*
-(void)hasAnyUpdateForApp{
    BOOL hasNetwork = [self hasNetwork];
    if(!hasNetwork){
        //        [[CoreData sharedCoreData].connection_failed_view_controller showView];
        [self promptNoConnectionAlert];
        return;
    }
    BOOL is_need_update = YES;
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:updateAPI]] autorelease];
    NSLog(@"%@", request.url);
    [request startSynchronous];
    NSError *error = [request error];
    if(!error){
        //go_to_check_has_available_update_found_today = [self parseAndHandleUpdateAPIForCommon:request];
        is_need_update = [self parseAndHandleUpdateAPI:request];
    }
    else{
        NSLog(@"error : %@", [error description]);
        //[[CoreData sharedCoreData].connection_failed_view_controller showView];
        [self promptNoConnectionAlert];
        return;
    }
    
    
    if(is_need_update){
        
        
//        NSMutableDictionary *plist_record = [[[NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path] retain] autorelease];
//        
//        NSString *app_update = [[plist_record objectForKey:@"update_info"] objectForKey:@"app_update"];
//        if([app_update isEqualToString:forceUpdate])
//        {
//            [self promptAppUpdateAlert];
//        }
         
        if ([self hasAppUpdate])
        {
            [self promptAppUpdateAlert];
        }
        
    }
}
*/

-(BOOL)shouldLoadXMLBaseOn3amLogic{    
    NSMutableDictionary *plistRecord = [[[NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path] retain] autorelease];
    if(!plistRecord)
        return YES;
    [[plistRecord retain] autorelease];
    
    NSMutableDictionary *updateInfoRecord = [plistRecord objectForKey:@"update_info"];
    if(!updateInfoRecord)
        return YES;
    [[updateInfoRecord retain] autorelease];
    
    NSString *latestCheckingDateStr = [updateInfoRecord objectForKey:@"latest_checking_date"];
    if(!latestCheckingDateStr)
        return YES;
    [[latestCheckingDateStr retain] autorelease];
    
    NSDate *currentDate = [[[NSDate date] retain] autorelease];
    
    NSDateFormatter *_date_formatter = [[NSDateFormatter alloc] init];
    [_date_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayAt3amStr = [NSString stringWithFormat:@"%@ 03:00:00", [_date_formatter stringFromDate:currentDate]];
    [_date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timeIntervalForBefore3am = [currentDate timeIntervalSinceDate:[_date_formatter dateFromString:todayAt3amStr]];
    
    [_date_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayAt0amStr = [NSString stringWithFormat:@"%@ 00:00:00", [_date_formatter stringFromDate:currentDate]];
    [_date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timeIntervalForAfterOrEqualTo0am = [currentDate timeIntervalSinceDate:[_date_formatter dateFromString:todayAt0amStr]];
    
    BOOL isBefore3am = NO;
    BOOL isAfterOrEqualTo0am = NO;
    if(timeIntervalForBefore3am < 0){
        isBefore3am = YES;
    }
    if(timeIntervalForAfterOrEqualTo0am >= 0){
        isAfterOrEqualTo0am = YES;
    }
    
    NSDate *beComparedDate = nil;
    
    if(isAfterOrEqualTo0am && isBefore3am){
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit | NSWeekCalendarUnit fromDate:currentDate];
        NSDateComponents *lastDayDateComponents = [self getLastDayDateComponents:dateComponents];
        [_date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        beComparedDate = [_date_formatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 03:00:00", [lastDayDateComponents year], [lastDayDateComponents month], [lastDayDateComponents day]]];
#ifdef DEBUG
        NSLog(@"%@", [_date_formatter stringFromDate:beComparedDate]);
#endif
    }
    else{
        [_date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        beComparedDate = [_date_formatter dateFromString:todayAt3amStr];
    }
    
    NSTimeInterval timeDifference = [[_date_formatter dateFromString:latestCheckingDateStr] timeIntervalSinceDate:beComparedDate];
    NSLog(@"%lf", timeDifference);
    [_date_formatter release];
    if(timeDifference < 0)
        return YES;
    return NO;
}

-(void)saveAppVersion{
    NSMutableDictionary *plistRecord = [[[NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path] retain] autorelease];
    NSMutableDictionary *app_info_record = [[NSMutableDictionary new] autorelease];
    [app_info_record setObject:[CoreData sharedCoreData].app_version forKey:@"app_version"];
    [plistRecord setObject:app_info_record forKey:@"app_info"];
    [plistRecord writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
}

-(void)setLatestCheckingDateAndSetAppUpdateToNoNeed{
    NSMutableDictionary *plistRecord = [[[NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path] retain] autorelease];
    NSMutableDictionary *updateInfoRecord = [[NSMutableDictionary new] autorelease];
    NSDateFormatter *_date_formatter = [[NSDateFormatter alloc] init];
    [_date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [updateInfoRecord setObject:[_date_formatter stringFromDate:[NSDate date]] forKey:@"latest_checking_date"];
    [_date_formatter release];
    [updateInfoRecord setObject:noNeedUpdate forKey:@"app_update"];
    [plistRecord setObject:updateInfoRecord forKey:@"update_info"];
    [plistRecord writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
}



-(void)setLatestCheckingDate{
    NSMutableDictionary *plistRecord = [[[NSMutableDictionary dictionaryWithContentsOfFile:[CoreData sharedCoreData].mtr_plist_path] retain] autorelease];
    NSMutableDictionary *updateInfoRecord = nil;
    if([plistRecord objectForKey:@"update_info"] == nil)
        updateInfoRecord = [[NSMutableDictionary new] autorelease];
    else
        updateInfoRecord = [[[plistRecord objectForKey:@"update_info"] retain] autorelease];
    NSDateFormatter *date_formatter = [[[NSDateFormatter alloc] init] autorelease];
    [date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [updateInfoRecord setObject:[date_formatter stringFromDate:[NSDate date]] forKey:@"latest_checking_date"];
    [plistRecord setObject:updateInfoRecord forKey:@"update_info"];
    [plistRecord writeToFile:[CoreData sharedCoreData].mtr_plist_path atomically:YES];
}


#pragma mark - UI
-(void)promptAppUpdateAlert:(int)updateparam
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    ((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate).update_app_bg_view.alpha = 1;
    if(updateparam == 1){
        ((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate).app_update_content_label.text = NSLocalizedString(([NSString stringWithFormat:@"app_can_update_content_%@", [CoreData sharedCoreData].lang]), nil);
        [((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate).cancel_button setHidden:NO];
        //jeff
        UIButton *app_update_update_now_button = ((NextTrainAppDelegate*)[UIApplication sharedApplication].delegate).app_update_update_now_button;
        app_update_update_now_button.frame = CGRectMake(app_update_update_now_button.frame.origin.x, 115.0, app_update_update_now_button.frame.size.width, app_update_update_now_button.frame.size.height);
    }

    [UIView commitAnimations];
}

-(void)promptNoConnectionAlert
{
    CustomAlertView *alert = [[CustomAlertView alloc] initWithMessage:NSLocalizedString(([NSString stringWithFormat:@"no_connection_content_%@", [CoreData sharedCoreData].lang]), nil)];
    [alert show];
    [alert release];
}



#pragma mark - date functions

-(NSDateComponents*)getFirstDateCompnentsWithYear:(int)year month:(int)month{
    NSDateFormatter *_date_formatter = [[NSDateFormatter alloc] init];
    [_date_formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *firstDate = [_date_formatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", year, month, 1]];
    [_date_formatter release];
    NSDateComponents *firstDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit | NSWeekCalendarUnit fromDate:firstDate];
    return firstDateComponents;
}

-(NSDateComponents*)getLastDayDateComponents:(NSDateComponents*)dateComponents{
    int day = [dateComponents day];
    int month = [dateComponents month];
    int year = [dateComponents year];
    
    day--;
    if(day < 1){
        month--;
        if(month < 1){
            month = 12;
            year--;
            if(year < 0){
                NSLog(@"Assume the app is not credy by year 0");
            }
        }
        
        NSRange range = [self getRangeWithDateComponents:[self getFirstDateCompnentsWithYear:year month:month]];
        [dateComponents setDay:range.length];
        [dateComponents setMonth:month];
        [dateComponents setYear:year];
        return dateComponents;
        
    }
    
    [dateComponents setDay:day];
    return dateComponents;
}

-(NSRange)getRangeWithDateComponents:(NSDateComponents*)dateComponents{
    return ([[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                               inUnit:NSMonthCalendarUnit
                                              forDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]]);
}


#pragma mark - DB
-(void)copyDBFilesToLibrary{
    NSLog(@"copyDBFilesToLibrary");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success;
    
    success = [fileManager removeItemAtPath:[self getDatabaseDestinationPathWithDBName:@"contact" DBExt:@".sqlite"] error:&error];
    if(!success){
        NSLog(@"remove contact error: %@", [error localizedDescription]);
    }
    success = [fileManager removeItemAtPath:[self getDatabaseDestinationPathWithDBName:@"stationinfo" DBExt:@".sqlite"] error:&error];
    if(!success){
        NSLog(@"remove facility error: %@", [error localizedDescription]);
    }
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", @"contact", @".sqlite"]];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:[self getDatabaseDestinationPathWithDBName:@"contact" DBExt:@".sqlite"] error:&error];    
    if(!success){
        NSLog(@"copy contact error: %@", [error localizedDescription]);
    }
    
    defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", @"stationinfo", @".sqlite"]];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:[self getDatabaseDestinationPathWithDBName:@"stationinfo" DBExt:@".sqlite"] error:&error];
    if(!success){
        NSLog(@"copy facility error: %@", [error localizedDescription]);
    }
}

-(NSString*)getDatabaseDestinationPathWithDBName:(NSString*)DBName DBExt:(NSString*)DBExt{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", DBName, DBExt]];
	return path;
}

#pragma mark - Trigger Delegate Functions

-(void)callDelegateBeginCheckUpdate
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(updateHandlerBeginCheckUpdate)])
    {
        [_delegate updateHandlerBeginCheckUpdate];
    }
}

-(void)callDelegateFinishCheckUpdate
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(updateHandlerFinishCheckUpdate)])
    {
        [_delegate updateHandlerFinishCheckUpdate];
    }
}



@end
