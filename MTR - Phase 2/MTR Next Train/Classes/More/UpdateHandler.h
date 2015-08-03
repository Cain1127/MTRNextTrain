//
//  UpdateHandler.h
//  MTR
//
//  Created by Jeff Cheung on 11年11月28日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData.h"
#import "ASIHTTPRequest.h"
#import "XPathQuery.h"
#import "NextTrainAppDelegate.h"
#import "UpdateHandlerDelegate.h"

#define noNeedUpdate @"0"
#define canUpdate @"1"
#define forceUpdate @"2"

@interface UpdateHandler : NSObject <ASIHTTPRequestDelegate>{

    ASIHTTPRequest *_request;
}

@property (nonatomic, assign) id <UpdateHandlerDelegate> delegate;


#pragma mark - Core
-(BOOL)hasNetwork;
-(NSMutableDictionary*)initMtrPlist;
-(void)updateNow;

#pragma mark - Check Update
-(void)checkUpdate;
-(void)checkUpdateSynchronously;

-(void)handleFirstTimeToOpenApp;
-(void)handleCommonOpenApp;

#pragma mark - Check Update ASIHTTPRequestDelegate
-(void)parseAndHandleUpdateAPIForCheckingFinished:(ASIHTTPRequest*)request;
-(void)parseAndHandleUpdateAPIForCheckingFailed:(ASIHTTPRequest*)request;
-(BOOL)parseAndHandleUpdateAPI:(ASIHTTPRequest*)request;

#pragma mark - Check Update Core
-(BOOL)hasAppUpdate;
//-(void)setAppNeedUpdate:(NSString*)app_need_update;
-(NSString*)appUpdateLink;
-(void)setAppUpdateLink:(NSString*)link;
//-(void)hasAnyUpdateForApp;
-(BOOL)shouldLoadXMLBaseOn3amLogic;
-(void)saveAppVersion;
-(void)setLatestCheckingDateAndSetAppUpdateToNoNeed;
-(void)setLatestCheckingDate;

#pragma mark - UI
-(void)promptAppUpdateAlert:(int)param;
-(void)promptNoConnectionAlert;

#pragma mark - date functions
-(NSDateComponents*)getFirstDateCompnentsWithYear:(int)year month:(int)month;
-(NSDateComponents*)getLastDayDateComponents:(NSDateComponents*)currentDateComponents;
-(NSRange)getRangeWithDateComponents:(NSDateComponents*)dateComponents;

#pragma mark - DB
-(void)copyDBFilesToLibrary;
-(NSString*)getDatabaseDestinationPathWithDBName:(NSString*)DBName DBExt:(NSString*)DBExt;

#pragma mark - Trigger Delegate Functions
-(void)callDelegateBeginCheckUpdate;
-(void)callDelegateFinishCheckUpdate;

@end
