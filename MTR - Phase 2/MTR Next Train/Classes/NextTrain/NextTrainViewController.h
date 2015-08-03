//
//  NextTrainViewController.h
//  MTR Next Train
//
//  Created by  on 12年2月9日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CoreData.h"
#import "JSON.h"
#import "NextTrainScheduleCell.h"
#import "SelectStationViewController.h"
#import "SystemMapViewController.h"
#import "TutorialHandler.h"
#import "TutorialViewController.h"
#import "InAppBrowserViewController.h"
#import "CustomerActionSheetViewController.h"
#import "CustomerActionSheetDelegate.h"
#import "CustomAlertViewDelegate.h"


@class SelectStationViewController;
@class TutorialViewController;

//#define getScheduleAPI @"MtrNextTrian/getSchedule.php?"
#define CancelBookMark 20
#define BookMark 10

@interface NextTrainViewController : UIViewController <ASIHTTPRequestDelegate, UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,CustomAlertViewDelegate>
{
    NSMutableDictionary *_station_record;
    NSMutableDictionary *_station_records;
    NSMutableDictionary *_station_records_with_station_as_key;
    NSMutableDictionary *_line_records_with_line_as_key;
    NSMutableArray *wrlStations;

    IBOutlet UILabel *_title_label;
    IBOutlet UIScrollView *_scView;
    
    ASIHTTPRequest *_request;
    
    BOOL _isShowing;
    
    IBOutlet UITableView *tbl_schedule_up;
    IBOutlet UITableView *tbl_schedule_down;
    
    NSMutableArray *ary_schedule_up;
    NSMutableArray *ary_schedule_down;
    
    IBOutlet UIButton *btn_schedule, *btn_route_map;
    IBOutlet UIView *vw_schedule, *vw_route_map, *vw_schedule_red_alert, *vw_schedule_schedule;
    IBOutlet UIView *vw_schedule_schedule_up, *vw_schedule_schedule_down;
    IBOutlet UILabel *lbl_line_name, *lbl_line_name_for_test, *lbl_station_name, *lbl_up_terminal, *lbl_down_terminal, *lbl_red_alert_message;
    IBOutlet UIView *img_up_terminal, *img_down_terminal;
    IBOutlet UILabel *lbl_up_destination, *lbl_up_platform, *lbl_up_time;
    IBOutlet UILabel *lbl_down_destination, *lbl_down_platform, *lbl_down_time;
    IBOutlet UIButton *btn_view_system_map;
    
    IBOutlet UILabel *lbl_last_update_time;
    IBOutlet UIButton *btn_favorite_station;
    IBOutlet UIView *vw_no_train_schedule_up, *vw_no_train_schedule_down;
    IBOutlet UILabel *lbl_no_train_schedule_up, *lbl_no_train_schedule_down;
    IBOutlet UIButton *btn_close_system_map;
    IBOutlet UIView *vw_loading_up, *vw_loading_down;
    IBOutlet UIView *vw_terminal_background;
    IBOutlet UIImageView *img_subtitle_bar_up, *img_subtitle_bar_down;
    
    NSTimer *timerUpdateNextTrain;
        
    BOOL isRedAlert;
    BOOL isTerminalUp, isTerminalDown;
    BOOL isNoInternet;
    BOOL isNoValidScheduleUp, isNoValidScheduleDown;
    BOOL isNoValidAELDown;
    BOOL isTrainEndedUp, isTrainEndedDown;
        
    NSDate *lastUpdateTime;
    
    BOOL isReloading, isShowingSystemMap;
    BOOL isObjectReleased;
    
    NSString *redAlertURL;
    
    //Alex
    IBOutlet UIButton *btn_left, *btn_right;
    NextTrainViewController *nextTrainViewController;
    UISwipeGestureRecognizer *swipeGestureRecognizerLeft;
    UISwipeGestureRecognizer *swipeGestureRecognizerRight;
    NSString *_lang;
    CustomAlertView * alert_view;

}

//@property (nonatomic, retain)    UISwipeGestureRecognizer *swipeGestureRecognizerLeft;
//@property (nonatomic, retain)    UISwipeGestureRecognizer *swipeGestureRecognizerRight;

@property (nonatomic,assign)  BOOL isBookmark;
@property (nonatomic, retain) NSMutableArray *favorite_station_array;
@property (nonatomic, retain) IBOutlet UIButton *btn_left, *btn_right;

@property (nonatomic, retain) NSMutableDictionary *station_record;
@property (nonatomic, retain) NSMutableDictionary *station_records;
@property (nonatomic, retain) NSMutableDictionary *station_records_with_station_as_key;
@property (nonatomic, retain) NSMutableDictionary *line_records_with_line_as_key;
@property (nonatomic,retain)NSMutableArray *wrlStations;

@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) int index;

@property (nonatomic, assign) UIViewController* parentViewController;
@property (nonatomic, assign) BOOL isReloading;



-(void)releaseObjects;

#pragma mark - main functions
-(void)reloadGetSchedule;
-(void)clearSchedule;
-(void)processScheduleFromResponseString:(NSString*)responseString;
-(void)didReloadGetSchedule;

#pragma mark - Control functions
-(void)show;
-(void)didShow;
-(void)hide;
-(void)didHidden;

-(void)showSchedule;
-(void)showRouteMap;

-(void)refreshScheduleView;
-(void)arrangeScheduleViewForTerminal;

-(void)handleFavoriteStation;
-(void)toggleFavoriteStation;

-(void)displayLastUpdateTime;

-(void)openSystemMap;
-(void)closeSystemMap;

-(void)showInAppTutorial;

-(void)showRedAlertURLInBrowser;

-(void)reloadData;


-(void)startFlashingbutton:(UIView *)btn;
#pragma mark - button functions
-(IBAction)clickBackButton:(UIButton*)button;
-(IBAction)clickHideButton:(UIButton*)button;
-(IBAction)clickRefreshButton:(UIButton*)button;
-(IBAction)clickScheduleButton:(UIButton*)button;
-(IBAction)clickRouteMapButton:(UIButton*)button;
-(IBAction)clickFavoriteButton:(UIButton*)button;
-(IBAction)clickOpenSystemMapButton:(UIButton*)button;
-(IBAction)clickCloseSystemMapButton:(UIButton*)button;
//- (IBAction)clickBackButton:(UIButton *)sender;


#pragma mark - Misc functions
-(NSString*)shortTimeFromSystemDate:(NSString*)systemDate;
-(NSString*)stationNameWithLine:(NSString*)line station:(NSString*)station;
-(NSString*)lineNameWithLine:(NSString*)line;
-(BOOL)isTerminalUpForLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode;
-(BOOL)isTerminalDownForLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode;
-(BOOL)isNoValidAELDownForLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode;

#pragma mark - Route Map Functions
-(void)clickStationWithStationCode:(NSString*)stationCode;
-(IBAction)clickStation_TUC:(id)sender;
-(IBAction)clickStation_SUN:(id)sender;
-(IBAction)clickStation_TSY:(id)sender;
-(IBAction)clickStation_LAK:(id)sender;
-(IBAction)clickStation_NAC:(id)sender;
-(IBAction)clickStation_OLY:(id)sender;
-(IBAction)clickStation_KOW:(id)sender;
-(IBAction)clickStation_HOK:(id)sender;
-(IBAction)clickStation_AWE:(id)sender;
-(IBAction)clickStation_AIR:(id)sender;

//Alex
- (IBAction)clickPreviousBookmarkButton:(UIButton *)sender;





#pragma mark - Timer Functions
-(void)startTimerForUpdateNextTrain;
-(void)stopTimerForUpdateNextTrain;
-(void)doUpdateNextTrain;

@end
