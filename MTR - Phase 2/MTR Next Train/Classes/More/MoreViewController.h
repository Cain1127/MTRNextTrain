//
//  MoreViewController.h
//  MTR
//
//  Created by Cheung Jeff on 2011/10/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"
#import "UpdateHandler.h"
#import "UpdateHandlerDelegate.h"
#import "ASIHTTPRequest.h"
#import "SettingsCell.h"
#import "TutorialHandler.h"
#import "TutorialViewController.h"
#import "TutorialAllViewController.h"

#define noNeedUpdate @"0"
#define canUpdate @"1"
#define forceUpdate @"2"

//#define changeLangaugeAPI @"java/mtr/chglang.api?"

@class UpdateHandler;

@interface MoreViewController : UIViewController <ASIHTTPRequestDelegate, UITableViewDelegate, UITableViewDataSource, UpdateHandlerDelegate, UIWebViewDelegate>{
    
    
    IBOutlet UIImageView *_background;
    
    UpdateHandler *_update_handle;
    
    IBOutlet UIImageView *term_of_use;
    IBOutlet UIImageView *check_update;
    
    IBOutlet UIButton *btn_setting;

    IBOutlet UIView *_select_language_view;
    IBOutlet UIView *_tnc_view;
    IBOutlet UIView *_updates_view;
    IBOutlet UIView *_about_view;
    IBOutlet UIImageView *_img_background_normal, *_img_background_setting,*bv;
    
    IBOutlet UIButton *_language_button, *_tnc_button, *_updates_button, *_about_button;
    
    //language view
    IBOutlet UIButton *_chinese_button;
    IBOutlet UIButton *_english_button;
    
    
    //updates view
    IBOutlet UILabel *_check_update_label;
    IBOutlet UILabel *_last_check_time_label;

    //about view
    IBOutlet UILabel *_version_label;
    
    BOOL _go_updates_section;
    IBOutlet UILabel *_select_language_label;
    
    //update frequency
    IBOutlet UITableView *tbl_update_frequency, *tbl_language;
    IBOutlet UILabel *lbl_update_frequency;
    NSArray *updateFrequencyArray;
    NSIndexPath* lastFreqIndexPath;
    
    //tnc view
//    IBOutlet UITextView *_tnc_english_text_view;
//    IBOutlet UITextView *_tnc_chinese_text_view;
    IBOutlet UIScrollView *_tnc_scroll_view,*_moreBkScrollView;
    IBOutlet UIImageView *_tnc_english_image_view;
    IBOutlet UIImageView *_tnc_chinese_image_view;
    IBOutlet UIWebView *_tnc_webview;
    IBOutlet UIActivityIndicatorView *_tnc_aiv;
    IBOutlet UIImageView *_pushTitleBk;
    IBOutlet UILabel *_pushTitleLabel;
    IBOutlet UILabel *_title_label;
    IBOutlet UILabel *_title_trem_of_Use;
    IBOutlet UILabel *_title_check_Update;
    NSString *_db_lang;

    IBOutlet UIButton *_in_app_tutorial_button;
    
    NSDateFormatter *_date_formatter;
    NSLocale *_locale;
    
    ASIHTTPRequest *_request;
    
    BOOL isShowingInAppTutorialAll;
    
    IBOutlet UIButton *_btn_callbackMother;
}

@property (nonatomic, assign) BOOL go_updates_section;
@property (nonatomic, assign) BOOL isShowingTNC;
@property (nonatomic, assign) BOOL isShowingCheckUpdate;

-(void)handleLocalLanguageSetting;
-(void)handleGlobalLanguagSetting;
-(void)reloadData;

-(IBAction)clickCheckUpdateButton:(UIButton*)button;
-(IBAction)clickChineseButton:(UIButton*)button;
-(IBAction)clickEnglishButton:(UIButton*)button;

-(IBAction)clickLanguageButton:(UIButton*)button;
//-(IBAction)clickTNCButton:(UIButton*)button;
-(IBAction)clickUpdatesButton:(UIButton*)button;
-(IBAction)clickAboutButton:(UIButton*)button;
-(IBAction)clickInAppTutorialButton:(UIButton*)button;
-(IBAction)clickSlideMenuButton:(id)sender;

-(void)requestChineseFinished:(ASIHTTPRequest *)request;
-(void)requestChineseFailed:(ASIHTTPRequest *)request;
-(void)requestEnglishFinished:(ASIHTTPRequest *)request;
-(void)requestEnglishFailed:(ASIHTTPRequest *)request;

-(void)loadSavedUpdateFrequency;

#pragma mark - Control Functions
//-(void)showInAppTutorial;

-(void)showInAppTutorialAll;
-(void)hideInAppTutorialAll;

#pragma mark - x-callback functions
-(void)handleCallbackMotherButton;
-(IBAction)clickCallbackMotherButton:(UIButton*)button;

@end
