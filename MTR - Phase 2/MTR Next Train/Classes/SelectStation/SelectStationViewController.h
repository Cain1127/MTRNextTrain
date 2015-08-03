//
//  StationFacilitiesViewController.h
//  MTR
//
//  Created by Jeff Cheung on 11年11月8日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"
#import "FacilitySQLOperator.h"
#import "SelectStationLineCell.h"
#import "SelectStationStationCell.h"
#import "SelectStationStationLHPCell.h"
#import "NextTrainViewController.h"
#import "LocationOperator.h"
#import "StationOption.h"
#import "SelectLineViewDelegate.h"
#import "SelectLineView.h"
#import "CustomAlertView.h"
#import "TutorialHandler.h"
#import "TutorialViewController.h"
#import "MapSearchViewController.h"
#import "RevealController.h"
#import "ASIHTTPRequest.h"

//@class Facility3DView;

@class NextTrainViewController;
@class SelectLineViewController;
@class RevealController;


@interface SelectStationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,  UIAlertViewDelegate, SelectLineViewDelegate, MapSearchViewControllerDelegate,UINavigationControllerDelegate> {
    
    UINavigationController *_navigation_controller;
    
    IBOutlet UIButton *_view_by_stations_button;
    IBOutlet UIButton *_view_by_types_button;
    
    IBOutlet UIView *_view_by_station_bg_view;
    IBOutlet UITableView *_line_table_view;
    IBOutlet UITableView *_line_shadow_table_view;
    IBOutlet UITableView *_station_table_view;
    IBOutlet UITableView *_station_shadow_table_view;
    IBOutlet UIImageView *_select_image_view;
    IBOutlet UIImageView *_middle_image_view;
    IBOutlet UIImageView *_yellow_dot_image_view;
    
    NSArray *_facility_array;
    NSMutableArray *_line_list;
    
    //    Facility3DView *_facility_3d_view;
    
    NSMutableDictionary *_station_records;
    NSMutableDictionary *_station_records_with_station_as_key;
    NSMutableDictionary *_line_records_with_line_as_key;
    
    int _line_index;
    int _station_index;
    
    NSString *_db_lang;
    
    IBOutlet UILabel *_title_label;
    IBOutlet UIButton *btn_nearby;
    IBOutlet UIView *vw_backgroundMask;
    IBOutlet UIButton *btn_mapSearch;
    
    NextTrainViewController *nextTrainViewController;
    MapSearchViewController *mapSearchViewController;
    
    SelectLineView *selectLineView;
    
    BOOL waitingForLocation;
    BOOL isShowingInAppTutorialAll;
    BOOL isShowingSystemMap;
    
    IBOutlet UIButton *_btn_callbackMother;
    
    //Alex
    IBOutlet UIButton *btn_left, *btn_right;
    IBOutlet UIButton *btn_setting;

    UIImageView *louhasParkStation;
    BOOL louhasParkStationSelected;
    
}


@property (nonatomic, retain) NSString *launch_line_code, *launch_station_code;
@property (assign, readwrite, nonatomic) BOOL liveBlur;

@property (assign , nonatomic) BOOL routemap;


-(IBAction)clickMapSearchButton:(id)button;



-(void)reloadData;

#pragma mark - Main Function
-(void)lineTableViewPaging;
-(void)stationTableViewPaging;

#pragma mark - Control Functions
-(void)loadNextTrainViewController;
-(void)hideNextTrainViewController;
-(void)unloadNextTrainViewController;

-(void)constructStationRecord;
-(void)showYellowDot;
-(void)handleLineColor;

-(void)showNextTrainWithLineIndex:(int)lineIndex stationIndex:(int)stationIndex;
-(void)hideNextTrain;

-(void)highlightStationWithLineIndex:(int)lineIndex stationIndex:(int)stationIndex;
-(void)highlightStationNoAnimatedWithLineIndex:(int)lineIndex stationIndex:(int)stationIndex;

-(void)selectStationWithStationCode:(NSString*)stationCode;
-(void)selectStationWithStationCode:(NSString*)stationCode popSchedule:(BOOL)popSchedule;
-(void)selectStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode popSchedule:(BOOL)popSchedule;
-(void)showStationOptions:(NSMutableArray*)stationOptions popSchedule:(BOOL)popSchedule;
-(void)doSelectStationWithLineIndex:(int)lineIndex stationIndex:(int)stationIndex popSchedule:(BOOL)popSchedule;

-(void)hideBackgroundMask;
-(void)showBackgroundMask;

-(void)showInAppTutorial;
-(void)showInAppTutorialAll;
-(void)hideInAppTutorialAll;


#pragma mark - Handle Click Button Events
-(IBAction)clickViewByStationsButton:(UIButton*)button;
-(IBAction)clickViewByTypesButton:(UIButton*)button;
-(IBAction)clickNearbyButton:(UIButton*)button;
-(IBAction)clickHideScheduleButton:(UIButton*)button;
-(IBAction)clickSlideMenuButton:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *clickSettingButton;

#pragma mark - Location Functions
-(void)startLocatingStation;
-(void)findClosestStationFromCurrentLocation:(CLLocation*)currentLocation;

#pragma mark - x-callback functions
-(void)handleCallbackMotherButton;
-(IBAction)clickCallbackMotherButton:(UIButton*)button;

@end
