//
//  CoreData.h
//  PIPTrade
//
//  Created by MTel on 19/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreLocation/CoreLocation.h>
//#import "ConnectionFailedViewController.h"
#import "BannerViewController.h"
#import "MaskViewController.h"
#import "Constants.h"

#define mtrPlistName @"mtrnexttrain"
#define mtrPlistExt @".plist"

#define readNoticePlistName @"readNotice"
#define readNoticePlistExt @".plist"

@class BannerViewController;
@class MaskViewController; 

@interface CoreData : NSObject {
//	NSString *_server_url;
	NSOperationQueue *_common_queue, *_graphic_queue;
	NSString *_udid, *_device;
	float _os;
	NSString *_aes_key;
	NSString *_lang;
    NSString *_psuh_token;
    NSString *_app_version;
    NSString *_mtr_plist_path;
    NSString *_readNoticePlistPath;

    NSString * btn_miniMap;
    NSString * sv_system_map;

    
//    ConnectionFailedViewController *_connection_failed_view_controller;
    BannerViewController *_banner_view_controller;    
	MaskViewController *_mask;
    
    int nextTrainUpdateFrequency;
    
    NSString *_x_callback_url_source;
    NSString *_x_callback_url_source_name_en;
    NSString *_x_callback_url_source_name_zh_HK;
    NSString *_x_callback_url_success; // callback URL
}

//@property (nonatomic, retain) NSString *server_url;
@property (nonatomic, retain) NSOperationQueue *common_queue, *graphic_queue;
@property (nonatomic, retain) NSString *udid, *device;
@property (nonatomic, assign) float os;
@property (nonatomic, retain) NSString *aes_key;
@property (nonatomic, retain) NSString *lang;
@property (nonatomic, retain) NSString *psuh_token;
@property (nonatomic, retain) NSString *app_version;
//@property (nonatomic, retain) ConnectionFailedViewController *connection_failed_view_controller;
@property (nonatomic, retain) NSString *mtr_plist_path;
@property (nonatomic, retain) BannerViewController *banner_view_controller;
@property (nonatomic, retain) NSString *readNoticePlistPath;
@property (nonatomic, retain) MaskViewController *mask;
@property (nonatomic, assign) int nextTrainUpdateFrequency;
@property (nonatomic, assign) BOOL isConnectionFailedCloseApp;
@property (nonatomic, retain) NSString *x_callback_url_source, *x_callback_url_source_name_en, *x_callback_url_source_name_zh_HK, *x_callback_url_success;
@property (nonatomic, retain) NSString * btn_miniMap;
@property (nonatomic, retain) NSString * sv_system_map;

+(CoreData *)sharedCoreData;

#pragma mark - Encryption
+(NSString *)md5:(NSString *)str;
+(NSString*)digest:(NSString*)input;
+(NSString*)stringWithUUID;

#pragma mark - WebView
+(void)webViewRemoveBackground:(UIWebView*)webView;

#pragma mark - user defaults
-(void)saveNextTrainUpdateFrequency:(int)newNextTrainUpdateFrequency;
-(int)loadNextTrainUpdateFrequency;
-(NSString*)loadUDID;

#pragma mark - misc utility
+(void)addPopUpAnimationToView:(UIView*)targetView delegate:(id)delegate;
+(void)addPopDownAnimationToView:(UIView*)targetView delegate:(id)delegate;

#pragma mark - x-callback functions
+(BOOL)shouldShowCallBackMotherButton;
+(void)callbackMother;

@end
