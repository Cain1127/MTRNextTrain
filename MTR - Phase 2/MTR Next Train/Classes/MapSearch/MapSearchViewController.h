//
//  MapSearchViewController.h
//  MTR Next Train
//
//  Created by Lam Bob on 9/1/13.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@protocol MapSearchViewControllerDelegate;

@interface MapSearchViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIButton *btn_view_system_map;
    NSMutableArray *wrlStations;
    IBOutlet UIImageView *bg;
    IBOutlet UIButton *btn1,*btn2;
    IBOutlet UIButton *btn_miniMap;
    IBOutlet UIView *view_map;
    MapSearchViewController *mapSearchViewController;
    IBOutlet UIButton *btn_gps;
    BOOL waitingForLocation;
    
    IBOutlet UIImageView *img_user_location;
    
    NSMutableArray *_line_list;
    NSMutableDictionary *_station_records;
    int _line_index;
    int _station_index;
    
    int _station_code;
    
    NSMutableDictionary *_line_records_with_line_as_key;
    NSArray *_facility_array;
    NSMutableDictionary *_station_records_with_station_as_key;

    ASIHTTPRequest *_request;
    IBOutlet UIButton *btn_nearby;

}

@property (nonatomic, assign) id <MapSearchViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIScrollView *scroll_view;
@property (nonatomic, assign) BOOL isShowingMapSearch;
@property (nonatomic, assign) UIImageView* isGPSpoint;


@property (nonatomic,retain)NSMutableArray *wrlStations;
-(IBAction)clickCloseButton:(id)sender;
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

//Alex TKO line

-(IBAction)clickStation_NOP:(id)sender;
-(IBAction)clickStation_QUB:(id)sender;
-(IBAction)clickStation_YAT:(id)sender;
-(IBAction)clickStation_TLK:(id)sender;
-(IBAction)clickStation_TKO:(id)sender;
-(IBAction)clickStation_LHP:(id)sender;
-(IBAction)clickStation_HAH:(id)sender;
-(IBAction)clickStation_POA:(id)sender;


-(IBAction)clickOpenSystemMapButton:(UIButton*)button;
-(void) reloadData;

@end



@protocol MapSearchViewControllerDelegate <NSObject>

@optional

-(void)mapSearchViewControllerDidSelectStationWithStationCode:(NSString*)stationsCode;
-(void)hideMapSearchViewController;
-(IBAction)timerAlert:(id)sender;
-(void)showAlert;


@end
