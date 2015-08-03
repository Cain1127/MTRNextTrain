//
//  ConnectionFailedViewController.h
//  MTR
//
//  Created by Jeff Cheung on 11年11月2日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionFailedViewDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreData.h"

typedef enum
{
    AlertType_ConnectionFailed,
    AlertType_ConnectServerFailed,
    AlertType_LocationFailed
} AlertType;

@interface ConnectionFailedViewController : UIViewController{
    IBOutlet UIView *_pop_up_view;
    NSMutableArray *_animation_values;
    BOOL _connection_failed_close_app;
    id <ConnectionFailedViewDelegate> _delegate;
    IBOutlet UILabel *_content_label;
    IBOutlet UIButton *_close_button;
}

@property (nonatomic, assign) BOOL connection_failed_close_app;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) int alertType;

-(void)doShowView;
-(void)showView;
-(void)showViewWithAlertType:(int)newAlertType;
-(void)hiddenView;
-(IBAction)clickCloseButton:(UIButton*)button;
-(void)handleLangauge;

@end
