//
//  SelectLineViewController.h
//  MTR Next Train
//
//  Created by  on 12年2月21日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CoreData.h"
#import "SelectLineViewDelegate.h"
#import "UIView-PopUpAnimations.h"

@interface SelectLineView : UIViewController
{
    IBOutlet UIButton *btn_cancel, *btn_line1, *btn_line2;
    IBOutlet UILabel *lbl_title;
    IBOutlet UIView *vw_pop_up;
    IBOutlet UIView *img_background;
    
    BOOL isShowing;
}

@property (nonatomic, assign) id <SelectLineViewDelegate> delegate;
@property (nonatomic, assign) BOOL isAutoPopSchedule;
@property (nonatomic, retain) NSArray *stationOptions;

#pragma mark - Main functions
-(void)setLanguage;

-(void)setButton:(int)buttonId title:(NSString*)title lineCode:(NSString*)lineCode;

#pragma mark - Control functions
-(void)show;
-(void)clearDelegatesAndCancel;

#pragma mark - Button functions
-(IBAction)clickButton:(id)sender;

@end
