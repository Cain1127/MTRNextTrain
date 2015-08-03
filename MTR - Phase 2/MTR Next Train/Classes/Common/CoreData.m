//
//  CoreData.m
//  PIPTrade
//
//  Created by MTel on 19/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CoreData.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CoreData
//@synthesize server_url = _server_url;
@synthesize udid = _udid;
@synthesize device = _device;
@synthesize os = _os;
@synthesize common_queue = _common_queue;
@synthesize graphic_queue = _graphic_queue;
@synthesize aes_key = _aes_key;
@synthesize lang = _lang;
@synthesize psuh_token = _psuh_token;
@synthesize app_version = _app_version;
//@synthesize connection_failed_view_controller = _connection_failed_view_controller;
@synthesize mtr_plist_path = _mtr_plist_path;
@synthesize banner_view_controller = _banner_view_controller;
@synthesize readNoticePlistPath = _readNoticePlistPath;
@synthesize mask = _mask;
@synthesize nextTrainUpdateFrequency = _nextTrainUpdateFrequency;
@synthesize isConnectionFailedCloseApp;
@synthesize btn_miniMap = _btn_miniMap;
@synthesize sv_system_map = _sv_system_map;


@synthesize x_callback_url_source = _x_callback_url_source, x_callback_url_source_name_en = _x_callback_url_source_name_en, x_callback_url_source_name_zh_HK = _x_callback_url_source_name_zh_HK, x_callback_url_success = _x_callback_url_success;

static CoreData *sharedCoreData = nil;



+(CoreData *)sharedCoreData {
	if (sharedCoreData==nil) {
		sharedCoreData = [[CoreData alloc] init];
        sharedCoreData.app_version = mtrAppVersion;
//		sharedCoreData.server_url = @"http://testsvr1.mtel.ws/"; //@"http://mtr.mtel.ws/";
		sharedCoreData.common_queue = [[NSOperationQueue alloc] init];
		[sharedCoreData.common_queue setMaxConcurrentOperationCount:2];
		sharedCoreData.graphic_queue = [[NSOperationQueue alloc] init];
		[sharedCoreData.graphic_queue setMaxConcurrentOperationCount:2];
		
		[sharedCoreData loadUDID];
		sharedCoreData.device = [[[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" touch" withString:@""] stringByReplacingOccurrencesOfString:@" Simulator" withString:@""];
		sharedCoreData.os = [[UIDevice currentDevice].systemVersion floatValue];
		sharedCoreData.aes_key = @"";
        sharedCoreData.mtr_plist_path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", mtrPlistName, mtrPlistExt]];
        sharedCoreData.readNoticePlistPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", readNoticePlistName, readNoticePlistExt]];
        
        [sharedCoreData loadNextTrainUpdateFrequency];
    }
	return sharedCoreData;
}

#pragma mark - Encryption

+(NSString *)md5:(NSString *)str {
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];	
}

+(NSString*) digest:(NSString*)input
{
    
    //NSData *data = [input dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSData *data = [input dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

+ (NSString*) stringWithUUID {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

#pragma mark - WebView

+(void)webViewRemoveBackground:(UIWebView*)webView
{
    if (webView)
    {
        webView.opaque = NO;
        webView.backgroundColor = [UIColor clearColor];
        
        id scrollview = [webView.subviews objectAtIndex:0];
        if ([scrollview isKindOfClass:[UIScrollView class]])
        {
            for (UIView *subview in [scrollview subviews])
            {
                if ([subview isKindOfClass:[UIImageView class]])
                    subview.hidden = YES;
            }
        }
    }
}


#pragma mark - user defaults
-(void)saveNextTrainUpdateFrequency:(int)newNextTrainUpdateFrequency
{
    NSString *key = @"nextTrainUpdateFrequency";
    NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
    [user_defaults setObject:[NSNumber numberWithInt:newNextTrainUpdateFrequency] forKey:key];
    [user_defaults synchronize];
    
    sharedCoreData.nextTrainUpdateFrequency = [[user_defaults objectForKey:key] intValue];
}

-(int)loadNextTrainUpdateFrequency
{
    NSString *key = @"nextTrainUpdateFrequency";
    NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
    
    if ([user_defaults objectForKey:key] == nil)
    {
        int defaultValue = 0;
        [user_defaults setObject:[NSNumber numberWithInt:defaultValue] forKey:key];
        [user_defaults synchronize];
    }
    
    sharedCoreData.nextTrainUpdateFrequency = [[user_defaults objectForKey:key] intValue];
    
    return sharedCoreData.nextTrainUpdateFrequency;
}

-(NSString*)loadUDID
{
    //sharedCoreData.udid = [UIDevice currentDevice].uniqueIdentifier;
    NSString *key = @"udid";
    NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
    
    if ([user_defaults objectForKey:key] == nil)
    {
        NSString *newUdid = [CoreData stringWithUUID];
        [user_defaults setObject:newUdid forKey:key];
        [user_defaults synchronize];
    }
    
    sharedCoreData.udid = [user_defaults objectForKey:key];
    
    return sharedCoreData.udid;
}

#pragma mark - misc utility
+(void)addPopUpAnimationToView:(UIView*)targetView delegate:(id)delegate
{    
    CAKeyframeAnimation *animation;
	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.duration = 0.3;
	animation.delegate = delegate;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
    
    NSArray *animationValues = [NSArray arrayWithObjects:
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                                nil];
	
	animation.values = animationValues;
	[targetView.layer addAnimation:animation forKey:nil];
}

+(void)addPopDownAnimationToView:(UIView*)targetView delegate:(id)delegate
{
    CAKeyframeAnimation *animation;
	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.duration = 0.5;
	animation.delegate = delegate;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	[animation setValue:@"hidden_connection_failed_bg_view" forKey:@"my_action"];
	
    NSArray *animationValues = [NSArray arrayWithObjects:
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)],
                                nil];
    
	animation.values = animationValues;
	[targetView.layer addAnimation:animation forKey:nil];
}


#pragma mark - x-callback functions

+(BOOL)shouldShowCallBackMotherButton
{
    if ([CoreData sharedCoreData].x_callback_url_source != nil &&
        [CoreData sharedCoreData].x_callback_url_source_name_en != nil &&
        [CoreData sharedCoreData].x_callback_url_source_name_zh_HK != nil &&
        [CoreData sharedCoreData].x_callback_url_success != nil)
    {
        return YES;
    }
    
    return NO;
}

+(void)callbackMother
{
    if ([CoreData sharedCoreData].x_callback_url_source != nil &&
        [CoreData sharedCoreData].x_callback_url_source_name_en != nil &&
        [CoreData sharedCoreData].x_callback_url_source_name_zh_HK != nil &&
        [CoreData sharedCoreData].x_callback_url_success != nil)
    {
        NSURL *url = [NSURL URLWithString:[CoreData sharedCoreData].x_callback_url_success];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
