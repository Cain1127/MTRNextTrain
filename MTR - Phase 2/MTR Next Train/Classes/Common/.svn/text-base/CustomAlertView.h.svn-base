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
#import "CustomAlertViewDelegate.h"
#import "UIView-PopUpAnimations.h"

@interface CustomAlertView : UIViewController
{
    IBOutlet UIButton *btn_close;
    IBOutlet UILabel *lbl_title;
    IBOutlet UIView *vw_pop_up;
    IBOutlet UIView *img_background;
    
    BOOL isShowing;
}

@property (nonatomic, assign) id <CustomAlertViewDelegate> delegate;
@property (nonatomic, retain) NSString *message;

-(id)initWithMessage:(NSString*)initMessage;

#pragma mark - Main functions
-(void)setLanguage;

#pragma mark - Control functions
-(void)show;
-(void)clearDelegatesAndCancel;

#pragma mark - Button functions
-(IBAction)dismiss:(id)sender;

@end
