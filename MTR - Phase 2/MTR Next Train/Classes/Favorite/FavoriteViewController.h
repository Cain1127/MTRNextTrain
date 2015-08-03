//
//  FavoriteViewController.h
//  MTR Next Train
//
//  Created by  on 12年2月15日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"
#import "FavoriteCell.h"
#import "NextTrainViewController.h"
#import "SelectLineView.h"
#import "SelectLineViewDelegate.h"
#import "TutorialHandler.h"
#import "TutorialViewController.h"
#import "CustomAlertView.h"
#import "CustomAlertViewDelegate.h"

@interface FavoriteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, SelectLineViewDelegate,CustomAlertViewDelegate>
{
    
    IBOutlet UIImageView *_background;
    
    IBOutlet UILabel *_title_label;
    IBOutlet UITableView *tbl_favorite;
    IBOutlet UIButton *btn_edit;
    IBOutlet UIView *vw_backgroundMask;
    IBOutlet UILabel *_status_label;
    
    NSArray *_facility_array;
    NSArray *_line_list;
    NSString *_db_lang;
    
    
    IBOutlet UIButton *btn_setting;
    
    NSMutableDictionary *_line_dictionary, *_station_dictionary;
    NSMutableDictionary *_station_records;
    
    NSMutableArray *favorite_station_array;
    
    NextTrainViewController *nextTrainViewController;
    FavoriteViewController *favoriteViewController;

    SelectLineView *selectLineView;
    
    IBOutlet UIButton *_btn_callbackMother;
    
    UIPanGestureRecognizer *panGestureRecognizer;
    
    CustomAlertView *customAlertView;

}

@property (strong, nonatomic) IBOutlet UIImageView *dssview;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, assign) int index;

#pragma mark - Main functions
-(void)reloadData;
-(void)constructStationRecord;
-(void)loadFavoriteStationArray;
-(void)loadLineAndStationArray;

#pragma mark - Control Functions
-(void)loadNextStationViewController;
-(void)unloadNextStationViewController;

-(void)selectStationWithStationCode:(NSString*)stationCode;
-(void)selectStationWithStationCode:(NSString*)stationCode popSchedule:(BOOL)popSchedule;
-(void)selectStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode index:(int)index;

-(void)showStationOptions:(NSMutableArray*)stationOptions popSchedule:(BOOL)popSchedule;

-(void)hideBackgroundMask;
-(void)showBackgroundMask;

-(void)refreshFavouriteTableView;
-(void)handleEditButton;

-(void)hideBookMarkViewController;


//-(void)showInAppTutorial;

#pragma mark - Button functions
-(IBAction)clickEditButton:(id)sender;
-(IBAction)clickSlideMenuButton:(id)sender;

#pragma mark - x-callback functions
-(void)handleCallbackMotherButton;
-(IBAction)clickCallbackMotherButton:(UIButton*)button;

@end
