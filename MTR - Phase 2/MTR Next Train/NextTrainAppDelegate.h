//
//  MTRAppDelegate.h
//  MTR
//
//  Created by Jeff Cheung on 11年10月25日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"
#import "ASIHTTPRequest.h"
#import "RootViewController.h"
#import "SelectStationViewController.h"
#import "SQLiteOperator.h"
#import "FavoriteViewController.h"
#import "MoreViewController.h"
#import "ContactUsViewController.h"
#import "SlideMenuViewController.h"
#import "BannerViewController.h"
#import "Reachability.h"
#import "CustomAlertView.h"
#import "CustomAlertViewDelegate.h"
#import "UpdateHandler.h"
#import "MapSearchViewController.h"
#import "CustomerActionSheetViewController.h"
#import "CustomerActionSheetDelegate.h"
#import "SystemMapViewController.h"
#import "RevealController.h"
#import "NextTrainViewController.h"

#define mtrPlistName @"mtrnexttrain"
#define mtrPlistExt @".plist"

#define noNeedUpdate @"0"
#define canUpdate @"1"
#define forceUpdate @"2"

@class BannerViewController;

@interface NextTrainAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, CustomAlertViewDelegate,UIActionSheetDelegate , CustomerActionSheetDelegate>{
    UIWindow *_window;
    UINavigationController *_navigation_controller;
    UIView *_tab_bar_bg_view;
    UIButton *_next_train_button, *_station_facilities_button, *_favorite_button, *_contact_us_button, *_more_button, *_routemap_button;
    
    NSMutableDictionary *_result_record;
    
    NSString *_app_need_update;
    
    NSDateFormatter *_date_formatter;
    BannerViewController *_banner_view_controller;
    
    UIView *_update_app_bg_view, *_update_app_pop_up_view;
    IBOutlet UILabel *_app_update_title_label;
    IBOutlet UILabel *_app_update_content_label;
    IBOutlet UIButton *_app_update_quit_app_button;
    IBOutlet UIButton *_cancel_button,*_english_button,*_chinese_button;
    
    //Alex
//    MapSearchViewController *mapSearchViewController;
    BOOL isShowingSystemMap;
    BOOL isShowingMapsSearch;

    BOOL isShowingInAppTutorialAll;

    BOOL _isInServiceNoticeSection;

    UpdateHandler *updateHandler;
    CustomAlertView* alert;

    CustomAlertView *alertInvalidURL;
    
    //language view
//    IBOutlet UIButton *_chinese_button;
//    IBOutlet UIButton *_english_button;
//    IBOutlet UIView *vw_backgroundMask;
    
    CustomerActionSheetViewController * customerActionSheet ;
    ASIHTTPRequest * map_request;
    CustomAlertView *customAlertView;


}
@property(nonatomic,retain) UIActionSheet *actionsheet;
@property(nonatomic,readonly) UIView *view;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigation_controller;
@property (nonatomic, retain) RevealController *revealController;
//@property (nonatomic, retain) UIView *_tab_bar_bg_view;

@property (nonatomic, retain) IBOutlet UIView *tab_bar_bg_view;
@property (nonatomic, retain) IBOutlet UIButton *next_train_button, *station_facilities_button, *favorite_button, *contact_us_button, *more_button, *cancel_button, *routemap_button;
@property (nonatomic, retain) IBOutlet UIView *update_app_bg_view, *update_app_pop_up_view;
@property (nonatomic, retain) IBOutlet UILabel *app_update_content_label;
@property (nonatomic, retain) IBOutlet UIButton *app_update_update_now_button;

//Alex
@property (retain, nonatomic) IBOutlet SlideMenuViewController *slideMenuView;
@property (nonatomic, assign) BOOL isShowingMapSearch;
@property (nonatomic, assign) BOOL isShowing;

- (IBAction)clickLanguageButton:(UIButton *)sender;
- (IBAction)clickUpdateButton:(UIButton *)sender;
- (IBAction)clickTermsButton:(UIButton *)sender;
- (IBAction)clickTutorialButton:(UIButton *)sender;
- (IBAction)clickCheckUpdateButton:(UIButton *)sender;

//-(void)englishButtonClicked;
//-(void)chinestButtonClicked;
//-(void)cancelButtonClicked;

-(void)handleLocalLanguageSetting;
-(void)handleGlobalLanguagSetting;
//-(void)openSystemMap;
//-(void)closeSystemMap;
-(void)setupLang;
-(void)handleTabBarLanguage;
-(IBAction)clickNextTrainButton:(UIButton*)button;
-(IBAction)clickStationFacilitiesButton:(UIButton*)button;
-(IBAction)clickFavoriteButton:(UIButton*)button;
-(IBAction)clickMapSearchButton:(UIButton*)button;
-(IBAction)clickContactUsButton:(UIButton*)button;

-(IBAction)clickUpdateNowButton:(UIButton*)button;
-(IBAction)clickQuitAppButton:(UIButton*)button;

//-(void)handleCommonOpenApp;
//-(BOOL)shouldLoadXMLBaseOn3amLogic;
//-(void)handleFirstTimeToOpenApp;

-(UpdateHandler*)getUpdateHandler;

//-(BOOL)handleAppUpdate:(NSString*)app_need_update;

//-(BOOL)parseAndHandleUpdateAPIForCommon:(ASIHTTPRequest*)request;

-(void)handleAppUpdatePopUpLanguage;
-(void)handleBannerLanguage;

//-(void)copyDBFilesToLibrary;
//-(void)saveAppVersion;
//-(NSString*)getDatabaseDestinationPathWithDBName:(NSString*)DBName DBExt:(NSString*)DBExt;

//-(void)setLatestCheckingDateAndSetAppUpdateToNoNeed;
//-(void)hasAnyUpdateForApp;

//-(void)promptAppUpdateAlert;
//-(BOOL)hasAppUpdate;
//-(BOOL)hasNetwork;

//-(NSDateComponents*)getFirstDateCompnentsWithYear:(int)year month:(int)month;
//-(NSDateComponents*)getLastDayDateComponents:(NSDateComponents*)currentDateComponents;
//-(NSRange)getRangeWithDateComponents:(NSDateComponents*)dateComponents;

-(void)launchNextTrainWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode;
-(void)sendPushNotificationTokenToServer;

-(void)makeTabBarDisappear;

@end
