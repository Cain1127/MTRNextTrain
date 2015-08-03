//
//  ContactUsViewController.h
//  MTR
//
//  Created by Jeff Cheung on 11年10月27日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"
#import "ASIHTTPRequest.h"
#import "XPathQuery.h"
#import "ContactSQLOperator.h"
#import "InAppBrowserViewController.h"

#define textViewTag 100
#define labelTag 200
#define buttonTag 300

@interface ContactUsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>{
    
    IBOutlet UIImageView *_background;
    
    NSArray *_general_contact_array;
    NSArray *_line_contact_array;
    NSArray *_station_contact_array;
    
    
    IBOutlet UIButton *_general_button, *_station_contact_button;
    IBOutlet UIButton *btn_setting;
    
    IBOutlet UIScrollView *_general_scroll_view;
    
    IBOutlet UIView *_station_contact_bg_view;
    IBOutlet UILabel *_station_contact_line_value_label, *_station_contact_station_value_label;
    IBOutlet UIButton *_station_contact_tel_button;
    IBOutlet UIButton *_station_contact_line_button, *_station_contact_station_button;
    IBOutlet UIView *_station_contact_picker_bg_view;
    IBOutlet UIPickerView *_station_contact_line_picker_view;
    IBOutlet UIPickerView *_station_contact_station_picker_view;
    IBOutlet UIButton *_select_button;
    IBOutlet UIActivityIndicatorView *_aiv;
    
    int _station_contact_line_picker_selected_index;
    int _station_contact_station_picker_selected_index;
    
    NSMutableDictionary *_station_contact_record;
    
    NSString *_lang;
    
    IBOutlet UILabel *_title_label;
    IBOutlet UILabel *_tel_label, *_line_label, *_station_label;
    
    
    IBOutlet UIButton *_btn_callbackMother;
    
    IBOutlet UIImageView *select_index;

    
}

@property (nonatomic, retain) UIView *station_contact_picker_bg_view;

-(void)reloadData;
-(void)constructGeneralSection;
-(void)constructStationContact;
-(IBAction)clickToCall:(UIButton*)button;
-(void)clickToLink:(UIButton*)button;
-(IBAction)clickGeneralButton:(UIButton*)button;
-(IBAction)clickStationContactButton:(UIButton*)button;
-(IBAction)clickStationContactLineButton:(UIButton*)button;
-(IBAction)clickStationContactStationButton:(UIButton*)button;
-(IBAction)clickSelectButton:(UIButton*)button;
//Alex
-(IBAction)clickSlideMenuButton:(id)sender;

#pragma mark - x-callback functions
-(void)handleCallbackMotherButton;
-(IBAction)clickCallbackMotherButton:(UIButton*)button;

@end
